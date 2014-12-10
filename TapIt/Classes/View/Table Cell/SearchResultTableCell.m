//
//  SearchResultTableCell.m
//  TapIt
//
//  Created by Admin on 7/6/13.
//  Copyright (c) 2013 Admin. All rights reserved.
//

#import "SearchResultTableCell.h"

@implementation SearchResultTableCell
@synthesize lblTitle, lblAddress, lblDistance, lblMile, vwSelected;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        NSLog(@"%@",reuseIdentifier);
        // Initialization code
//        lblDistance = [[UILabel alloc] initWithFrame:CGRectMake(5, 2, 50, 30)];
//        lblDistance.text = @"0.3";
//        [self.contentView addSubview:lblDistance];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
