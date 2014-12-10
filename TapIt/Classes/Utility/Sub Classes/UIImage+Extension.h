//
//  UIImage+Extension.h
//  Gobymobile
//
//  Created by Shardul on 20/11/12.
//  Copyright (c) 2012 Shardul. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Extension)

+ (UIImage *)imageWithColor:(UIColor *)color
                    andSize:(CGSize)imageSize;

// Image Crop & Resize Methods
- (UIImage *) croppedImage:(CGRect)bounds;
- (UIImage *) resizedImage:(CGSize)newSize interpolationQuality:(CGInterpolationQuality)quality;
- (UIImage *) resizedImageWithContentMode:(UIViewContentMode)contentMode bounds:(CGSize)bounds interpolationQuality:(CGInterpolationQuality)quality;
- (CGAffineTransform)transformForOrientation:(CGSize)newSize;

@end
