//
//  SPServiceMockResponse.m
//  DnaTicket
//
//  Created by Shardul Patel on 30/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SPServiceMockResponse.h"

@implementation SPServiceMockResponse

#pragma mark - Initialization Method

- (id) init {
    
    self = [super init];
    if (self) {
        // Custom Initialization Code
    }
    return self;
}

#pragma mark - Utility Methods

- (NSDictionary *) params:(NSString *)url {
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    NSArray *questionComponents = [url componentsSeparatedByString:@"?"];
    NSString *query = [questionComponents lastObject];
    NSArray *queryParams = [query componentsSeparatedByString:@"&"];
    for (NSString *queryParam in queryParams) {
        NSArray *keyVal = [queryParam componentsSeparatedByString:@"="];
        NSString *key = [keyVal objectAtIndex:0];
        NSString *value = [keyVal count]>1 ? [keyVal lastObject] : @"";
        if(value==nil || value==NULL || [value isEqualToString:@"(null)"]) value = @"";
        [params setValue:value forKey:key];
    }
    return params;
}

- (void) waitBeforeGivingResponseForSeconds:(float)seconds    {
    
    if (MOCK_RESPONSE_WAIT_ENABLED && seconds>0.0) {
        
        totalWaitSeconds = seconds;
        waitUntilFinish = YES;
        
        // Schedule Auto Load Finish Timer
        [self performSelector:@selector(autoLoadFinish) withObject:nil afterDelay:totalWaitSeconds];
        
        while (waitUntilFinish) {
            // Wait until Asynchronus Response is received
            [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
        }
    }
}

- (void) autoLoadFinish   {
    
    waitUntilFinish = NO;
}

- (NSString *) getFileContent:(NSString *)fileName ofFileType:(NSString *)fileType afterDelay:(float)seconds     {
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:fileName ofType:fileType];
    NSStringEncoding encoding;
    NSError *error;
    
    NSString *fileContent = [[NSString alloc] initWithContentsOfFile:filePath
                                                        usedEncoding:&encoding
                                                               error:&error];
    [self waitBeforeGivingResponseForSeconds:seconds];
    
    return fileContent;    
}

- (NSString *) serviceResponse: (NSString *)url {
    
    return @"";
}

@end
