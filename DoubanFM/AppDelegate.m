//
//  AppDelegate.m
//  DoubanFM
//
//  Created by 王振宇OneZY on 15/11/9.
//  Copyright © 2015年 王振宇. All rights reserved.
//

#import "AppDelegate.h"
#import "ChannelViewController.h"
#import "LeftSortsViewController.h"
#import <AVFoundation/AVFoundation.h>

#import "ChannelInfo.h"



@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        self.window.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"leftbackground"]]; //通用背景颜色
        [self.window makeKeyAndVisible];
        
        ChannelViewController *ChannelVC = [[ChannelViewController alloc]init];
        
        self.navVC = [[UINavigationController alloc]initWithRootViewController:ChannelVC];
        
        LeftSortsViewController *leftSortsVC = [[LeftSortsViewController alloc]init];
        
        self.LeftSideVC = [[LeftViewController alloc]initWithLeftView:leftSortsVC andMainVC:self.navVC];
        
        self.window.rootViewController = self.LeftSideVC;
        
        [[UINavigationBar appearance]setBarTintColor:[UIColor colorWithRed:20/255.0 green:155/255.0 blue:213/255.0 alpha:1.0]];
        
        [self loadChannelSections];
        
        self.player = [[MPMoviePlayerController alloc] init];
        self.playList = [NSMutableArray array];
        
        //后台播放
        AVAudioSession *session = [AVAudioSession sharedInstance];
        [session setCategory:AVAudioSessionCategoryPlayback error:nil];
        [session setActive:YES error:nil];
        }
    );
    return YES;
}

//加载用户数据
- (void)loadUserInfo{

    //待添加
}

//加载频道分组
- (void)loadChannelSections{
    [ChannelInfo updateChannelTitles:@[@"我的兆赫",@"推荐兆赫",@"热门兆赫",@"上升最快"]];
    NSMutableArray *channelSections = [ChannelInfo channelSections];
    
    //私人频道
    _privateChannel = [ChannelInfo setChannelWithId:@"0" andName:@"私人"];
    //我的喜爱
    ChannelInfo *likedChannel = [ChannelInfo setChannelWithId:@"-3" andName:@"我的喜爱"];
    //我的兆赫
    NSArray *myChannels = @[_privateChannel , likedChannel];
    [channelSections addObject:myChannels];
    //推荐兆赫
    NSArray *recommandChannels = [NSMutableArray array];
    [channelSections addObject:recommandChannels];
    //热门兆赫
    NSMutableArray *hotChannels = [NSMutableArray array];
    [channelSections addObject:hotChannels];
    //上升最快
    NSArray *upChannels = [NSMutableArray array];
    [channelSections addObject:upChannels];
    
    //程序启动后，若当前频道为空，则设置当前频道为”私人频道“
    if ([ChannelInfo currentChannel].channelId == nil) {
        [ChannelInfo updateCurremtChannel:_privateChannel];
    }

}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
