//
//  GoogleMapsCoordinateDistanceRequest.h
//  Proxinets
//
//  Created by Shardul Patel on 07/02/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Request.h"

@interface GoogleMapsCoordinateDistanceRequest : Request {
    
    NSString *serviceMethodName;
    NSString *outputFormat;
    
    NSNumber *originLatitude;
    NSNumber *originLongitude;
    
    NSNumber *destinationLatitude;
    NSNumber *destinationLongitude;
}

@property (nonatomic, retain) NSString *serviceMethodName;
@property (nonatomic, retain) NSString *outputFormat;
@property (nonatomic, retain) NSNumber *originLatitude;
@property (nonatomic, retain) NSNumber *originLongitude;
@property (nonatomic, retain) NSNumber *destinationLatitude;
@property (nonatomic, retain) NSNumber *destinationLongitude;

- (NSString *)url;

@end
