//
//  SplashViewController.h
//  TapIt
//
//  Created by Admin on 7/2/13.
//  Copyright (c) 2013 Admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface SplashViewController : BaseViewController
{
    //Interface.
    IBOutlet UIImageView *imgScreen;
}

@property (nonatomic,retain)  IBOutlet UITabBarController *myTab;

@end
