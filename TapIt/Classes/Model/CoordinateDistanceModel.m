//
//  CoordinateDistanceModel.m
//  Proxinets
//
//  Created by Shardul Patel on 07/02/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CoordinateDistanceModel.h"

@implementation CoordinateDistanceModel

@synthesize distance;
@synthesize distanceString;
@synthesize duration;
@synthesize durationString;
@synthesize success;

- (id)copyWithZone:(NSZone *)zone    {
    
    CoordinateDistanceModel *copy = [[CoordinateDistanceModel alloc] init];
    copy.distance = distance;
    copy.distanceString = distanceString;
    copy.duration = duration;
    copy.durationString = durationString;
    copy.success = success;
    
    return copy;
}

@end
