//
//  HeavyCondensedTextView.m
//  Gobymobile
//
//  Created by Shardul on 21/05/13.
//  Copyright (c) 2013 Techgrains. All rights reserved.
//

#import "HeavyCondensedTextView.h"
#import "Constants.h"

@implementation HeavyCondensedTextView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization codev
        [self setFont: [UIFont fontWithName:FONT_87_HEAVY_CONDENSED size:self.font.pointSize]];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)decoder {
    
    if (self = [super initWithCoder: decoder]) {
        [self setFont: [UIFont fontWithName:FONT_87_HEAVY_CONDENSED size:self.font.pointSize]];
    }
    
    return self;
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
