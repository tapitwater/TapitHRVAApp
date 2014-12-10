//
//  MapViewController.m
//  TapIt
//
//  Created by Admin on 7/2/13.
//  Copyright (c) 2013 Admin. All rights reserved.
//

#import "MapViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "SearchResultTableCell.h"
#import "MapAnnotation.h"

@interface MapViewController ()

@end

@implementation MapViewController
@synthesize mapview;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = NSLocalizedString(@"Map", @"Map");
        self.tabBarItem.image = [UIImage imageNamed:@"Map"];
    }
    return self;
}
#pragma mark - View life Cycle
- (void)logFlurryEventForUserLocation
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setValue:[NSString stringWithFormat:@"%f",[session mapLatitude]] forKey:@"lat"];
    [params setValue:[NSString stringWithFormat:@"%f",[session mapLongitude]] forKey:@"lon"];
    [Flurry logEvent:@"User_Location" withParameters:params];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [mapview setShowsUserLocation:YES];
    [self getCurrentLocationResults];
    
    [self logFlurryEventForUserLocation];
    detailButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    objSearchTap = [[SearchTapViewController alloc] initWithNibName:@"SearchTapViewController" bundle:nil];
    
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    session.isMapLocationCall = YES;
    session.isMapLocationComplet = YES;
    
    [Flurry logPageView];
    [Flurry logEvent:@"Map View"];

    [tblView reloadData];
    self.navigationController.navigationBarHidden = YES;
    
    //For Add
    //[self performSelectorOnMainThread:@selector(fetchInfoAd) withObject:nil waitUntilDone:YES];
    [self performSelectorInBackground:@selector(fetchInfoAd) withObject:nil];
    
    //For Favorite Loation;
    //[self performSelectorOnMainThread:@selector(fetchFavoriteLocation) withObject:nil waitUntilDone:YES];
    [self performSelectorInBackground:@selector(fetchFavoriteLocation) withObject:nil];
    
    self.tabBarController.delegate = self;
    
    //session.nMapClick = 1;
    if(session.nMapClick==1)
    {
        btnAd.hidden = NO;
        mapview.hidden = NO;
        tblView.hidden = YES;
        imgToggleBG.image = [UIImage imageNamed:@"2.png"];
    }
    else
    {
        btnAd.hidden = YES;
        mapview.hidden = YES;
        tblView.hidden = NO;
        imgToggleBG.image = [UIImage imageNamed:@"1.png"];
    }
}
#pragma mark - Custom Method

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (int) getIconType : (NSString *) annotationTitle
{
    NSMutableArray *array =  [self getMapLocations];
    for(int i=0; i < [array count]; i++)
    {
        
        MapLocationModel *model = [array objectAtIndex:i];
        if([model.name isEqualToString:annotationTitle])
        {
            nIconType = model.icontype;
            break;
        }
    }
    return nIconType;
}

- (IBAction) mapButtonClick:(id)sender
{
    btnAd.hidden = NO;
    session.nMapClick = 1;
    mapview.hidden = NO;
    tblView.hidden = YES;
    imgToggleBG.image = [UIImage imageNamed:@"2.png"];
}

- (IBAction) listButtonClick:(id)sender
{
    btnAd.hidden = YES;
    session.nMapClick = 0;
    mapview.hidden = YES;
    tblView.hidden = NO;
    imgToggleBG.image = [UIImage imageNamed:@"1.png"];
    [tblView reloadData];
}

- (IBAction) adButtonClick:(id)sender
{
    [session openWebURL:adUrl];
}

- (IBAction) currentLocationButtonClick:(id)sender
{
    [self getCurrentLocationResults];
}

- (void) getCurrentLocationResults
{
    
    tblView.hidden = YES;
    mapview.hidden = NO;
    //Span of Map
    MKCoordinateRegion region;
    CLLocationCoordinate2D location;
    location.latitude = session.mapLatitude;
    location.longitude = session.mapLongitude;
    region.center = location;
    MKCoordinateSpan span;
    span.latitudeDelta = session.mapSpanLatitude;
    span.longitudeDelta = session.mapSpanLongitude;
    region.span = span;
    session.mapRadius = @"";
    [mapview setRegion:region animated:TRUE];
    [mapview setShowsUserLocation:YES];
    
    //Get Map location
    [self performSelectorInBackground:@selector(fetchMapLocation) withObject:nil];
    [tblView reloadData];
}

- (void) fetchFavoriteLocation
{
    if(session.isInternetReachable == YES)
    {
        [session getFavoriteLocationList];
    }
}


