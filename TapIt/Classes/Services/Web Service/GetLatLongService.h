//
//  GetLatLongService.h
//  TapIt
//
//  Created by Admin on 8/7/13.
//  Copyright (c) 2013 Admin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SPService.h"
#import "GetLatLongModel.h"
#import "GetLatLongRequest.h"
#import "GetLatLongResponse.h"

@interface GetLatLongService : SPService
{
    NSString *serviceMethodName;
}

+ (GetLatLongService *) getInstance;
- (GetLatLongResponse *) getLatLong: (GetLatLongRequest *)request;

@end
