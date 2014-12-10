//
//  MapViewController.h
//  TapIt
//
//  Created by Admin on 7/2/13.
//  Copyright (c) 2013 Admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "SearchTapViewController.h"
#import <MapKit/MapKit.h>

@interface MapViewController : BaseViewController <MKMapViewDelegate,UITabBarControllerDelegate,UITabBarDelegate>
{
    //Controller.
    SearchTapViewController *objSearchTap;
    
    //Interface.
    IBOutlet UITableView *tblView;
    IBOutlet MKMapView *mapview;
    IBOutlet UIButton *btnMap, *btnList;
    IBOutlet UIButton *btnAd;
    IBOutlet UIImageView *imgToggleBG;
    IBOutlet UIButton *detailButton;
    
    //Objects.
    NSString       *adUrl;
    MKPinAnnotationView *Pin;
    
    //Flag.
    int nTagCallOut, nIconType;
    BOOL isAnnotationRun;
}

@property (nonatomic, retain)IBOutlet MKMapView *mapview;

- (void) fetchInfoAd;
- (void) fetchFavoriteLocation;
- (void) fetchMapLocation;
- (void) loadAnnotationViewOnMap;
- (IBAction) mapButtonClick:(id)sender;
- (IBAction) listButtonClick:(id)sender;
- (IBAction) adButtonClick:(id)sender;
- (IBAction) currentLocationButtonClick:(id)sender;

@end

