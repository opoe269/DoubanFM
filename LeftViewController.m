//
//  LeftViewController.m
//  DoubanFM
//
//  Created by 王振宇OneZY on 15/11/9.
//  Copyright © 2015年 王振宇. All rights reserved.
//

#import "LeftViewController.h"

@interface LeftViewController()
{
    CGFloat _scalef;
}

//@property (strong, nonatomic)UIViewController *leftView;
//@property (strong, nonatomic)UIView *contentView;

@end

@implementation LeftViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    }

- (instancetype)initWithLeftView:(UIViewController *)leftVC
                     andMainVC:(UIViewController *)mainVC
{
    if(self = [super init]){
        self.speedf = vSpeedFloat;
        
        self.leftVC = leftVC;
        self.mainVC = mainVC;
        
        //滑动手势
        self.pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePan:)];
        [self.mainVC.view addGestureRecognizer:self.pan];
        [self.pan setCancelsTouchesInView:YES];
        self.pan.delegate = self;
        
        self.leftVC.view.hidden = YES;
        
        [self.view addSubview:self.leftVC.view];
        
        //设置左侧tableview的初始位置和缩放系数
        self.leftVC.view.transform = CGAffineTransformMakeScale(kLeftScale, kLeftScale);
        self.leftVC.view.center = CGPointMake(50, kScreenHeight * 0.5);
        
        [self.view addSubview:self.mainVC.view];
        self.closed = YES;//初始时侧滑窗关闭
    }
    return self;
}



//侧边栏准备滑出的时候，取消hidden
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.leftVC.view.hidden = NO;
}


#pragma mark - 
#pragma mark pan手势
- (void)handlePan:(UIPanGestureRecognizer *)pan{

    
//利用pan手势的translationInView:方法取得在相对指定视图（这里是控制器根视图）的移动
    CGPoint point = [pan translationInView:self.view];
    
    //横向位移,这里不调用scalef的setter方法
    _scalef = (point.x * self.speedf + _scalef);
    
    NSLog(@"%f",_scalef);
    
    BOOL movingWithTap = YES;
    
    //当最大或最小边界值，即主界面状态下，不能再往左滑动 or 侧边栏已经滑出且已经滑到最大值，不能再往右滑动。
    if (((self.mainVC.view.x <= 0 ) && (_scalef <= 0)) || ((self.mainVC.view.x >= (kScreenWidth - kMainPageDistance )) && (_scalef >= 0)))
    {
        _scalef = 0;
        movingWithTap = NO;
    }
    
    //根据视图位置判断滑动的方向
    if (movingWithTap && (pan.view.frame.origin.x >= 0 ) && (pan.view.frame.origin.x <= (kScreenWidth - kMainPageDistance)))
    {
        CGFloat panCenterX = pan.view.center.x + point.x * self.speedf; //横向位移的坐标
        if (panCenterX < kScreenWidth * 0.5 - 2) {
            panCenterX = kScreenWidth * 0.5;
        }
        CGFloat panCenterY = pan.view.center.y;
        pan.view.center = CGPointMake(panCenterX, panCenterY);

        //主界面尺寸缩小
        CGFloat mainScale = 1 - (1 - kMainPageScale) * (pan.view.frame.origin.x / (kScreenWidth - kMainPageDistance));
        
        pan.view.transform = CGAffineTransformScale(CGAffineTransformIdentity, mainScale, mainScale);
        
        [pan setTranslation:CGPointMake(0, 0) inView:self.view];
        
        //侧边栏位置变化
        CGFloat leftTabCenterX = kLeftCenterX + ((kScreenWidth - kMainPageDistance) * 0.5 - kLeftCenterX) *
            (pan.view.frame.origin.x / (kScreenWidth - kMainPageDistance));

        CGFloat leftScale = kLeftScale + (1 - kLeftScale) * (pan.view.frame.origin.x / (kScreenWidth - kMainPageDistance));
        //设置侧边栏view的center位置
        self.leftVC.view.center = CGPointMake(leftTabCenterX,kScreenHeight * 0.5);
        self.leftVC.view.transform = CGAffineTransformScale(CGAffineTransformIdentity, leftScale, leftScale);
        
        //cover随着侧边栏的大小改变透明度
//        CGFloat tempAlpha = kLeftAlpha - kLeftAlpha * (pan.view.frame.origin.x / (kScreenWidth - kMainPageDistance));
//        self.contentView.alpha = tempAlpha;
    }else{
        if (self.mainVC.view.x < 0) {
            
            [self closeLeftView];
            _scalef = 0;
        }else if(self.mainVC.view.x > (kScreenWidth - kMainPageDistance)){
            
            [self openLeftView];
            _scalef = 0;
        }
    }
    
    if (pan.state == UIGestureRecognizerStateEnded) {
        if (fabs(_scalef) > vCouldChangeDeckStateDistance)
        {
            if (self.closed)
            {
                [self openLeftView];
            }
            else
            {
                [self closeLeftView];
            }
        }
        else
        {
            if (self.closed)
            {
                [self closeLeftView];
            }
            else
            {
                [self openLeftView];
            }
        }
        _scalef = 0;
    }
}

