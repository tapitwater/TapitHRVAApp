//
//  SessionManager.m
//  DnaTicket
//
//  Created by Shardul Patel on 29/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SessionManager.h"
#import "InfoAboutService.h"
#import "GetLatLongService.h"
#import "GoogleMapsCoordinateDistanceService.h"
#import "SocialTempletService.h"

@interface SessionManager (Private)

- (void) determineIOSVersion;

@end

@implementation SessionManager

#pragma mark - Synthesized Objects
@synthesize iOSVersion;
@synthesize deviceDetails;
@synthesize mapLocationsList, searchLocationsList,searchListLocationList,mapListLocationList;
@synthesize favoriteLocationList;
@synthesize isiPhone5, isResponseSuccess;
@synthesize mapLatitude, mapLongitude, mapRadius, searchRadius, mapCenterLat, mapCenterLon,  mapSpanLatitude, mapSpanLongitude,searchSpanLatitude, searchSpanLongitude, searchLatitude, searchLongitude, searchCenterLon,searchCenterLat, directionLatitude, directionLongitude;
@synthesize nTabIndex, nMapClick, isMapLocationComplet, isMapLocationCall, previusSearchText, isSearchLocationComplet, isSearchLocationCall;
@synthesize myTab1;
@synthesize internetReachability, isInternetReachable;
@synthesize cityLatitude, cityLongitude;
@synthesize errorMessage;

#pragma mark - Initialization Methods

static SessionManager *sessionInstance = nil;

// App Session Pointer
+ (SessionManager *) getInstance {
    @synchronized(self) {
        if (sessionInstance == nil) {
            sessionInstance = [[self alloc] init];
        }
    }
    return sessionInstance;
}

- (void) loadInternetReachability {
    NSLog(@"loadInternetReachability");
    internetReachability = [Reachability reachabilityForInternetConnection];
    [internetReachability startNotifier];
    isInternetReachable =[internetReachability isReachable];
}

// Initialize Session Defaults Here
- (void)loadSessionDefaults {
    // Check Internet Rechability
    [self loadInternetReachability];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reachabilityChanged:)
                                                 name:kReachabilityChangedNotification
                                               object:nil];
    
    // Determine iOS Version Number
    [self determineIOSVersion];
    
    // Get Device Info
    deviceDetails = [SPDeviceInfo deviceDetails];
    
    // Update User Location
    //[self updateUserLocation];
    
    // Get Mobile Device
    [self checkMobileDevice];
    
    //Array Initialization
    mapLocationsList = [[NSMutableArray alloc] init];
    searchLocationsList = [[NSMutableArray alloc] init];
    searchListLocationList = [[NSMutableArray alloc] init];
    favoriteLocationList = [[NSMutableArray alloc] init];
    mapListLocationList = [[NSMutableArray alloc] init];
    
    //Initiating Variables
    nTabIndex = 2;
    nMapClick = 1;
    //spanLatitude = 0.27;
    //spanLongitude = 0.27; 
    mapSpanLatitude = 0.017149;
    mapSpanLatitude = 0.015958;
    searchSpanLatitude = 0.017149;
    searchSpanLongitude = 0.015958;
    isMapLocationComplet = YES;
    isMapLocationCall = YES;
    isSearchLocationComplet = YES;
    isSearchLocationCall = YES;
    
}

// An Event to handle stuff after fresh install of app or after App Update
- (void)appRunningAfterFreshInstallOrUpdate    {
    NSLog(@"App Running After Fresh Install or After App Update");
}

// Initialization Code
- (id)init
{
    self = [super init];
    if (self) {
        
        // Initialization code here
        [self loadSessionDefaults];
        
        // Check If App is running after an Update
        if ([self isAppRunningFirstTimeAfterUpdate]) {
            [self appRunningAfterFreshInstallOrUpdate];
        }
    }
    
    return self;
}

#pragma mark - Application Instance Methods

// Get Application Delegate
- (AppDelegate *) appDelegate   {
    return (AppDelegate*)[[UIApplication sharedApplication] delegate];
}

