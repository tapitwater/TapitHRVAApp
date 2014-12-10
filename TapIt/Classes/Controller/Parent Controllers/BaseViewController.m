//
//  BaseViewController.m
//  Gobymobile
//
//  Created by Shardul Patel on 29/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BaseViewController.h"
#import "Flurry.h"

@implementation BaseViewController

#pragma mark - Synthesized Objects

@synthesize session;

#pragma mark - Initialization Methods

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
        // Get Instance Of Session Manager
        session = [SessionManager getInstance];
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        // Get Instance Of Session Manager
        session = [SessionManager getInstance];
    }
    return self;
}

#pragma mark - View lifecycle

- (void)loadVariables   {
    
}


- (void)loadNavigationBar   {
    
}

- (void)loadDisplayContents {
    
}

- (void)startNotifications   {
    
    viewNotificationEnabled = YES;
}

- (void)resignNotifications {
    
    viewNotificationEnabled = NO;
}

- (void)viewDidLoad
{
    // Get Instance Of Session Manager
    session = [SessionManager getInstance];
    
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self loadVariables];
    [self loadNavigationBar];
    [self loadDisplayContents];
}

#pragma mark - Helper Methods

- (BOOL) objectHasValue:(NSObject *) object
{
    if (object == (id)[NSNull null] || object==nil) {
        return NO;
    }
    else {
        return YES;
    }
}

#pragma mark - Setter Methods

- (void)setNavigationBarTitle:(NSString *)title  {
    
    if (self.navigationItem!=nil)   {
        self.navigationItem.title = title;
    }
}

#pragma mark - Rotation Support Method

- (BOOL)isPortrait  {
    
    if (self.interfaceOrientation == UIInterfaceOrientationPortrait ||
        self.interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
        
        return YES;
    }
    else {
        return NO;
    }
}

#pragma mark - Progress Bar Display Methods

- (void)setProgressIndicatorWithTitle:(NSString *)title andDetail:(NSString *)detail    {
    
    // Hide Any Ongoing Progress Indicator
    if (progressIndicator != nil) {
        [progressIndicator hide:YES];
        progressIndicator = nil;
    }
    
    // Show Indicator
    progressIndicator = [[MBProgressHUD alloc] initWithWindow:[session getAppScreen]];
    [[session getAppScreen] addSubview:progressIndicator];
    progressIndicator.dimBackground = YES;
    progressIndicator.delegate = self;
    progressIndicator.labelText = title;
    progressIndicator.detailsLabelText = detail;
    progressIndicator.animationType = MBProgressHUDAnimationZoomOut;
    progressIndicator.mode = MBProgressHUDModeIndeterminate;
}

- (void)showProgressIndicator:(NSNumber *)animated  {
    
    // Display Indicator
    if (progressIndicator != nil) {
        [progressIndicator show:[animated boolValue]];
    }
}

- (void)showProgressIndicatorWithTitle:(NSString *)title andDetail:(NSString *)detail animated:(BOOL)animated    {
    
    // Set Indicator Details
    [self setProgressIndicatorWithTitle:title andDetail:detail];
    
    // Display Indicator
    [self showProgressIndicator:[NSNumber numberWithBool:animated]];
}

- (void)hideProgressIndicator:(NSNumber *)animated  {
    
    // Hide Indicator
    if (progressIndicator != nil) {
        [progressIndicator hide:[animated boolValue]];
        progressIndicator = nil;
    }
}

- (void)updateProgressIndicatorTitle:(NSString *)title andDetail:(NSString *)detail     {
    
    [progressIndicator performSelectorOnMainThread:@selector(setLabelText:) 
                                        withObject:title 
                                     waitUntilDone:YES];
    [progressIndicator performSelectorOnMainThread:@selector(setDetailsLabelText:) 
                                        withObject:detail 
                                     waitUntilDone:YES];
    [progressIndicator performSelectorOnMainThread:@selector(setNeedsDisplay) 
                                        withObject:nil 
                                     waitUntilDone:NO];
}

#pragma mark MBProgressHUD Delegate Methods

- (void)hudWasHidden:(MBProgressHUD *)hud {
    
    // Remove HUD from screen when the HUD was hidded
    if (progressIndicator != nil) {
        
        [progressIndicator removeFromSuperview];
        progressIndicator = nil;
    }
}

#pragma mark - Tab Selection Methods

