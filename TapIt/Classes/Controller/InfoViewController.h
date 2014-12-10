//
//  InfoViewController.h
//  TapIt
//
//  Created by Admin on 7/2/13.
//  Copyright (c) 2013 Admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"


@interface InfoViewController : BaseViewController
{
    //Interface.
    IBOutlet UITableView *tblView;
    
    //Object.
    NSMutableArray *arrayInfo;
}

- (void) fetchInfoAbout;
- (void) urlButtonClick : (UIButton *) sender;
- (IBAction) mapTabButtonClick:(id)sender;
@end
