//
//  PlayerDelegate.h
//  DoubanFM
//
//  Created by 王振宇OneZY on 16/8/1.
//  Copyright © 2016年 王振宇. All rights reserved.
//

#import <Foundation/Foundation.h>

//遵循此代理delega的目的为：播放界面与独立播放条同步更新

@protocol PlayerDelegate <NSObject>

@optional

- (void)initSongInfo;

@end
