//
//  UIImage+imageEffects.h
//  DoubanFM
//
//  Created by 王振宇OneZY on 15/11/16.
//  Copyright © 2015年 王振宇. All rights reserved.
//

#import <UIKit/UIKit.h> //返回一张经过模糊透明处理的图片

@interface UIImage (ImageEffects)

- (UIImage *)applyLightEffect;
- (UIImage *)applyExtraLightEffect;
- (UIImage *)applyDarkEffect;
- (UIImage *)applyTintEffectWithColor:(UIColor *)tintColor;

- (UIImage *)applyBlurWithRadius:(CGFloat)blurRadius tintColor:(UIColor *)tintColor saturationDeltaFactor:(CGFloat)saturationDeltaFactor maskImage:(UIImage *)maskImage;

@end

