//
//  InfoCell.m
//  TapIt
//
//  Created by Admin on 7/6/13.
//  Copyright (c) 2013 Admin. All rights reserved.
//

#import "InfoCell.h"

@implementation InfoCell
@synthesize lblDetail,imgLogo,btnUrl,viewSepreateLine;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
