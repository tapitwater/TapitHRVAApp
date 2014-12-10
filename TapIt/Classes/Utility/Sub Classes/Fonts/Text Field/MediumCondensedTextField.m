//
//  MediumCondensedTextField.m
//  Gobymobile
//
//  Created by Shardul on 22/05/13.
//  Copyright (c) 2013 Techgrains. All rights reserved.
//

#import "MediumCondensedTextField.h"
#import "Constants.h"

@implementation MediumCondensedTextField

@synthesize insets;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization codev
        [self setFont: [UIFont fontWithName:FONT_67_MEDIUM_CONDENSED size:self.font.pointSize]];
        self.insets = UIEdgeInsetsMake(3.0, 0.0, 0.0, 0.0);
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)decoder {
    
    if (self = [super initWithCoder: decoder]) {
        [self setFont: [UIFont fontWithName:FONT_67_MEDIUM_CONDENSED size:self.font.pointSize]];
        self.insets = UIEdgeInsetsMake(3.0, 0.0, 0.0, 0.0);
    }
    
    return self;
}

#pragma mark - Drawing and Positioning Overrides

- (CGRect) placeholderRectForBounds:(CGRect)bounds
{
    return UIEdgeInsetsInsetRect([super placeholderRectForBounds:bounds], self.insets);
}

- (CGRect) textRectForBounds:(CGRect)bounds
{
    return UIEdgeInsetsInsetRect([super textRectForBounds:bounds], self.insets);
}

- (CGRect) editingRectForBounds:(CGRect)bounds
{
    return UIEdgeInsetsInsetRect([super editingRectForBounds:bounds], self.insets);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
