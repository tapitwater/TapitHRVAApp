//
//  InfoCell.h
//  TapIt
//
//  Created by Admin on 7/6/13.
//  Copyright (c) 2013 Admin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InfoCell : UITableViewCell
{
    
}
@property (nonatomic, strong) IBOutlet UIImageView *imgLogo;
@property (nonatomic, strong) IBOutlet UIView *vwImage;
@property (nonatomic, strong) IBOutlet UILabel     *lblDetail;
@property (nonatomic, retain) IBOutlet UIButton *btnUrl;
@property (nonatomic, retain) IBOutlet UIView *viewSepreateLine;

@end
