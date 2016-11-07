//
//  UIView+dynamic.h
//  DoubanFM
//
//  Created by 王振宇OneZY on 15/11/12.
//  Copyright © 2015年 王振宇. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (UIView)

@property (nonatomic, assign) CGFloat   x;
@property (nonatomic, assign) CGFloat   y;
@property (nonatomic, assign) CGFloat   width;
@property (nonatomic, assign) CGFloat   height;
@property (nonatomic, assign) CGPoint   origin;
@property (nonatomic, assign) CGSize    size;
@property (nonatomic, assign) CGFloat   bottom;
@property (nonatomic, assign) CGFloat   right;
@property (nonatomic, assign) CGFloat   centerX;
@property (nonatomic, assign) CGFloat   centerY;
@property (nonatomic, strong, readonly) UIView *lastSubviewOnX;
@property (nonatomic, strong, readonly) UIView *lastSubviewOnY;

- (void)removeAllSubviews;


@end
