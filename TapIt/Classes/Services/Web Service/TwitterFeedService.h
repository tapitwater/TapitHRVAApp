//
//  TwitterFeedService.h
//  TapIt
//
//  Created by Admin on 7/24/13.
//  Copyright (c) 2013 Admin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SPService.h"
#import "TwitterFeedRequest.h"
#import "TwitterFeedResponce.h"
#import "TwitterFeedModel.h"

@interface TwitterFeedService : SPService
{
    
}

+ (TwitterFeedService *) getInstance;
- (TwitterFeedResponce *) twitterFeedWithRequest:(TwitterFeedRequest *)request;

@end
