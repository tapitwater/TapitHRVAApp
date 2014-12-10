//
//  FavoritesRequest.m
//  TapIt
//
//  Created by Admin on 7/25/13.
//  Copyright (c) 2013 Admin. All rights reserved.
//

#import "FavoritesRequest.h"

@implementation FavoritesRequest

#pragma mark - Synthesized Objects

@synthesize latitude,longitude,mapCenterLat,mapCenterLon,favorites,query,radius;

#pragma mark - Initialization Methods

- (id)init
{
    self = [super init];
    if (self) {
        
        // Set Service Method Name
        serviceMethodName = FAVORITES_SERVICE_NAME;
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
