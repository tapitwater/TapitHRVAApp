//
//  InfoAdService.h
//  TapIt
//
//  Created by Admin on 7/26/13.
//  Copyright (c) 2013 Admin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SPService.h"
#import "InfoAdModel.h"
#import "infoAdRequest.h"
#import "infoAdResponce.h"

@interface InfoAdService : SPService
{
    NSString *serviceMethodName;
}

+ (InfoAdService *) getInstance;
- (infoAdResponce *) getInfoAd: (infoAdRequest *)request;

@end
