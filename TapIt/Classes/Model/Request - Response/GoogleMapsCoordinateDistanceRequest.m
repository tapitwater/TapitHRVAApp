//
//  GoogleMapsCoordinateDistanceRequest.m
//  Proxinets
//
//  Created by Shardul Patel on 07/02/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GoogleMapsCoordinateDistanceRequest.h"

@implementation GoogleMapsCoordinateDistanceRequest

@synthesize serviceMethodName;
@synthesize outputFormat;
@synthesize originLatitude;
@synthesize originLongitude;
@synthesize destinationLatitude;
@synthesize destinationLongitude;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
        serviceMethodName = GOOGLE_MAPS_COORDINATE_DISTANCE_SERVICE_NAME;
        outputFormat = RESPONSE_TYPE;
        serverName = GOOGLE_MAPS_SERVICE_HOST_URL;
    }
    
    return self;
}

- (NSString *)url {
    
    // Get Server URL
    NSString *urlString = [[NSString alloc] initWithFormat:@"%@",serverName];
    
    // Append Service Method Name
    urlString = [urlString stringByAppendingFormat:@"/api/%@/%@?",serviceMethodName,outputFormat];
    
    return urlString;
}

@end
