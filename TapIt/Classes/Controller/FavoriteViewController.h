//
//  FavoriteViewController.h
//  TapIt
//
//  Created by Admin on 7/2/13.
//  Copyright (c) 2013 Admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "SearchTapViewController.h"

@interface FavoriteViewController : BaseViewController <UITabBarControllerDelegate>
{
    //Controller.
    SearchTapViewController *objSearchTap;
    
    //Interface
    IBOutlet UITableView *tblView;

    //Object
    NSString *strFavoriteID;
}
- (IBAction) mapTabButtonClick:(id)sender;

@end
