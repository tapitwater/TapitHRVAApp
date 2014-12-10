//
//  TwitterFeedViewController.m
//  TapIt
//
//  Created by Admin on 7/2/13.
//  Copyright (c) 2013 Admin. All rights reserved.
//

#import "TwitterFeedViewController.h"
#import "TwitterFeedCell.h"

@interface TwitterFeedViewController ()

@end

@implementation TwitterFeedViewController
@synthesize webView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = NSLocalizedString(@"Twitter", @"Twitter");
        self.tabBarItem.image = [UIImage imageNamed:@"Twitter"];
    }
    return self;
}
#pragma mark - View Life Cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
     isLoaded = YES;
    if(isLoaded)
    {
        isLoaded = NO;
        //[self performSelectorOnMainThread:@selector(webUrlCall) withObject:nil waitUntilDone:YES];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self webUrlCall];
        });
    }
}

- (void) viewWillAppear:(BOOL)animated
{
    [Flurry logPageView];
    [Flurry logEvent:@"Twitter List View"];
}

#pragma mark - Custom Method

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (IBAction) roloadUrlButtonClick:(id)sender
{
    if(isLoaded)
    {
        isLoaded = NO;
        [self performSelectorOnMainThread:@selector(webUrlCall) withObject:nil waitUntilDone:YES];
    }
}

- (void) webUrlCall
{
    session.internetReachability = [Reachability reachabilityWithHostname:@"www.google.com"];
    [session.internetReachability startNotifier];
    if(session.isInternetReachable == YES)
    {
        //NSString *urlString = [NSString stringWithFormat:@"http://220.224.203.133:4488/TwitterFeed.html?W=1000&H=1000&AppStateId=%@",APP_STATE_TOKEN];
        NSString *urlString = [NSString stringWithFormat:@"http://app.tapitwater.com/TwitterFeed.html?W=1000&H=1000&AppStateId=%@",APP_STATE_TOKEN];
        NSURL *url = [NSURL URLWithString:urlString];
        NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
        [webView loadRequest:requestObj];
    }
    else
    {
        isLoaded = YES;
    }
}


- (IBAction) mapTabButtonClick:(id)sender
{
    session.myTab1.selectedIndex = 2;
    session.myTab1.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
}

#pragma mark - UIWebView Delegate Method

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(callEndIgnoring) userInfo:nil repeats:NO];
}

- (void) callEndIgnoring
{
    isLoaded = YES;
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSString *path = request.URL.path;
    if([path rangeOfString:@"witterFeed.html"].length>0) {
        return YES;
    } else {
        // TODO: Pass request to external browser.
        [session openWebURL1:request.URL];
        //[[UIApplication sharedApplication] openURL:request.URL];
    }
    return NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
