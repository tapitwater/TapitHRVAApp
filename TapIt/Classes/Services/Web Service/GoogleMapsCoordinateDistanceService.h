//
//  GoogleMapsCoordinateDistanceService.h
//  Proxinets
//
//  Created by Shardul Patel on 07/02/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SPService.h"
#import "GoogleMapsCoordinateDistanceRequest.h"
#import "GoogleMapsCoordinateDistanceResponse.h"

@interface GoogleMapsCoordinateDistanceService : SPService    {
    
}

+ (GoogleMapsCoordinateDistanceService *) getInstance; 
- (GoogleMapsCoordinateDistanceResponse *) getGoogleMapsCoordinateDistanceWithRequest:(GoogleMapsCoordinateDistanceRequest *)request;

@end
