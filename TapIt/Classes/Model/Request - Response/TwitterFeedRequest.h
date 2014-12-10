//
//  TwitterFeedRequest.h
//  TapIt
//
//  Created by Admin on 7/24/13.
//  Copyright (c) 2013 Admin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Request.h"

@interface TwitterFeedRequest : Request
{
    NSString *serviceMethodName;
}

@property (nonatomic, strong) NSString *UserName, *Password;

@end
