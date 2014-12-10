//
//  InfoAboutService.h
//  TapIt
//
//  Created by Admin on 7/26/13.
//  Copyright (c) 2013 Admin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SPService.h"
#import "InfoAboutModel.h"
#import "InfoAboutRequest.h"
#import "InfoAboutResponce.h"

@interface InfoAboutService : SPService
{
    
}

+ (InfoAboutService *) getInstance;
- (InfoAboutResponce *) getInfoAbout: (InfoAboutRequest *)request;

@end
