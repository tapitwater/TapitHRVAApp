//
//  MapDirectionViewController.m
//  TapIt
//
//  Created by Admin on 7/29/13.
//  Copyright (c) 2013 Admin. All rights reserved.
//

#import "MapDirectionViewController.h"
#import "myAnnotation.h"
#import "LocationPinModal.h"

enum {
    STANDARD = 0,
    SATELLITE = 1,
    HYBRIAD = 2
};

@interface MapDirectionViewController ()

@end

@implementation MapDirectionViewController
@synthesize mapView,strAddress,latEnd,lonEnd;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - View Load Methods

- (void) commonInitialization   {
    // Custom initialization
    [mapView setDelegate:self];
    if (locationPins != nil) {
        [self removeAllLocationPins];
        locationPins = nil;
    }
    locationPins = [[NSMutableArray alloc] init];
}

- (void) defaultDrawPathInitialization  {
    
    // Common Initialization
    [self commonInitialization];
    
    // Initialize Route View
    [self resetRouteView];
}

- (void)resetRouteView  {
    
    if (routeView!=nil) {
        [routeView removeFromSuperview];
        routeView = nil;
    }
    routeView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, mapView.frame.size.width, mapView.frame.size.height)];
    routeView.userInteractionEnabled = NO;
    [mapView addSubview:routeView];
}

- (void)loadVariables   {
    [super loadVariables];
    
    // Default Draw Path Initialization
    [self defaultDrawPathInitialization];
}

- (void)loadNavigationBar   {
    [super loadNavigationBar];
}

- (void)loadDisplayContents     {
    [super loadDisplayContents];
    
    // Detect Device Display Size
    if (session.deviceDetails.display == SPDeviceDisplayiPhone4Inch) {
        // It has an iPhone 4 inch display
    }
    else    {
        // It has an iPhone 3.5 inch display
    }
    
    // Set Main Window Frame Bounds To Current View
    self.view.frame = [[UIScreen mainScreen] applicationFrame];
    
}

- (void)startNotifications  {
    
    [super startNotifications];
}

- (void)resignNotifications {
    
    [super resignNotifications];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [mapView setShowsUserLocation:YES];
}

- (void)viewWillAppear:(BOOL)animated   {
    
    [super viewWillAppear:animated];
    [Flurry logPageView];
    [Flurry logEvent:@"Direction View"];

    lineColor = [UIColor redColor];
    
    startLocation.latitude = session.directionLatitude;
    startLocation.longitude = session.directionLongitude;
    
    EndLocation.latitude = latEnd;
    EndLocation.longitude = lonEnd;
    
    [self performSelectorInBackground:@selector(drawPath) withObject:nil];
    [self.mapView removeAnnotations:mapView.annotations];
}
- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    routes = nil;
    [self updateRouteView];

}

#pragma mark - custom method

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (IBAction) backButtonClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Supporting Methods

- (void)removeAllLocationPins   {
    
    [mapView removeAnnotations:[mapView annotations]];
    [locationPins removeAllObjects];
}

- (void)drawPath
{
    @autoreleasepool {
        
        CLLocationCoordinate2D fromLocation = startLocation;
        CLLocationCoordinate2D toLocation   = EndLocation;
        
        if (locationPins == nil) {
            [self removeAllLocationPins];
            locationPins = nil;
            locationPins = [[NSMutableArray alloc] initWithCapacity:2];
        }
        
        // Add "From Location" Pin
        myAnnotation *from = [[myAnnotation alloc] initWithCoordinate:fromLocation title:@"Start Point"];
        [locationPins addObject:from];
        [mapView addAnnotation:from];
        
        // Add "To Location" Pin
        myAnnotation *to = [[myAnnotation alloc] initWithCoordinate:toLocation title:strAddress];
        [locationPins addObject:to];
        [mapView addAnnotation:to];
        
        routes = [self calculateRoutesFrom:from.coordinate to:to.coordinate];
        if ([routes count] > 0) {
            routeFound = YES;
            // Update Route Drawing
            [self updateRouteView];
            routeView.hidden = NO;
            [routeView setNeedsDisplay];
        }
        else    {
            routeFound = NO;
        }
        
        BOOL animateFocus = YES;
        NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys: [NSNumber numberWithBool:animateFocus], @"Animated", nil];
        [self performSelector:@selector(setFocusOnRout:) withObject:param];
        
        [self getDistanceFromLocation:fromLocation toLocation:toLocation];
    }
}

- (CoordinateDistanceModel *) getDistanceFromLocation:(CLLocationCoordinate2D)fromLocation toLocation:(CLLocationCoordinate2D)toLocation   {
    
    if(session.isInternetReachable == YES)
    {
        CoordinateDistanceModel *distanceCooedinate = [session getGoogleMapsCoordinateDistanceWithRequest:fromLocation toLocation:toLocation];
        
        if (session.isResponseSuccess)
            return distanceCooedinate;
        else
            return nil;
    }
    return nil;
}

