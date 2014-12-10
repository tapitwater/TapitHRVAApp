//
//  TwitterFeedRequest.m
//  TapIt
//
//  Created by Admin on 7/24/13.
//  Copyright (c) 2013 Admin. All rights reserved.
//

#import "TwitterFeedRequest.h"

@implementation TwitterFeedRequest


#pragma mark - Synthesized Objects

@synthesize UserName,Password;

#pragma mark - Initialization Methods
- (id)init
{
    self = [super init];
    if (self) {
        
        // Set Service Method Name
        serviceMethodName = TWITTER_FEED_SERVICE_NAME;
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