// Get Whole Screen
- (UIWindow *) getAppScreen   {
    return [[self appDelegate] window];
}
#pragma mark - checkMobileDevice

- (void) checkMobileDevice
{
    if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone){
        if([UIScreen mainScreen].bounds.size.height == 568.0)
        {
            isiPhone5 = YES;
        }
        else{
            isiPhone5 = NO;
        }
    }
}
#pragma mark - Check And Update App Version

- (BOOL) isAppRunningFirstTimeAfterUpdate   {
    
    // Init User Defaults
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    // Version Object Key
    static NSString *lastKnownAppVersionKey = @"LastKnownAppVersion";
    
    // Fetch Last Known App Version from User Defaults
    NSString *lastKnownVersionString = [userDefaults objectForKey:lastKnownAppVersionKey];
    
    // Fetch Current App Version from Main Bundle
    NSString *currentVersionString = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    
    // Check If Last Known Version Is Available
    if ([self stringHasValue:lastKnownVersionString]) {
        // Version Number Exist
        // Compare Last Known App Version with Current App Version
        if ([lastKnownVersionString isEqualToString:currentVersionString]) {
            // App is running on Same Version
            return NO;
        }
        else    {
            // App is running newer version then Last known App Version
            [userDefaults setObject:currentVersionString forKey:lastKnownAppVersionKey];
            [userDefaults synchronize];
            return YES;
        }
    }
    else    {
        // App Running After Fresh Install
        [userDefaults setObject:currentVersionString forKey:lastKnownAppVersionKey];
        [userDefaults synchronize];
        return YES;
    }
}

#pragma mark - Determine iOS Version Number

- (void) determineIOSVersion {
    
    int index = 0;
    
    NSArray* digits = [[UIDevice currentDevice].systemVersion componentsSeparatedByString:@"."];
    NSEnumerator* enumer = [digits objectEnumerator];
    NSString* number;
    while (number = [enumer nextObject]) {
        if (index>2) {
            break;
        }
        NSInteger multipler = powf(100, 2-index);
        iOSVersion += [number intValue]*multipler;
        index++;
    }
    
    NSLog(@"Current iOS Version : %@ : %d", [[UIDevice currentDevice] systemVersion], iOSVersion);
}

#pragma mark - Internet Rechability Check

- (void) reachabilityChanged:(NSNotification*)note    {
    NSLog(@"reachabilityChanged");
    Reachability *reachability = [note object];
    if([reachability isReachable])
    {
        isInternetReachable = YES;
    }
    else
    {
        isInternetReachable = NO;
        //[self displayInternetConnectionNotAvailableAlert];
    }
}

- (void) displayInternetConnectionNotAvailableAlert {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sorry"
                                                    message:@"Internet is not reachable."
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert performSelectorOnMainThread:@selector(show)
                            withObject:nil
                         waitUntilDone:NO];
    
}

#pragma mark - Detect Retina Display
+ (BOOL) isDeviceHaveRetinaDisplay  {
    
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)] && [[UIScreen mainScreen] scale] == 2.0) {
        // Device Have Retina Screen
        return YES;
    }
    // Device Have Normal Screen
    return NO;
}

#pragma mark - Value Check Methods

- (BOOL) stringHasValue:(NSString *)string    {
    
    if (string == (id)[NSNull null] || string==nil || [string isEqualToString:@""]) {
        return NO;
    }
    else {
        return YES;
    }
}

- (BOOL) urlHasValue:(NSURL *)string    {
    
    if (string == (id)[NSNull null] || string==nil) {
        return NO;
    }
    else {
        return YES;
    }
}

- (BOOL) arrayHasValue:(NSArray *)array     {
    
    if (array == (id)[NSNull null] || array==nil || [array count]==0) {
        return NO;
    }
    else {
        return YES;
    }
}

- (BOOL) dictionaryHasValue:(NSDictionary *)dictionary  {
    
    if (dictionary == (id)[NSNull null] || dictionary==nil || [dictionary count]==0) {
        return NO;
    }
    else {
        return YES;
    }
}

