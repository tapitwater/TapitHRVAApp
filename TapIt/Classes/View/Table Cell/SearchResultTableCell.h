//
//  SearchResultTableCell.h
//  TapIt
//
//  Created by Admin on 7/6/13.
//  Copyright (c) 2013 Admin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchResultTableCell : UITableViewCell
{
    
}
@property (nonatomic, strong) IBOutlet UILabel *lblDistance, *lblMile, *lblTitle, *lblAddress;
@property (nonatomic, strong) IBOutlet UIView *vwSelected;
@end
