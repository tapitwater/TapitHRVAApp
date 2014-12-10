//
//  SplashViewController.m
//  TapIt
//
//  Created by Admin on 7/2/13.
//  Copyright (c) 2013 Admin. All rights reserved.
//

#import "SplashViewController.h"

@interface SplashViewController ()

@end

@implementation SplashViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
#pragma mark - View Life Cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    [session updateUserLocation];
    [session loadInternetReachability];
}

- (void)willAppearIn:(UINavigationController *)navController   {
    
    //[super willAppearIn:navController];
    
    // Hide Navigation Bar
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
}
- (BOOL)prefersStatusBarHidden
{
    return YES;
}

#pragma mark - Custom Method
- (void) viewWillAppear:(BOOL)animated
{
    [Flurry logPageView];
    [Flurry logEvent:@"Splash View"];

    self.navigationController.navigationBarHidden = YES;
    //[[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:NO];
    
    if(session.isiPhone5)
        imgScreen.image = [UIImage imageNamed:@"screen2-568h@2x.png"];
    else
        imgScreen.image = [UIImage imageNamed:@"screen2.png"];
    
    [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(screen2) userInfo:nil repeats:NO];
}

- (void) screen1
{
    if(session.isiPhone5)
        imgScreen.image = [UIImage imageNamed:@"screen2-568h@2x.png"];
    else
        imgScreen.image = [UIImage imageNamed:@"screen2.png"];
    
    [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(screen2) userInfo:nil repeats:NO];
}

- (void) screen2
{
    session.myTab1 = self.myTab;
    
    if(session.iOSVersion >= 70000)
        [[UITabBar appearance] setTintColor:[UIColor whiteColor]];
    else
        [[UITabBar appearance] setTintColor:[UIColor blackColor]];
    [self.myTab setSelectedIndex:2];
    self.myTab.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
    [self presentViewController:self.myTab animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