#pragma mark - Email Validation Method
- (BOOL) isStringIsValidEmail:(NSString *)checkString   {
    
    BOOL stricterFilter = YES;
    NSString *stricterFilterString = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSString *laxString = @".+@.+\\.[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}

#pragma mark - Color Generation Methods
- (UIColor *) makeColorWithRed:(int)red Green:(int)green Blue:(int)blue Alpha:(float)alpha  {
    return [UIColor colorWithRed:(float)red/255.0 green:(float)green/255.0 blue:(float)blue/255.0 alpha:alpha];
}

#pragma mark - Frame Resize Helper Methods
- (CGRect) resizeLabel:(UILabel *)myLabel    {
    
    CGRect labelFrame = CGRectMake(myLabel.frame.origin.x,
                                   myLabel.frame.origin.y,
                                   myLabel.frame.size.width,
                                   500000.0);
    
    CGSize labelSize = [myLabel.text sizeWithFont:myLabel.font
                                constrainedToSize:labelFrame.size
                                    lineBreakMode:myLabel.lineBreakMode];
    
    CGRect frame = CGRectMake(myLabel.frame.origin.x,
                              myLabel.frame.origin.y,
                              labelSize.width,
                              labelSize.height);
    
    return frame;
}

- (int) numberOfLinesInLabel:(UILabel *)myLabel {
    
    CGRect labelFrame = [self resizeLabel:myLabel];
    int rowCount = labelFrame.size.height / myLabel.font.lineHeight;
    return rowCount;
}

- (CGRect) resizeTextView:(UITextView *)myTextView      {
    
    CGSize textViewSize = myTextView.contentSize;
    
    CGRect frame = CGRectMake(myTextView.frame.origin.x,
                              myTextView.frame.origin.y,
                              textViewSize.width,
                              textViewSize.height);
    
    return frame;
}

- (int) numberOfLinesInTextView:(UITextView *)myTextView {
    
    CGRect textViewFrame = [self resizeTextView:myTextView];
    int rowCount = textViewFrame.size.height / myTextView.font.lineHeight;
    return rowCount;
}

#pragma mark - Path Generation Methods

- (NSString *) mainBundlePathStringForFileName:(NSString *)fileName ofType:(NSString *)type   {
    
    return [[NSBundle mainBundle] pathForResource:fileName ofType:type];
}

- (NSURL *) mainBundlePathURLForFileName:(NSString *)fileName ofType:(NSString *)type    {
    
    NSString *filPath = [self mainBundlePathStringForFileName:fileName ofType:type];
    return [NSURL fileURLWithPath:filPath];
}

- (NSString *) pathStringForFileName:(NSString *)fileName ofType:(NSString *)type   {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
    
    // Validate File Name
    if (fileName==nil || [fileName isEqualToString:@""]) {
        return nil;
    }
    
    NSString *fullFilename = [NSString stringWithFormat:@"%@",fileName];
    
    // Validate File Extension
    if (type!=nil && ![type isEqualToString:@""]) {
        fullFilename = [fullFilename stringByAppendingFormat:@".%@",type];
    }
    
	return [documentsDirectory stringByAppendingPathComponent:fullFilename];
}

- (NSURL *) pathURLForFileName:(NSString *)fileName ofType:(NSString *)type	{
    
	NSString *filPath = [self pathStringForFileName:fileName ofType:type];
    return [NSURL fileURLWithPath:filPath];
}

#pragma mark - Save Image to Path
- (NSString *) currentTimeStamp {
    NSTimeInterval timeStamp = [[NSDate date] timeIntervalSince1970];
    return [[NSNumber numberWithUnsignedInteger:timeStamp] stringValue];
}

- (BOOL) validateImageStorageDirectory    {
    
    NSString *directoryPath = [self pathStringForFileName:@"AssetImages" ofType:nil];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:directoryPath]){
        
        NSError* error;
        if ([[NSFileManager defaultManager] createDirectoryAtPath:directoryPath
                                      withIntermediateDirectories:YES
                                                       attributes:nil
                                                            error:&error])
        {
            return YES;
        }
        else    {
            NSLog(@"ERROR: %@", [error localizedDescription]);
            return NO;
        }
    }
    else    {
        return YES;
    }
}

