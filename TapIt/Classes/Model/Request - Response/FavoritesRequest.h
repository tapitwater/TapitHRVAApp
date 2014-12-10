//
//  FavoritesRequest.h
//  TapIt
//
//  Created by Admin on 7/25/13.
//  Copyright (c) 2013 Admin. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Request.h"

@interface FavoritesRequest : Request
{
    NSString *serviceMethodName;
    
}

@property (nonatomic, strong) NSString *latitude, *longitude,*mapCenterLat,*mapCenterLon,*favorites,*query,*radius;

- (NSString *)url;

@end