- (void) fetchInfoAd  {
    if(session.isInternetReachable == YES)
    {
        NSMutableArray * infoAdList = [session getInfoAd];
        if(session.isResponseSuccess)
        {
            int index = arc4random() % infoAdList.count;
            InfoAdModel *model = [infoAdList objectAtIndex:index];
            //urlString should be your image url which you want to access
            NSURL *url = [NSURL URLWithString:model.imageUrl];
            NSData *data = [NSData dataWithContentsOfURL:url];
            UIImage *image = [UIImage imageWithData:data];
            [btnAd setImage:image forState:UIControlStateNormal];
            adUrl = model.linkUrl;
        }
    }
}

- (void) fetchMapLocation  {
    
    if(session.isMapLocationComplet)
    {
        if(session.isInternetReachable == YES)
        {
            [session getMapLocations];
            
            if(session.mapLocationsList.count>0)
            {
                //For merge list Array;
                session.mapListLocationList = [self mergeSearchListArray:session.mapLocationsList :session.mapListLocationList];
                
                //Sort SearchList Array
                session.mapListLocationList = [self sortSearchListArray:session.mapListLocationList];
                
                [mapview setDelegate:self];
                [tblView reloadData];
                [self performSelectorOnMainThread:@selector(loadAnnotationViewOnMap) withObject:nil waitUntilDone:YES];
            }
            else
            {
                [tblView reloadData];
                [self removeAnnotations];
            }
            session.isMapLocationCall = YES;//Not Continus calling Method
            
            //This method will call when method response get complet.
            if(session.isMapLocationComplet==NO)
            {
                session.isMapLocationComplet = YES;
                session.isMapLocationCall = NO;//check add
                [self performSelectorInBackground:@selector(fetchMapLocation) withObject:nil];
            }
        }
    }
}

- (void) removeAnnotations {
    @try {
        [self.mapview removeAnnotations:self.mapview.annotations];
    } @catch (NSException *exception) {
        [Flurry logEvent:@"Remove Annotations Skips"];
    }
}

- (void) loadAnnotationViewOnMap
{
    [self removeAnnotations];
    
    isAnnotationRun = YES;
    NSMutableArray *annotations = [[NSMutableArray alloc] init];
    for(MapLocationModel *model in [self getMapLocations]) {
        [annotations addObject:[[MapAnnotation alloc] initWithNearby:model]];
    }
    [mapview addAnnotations:annotations];
    isAnnotationRun = NO;
}

- (NSMutableArray *) mergeSearchListArray : (NSMutableArray *) arrMap : (NSMutableArray *) arrList
{
    //For merge list Array;
    NSMutableArray *arrNewObject = [[NSMutableArray alloc] init];
    if(arrList.count>0)
    {
        for (int i = 0; i < arrMap.count; i++)
        {
            MapLocationModel *mapLocationModel = [arrMap objectAtIndex:i];
            BOOL isNewObject;
            MapLocationModel *listLocationModel;//
            for(int j = 0; j < arrList.count; j++)
            {
                isNewObject = NO;
                listLocationModel = [arrList objectAtIndex:j];
                if(mapLocationModel.ID == listLocationModel.ID)
                {
                    [arrList replaceObjectAtIndex:j withObject:mapLocationModel];
                    break;
                }
                else
                {
                    isNewObject = YES;
                }
            }
            if(isNewObject)
            {
                [arrNewObject addObject:mapLocationModel];
            }
        }
        
        [arrList addObjectsFromArray:arrNewObject];
    }
    else
    {
        [arrList addObjectsFromArray:arrMap];
    }
    
    return arrList;
}

- (NSMutableArray *) sortSearchListArray : (NSMutableArray *) arraySearch
{
    /*for ( int i=0; i < arraySearch.count-1; i++) //Here Check Max Count Condition
    {
        for (int j = i+1 ; j < arraySearch.count; j++) //Here Check Max Count Condition
        {
            MapLocationModel *model1 = [arraySearch objectAtIndex:i];
            MapLocationModel *model2 = [arraySearch objectAtIndex:j];
            
            if([super hasValue:model1] && [super hasValue:model2])
            {
                if(model1.distance > model2.distance)
                {
                    [arraySearch exchangeObjectAtIndex:i withObjectAtIndex:j];
                }
            }
        }
    }
    return arraySearch;*/
    NSSortDescriptor *sortByExpensedate;
    sortByExpensedate = [[NSSortDescriptor alloc] initWithKey:@"distance" ascending:YES];
    NSMutableArray *sortedExpenseArray = [NSMutableArray arrayWithObject:sortByExpensedate];
    [arraySearch sortUsingDescriptors:sortedExpenseArray];
    return arraySearch;
}

