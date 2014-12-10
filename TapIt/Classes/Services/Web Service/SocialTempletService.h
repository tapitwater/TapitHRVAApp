//
//  SocialTempletService.h
//  TapIt
//
//  Created by Admin on 8/6/13.
//  Copyright (c) 2013 Admin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SPService.h"
#import "SocialTempleteModel.h"
#import "SocialTempletRequest.h"
#import "SocialTempletResponce.h"

@interface SocialTempletService : SPService
{
    NSString *serviceMethodName;
}

+ (SocialTempletService *) getInstance;
- (SocialTempletResponce *) getSocialTemplet: (SocialTempletRequest *)request;

@end
