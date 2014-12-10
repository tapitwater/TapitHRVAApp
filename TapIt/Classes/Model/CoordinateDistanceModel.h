//
//  CoordinateDistanceModel.h
//  Proxinets
//
//  Created by Shardul Patel on 07/02/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CoordinateDistanceModel : NSObject   {
    
    NSNumber *distance;             // Unit Of Measurement : Meters
    NSString *distanceString;
    NSNumber *duration;             // Unit Of Measurement : Second
    NSString *durationString;
    
    BOOL success;
}

@property (nonatomic, retain) NSNumber *distance;
@property (nonatomic, retain) NSString *distanceString;
@property (nonatomic, retain) NSNumber *duration;
@property (nonatomic, retain) NSString *durationString;
@property (nonatomic) BOOL success;

@end
