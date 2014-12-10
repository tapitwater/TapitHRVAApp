//
//  LocationPinModal.h
//  Gobymobile
//
//  Created by Kuldip on 7/29/13.
//  Copyright (c) 2013 Techgrains. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>



typedef enum {
    
    CURRENT_LOCATION_PIN,
    DESTINATION_LOCATION_PIN,
    OTHER_LOCATION_PIN
    
} LocationPinType;

@interface LocationPinModal : NSObject <MKAnnotation>  {
    
    CLLocationCoordinate2D coordinate;
}

@property (nonatomic) CLLocationCoordinate2D coordinate;

@end