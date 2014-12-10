//
//  SessionManager.h
//  DnaTicket
//
//  Created by Shardul Patel on 29/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

#import "AppDelegate.h"
#import "SPDeviceInfo.h"
#import "Reachability.h"
#import <Twitter/Twitter.h>
#import <Social/Social.h>
#import "CoordinateDistanceModel.h"

#import "MapLocationService.h"
#import "TwitterFeedService.h"
#import "FavoriteService.h"
#import "InfoAdService.h"



@interface SessionManager : NSObject <CLLocationManagerDelegate>    {
    
    // Device Info
    SPDeviceDetails deviceDetails;
    NSUInteger iOSVersion;

    // Internet Reachability
    Reachability *internetReachability;
    BOOL isInternetReachable;
    
    // User Data
    
    // Background Image List
    NSArray *backgroundImageNameList;
    int currentBackgroundImageIndex;
    
    //Check for iPhone 4 Or iPhone 5
    BOOL isiPhone5;

    // User Location Info
    CLLocationManager *locationManager;
    
    // Array Data
    NSMutableArray *mapLocationsList, *mapListLocationList, *searchLocationsList, *searchListLocationList;
    NSMutableArray *favoriteLocationList;
    
    //Selected tab index
    int nTabIndex,nMapClick;
    
    //Map Location Service call con-currently
    BOOL isMapLocationComplet,isMapLocationCall;
    BOOL isSearchLocationComplet, isSearchLocationCall;
    
    //Previus Search Text
    NSString *previusSearchText;
    
    //Map Location parameter
    double mapLatitude, searchLatitude;
    double mapLongitude, searchLongitude;
    NSString *mapRadius,*searchRadius;
    double mapCenterLat, searchCenterLat;
    double mapCenterLon, searchCenterLon;
    double mapSpanLatitude, mapSpanLongitude, searchSpanLatitude, searchSpanLongitude;
    double directionLatitude, directionLongitude;
    
    //Get LatLog Variable
    double cityLatitude, cityLongitude;
    BOOL isResponseSuccess;
    NSString *errorMessage;
}

@property (nonatomic, readonly) NSUInteger iOSVersion;
@property (nonatomic, readonly) SPDeviceDetails deviceDetails;

+ (SessionManager *) getInstance;
- (AppDelegate *) appDelegate;
- (UIWindow *) getAppScreen;

// Detect Retina Display
+ (BOOL) isDeviceHaveRetinaDisplay;

// Value Check Methods
- (BOOL) stringHasValue:(NSString *)string;
- (BOOL) arrayHasValue:(NSArray *)array;
- (BOOL) dictionaryHasValue:(NSDictionary *)dictionary;

// Email Validation Method
- (BOOL) isStringIsValidEmail:(NSString *)checkString;

// Color Generation Methods
- (UIColor *) makeColorWithRed:(int)red Green:(int)green Blue:(int)blue Alpha:(float)alpha;

// Frame Resize Helper Methods
- (CGRect) resizeLabel:(UILabel *)myLabel;
- (int) numberOfLinesInLabel:(UILabel *)myLabel;
- (CGRect) resizeTextView:(UITextView *)myTextView;
- (int) numberOfLinesInTextView:(UITextView *)myTextView;

// Save Image to Path
- (NSString *) currentTimeStamp;
- (NSString *) saveImageInDocuments:(UIImage *)image;

// Path Generation Methods
- (NSString *) mainBundlePathStringForFileName:(NSString *)fileName ofType:(NSString *)type;
- (NSURL *) mainBundlePathURLForFileName:(NSString *)fileName ofType:(NSString *)type;
- (NSString *) pathStringForFileName:(NSString *)fileName ofType:(NSString *)type;
- (NSURL *) pathURLForFileName:(NSString *)fileName ofType:(NSString *)type;

// Open Web browser
- (void) openWebURL:(NSString *)webURL;
- (void) openWebURL1:(NSURL *)webURL;

// Call to Number Method
- (void) callNumber:(NSString *)numberString;


// Get App Background Image Method
- (UIImage *) getRandomAppBackgroundImage;
- (UIImage *) getCurrentAppBackgroundImage;

// Update User Location
- (void) updateUserLocation;

// User Accessible Methods
- (BOOL) isUserLoggedIn;

//#####################################################

//#######

//#####################################################
//TabBar For Button Click
@property (nonatomic,retain) UITabBarController *myTab1;
@property (nonatomic) BOOL isiPhone5, isInternetReachable, isResponseSuccess;
@property (nonatomic, retain) NSString *previusSearchText;
@property (nonatomic) BOOL isMapLocationComplet, isMapLocationCall, isSearchLocationComplet, isSearchLocationCall;
@property (nonatomic) int nTabIndex, nMapClick;
@property (nonatomic, retain) NSMutableArray *mapLocationsList, *searchLocationsList, *searchListLocationList, *mapListLocationList;
@property (nonatomic, retain) NSMutableArray *favoriteLocationList;
//For Map Location parameter
@property (nonatomic) double mapLatitude, mapLongitude, mapCenterLat, mapCenterLon, mapSpanLatitude, mapSpanLongitude,searchSpanLatitude, searchSpanLongitude, searchLatitude, searchLongitude, searchCenterLat,
searchCenterLon, directionLatitude, directionLongitude;
@property (nonatomic, retain) NSString *mapRadius,*searchRadius, *errorMessage;;
@property (nonatomic, retain) Reachability *internetReachability;
@property (nonatomic) double cityLatitude, cityLongitude;

// Web Services
- (void) loadInternetReachability;
- (void) getMapLocations;
- (void) getSearchLocations;
- (void) getFavoriteLocationList;
- (NSMutableArray *) getInfoAd;
- (NSMutableArray *) getInfoAbout;
- (CoordinateDistanceModel *) getGoogleMapsCoordinateDistanceWithRequest: (CLLocationCoordinate2D)fromLocation toLocation:(CLLocationCoordinate2D)toLocation;
- (NSMutableArray *) getSocialTemplet;
- (void) getLatLong: (NSString *) searchCity;

@end