# pragma mark - Path Drawing Methods

-(void) setFocusOnRout:(NSDictionary *)parameters   {
    
    // Get Parameters
    BOOL animated = [[parameters objectForKey:@"Animated"] boolValue];
    
    [self focusOnRout:animated];
}

- (void)focusOnRout:(BOOL)animated {
    //Static
    [self centerMap:animated];
}

-(NSMutableArray *)decodePolyLine: (NSMutableString *)encoded {
	[encoded replaceOccurrencesOfString:@"\\\\" withString:@"\\"
								options:NSLiteralSearch
								  range:NSMakeRange(0, [encoded length])];
	NSInteger len = [encoded length];
	NSInteger index = 0;
	NSMutableArray *array = [[NSMutableArray alloc] init];
	NSInteger lat=0;
	NSInteger lng=0;
	while (index < len) {
		NSInteger b;
		NSInteger shift = 0;
		NSInteger result = 0;
		do {
			b = [encoded characterAtIndex:index++] - 63;
			result |= (b & 0x1f) << shift;
			shift += 5;
		} while (b >= 0x20);
		NSInteger dlat = ((result & 1) ? ~(result >> 1) : (result >> 1));
		lat += dlat;
		shift = 0;
		result = 0;
		do {
			b = [encoded characterAtIndex:index++] - 63;
			result |= (b & 0x1f) << shift;
			shift += 5;
		} while (b >= 0x20);
		NSInteger dlng = ((result & 1) ? ~(result >> 1) : (result >> 1));
		lng += dlng;
		NSNumber *latitude = [[NSNumber alloc] initWithFloat:lat * 1e-5];
		NSNumber *longitude = [[NSNumber alloc] initWithFloat:lng * 1e-5];
		//printf("[%f,", [latitude doubleValue]);
		//printf("%f]", [longitude doubleValue]);
		CLLocation *loc = [[CLLocation alloc] initWithLatitude:[latitude floatValue] longitude:[longitude floatValue]];
		[array addObject:loc];
	}
	
	return array;
}

-(NSArray *) calculateRoutesFrom:(CLLocationCoordinate2D)f to: (CLLocationCoordinate2D)t {
    
	NSString *saddr = [NSString stringWithFormat:@"%f,%f", f.latitude, f.longitude];
	NSString *daddr = [NSString stringWithFormat:@"%f,%f", t.latitude, t.longitude];
	
	//NSString *apiUrlStr = [NSString stringWithFormat:@"http://maps.google.com/maps?output=dragdir&saddr=%@&daddr=%@", saddr, daddr];
    NSString *apiUrlStr = [NSString stringWithFormat:@"http://maps.google.com/maps?dirflg=w&output=dragdir&saddr=%@&daddr=%@", saddr, daddr];
    //NSString *apiUrlStr = [NSString stringWithFormat:@"http://maps.google.com/maps?output=dragdir&saddr=vadodara&daddr=ahmedabad"];
    
	NSURL *apiUrl = [NSURL URLWithString:apiUrlStr];
	NSError *error;
	NSString *apiResponse = [NSString stringWithContentsOfURL:apiUrl encoding:NSASCIIStringEncoding error:&error];;
	NSString *encodedPoints = [apiResponse stringByMatching:@"points:\\\"([^\\\"]*)\\\"" capture:1L];
	
	return [self decodePolyLine:[encodedPoints mutableCopy]];
}

- (void) centerMapToViewAllLocations:(NSArray *)locations animated:(BOOL)animated   {
    
    MKCoordinateRegion region;
    
    CLLocationDegrees maxLat = -90;
    CLLocationDegrees maxLon = -180;
    CLLocationDegrees minLat = 90;
    CLLocationDegrees minLon = 180;
    for(int count=0; count<locations.count; count++)
    {
        LocationPinModal *locationPin = [locations objectAtIndex:count];

        
        if(locationPin.coordinate.latitude > maxLat)
            maxLat = locationPin.coordinate.latitude;
        if(locationPin.coordinate.latitude < minLat)
            minLat = locationPin.coordinate.latitude;
        if(locationPin.coordinate.longitude > maxLon)
            maxLon = locationPin.coordinate.longitude;
        if(locationPin.coordinate.longitude < minLon)
            minLon = locationPin.coordinate.longitude;
    }
    
    region.center.latitude     = (maxLat + minLat) / 2;
    region.center.longitude    = (maxLon + minLon) / 2;
    region.span.latitudeDelta  = maxLat - minLat;
    region.span.longitudeDelta = maxLon - minLon;
    
    [mapView setRegion:[mapView regionThatFits:region] animated:animated];
}

