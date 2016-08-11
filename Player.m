//
//  Player.m
//  DoubanFM
//
//  Created by 王振宇OneZY on 16/8/1.
//  Copyright © 2016年 王振宇. All rights reserved.
//

#import "Player.h"
#import "AppDelegate.h"
#import "NetManager.h"
#import "songInfo.h"

#import "PlayerDelegate.h"

/*
b	sid	bye，不再播放，并放回一个新的歌曲列表	长报告
e	sid	end，当前歌曲播放完毕，但是歌曲队列中还有歌曲	短报告
n		new，没有歌曲播放，歌曲队列也没有任何歌曲，需要返回新播放列表	长报告
p		playing，歌曲正在播放，队列中还有歌曲，需要返回新的播放列表	长报告
s	sid	skip，歌曲正在播放，队列中还有歌曲，适用于用户点击下一首	短报告
r	sid	rate，歌曲正在播放，标记喜欢当前歌曲	短报告
u	sid	unrate，歌曲正在播放，标记取消喜欢当前歌曲
*/

@interface Player ()

@property (strong, nonatomic)AppDelegate *appDelegate;
@property (strong, nonatomic)NetManager *networkManager;

@end

@implementation Player

#pragma mark - 重写init方法
- (instancetype)init{
    if (self = [super init]) {
        self.appDelegate = [UIApplication sharedApplication].delegate;
        self.networkManager = [[NetManager alloc]init];
    }
    // 通知中心检测到播放器播放完毕就调用-startPlay方法，播放下一首歌曲
    // KVO
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(startPlay)
                                                 name:MPMoviePlayerPlaybackDidFinishNotification
                                               object:nil];
    // 通知中心检测到播放器负载状态改变，就调用-initSongInfo方法
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(currentSongInfo)
                                                 name:MPMoviePlayerLoadStateDidChangeNotification
                                               object:nil];
    
    return self;
}

#pragma mark - 获得当前歌曲信息
- (void)currentSongInfo{
    [self.delegate initSongInfo];
}

#pragma mark - 开始播放
- (void)startPlay{
    
    if ([songInfo currentSongIndex] >= self.appDelegate.playList.count - 1) {
        [self.networkManager loadingPlayListWithTaye:@"p"]; //p是什么type？
    }else{
        //下一首歌曲
        [songInfo setCurrentSongIndex:[songInfo currentSongIndex]+1];
        [songInfo setCurrentSong:[self.appDelegate.playList objectAtIndex:[songInfo currentSongIndex]]];
        
        //MPMoviePlayer类方法
        [self.appDelegate.player setContentURL:[NSURL URLWithString:[[songInfo currentSong] valueForKey:@"url"]]];
        [self.appDelegate.player play];
    }
}

- (void)pause{

    [self.appDelegate.player pause];
}

- (void)restart{

    [self.appDelegate.player play];
}

- (void)like{

    [self.networkManager loadingPlayListWithTaye:@"r"];
}

- (void)dislike{

    [self.networkManager loadingPlayListWithTaye:@"u"];
}

- (void)songDelete{

    [self.networkManager loadingPlayListWithTaye:@"b"];
}

- (void)skip{

    [self.networkManager loadingPlayListWithTaye:@"s"];
}

@end
