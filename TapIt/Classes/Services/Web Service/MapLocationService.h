//
//  MapLocationService.h
//  TapIt
//
//  Created by Admin on 7/15/13.
//  Copyright (c) 2013 Admin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SPService.h"
#import "MapLocationRequest.h"
#import "MapLocationResponce.h"
#import "MapLocationModel.h"

@interface MapLocationService : SPService
{

}

+ (MapLocationService *) getInstance;
- (NSMutableArray *) mapLocation:(MapLocationRequest *)request;

@end
