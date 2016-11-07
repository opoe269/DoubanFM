//
//  LeftViewController.h
//  DoubanFM
//
//  Created by 王振宇OneZY on 15/11/9.
//  Copyright © 2015年 王振宇. All rights reserved.
//

#define kScreenSize           [[UIScreen mainScreen] bounds].size
#define kScreenWidth          [[UIScreen mainScreen] bounds].size.width
#define kScreenHeight         [[UIScreen mainScreen] bounds].size.height

#define kMainPageDistance   100   //打开左侧窗时，中视图(右视图)露出的宽度
#define kMainPageScale   0.8  //打开左侧窗时，中视图(右视图）缩放比例
#define kMainPageCenter  CGPointMake(kScreenWidth + kScreenWidth * kMainPageScale / 2.0 - kMainPageDistance, kScreenHeight / 2)  //打开左侧窗时，中视图中心点

#define vCouldChangeDeckStateDistance  (kScreenWidth - kMainPageDistance) / 2.0 - 40 //滑动距离大于此数时，状态改变（关--》开，或者开--》关）
#define vSpeedFloat   0.7    //滑动速度

#define kLeftAlpha 0.9  //左侧蒙版的最大值
#define kLeftCenterX 30 //左侧初始偏移量
#define kLeftScale 0.7 //左侧初始缩放比例

#define vDeckCanNotPanViewTag    987654   // 不响应此侧滑的View的tag

#import <UIKit/UIKit.h>
#import "UIView+dynamic.h"

@interface LeftViewController : UIViewController<UIGestureRecognizerDelegate>

@property (assign, nonatomic)CGFloat speedf; //滑动速度系数
@property (assign, nonatomic)BOOL closed; //侧边栏是否关闭

@property (strong, nonatomic)UIViewController *leftVC;
@property (strong, nonatomic)UIViewController *mainVC;

@property (strong, nonatomic)UITapGestureRecognizer *sidesLipTapGes;
@property (strong, nonatomic)UIPanGestureRecognizer *pan;

- (instancetype)initWithLeftView:(UIViewController *)leftVC andMainVC:(UIViewController *)mainVC;
- (void)closeLeftView;
- (void)openLeftView;
//optional
- (void)setPanEnabled:(BOOL)enabled;

@end