- (void)currentTabSelected:(UITabBarController *)tabController      {
    
    if (viewNotificationEnabled == NO) {
        [self startNotifications];
    }
}

- (void)currentTabDeselected:(UITabBarController *)tabController    {
    
    if (viewNotificationEnabled == YES) {
        [self resignNotifications];
    }
}

#pragma mark - ImageView Method

- (UIImageView *) checkmarkForTableViewCellAccessoryView {
    return [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"checkmark.png"]];
}

#pragma mark - Button Method

- (UIButton *) buttonForTableViewCell: (NSString *)imageName {
    UIImage *image = [UIImage imageNamed:imageName];
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
    [button setBackgroundColor:[UIColor clearColor]];
    [button setImage:image forState:UIControlStateNormal];
    [button setContentMode:UIViewContentModeScaleToFill];
    return button;
}

- (void) button:(UIButton *)button pressedImageName:(NSString *)pressedImageName {
    UIImage *pressedImage = [UIImage imageNamed:pressedImageName];
    [button setImage:pressedImage forState:UIControlStateHighlighted];
    [button setImage:pressedImage forState:UIControlStateSelected];
    [button setImage:pressedImage forState:UIControlStateDisabled];
}

#pragma mark - Textfield Method

- (UITextField *) textFieldForTableViewCellAccessoryView: (NSString *) placeHolder {
    UITextField *textField = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, 145, 30)];
    [textField setTextAlignment:NSTextAlignmentCenter];
    [textField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [textField setClearButtonMode:UITextFieldViewModeWhileEditing];
    [textField setClearsOnBeginEditing:NO];
    [textField setPlaceholder:placeHolder];
    [textField setTextColor:[UIColor colorWithRed:56.0/255.0 green:84.0/255.0 blue:135.0/255.0 alpha:1.0]];
    return textField;
}

- (UITextField *) textFieldForTableViewCellContentView: (NSString *) placeHolder {
    UITextField *textField = [[UITextField alloc]initWithFrame:CGRectMake(10, 6, 280, 30)];
    [textField setTextAlignment:NSTextAlignmentLeft];
    [textField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [textField setClearButtonMode:UITextFieldViewModeWhileEditing];
    [textField setClearsOnBeginEditing:NO];
    [textField setPlaceholder:placeHolder];
    return textField;
}

#pragma mark - Lable for cell Method

- (UILabel *) labelForTableViewCellAccessoryView: (NSString *) text {
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 120, 30)];
    [label setBackgroundColor:[UIColor clearColor]];
    [label setTextColor:[UIColor grayColor]];
    [label setFont:[UIFont systemFontOfSize:18]];
    [label setTextAlignment:NSTextAlignmentRight];
    [label setText:[text stringByAppendingString:@" "]];
    [label setTextColor:[UIColor colorWithRed:56.0/255.0 green:84.0/255.0 blue:135.0/255.0 alpha:1.0]];
    return label;
}

#pragma mark - Switch Method

- (UISwitch *) uiSwitchForTableViewCellContentView: (BOOL) isOn {
    UISwitch *uiSwitch = [[UISwitch alloc] init];
    [uiSwitch setOn:isOn];
    return uiSwitch;
}


#pragma mark - AlertView Method

- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
													message:message
												   delegate:nil
										  cancelButtonTitle:@"OK"
										  otherButtonTitles:nil];
    [alert show];
}

-(void)showAlertWithCancelOk: (NSString *)title message:(NSString *)message delegate:(id)delegate tag:(int)tag {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
													message:message
												   delegate:delegate
										  cancelButtonTitle:@"Cancel"
										  otherButtonTitles:@"OK",
                          nil];
    [alert setTag:tag];
	[alert show];
}

#pragma mark - NavigationBar Background Method

- (void) applyNavigationBarBackground:(UINavigationBar *)navigationBar {
    if ([navigationBar respondsToSelector:@selector( setBackgroundImage:forBarMetrics:)]){
        [navigationBar setBackgroundImage:[UIImage imageNamed:@"navigation_bar.png"] forBarMetrics:UIBarMetricsDefault];
    }
}

#pragma mark - Animation Method

- (void) displayGuideWithAnimation:(UIViewController *)guide {
    [guide.view setAlpha:0.0f];
    [UIView animateWithDuration:1.0
                          delay: 0.0
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         [guide.view setAlpha:1.0f];
                     }
                     completion:^(BOOL finished){
                     }];
}

