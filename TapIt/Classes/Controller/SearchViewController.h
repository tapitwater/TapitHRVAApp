//
//  SearchViewController.h
//  TapIt
//
//  Created by Admin on 8/7/13.
//  Copyright (c) 2013 Admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "BaseViewController.h"
#import "SearchTapViewController.h"

@interface SearchViewController : BaseViewController <MKMapViewDelegate,UITabBarControllerDelegate,UITabBarDelegate>
{
    //Controller.
    SearchTapViewController *objSearchTap;
    
    //Interface.
    IBOutlet UITableView *tblView; 
    IBOutlet MKMapView *mapview;
    IBOutlet UIButton *btnMap, *btnList;
    IBOutlet UIImageView *imgToggleBG,*imgSearchBG;
    IBOutlet UITextField *txtSearch;
    IBOutlet UIButton *btnAd;
    IBOutlet UIButton *detailButton;
    
    //Objects.
    NSString       *adUrl;
    MKPinAnnotationView *Pin;
    
    //Flag.
    int nIconType;
    BOOL isAnnotationRun;
}

@property (nonatomic, retain)IBOutlet MKMapView *mapview;

- (void) setCurrentLocationResults;
- (void) fetchFavoriteLocations;
- (void) fetchInfoAd;
- (void) fetchMapLocation;
- (void) loadAnnotationViewOnMap;
- (void) searchButtonClick;
- (IBAction) mapTabButtonClick:(id)sender;
- (IBAction) mapButtonClick:(id)sender;
- (IBAction) listButtonClick:(id)sender;
- (IBAction) adButtonClick:(id)sende;

@end
