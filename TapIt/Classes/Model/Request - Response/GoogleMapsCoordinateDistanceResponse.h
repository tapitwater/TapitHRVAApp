//
//  GoogleMapsCoordinateDistanceResponse.h
//  Proxinets
//
//  Created by Shardul Patel on 07/02/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Response.h"
#import "CoordinateDistanceModel.h"

@interface GoogleMapsCoordinateDistanceResponse : Response   {
    
    CoordinateDistanceModel *coordinateDistance;
    NSString *error;
}

@property (nonatomic) BOOL success;
@property (nonatomic, retain) CoordinateDistanceModel *coordinateDistance;
@property (nonatomic, retain) NSString *error;

@end