- (void) removeGuideWithAnimation:(UIViewController *)guide {
    [guide.view setAlpha:1.0f];
    [UIView animateWithDuration:1.0
                          delay: 0.0
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         [guide.view setAlpha:0.0f];
                     }
                     completion:^(BOOL finished){
                         [guide.view removeFromSuperview];
                     }];
}

#pragma mark - Email Method

- (void) sendEmailTo:(NSString *)to withSubject:(NSString *)subject withBody:(NSString *)body {
    
    NSString *mailString = [NSMutableString stringWithFormat:@"mailto:?"];
    BOOL firstAtributeAdded = NO;
    
    if (to!=nil && ![to isEqualToString:@""]) {
        mailString = [mailString stringByAppendingFormat:@"to=%@",[to stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        firstAtributeAdded = YES;
    }
    if (subject!=nil && ![subject isEqualToString:@""]) {
        if (firstAtributeAdded) {
            mailString = [mailString stringByAppendingFormat:@"&"];
        }
        mailString = [mailString stringByAppendingFormat:@"subject=%@",[subject stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        firstAtributeAdded = YES;
    }
    if (body!=nil && ![body isEqualToString:@""]) {
        if (firstAtributeAdded) {
            mailString = [mailString stringByAppendingFormat:@"&"];
        }
        mailString = [mailString stringByAppendingFormat:@"body=%@",[body stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        firstAtributeAdded = YES;
    }
	
    if (firstAtributeAdded) {
        
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:mailString]]) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:mailString]];
        }
        else    {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sorry" message:@"Unable to open Mail app." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
    }
    else    {
        
        NSLog(@"Can not open Mail : (Reason) There is no any email, subject or body content available to generate mail.");
    }
}

#pragma mark - Header & Footer of tableview Method

- (UIView *) headerView:(UITableView *)tableView section:(NSInteger)section sectionTitle:(NSString *)sectionTitle{
    if (sectionTitle == nil) {
        return nil;
    }
    
    // Create label with section title
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(10, 6, 300, 30);
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont boldSystemFontOfSize:16];
    label.text = sectionTitle;
    
    // Create header view and add label as a subview
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
    [view addSubview:label];
    
    return view;
}


- (UIView *) footerView:(UITableView *)tableView section:(NSInteger)section sectionFooter:(NSString *)sectionFooter numberOfLines:(int)numberOfLines{
    if (sectionFooter == nil) {
        return nil;
    }
    
    // Create label with section title
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(10, 6, 300, 22*numberOfLines);
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:14];
    label.text = sectionFooter;
    label.numberOfLines=numberOfLines;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.textAlignment = NSTextAlignmentCenter;
    
    // Create header view and add label as a subview
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
    [view addSubview:label];
    
    return view;
}

#pragma mark - Image With Color Method

- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

#pragma mark - View Load Methods

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)willAppearIn:(UINavigationController *)navController   {
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    
    // Enable Notification
    if (viewNotificationEnabled == NO) {
        [self startNotifications];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void) viewWillDisappear:(BOOL)animated   {
    
    [super viewWillDisappear:animated];
    
    // Disable Notification
    if (viewNotificationEnabled == YES) {
        [self resignNotifications];
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

#pragma mark - Rotation Handler Methods

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Memory Warning Handler Methods

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
    
    NSLog(@".....MEMORY WARNING.....");
}

- (BOOL) hasValue:(id)object {
    
    if(object!=nil && (NSNull *)object != [NSNull null])    {
        
        // Check NSString Class
        if([object isKindOfClass:[NSString class]] || [object isKindOfClass:[NSMutableString class]]) {
            if([object length]>0) {
                return YES;
            }
        }
        
        // Check UIImage Class
        if([object isKindOfClass:[UIImage class]]){
            if ([object CGImage]!=nil) {
                return YES;
            }
        }
        
        // Check NSArray Class
        if ([object isKindOfClass:[NSArray class]] || [object isKindOfClass:[NSMutableArray class]]) {
            if ([object count] > 0) {
                return YES;
            }
        }
        
        
        // Check NSDictionary Class
        if ([object isKindOfClass:[NSDictionary class]] || [object isKindOfClass:[NSMutableDictionary class]]) {
            if ([object count] > 0) {
                return YES;
            }
        }
        else {
            return YES;
        }
    }
    
    return NO;
}

@end
