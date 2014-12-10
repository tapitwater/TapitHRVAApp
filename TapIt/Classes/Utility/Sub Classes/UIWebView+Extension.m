//
//  UIWebView+Extension.m
//  Gobymobile
//
//  Created by Shardul on 04/06/13.
//  Copyright (c) 2013 Techgrains. All rights reserved.
//

#import "UIWebView+Extension.h"

@implementation UIWebView (Extension)

- (void)setScrollEnabled:(BOOL)scrollEnabled     {
    
    for (id subview in self.subviews)    {
        
        if ([[subview class] isSubclassOfClass: [UIScrollView class]])  {
            ((UIScrollView *)subview).scrollEnabled = scrollEnabled;
        }
    }
}

- (void)setBounces:(BOOL)bounces    {
    
    for (id subview in self.subviews)    {
        
        if ([[subview class] isSubclassOfClass: [UIScrollView class]])  {
            ((UIScrollView *)subview).bounces = bounces;
        }
    }
}

- (void)setBackgroundImageHidden:(BOOL)hideBackground   {
    
    for (UIView* subView in self.subviews)
    {
        if ([subView isKindOfClass:[UIScrollView class]]) {
            for (UIView* shadowView in [subView subviews])
            {
                if ([shadowView isKindOfClass:[UIImageView class]]) {
                    [shadowView setHidden:hideBackground];
                }
            }
        }
    }
}

@end
