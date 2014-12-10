//
//  BaseViewController.h
//  Gobymobile
//
//  Created by Shardul Patel on 29/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"
#import <QuartzCore/QuartzCore.h>
#import "UIImage+Extension.h"
#import "SessionManager.h"
#import "MBProgressHUD.h"
#import "Flurry.h"

@interface BaseViewController : UIViewController <MBProgressHUDDelegate>    {
    
    SessionManager *session;
    MBProgressHUD *progressIndicator;
    BOOL viewNotificationEnabled;
}

@property (nonatomic, retain) SessionManager *session;

- (void)loadVariables;
- (void)loadNavigationBar;
- (void)loadDisplayContents;
- (void)startNotifications;
- (void)resignNotifications;
- (void)willAppearIn:(UINavigationController *)navController;   // Will Appear In Using Navigation controller
- (void)currentTabSelected:(UITabBarController *)tabController;
- (void)currentTabDeselected:(UITabBarController *)tabController;
- (void)setProgressIndicatorWithTitle:(NSString *)title andDetail:(NSString *)detail;
- (void)showProgressIndicatorWithTitle:(NSString *)title andDetail:(NSString *)detail animated:(BOOL)animated;
- (void)showProgressIndicator:(NSNumber *)animated;
- (void)hideProgressIndicator:(NSNumber *)animated;
- (void)updateProgressIndicatorTitle:(NSString *)title andDetail:(NSString *)detail;
- (BOOL)isPortrait;
- (UIButton *) buttonForTableViewCell: (NSString *)imageName;
- (void) button:(UIButton *)button pressedImageName:(NSString *)pressedImageName;
- (UIImageView *) checkmarkForTableViewCellAccessoryView;
- (UITextField *) textFieldForTableViewCellAccessoryView: (NSString *) placeHolder;
- (UITextField *) textFieldForTableViewCellContentView: (NSString *) placeHolder;
- (UILabel *) labelForTableViewCellAccessoryView: (NSString *) text;
- (UISwitch *) uiSwitchForTableViewCellContentView: (BOOL) isOn;
- (void) showAlertWithTitle:(NSString *)title message: (NSString *)message;
- (void)showAlertWithCancelOk: (NSString *)title message:(NSString *)message delegate:(id)delegate tag:(int)tag;
- (void) applyNavigationBarBackground:(UINavigationBar *)navigationBar;
- (void) displayGuideWithAnimation:(UIViewController *)guide;
- (void) removeGuideWithAnimation:(UIViewController *)guide;
- (void) sendEmailTo:(NSString *)to withSubject:(NSString *)subject withBody:(NSString *)body;
- (UIView *) headerView:(UITableView *)tableView section:(NSInteger)section sectionTitle:(NSString *)sectionTitle;
- (UIView *) footerView:(UITableView *)tableView section:(NSInteger)section sectionFooter:(NSString *)sectionFooter numberOfLines:(int)numberOfLines;
- (UIImage *)imageWithColor:(UIColor *)color;

- (BOOL) objectHasValue:(NSObject *) object;
- (BOOL) hasValue:(id)object;

@end


// Private Methods
@interface BaseViewController (Private)

@end