#pragma mark - MKMapViewDelegate
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    
    
    if ([annotation isKindOfClass:MKUserLocation.class]) {
        return nil;
    }
    
    MKPinAnnotationView *pin = (MKPinAnnotationView *) [mapView dequeueReusableAnnotationViewWithIdentifier: @"mapPin"];
	if (pin == nil) {
		pin = [[MKPinAnnotationView alloc] initWithAnnotation: annotation reuseIdentifier: @"mapPin"];
	} else {
		pin.annotation = annotation;
	}
    
	pin.canShowCallout = YES;
    MapAnnotation *model = (MapAnnotation *)annotation;
    nIconType = model.nIconType;
    if(nIconType==0)
    {
        pin.image = [UIImage imageNamed:@"tapit_icon.png"];
    }
    else{
        pin.image = [UIImage imageNamed:@"municipal_icon.png"];
    }
	pin.rightCalloutAccessoryView = detailButton;
	return pin;
}

- (void)mapView:(MKMapView *)inMapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    MapLocationModel *model = [((MapAnnotation *)(view.annotation)) model];
    
    session.directionLatitude = session.mapLatitude;
    session.directionLongitude = session.mapLongitude;
    
    objSearchTap.mapLocationModel = model;
    [self.navigationController pushViewController:objSearchTap animated:YES];
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    [mapview setShowsUserLocation:YES];
}


- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    //Center Point of MapView
    CLLocationCoordinate2D centre = [mapView centerCoordinate];
    session.mapCenterLat = centre.latitude;
    session.mapCenterLon = centre.longitude;
    
    //Span Value of MapView
    MKCoordinateSpan mySpan = [mapView region].span;
    session.mapSpanLatitude = mySpan.latitudeDelta;
    session.mapSpanLongitude = mySpan.longitudeDelta;
    
    //Radius
    CLLocationCoordinate2D centerCoordinate = mapView.centerCoordinate;
    CLLocation * newLocation = [[CLLocation alloc] initWithLatitude:centerCoordinate.latitude+mapView.region.span.latitudeDelta longitude:centerCoordinate.longitude];
     CLLocation *centerLocation = [[CLLocation alloc] initWithLatitude:centerCoordinate.latitude longitude:centerCoordinate.longitude];
    CLLocationDistance distance = [centerLocation distanceFromLocation:newLocation];
    session.mapRadius = [NSString stringWithFormat:@"%f", (distance*0.001)/2.2];//0.000621371*2
    
    if(session.isMapLocationCall)
    {
        session.isMapLocationCall = NO;
        [self performSelectorInBackground:@selector(fetchMapLocation) withObject:nil];
    }
    else 
    {
        session.isMapLocationComplet = NO;
    }
    
    [mapView setDelegate:self];
}


#pragma mark - Table View Datasource Method

- (NSMutableArray *) getMapLocations
{
    return session.mapLocationsList;
}

- (NSMutableArray *) getMapLocationsList
{
    return session.mapListLocationList;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section {
    return [[self getMapLocationsList] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SearchResultTableCell";
    SearchResultTableCell *cell = (SearchResultTableCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"SearchResultTableCell" owner:self options:nil];
        cell = [topLevelObjects objectAtIndex:0];
    }
    //Selected Bg
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    cell.selectedBackgroundView = cell.vwSelected;

    // Get Map Location Item
    MapLocationModel *mapLocation = [[self getMapLocationsList] objectAtIndex:indexPath.row];

    cell.lblDistance.text = [NSString stringWithFormat:@"%.1f",mapLocation.distance];
    cell.lblTitle.text = mapLocation.name;
    cell.lblAddress.text = mapLocation.address;
    
    [cell.lblDistance setFont:[UIFont fontWithName:FONT_BEBASNEUE size:17]];
    [cell.lblMile setFont:[UIFont fontWithName:FONT_DINREGULAR size:13]];
    [cell.lblTitle setFont:[UIFont fontWithName:FONT_DINBOLD size:14]];
    [cell.lblAddress setFont:[UIFont fontWithName:FONT_DINREGULAR size:12]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    session.directionLatitude = session.mapLatitude;
    session.directionLongitude = session.mapLongitude;
    
    objSearchTap.mapLocationModel = [[self getMapLocationsList] objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:objSearchTap animated:YES];
}

@end
