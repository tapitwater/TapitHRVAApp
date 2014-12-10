//
//  GetLatLongRequest.m
//  TapIt
//
//  Created by Admin on 8/7/13.
//  Copyright (c) 2013 Admin. All rights reserved.
//

#import "GetLatLongRequest.h"

@implementation GetLatLongRequest


#pragma mark - Synthesized Objects

@synthesize address;

#pragma mark - Initialization Methods
- (id)init
{
    self = [super init];
    if (self) {
        
        // Set Service Method Name
        serviceMethodName = GET_LAT_LONG_SERVICE_NAME;
    }
    
    return self;
}

#pragma mark - Supporting Methods

- (NSString *)url {
    
    // Get Server URL
    NSString *urlString = [[NSString alloc] initWithFormat:@"%@",serverName];
    
    // Append Service Method Name
    urlString = [urlString stringByAppendingFormat:@"/%@",serviceMethodName];
    
    return urlString;
}

@end
