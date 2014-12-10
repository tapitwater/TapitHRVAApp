//
//  SearchViewController.m
//  TapIt
//
//  Created by Admin on 8/7/13.
//  Copyright (c) 2013 Admin. All rights reserved.
//

#import "SearchViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "SearchResultTableCell.h"
#import "myAnnotation.h"
#import "MapAnnotation.h"

@interface SearchViewController ()

@end

@implementation SearchViewController
@synthesize mapview;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [mapview setShowsUserLocation:YES];
    
    //Call for Current Location Results
    [self setCurrentLocationResults];
    
    detailButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    objSearchTap = [[SearchTapViewController alloc] initWithNibName:@"SearchTapViewController" bundle:nil];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    session.isSearchLocationCall = YES;
    session.isSearchLocationComplet = YES;
    
    self.navigationController.navigationBarHidden = YES;
    self.tabBarController.delegate = self;
    
    [Flurry logPageView];
    [Flurry logEvent:@"Search View"];

    txtSearch.text = @"";
    [tblView reloadData];
    
    //For Add
    [self performSelectorInBackground:@selector(fetchInfoAd) withObject:nil];
    
    //For Favorite Loation;
    [self performSelectorInBackground:@selector(fetchFavoriteLocations) withObject:nil];
    
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
    NSMutableArray *array =  [self getSearchLocations];
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

- (IBAction) mapTabButtonClick:(id)sender
{
    session.myTab1.selectedIndex = 2;
    session.myTab1.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
}

- (IBAction) mapButtonClick:(id)sender
{
    btnAd.hidden = NO;
    txtSearch.text = @"";
    session.nMapClick = 1;
    mapview.hidden = NO;
    tblView.hidden = YES;
    imgSearchBG.backgroundColor = [UIColor whiteColor];
    imgSearchBG.alpha = 0.7;
    imgToggleBG.image = [UIImage imageNamed:@"2.png"];
    [txtSearch resignFirstResponder];
}

- (IBAction) listButtonClick:(id)sender
{
    btnAd.hidden = YES;
    txtSearch.text = @"";
    session.nMapClick = 0;
    mapview.hidden = YES;
    tblView.hidden = NO;
    imgSearchBG.backgroundColor = [UIColor whiteColor];
    imgToggleBG.image = [UIImage imageNamed:@"1.png"];
    [txtSearch resignFirstResponder];
    [tblView reloadData];
}

- (IBAction) adButtonClick:(id)sender
{
    [session openWebURL:adUrl];
}

- (void) setCurrentLocationResults
{
    //Span & Center of Map
    MKCoordinateRegion region;
    CLLocationCoordinate2D location;

    location.latitude = session.mapLatitude;
    location.longitude = session.mapLongitude;
    region.center = location;
    MKCoordinateSpan span;
    span.latitudeDelta = session.searchSpanLatitude;
    span.longitudeDelta = session.searchSpanLongitude;
    region.span = span;
    session.searchRadius = @"";
    [mapview setRegion:region animated:TRUE];
    
    [mapview setDelegate:self];
}

- (void) fetchFavoriteLocations
{
    if(session.isInternetReachable == YES)
    {
        [session getFavoriteLocationList];
    }
}

