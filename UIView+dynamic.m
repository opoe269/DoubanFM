//
//  UIView+dynamic.m
//  DoubanFM
//
//  Created by 王振宇OneZY on 15/11/12.
//  Copyright © 2015年 王振宇. All rights reserved.
//

#import "UIView+dynamic.h"

@implementation UIView (UIView)

@dynamic x;
@dynamic y;
@dynamic width;
@dynamic height;
@dynamic origin;
@dynamic size;

#pragma mark - 
#pragma mark ---Setters---

//x是frame中的x，frame.origin.x
- (void)setX:(CGFloat)x{
    CGRect Frame = self.frame;
    Frame.origin.x = x;
    self.frame = Frame;
}

- (void)setY:(CGFloat)y{
    CGRect Frame = self.frame;
    Frame.origin.y = y;
    self.frame = Frame;
}

- (void)setWidth:(CGFloat)width{
    CGRect Frame = self.frame;
    Frame.size.width = width;
    self.frame = Frame;
}

- (void)setHeight:(CGFloat)height{
    CGRect Frame = self.frame;
    Frame.size.height = height;
    self.frame = Frame;
}

- (void)setOrigin:(CGPoint)origin{
    self.x = origin.x;
    self.y = origin.y;
}

- (void)setSize:(CGSize)size{
    self.width = size.width;
    self.height = size.height;
}

//往右移动后的？
- (void)setRight:(CGFloat)right{
    CGRect Frame = self.frame;
    Frame.origin.x = right - Frame.size.width;
    self.frame = Frame;
}

//往下移动后的？
- (void)setBottom:(CGFloat)bottom{
    CGRect Frame = self.frame;
    Frame.origin.y = bottom - Frame.size.height;
    self.frame = Frame;
}

- (void)setCenterX:(CGFloat)centerX{
    self.center = CGPointMake(centerX, self.center.y);
}

- (void)setCenterY:(CGFloat)centerY{
    self.center = CGPointMake(self.center.x, centerY);
}


#pragma mark - 
#pragma mark ---Getters---
-(CGFloat)x{
    return self.frame.origin.x;
}

-(CGFloat)y{
    return self.frame.origin.y;
}

-(CGFloat)width{
    return self.frame.size.width;
}

-(CGFloat)height{
    return self.frame.size.height;
}

-(CGPoint)origin{
    return CGPointMake(self.x, self.y);
}

-(CGSize)size{
    return CGSizeMake(self.width, self.height);
}

-(CGFloat)right {
    return self.frame.origin.x + self.frame.size.width;
}

-(CGFloat)bottom {
    return self.frame.origin.y + self.frame.size.height;
}

-(CGFloat)centerX {
    return self.center.x;
}

-(CGFloat)centerY {
    return self.center.y;
}

#pragma mark - 
//这是什么？
-(UIView *)lastSubviewOnX{
    if(self.subviews.count > 0){
        UIView *outView = self.subviews[0];
        for(UIView *v in self.subviews){
            if (v.x >outView.x) {
                outView  = v;
            }
        }
        return outView;
    }
    return nil;
}

-(UIView *)lastSubviewOnY{
    if(self.subviews.count > 0){
        UIView *outView = self.subviews[0];
        
        for(UIView *v in self.subviews)
            if(v.y > outView.y)
                outView = v;
        
        return outView;
    }
    
    return nil;
}

#pragma mark - 
#pragma mark ---others---
- (void)removeAllSubviews{
    for(UIView *v in self.subviews){
        [v removeFromSuperview];
    }
    return;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
