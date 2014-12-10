//
//  Request.m
//  Gobymobile
//
//  Created by Shardul Patel on 30/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Request.h"

@implementation Request

#pragma mark - Synthesized Objects

@synthesize serverName;
@synthesize caller;
@synthesize version;

#pragma mark - Initialization Methods

- (id)init {
    
    self = [super init];
    if (self) {
        
        // Set Base URL
        serverName = LIVE_SERVICE_HOST_URL;
        
        // Set Caller
        caller = @"iOS";
        
        // Set App Version
        NSDictionary *bundleInfo = [[NSBundle mainBundle] infoDictionary];
        version = [bundleInfo objectForKey:@"CFBundleShortVersionString"];
    }
    return self;
}

#pragma mark - Supporting Methods

- (NSString *) url {
    
    //  Override this method to suport url creation for each request
    
    // Get Server URL
    NSString *urlString = [[NSString alloc] initWithFormat:@"%@",self.serverName];
    return urlString;
}

@end
