//
//  MapDirectionViewController.h
//  TapIt
//
//  Created by Admin on 7/29/13.
//  Copyright (c) 2013 Admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "BaseViewController.h"
#import "CoordinateDistanceModel.h"
#import "RegexKitLite.h"
#define ANNOTATION_IDENTIFIER    @"AnnotationIdentifier"

@interface MapDirectionViewController : BaseViewController <MKMapViewDelegate,MKAnnotation,CLLocationManagerDelegate>
{
    //Objects.
    NSMutableArray *locationPins;
    UIImageView *routeView;
    NSArray *routes;
    UIColor *lineColor;
    CLLocationCoordinate2D startLocation;
    CLLocationCoordinate2D EndLocation;
    
    //Flag.
    BOOL routeFound;
}

@property (nonatomic, retain) IBOutlet NSString *strAddress;
@property (nonatomic) float latEnd,lonEnd;
@property (nonatomic, retain)IBOutlet MKMapView *mapView;

- (CoordinateDistanceModel *) getDistanceFromLocation:(CLLocationCoordinate2D)fromLocation toLocation:(CLLocationCoordinate2D )toLocation;

@end

// Private Methods
@interface MapDirectionViewController (Private)

- (NSMutableArray *)decodePolyLine:(NSMutableString *)encoded;
- (void) updateRouteView;
- (NSArray*) calculateRoutesFrom:(CLLocationCoordinate2D)from to:(CLLocationCoordinate2D)to;
- (void) centerMap:(BOOL)animated;
- (IBAction) backButtonClick:(id)sender;

@end