- (NSString *) saveImageInDocuments:(UIImage *)image    {
    
    if (image!=nil && image.CGImage) {
        
        NSString *imagePath;
        if ([self validateImageStorageDirectory]) {
             imagePath = [self pathStringForFileName:[NSString stringWithFormat:@"Images/%@",[self currentTimeStamp]] ofType:@"jpg"];
        }
        else    {
             imagePath = [self pathStringForFileName:[NSString stringWithFormat:@"%@",[self currentTimeStamp]] ofType:@"jpg"];
        }
        
        if ([self stringHasValue:imagePath]) {
         
            // Write image to PNG
            [UIImageJPEGRepresentation(image, 1.0) writeToFile:imagePath atomically:YES];
            
            // Create file manager
            NSFileManager *fileManager = [NSFileManager defaultManager];
            
            // Let's check to see if files were successfully written...
            if ([fileManager fileExistsAtPath:imagePath]) {
                return imagePath;
            }
        }
    }
    
    return nil;
}

#pragma mark - Open Web browser
- (void) openWebURL:(NSString *)webURL  {
    
    if ([self stringHasValue:webURL]) {
        
        NSURL *url = [NSURL URLWithString:[webURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        
        if (![[UIApplication sharedApplication] openURL:url])   {
            NSLog(@"%@%@",@"Failed to open url:",[url description]);
        }
    }
    else    {
        
        NSLog(@"Can not open Safari : (Reason) There is no any link available to open url.");
    }
}

- (void) openWebURL1:(NSURL *)webURL  {
    
    if ([self urlHasValue:webURL]) {
        
       // NSURL *url = [NSURL URLWithString:[webURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        
        if (![[UIApplication sharedApplication] openURL:webURL])   {
            NSLog(@"%@%@",@"Failed to open url:",[webURL description]);
        }
    }
    else    {
        
        NSLog(@"Can not open Safari : (Reason) There is no any link available to open url.");
    }
}

#pragma mark - Call Method
- (void) callNumber:(NSString *)numberString    {
    

    NSString *phoneNumber = [numberString copy];
    NSString *cleanedString = [[phoneNumber componentsSeparatedByCharactersInSet:[[NSCharacterSet characterSetWithCharactersInString:@"0123456789-+()"] invertedSet]] componentsJoinedByString:@""];
    NSString *escapedPhoneNumber = [cleanedString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    // Init Call
    if (escapedPhoneNumber!=nil && ![escapedPhoneNumber isEqualToString:@""]) {
        
        NSURL *telURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", escapedPhoneNumber]];
        if ([[UIApplication sharedApplication] canOpenURL:telURL]) {
            [[UIApplication sharedApplication] openURL:telURL];
        }
        else    {
            NSLog(@"%@%@",@"Failed to open url:",[telURL description]);
        }
    }
    else    {
        NSLog(@"Can not open Call : (Reason) There is no any link available to open url.");
    }
    
    /*
    NSString *phoneNumber = @"1-800-555-1212"; // dynamically assigned
    NSString *phoneURLString = [NSString stringWithFormat:@"tel:%@", phoneNumber];
    NSURL *phoneURL = [NSURL URLWithString:phoneURLString];
    [[UIApplication sharedApplication] openURL:phoneURL];
     */
}

#pragma mark - Get App Background Image Method

- (BOOL) loadAppBackgroundImageNames    {
    
    // Load Image Name List from PList file if not loaded
    if (![self arrayHasValue:backgroundImageNameList]) {
        
        NSString *filename;
        
        // Detect Device Display Size
        if (self.deviceDetails.display == SPDeviceDisplayiPhone4Inch) {
            // It has an iPhone 4 inch display
            filename = APP_BACKGROUNDS_4INCH_PLIST;
        }
        else    {
            // It has an iPhone 3.5 inch display
            filename = APP_BACKGROUNDS_PLIST;
        }
        
        backgroundImageNameList = [NSArray arrayWithContentsOfFile:[self mainBundlePathStringForFileName:filename ofType:nil]];
        currentBackgroundImageIndex = 0;
        
        if (![self arrayHasValue:backgroundImageNameList]) {
            return NO;
        }
    }
    
    return YES;
}

- (UIImage *) getRandomAppBackgroundImage   {
    
    if ([self loadAppBackgroundImageNames]) {
        
        // Generate Random Number
        int totalAvailableImages = [backgroundImageNameList count];
        currentBackgroundImageIndex = arc4random() % totalAvailableImages;
        
        // Validate Current Index
        if (currentBackgroundImageIndex>=0 && currentBackgroundImageIndex<totalAvailableImages) {
            return [UIImage imageNamed:[backgroundImageNameList objectAtIndex:currentBackgroundImageIndex]];
        }
    }
    
    return nil;
}

- (UIImage *) getCurrentAppBackgroundImage  {
    
    if ([self loadAppBackgroundImageNames]) {
        
        // Validate Current Index
        int totalAvailableImages = [backgroundImageNameList count];
        if (currentBackgroundImageIndex>=0 && currentBackgroundImageIndex<totalAvailableImages) {
            return [UIImage imageNamed:[backgroundImageNameList objectAtIndex:currentBackgroundImageIndex]];
        }
    }
    
    return nil;
}

#pragma mark - User Location Update Helper Methods
- (void) updateUserLocation     {
    locationManager = [[CLLocationManager alloc] init];
	locationManager.delegate = self;
	locationManager.desiredAccuracy = kCLLocationAccuracyBest;
	[locationManager startUpdatingLocation];
}

#pragma mark CLLocationManagerDelegate Methods
- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation {
    mapLatitude = newLocation.coordinate.latitude;
    mapLongitude = newLocation.coordinate.longitude;
    mapCenterLat = mapLatitude;
    mapCenterLon = mapLongitude;
    searchLatitude = mapLatitude;
    searchLongitude = mapLongitude;
    
    [locationManager stopUpdatingLocation];
    locationManager.delegate = nil;
    locationManager = nil;
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error	{
    
//    mapLatitude = 38.907;
//    mapLongitude = -77.0367;
    mapLatitude = 38.010494;
    mapLongitude = -79.4613645;
    mapCenterLat = mapLatitude;
    mapCenterLon =mapLongitude;
    searchLatitude = mapLatitude;
    searchLongitude = mapLongitude;
    
    [locationManager stopUpdatingLocation];
    locationManager.delegate = nil;
    locationManager = nil;
    
    // Show Error Alert Message
    NSString *title = @"";
    NSString *description = @"";
    if (error.code == kCLErrorDenied)   {
        title = @"Access Denied";
        description = error.localizedDescription;
    }
    else    {
        title = @"Unable to get location";
        description = error.localizedDescription;
    }
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Unable to get location"
                                                    message:error.localizedDescription
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:NO];
}

#pragma mark - User Accessible Methods
- (BOOL) isUserLoggedIn    {
    
//    if (self.currentUser==nil) {
//        return NO;
//    }
    
    return YES;
}
 
#pragma mark - Services ##########


#pragma mark Fetch All Map Location

- (void) getMapLocations
{
    //[self updateUserLocation];
    
    MapLocationRequest *request = [[MapLocationRequest alloc] init];
    request.latitude = [NSString stringWithFormat:@"%f",mapLatitude];
    request.longitude =[NSString stringWithFormat:@"%f",mapLongitude];
    request.mapCenterLat = [NSString stringWithFormat:@"%f",mapCenterLat];
    request.mapCenterLon = [NSString stringWithFormat:@"%f",mapCenterLon];
    request.radius = mapRadius;//*searchRadius
    
    mapLocationsList = [[MapLocationService getInstance] mapLocation:request];
}

- (void) getSearchLocations
{
    //[self updateUserLocation];
    
    MapLocationRequest *request = [[MapLocationRequest alloc] init];
    request.latitude = [NSString stringWithFormat:@"%f",searchLatitude];
    request.longitude =[NSString stringWithFormat:@"%f",searchLongitude];
    request.mapCenterLat = [NSString stringWithFormat:@"%f",searchCenterLat];
    request.mapCenterLon = [NSString stringWithFormat:@"%f",searchCenterLon];
    request.radius = searchRadius;
    
    searchLocationsList = [[MapLocationService getInstance] mapLocation:request];
}

#pragma mark - get Faverites list

- (void) getFavoriteLocationList
{
    FavoritesRequest *request = [[FavoritesRequest alloc] init];
    request.latitude = [NSString stringWithFormat:@"%f",mapLatitude];
    request.longitude =[NSString stringWithFormat:@"%f",mapLongitude];
    request.mapCenterLat = @"";
    request.mapCenterLon = @"";
    request.radius = @"";
    NSString *str = [[NSUserDefaults standardUserDefaults] objectForKey:@"favoristLocations"];
    request.favorites = str;
    //NSLog(@"favorite string: %@",str);
    if(str.length > 0)
    {
        favoriteLocationList = [[FavoriteService getInstance] mapLocation:request];
    }
}

#pragma mark Get Info Ad Method

- (NSMutableArray *) getInfoAd
{
    infoAdRequest *request = [[infoAdRequest alloc] init];
    infoAdResponce *response = [[InfoAdService getInstance] getInfoAd:request];
    
    if(response.success)
    {
        isResponseSuccess = response.success;
        return response.infoAdList;
    }
    else
    {
        isResponseSuccess = response.success;
    }
    return nil;
}

#pragma mark Get Info About Method

- (NSMutableArray *) getInfoAbout
{
    InfoAboutRequest *request = [[InfoAboutRequest alloc] init];
    InfoAboutResponce *response = [[InfoAboutService getInstance] getInfoAbout:request];
    if(response.success)
    {
        isResponseSuccess = response.success;
        return response.infoAboutList;
    }
    else
    {
        isResponseSuccess = response.success;
    }
    return nil;
    
}

#pragma mark Get Coordinate distance & Time Method

- (CoordinateDistanceModel *) getGoogleMapsCoordinateDistanceWithRequest: (CLLocationCoordinate2D)fromLocation toLocation:(CLLocationCoordinate2D)toLocation    {
    
    GoogleMapsCoordinateDistanceRequest *request = [[GoogleMapsCoordinateDistanceRequest alloc] init];
    request.originLatitude = [NSNumber numberWithDouble:fromLocation.latitude];
    request.originLongitude = [NSNumber numberWithDouble:fromLocation.longitude];
    request.destinationLatitude = [NSNumber numberWithDouble:toLocation.latitude];
    request.destinationLongitude = [NSNumber numberWithDouble:toLocation.longitude];
    
    GoogleMapsCoordinateDistanceResponse *response = [[GoogleMapsCoordinateDistanceService getInstance] getGoogleMapsCoordinateDistanceWithRequest:request];
    if(response.success)
    {
        isResponseSuccess = response.success;
        return response.coordinateDistance;
    }
    else
    {
        isResponseSuccess = response.success;
        errorMessage = response.errorMessage;
    }
    return nil;
}

#pragma mark Get SocialTemplet

- (NSMutableArray *) getSocialTemplet
{
    SocialTempletRequest *request = [[SocialTempletRequest alloc] init];
    SocialTempletResponce *response = [[SocialTempletService getInstance] getSocialTemplet:request];
    if(response.success)
    {
        isResponseSuccess = response.success;
        return response.socialTempletList;
    }
    else
    {
        isResponseSuccess = response.success;
        errorMessage = response.errorMessage;
    }
    return nil;
}

#pragma mark Get LatLong

- (void) getLatLong: (NSString *) searchCity
{
    GetLatLongRequest *request = [[GetLatLongRequest alloc] init];
    request.address = searchCity;

    GetLatLongResponse *response = [[GetLatLongService getInstance] getLatLong:request];
    if(response.success)
    {
        isResponseSuccess = response.success;
        cityLatitude = [response.latitude doubleValue];
        cityLongitude = [response.longitude doubleValue];
    }
    else
    {
        isResponseSuccess = response.success;
        errorMessage = response.errorMessage;
    }
}

@end

