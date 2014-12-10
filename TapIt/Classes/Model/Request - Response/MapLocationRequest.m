//
//  MapLocationRequest.m
//  TapIt
//
//  Created by Admin on 7/15/13.
//  Copyright (c) 2013 Admin. All rights reserved.
//

#import "MapLocationRequest.h"

@implementation MapLocationRequest

#pragma mark - Synthesized Objects

@synthesize latitude,longitude,query,radius,mapCenterLat,mapCenterLon;

#pragma mark - Initialization Methods
- (id)init
{
    self = [super init];
    if (self) {
        
        // Set Service Method Name
        serviceMethodName = MAP_LOCATION_SERVICE_NAME;
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
