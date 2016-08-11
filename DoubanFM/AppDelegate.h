//
//  AppDelegate.h
//  DoubanFM
//
//  Created by 王振宇OneZY on 15/11/9.
//  Copyright © 2015年 王振宇. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>
#import "LeftViewController.h"
#import <MediaPlayer/MediaPlayer.h>

@class ChannelInfo;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) LeftViewController *LeftSideVC;
@property (strong, nonatomic) UINavigationController *navVC;

@property (strong, nonatomic) NSMutableArray *playList; // 播放列表

@property (strong, nonatomic) MPMoviePlayerController *player; //播放器

@property (strong, nonatomic) ChannelInfo *privateChannel;

//@property (strong, nonatomic) AVPlayer *player;
//@property (strong, nonatomic) AVPlayerItem *playerItem;

@end

