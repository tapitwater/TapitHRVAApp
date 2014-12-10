//
//  TwitterFeedViewController.h
//  TapIt
//
//  Created by Admin on 7/2/13.
//  Copyright (c) 2013 Admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface TwitterFeedViewController : BaseViewController <UIWebViewDelegate>
{
    //Interface.
    IBOutlet UIButton *btnReload;
    
    //Object.
    NSMutableArray *arrList;
    
    //Flag.
    BOOL isLoaded;
}

@property (nonatomic, retain) IBOutlet UIWebView *webView;

- (void) webUrlCall;
- (IBAction) roloadUrlButtonClick:(id)sender;
- (IBAction) mapTabButtonClick:(id)sender;

@end