#pragma mark -
#pragma mark tap手势
//点击mainView，关闭侧边栏
- (void)handleTap:(UITapGestureRecognizer *)tap{
    if ((!self.closed)&&(tap.state == UIGestureRecognizerStateEnded)) {
        //当侧边栏还在，并且tap事件已经识别完成，下面是将要做的事情,点击mainView关闭侧边栏
        [UIView beginAnimations:nil context:nil];
        //tap.view恢复本来大小
        tap.view.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.0, 1.0);
        tap.view.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2,[UIScreen mainScreen].bounds.size.height/2);
        self.closed = YES;
        self.leftVC.view.center = CGPointMake(kLeftCenterX, kScreenHeight/2);
        self.leftVC.view.transform = CGAffineTransformScale(CGAffineTransformIdentity, kLeftScale, kLeftScale);
        //self.contentView.alpha  = kLeftAlpha;
        
        [UIView commitAnimations];
        _scalef = 0;
        [self removeSingleTap];
    }
}

#pragma mark - 
#pragma mark 关于view的操作
/**

 打开和关闭侧边栏
 
 **/

- (void)openLeftView{
    [UIView beginAnimations:nil context:nil];
    self.mainVC.view.transform = CGAffineTransformScale(CGAffineTransformIdentity, kMainPageScale, kMainPageScale);
    self.mainVC.view.center = kMainPageCenter;
    self.closed = NO;
    
    //self.leftVC.view.center = CGPointMake((kScreenWidth-kMainPageDistance) * 0.5, kScreenHeight *0.5);
    self.leftVC.view.center = CGPointMake(kScreenWidth * 0.5, kScreenHeight *0.5);
    self.leftVC.view.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.0, 1.0); //缩放后的scale
    //self.contentView.alpha = 0;
    
    [UIView commitAnimations];
    
    [self disableTapButton]; //打开侧边栏以后，使得点击主屏关闭侧边栏的功能生效
    
}
- (void)closeLeftView{
    [UIView beginAnimations:nil context:nil]; //begin
    
    self.mainVC.view.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.0, 1.0);
    self.mainVC.view.center = CGPointMake(kScreenWidth/2, kScreenHeight/2);
    self.closed = YES;
    self.leftVC.view.center = CGPointMake(kLeftCenterX, kScreenHeight/2);
    self.leftVC.view.transform = CGAffineTransformScale(CGAffineTransformIdentity, kLeftScale, kLeftScale);
    //self.contentView.alpha = kLeftAlpha;
    
    [UIView commitAnimations]; // end
    
    [self removeSingleTap];
}

#pragma mark -
#pragma mark 点击主屏关闭侧边栏
//使得点击主屏关闭侧边栏的功能生效
- (void)disableTapButton{
    //使得所有的button失效，setUserInteractionEnabled决定UIView是否响应用户的交互
    for (UIButton *button in [self.mainVC.view subviews]) {
        [button setUserInteractionEnabled:NO];
    }
    //单击
    if (!self.sidesLipTapGes) {
        self.sidesLipTapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTap:)];
        [self.sidesLipTapGes setNumberOfTapsRequired:1];
        
        [self.mainVC.view addGestureRecognizer:self.sidesLipTapGes];
        //除了UIButton以外，点击事件覆盖其他的touch响应事件
        self.sidesLipTapGes.cancelsTouchesInView = YES;
    }
}

- (void)removeSingleTap{
    for (UIButton *button in [self.mainVC.view subviews]) {
        [button setUserInteractionEnabled:YES];
    }
    [self.mainVC.view removeGestureRecognizer:self.sidesLipTapGes];
    self.sidesLipTapGes = nil;
}


#pragma mark -
#pragma mark what is this?
//并不是很懂
- (void)setPanEnabled: (BOOL) enabled
{
    [self.pan setEnabled:enabled];
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer*)gestureRecognizer shouldReceiveTouch:(UITouch*)touch {
    
    if(touch.view.tag == vDeckCanNotPanViewTag)
    {
        return NO;
    }
    else
    {
        return YES;
    }
}

@end
