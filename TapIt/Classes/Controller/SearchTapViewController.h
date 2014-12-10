//
//  SearchTapViewController.h
//  TapIt
//
//  Created by Admin on 7/2/13.
//  Copyright (c) 2013 Admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "MapLocationModel.h"
#import <Twitter/Twitter.h>
#import <Social/Social.h>
#import "MapDirectionViewController.h"
#import <Accounts/Accounts.h>

@interface SearchTapViewController : BaseViewController
{
    //Controller.
    MapLocationModel *mapLocationModel;
    MapDirectionViewController *objMapDirection;
    
    //Interface.
    IBOutlet UILabel *lblDistance, *lblMile, *lblName, *lblAddress, *lblWaterAccessQue, *lblWaterAccessMode, *lblWaterTypeQue, *lblWaterType,*lblNoteQue, *lblNote, *lblShareByRefill;
    IBOutlet UIButton *btnMap, *btnCall, *btnFavorite;
    IBOutlet UILabel *lblMap, *lblCall;
    IBOutlet UIView *viewMiddle, *viewLast;
    IBOutlet UIScrollView *scrView;
    IBOutlet UIImageView *imgCall;
    
    //Object
    NSMutableArray *arrFavorites;
    NSString *strFavoriteID;
    NSArray *arrTemp;
    NSString *strFBText, *strTwitterText;
}

@property (nonatomic, retain) MapLocationModel *mapLocationModel;

- (void) strFavoriteLocationID;
- (void) fetchSocialTempletText;
- (IBAction) favoriteButtonClick:(id)sender;
- (IBAction) backButtonClick:(id)sender;
- (IBAction) callButtonClick:(id)sender;
- (IBAction) mapDirectionButtonClick:(id)sender;
- (IBAction) facebookButtonClick:(id)sender;
- (IBAction) twitterButtonClick:(id)sender;

@end