- (void) centerMap:(BOOL)animated    {
    
    if (!routeFound) {
        
        if ([locationPins count]==1) {
            
            // Zoom To Current Location
            MKCoordinateRegion region = {{0.0f, 0.0f}, {100.0f, 100.0f}};
            
            LocationPinModal *location = [locationPins objectAtIndex:0];
            CLLocation *currentPlace = [[CLLocation alloc] initWithLatitude:location.coordinate.latitude longitude:location.coordinate.longitude];
            region.center = currentPlace.coordinate;
            region.span.longitudeDelta = 0.05;
            region.span.latitudeDelta  = 0.05;
            [mapView setRegion:region animated:NO];
            
        }
        else if ([locationPins count]>0) {
            
            [self centerMapToViewAllLocations:locationPins animated:NO];
        }
    }
    else    {
        
        MKCoordinateRegion region;
        
        CLLocationDegrees maxLat = -90;
        CLLocationDegrees maxLon = -180;
        CLLocationDegrees minLat = 120;
        CLLocationDegrees minLon = 240;
        for(int idx = 0; idx < routes.count; idx++)
        {
            CLLocation* currentLocation = [routes objectAtIndex:idx];
            if(currentLocation.coordinate.latitude > maxLat)
                maxLat = currentLocation.coordinate.latitude;
            if(currentLocation.coordinate.latitude < minLat)
                minLat = currentLocation.coordinate.latitude;
            if(currentLocation.coordinate.longitude > maxLon)
                maxLon = currentLocation.coordinate.longitude;
            if(currentLocation.coordinate.longitude < minLon)
                minLon = currentLocation.coordinate.longitude;
        }
        region.center.latitude     = (maxLat + minLat) / 2;
        region.center.longitude    = (maxLon + minLon) / 2;
        region.span.latitudeDelta  = (maxLat - minLat) * 1.25;
        region.span.longitudeDelta = (maxLon - minLon) * 1.4;
        
        if(region.span.latitudeDelta >= 0.0 && region.span.longitudeDelta >= 0.0 && region.span.latitudeDelta <= 180 && region.span.longitudeDelta <= 180)
        {
            [mapView setRegion:region animated:animated];
        }
        else
        {
            if(region.span.latitudeDelta > 180 || region.span.longitudeDelta > 180)
            {
                region.span.latitudeDelta  = 175;
                region.span.longitudeDelta = 175;
            }
            else
            {
                region.span.latitudeDelta  = 0.01;
                region.span.longitudeDelta = 0.01;
            }
           [mapView setRegion:region animated:animated];
        }
    }
}

- (void) updateRouteView {
	CGContextRef context = 	CGBitmapContextCreate(nil,
												  routeView.frame.size.width,
												  routeView.frame.size.height,
												  8,
												  4 * routeView.frame.size.width,
												  CGColorSpaceCreateDeviceRGB(),
												  kCGImageAlphaPremultipliedLast);
	
	CGContextSetStrokeColorWithColor(context, lineColor.CGColor);
	CGContextSetRGBFillColor(context, 0.0, 0.0, 1.0, 1.0);
	CGContextSetLineWidth(context, 3.0);
	
	for(int i = 0; i < routes.count; i++) {
		CLLocation* location = [routes objectAtIndex:i];
		CGPoint point = [mapView convertCoordinate:location.coordinate toPointToView:routeView];
		
		if(i == 0) {
			CGContextMoveToPoint(context, point.x, routeView.frame.size.height - point.y);
		} else {
			CGContextAddLineToPoint(context, point.x, routeView.frame.size.height - point.y);
		}
	}
	
	CGContextStrokePath(context);
	
	CGImageRef image = CGBitmapContextCreateImage(context);
	UIImage* img = [UIImage imageWithCGImage:image];
	
	routeView.image = img;
	CGContextRelease(context);
}

#pragma mark - MapView delegate functions

- (void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated
{
	routeView.hidden = YES;
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    if (routeFound) {
        
        [self updateRouteView];
        routeView.hidden = NO;
        [routeView setNeedsDisplay];
    }
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    
    if([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    
    static NSString *identifier = @"myAnnotation";
    MKPinAnnotationView * annotationView = (MKPinAnnotationView*)[self.mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
    if (!annotationView)
    {
        annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
        annotationView.pinColor = MKPinAnnotationColorPurple;
        annotationView.canShowCallout = YES;
    }
    else
    {
        annotationView.annotation = annotation;
    }

    return annotationView;
}

#pragma mark -

#pragma mark - Finalize Methods

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
    mapView = nil;
    routes = nil;
    routeView = nil;
    lineColor = nil;
    locationPins = nil;
}

#pragma mark - Memory Management

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
