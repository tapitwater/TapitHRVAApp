//
//  MapLocationRequest.h
//  TapIt
//
//  Created by Admin on 7/15/13.
//  Copyright (c) 2013 Admin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Request.h"

@interface MapLocationRequest : Request
{
    NSString *serviceMethodName;
    
}

@property (nonatomic, strong) NSString *query,*radius,*mapCenterLat,*mapCenterLon;
@property (nonatomic, strong) NSString *latitude, *longitude;

- (NSString *)url;

@end
