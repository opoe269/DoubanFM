//
//  Player.h
//  DoubanFM
//
//  Created by 王振宇OneZY on 16/8/1.
//  Copyright © 2016年 王振宇. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PlayerDelegate;

//播放器

@interface Player : NSObject

@property (weak, nonatomic) id<PlayerDelegate> delegate;

//播放操作
- (void)startPlay;
- (void)pause;
- (void)restart;
- (void)like;
- (void)dislike;
- (void)songDelete;
- (void)skip;

@end