- (void) fetchInfoAd
{
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
    
        if(session.isSearchLocationComplet)
        {
            if(session.isInternetReachable == YES)
            {
                [session getSearchLocations];
                
                if(session.searchLocationsList.count>0)
                {
                    //Merge Search List
                    session.searchListLocationList = [self mergeSearchListArray:session.searchLocationsList :session.searchListLocationList];
                    
                    //Sort SearchList Array
                    session.searchListLocationList = [self sortSearchListArray:session.searchListLocationList];
                    
                    [mapview setDelegate:self];
                    [tblView reloadData];
                    [self performSelectorOnMainThread:@selector(loadAnnotationViewOnMap) withObject:nil waitUntilDone:YES];
                }
                else
                {
                    [tblView reloadData];
                    [self removeAnnotations];
                }
                session.isSearchLocationCall = YES;//Not Continus calling Method
                
                //This method will call when method response get complet.
                if(session.isSearchLocationComplet==NO)
                {
                    session.isSearchLocationComplet = YES;
                    session.isSearchLocationCall = NO;//check add
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
    for(MapLocationModel *model in [self getSearchLocations]) {
        [annotations addObject:[[MapAnnotation alloc] initWithNearby:model]];
    }
    [mapview addAnnotations:annotations];
    isAnnotationRun = NO;
}

- (void) searchButtonClick
{
    if(txtSearch.text.length > 0)
    {
        if(session.previusSearchText != txtSearch.text)
        {
            if(session.isInternetReachable == YES)
            {
                [session getLatLong:txtSearch.text];
                
                NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
                [params setValue:[NSString stringWithFormat:@"%f",[session mapLatitude]] forKey:@"lat"];
                [params setValue:[NSString stringWithFormat:@"%f",[session mapLongitude]] forKey:@"lon"];
                [Flurry logEvent:@"User_Location" withParameters:params];
                
                if(session.isResponseSuccess)
                {
                    session.searchLatitude = session.cityLatitude;
                    session.searchLongitude = session.cityLongitude;
                    session.searchCenterLat = session.searchLatitude;
                    session. searchCenterLon = session.searchLongitude;
                    
                    //Span & Center of Map
                    MKCoordinateRegion region;
                    CLLocationCoordinate2D location;
                    location.latitude = session.searchLatitude;
                    location.longitude = session.searchLongitude;
                    region.center = location;
                    MKCoordinateSpan span;
                    span.latitudeDelta = 0.017149;
                    span.longitudeDelta = 0.015958;
                    region.span = span;
                    session.searchRadius = @"";
                    [mapview setRegion:region animated:TRUE];
                    
                    [txtSearch resignFirstResponder];
                    [session.searchLocationsList removeAllObjects];//check add this line
                    [session.searchListLocationList removeAllObjects];
                    [self performSelectorInBackground:@selector(fetchMapLocation) withObject:nil];
                    [mapview setDelegate:self];

                    session.previusSearchText = txtSearch.text;
                }
                else
                {
                    txtSearch.text = @"";
                    [session.searchLocationsList removeAllObjects];
                    [session.searchListLocationList removeAllObjects];
                    [tblView reloadData];
                    [self removeAnnotations];
                    
                    //Set Current Location
                    session.searchCenterLat = session.mapLatitude;
                    session.searchCenterLon = session.mapLongitude;
                    session.searchLatitude = session.mapLatitude;//add
                    session.searchLongitude = session.mapLongitude;//add
                    [self setCurrentLocationResults];
                    
                    UIAlertView *alrt = [[UIAlertView alloc] initWithTitle:@"Error!" message:session.errorMessage delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
                    [alrt performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:NO];
                }
            }
        }
    }
    else
    {
        //Set current location
        [txtSearch resignFirstResponder];
        session.previusSearchText = txtSearch.text;
        [session.searchLocationsList removeAllObjects];
        [session.searchListLocationList removeAllObjects];
        [tblView reloadData];
        [self removeAnnotations];
        
        //Set Current Location
        session.searchCenterLat = session.mapLatitude;
        session.searchCenterLon = session.mapLongitude;
        session.searchLatitude = session.mapLatitude;//add
        session.searchLongitude = session.mapLongitude;//add
        [self setCurrentLocationResults];
        
        [mapview setShowsUserLocation:YES];
    }
}

- (NSMutableArray *) mergeSearchListArray : (NSMutableArray *) arrSearch : (NSMutableArray *) arrList
{
    //For merge list Array;
    NSMutableArray *arrNewObject = [[NSMutableArray alloc] init];
    if(arrList.count>0)
    {
        for (int i = 0; i < arrSearch.count; i++)
        {
            MapLocationModel *searchLocationModel = [arrSearch objectAtIndex:i];
            BOOL isNewObject;
            MapLocationModel *listLocationModel;//
            for(int j = 0; j < arrList.count; j++)
            {
                isNewObject = NO;
                listLocationModel = [arrList objectAtIndex:j];
                if(searchLocationModel.ID == listLocationModel.ID)
                {
                    [arrList replaceObjectAtIndex:j withObject:searchLocationModel];
                    break;
                }
                else
                {
                    isNewObject = YES;
                }
            }
            if(isNewObject)
            {
                [arrNewObject addObject:searchLocationModel];
            }
        }
        
        [arrList addObjectsFromArray:arrNewObject];
    }
    else
    {
        [arrList addObjectsFromArray:arrSearch];
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
    MKPinAnnotationView *annotationView = (MKPinAnnotationView *) [mapView dequeueReusableAnnotationViewWithIdentifier: @"mapPin"];
	if (annotationView == nil) {
		annotationView = [[MKPinAnnotationView alloc] initWithAnnotation: annotation reuseIdentifier: @"mapPin"];
	} else {
		annotationView.annotation = annotation;
	}
    
    annotationView.canShowCallout = YES;
    
    MapAnnotation *model = (MapAnnotation *)annotation;
    nIconType = model.nIconType;
    
    if(nIconType==0)
    {
        annotationView.image = [UIImage imageNamed:@"tapit_icon.png"];
    }
    else
    {
        annotationView.image = [UIImage imageNamed:@"municipal_icon.png"];
    }
    
    annotationView.rightCalloutAccessoryView = detailButton;
    return annotationView;
}

- (void)mapView:(MKMapView *)inMapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    MapLocationModel *model = [((MapAnnotation *)(view.annotation)) model];
    
    session.directionLatitude = session.searchLatitude;
    session.directionLongitude = session.searchLongitude;
    
    objSearchTap.mapLocationModel = model;
    [self.navigationController pushViewController:objSearchTap animated:YES];
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    //    //[mapview setCenterCoordinate:userLocation.location.coordinate animated:YES];
    [self.mapview setShowsUserLocation:YES];
}


- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    //Center Point of MapView
    CLLocationCoordinate2D centre = [mapView centerCoordinate];
    session.searchCenterLat = centre.latitude;
    session.searchCenterLon = centre.longitude;
    
    //Span Value of MapView
    MKCoordinateSpan mySpan = [mapView region].span;
    session.searchSpanLatitude = mySpan.latitudeDelta;
    session.searchSpanLongitude = mySpan.longitudeDelta;
    
    //Radius
    CLLocationCoordinate2D centerCoordinate = mapView.centerCoordinate;
    CLLocation * newLocation = [[CLLocation alloc] initWithLatitude:centerCoordinate.latitude+mapView.region.span.latitudeDelta longitude:centerCoordinate.longitude];
    CLLocation *centerLocation = [[CLLocation alloc] initWithLatitude:centerCoordinate.latitude longitude:centerCoordinate.longitude];
    CLLocationDistance distance = [centerLocation distanceFromLocation:newLocation];
    session.searchRadius = [NSString stringWithFormat:@"%f", (distance*0.001)/2.2];//0.000621371*2
    
    if(session.isSearchLocationCall)
    {
        session.isSearchLocationCall = NO;
        [self performSelectorInBackground:@selector(fetchMapLocation) withObject:nil];
    }
    else
    {
        session.isSearchLocationComplet = NO;
    }
    [mapview setDelegate:self];
}


#pragma mark - Table View Datasource Method

- (NSMutableArray *) getSearchLocations
{
    return session.searchLocationsList;
}

- (NSMutableArray *) getSearchLocationList
{
    return session.searchListLocationList;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section {
    return [[self getSearchLocationList] count];
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
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    cell.selectedBackgroundView = cell.vwSelected;
    
    // Get Map Location Item
    if(indexPath.row < [[self getSearchLocationList] count]) {
        MapLocationModel *mapLocation = [[self getSearchLocationList] objectAtIndex:indexPath.row];
    
        cell.lblDistance.text = [NSString stringWithFormat:@"%.1f",mapLocation.distance];
        cell.lblTitle.text = mapLocation.name;
        cell.lblAddress.text = mapLocation.address;
    
        [cell.lblDistance setFont:[UIFont fontWithName:FONT_BEBASNEUE size:17]];
        [cell.lblMile setFont:[UIFont fontWithName:FONT_DINREGULAR size:13]];
        [cell.lblTitle setFont:[UIFont fontWithName:FONT_DINBOLD size:14]];
        [cell.lblAddress setFont:[UIFont fontWithName:FONT_DINREGULAR size:12]];
        
    } else {
        NSLog(@"Warning: Search Table Reload Happened !!!");
        [tableView reloadData];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    session.directionLatitude = session.searchLatitude;
    session.directionLongitude = session.searchLongitude;
    objSearchTap.mapLocationModel = [[self getSearchLocationList] objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:objSearchTap animated:YES];
}

#pragma mark - UiTextField Method

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self searchButtonClick];
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - Event Method

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [txtSearch resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
