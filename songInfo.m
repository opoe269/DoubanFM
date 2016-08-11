//
//  songInfo.m
//  DoubanFM
//
//  Created by 王振宇OneZY on 15/11/22.
//  Copyright © 2015年 王振宇. All rights reserved.
//

#import "songInfo.h"

static songInfo *currentSong;
static int currentSongIndex;

@implementation songInfo

//解析歌曲dictionary的init
- (instancetype)initWithDict:(NSDictionary *)dict{
    if (self = [super init]) {
        self.songId = dict[@"sid"]; //song ID，@[b,e,n,p,s,r,u]
        self.title = dict[@"title"];
        self.artist = dict[@"artist"];
        self.picture = dict[@"picture"];
        self.length = dict[@"length"];
        self.like = dict[@"like"];
        self.url = dict[@"url"];
    }
    return self;
}

- (instancetype)initWithArray:(NSArray *)array{
    if (self = [super init]) {
        self.songId = array[0][@"sid"];
        self.title = array[0][@"title"];
        self.artist = array[0][@"artist"];
        self.picture = array[0][@"picture"];
        self.length = array[0][@"length"];
        self.like = array[0][@"like"];
        self.url = array[0][@"url"];
    }
    return self;
}

//返回当前歌曲
+ (songInfo *)currentSong{
    if (!currentSong) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken,^{
            currentSong = [[self alloc] init];
        });
    }
    return currentSong;
}

//设置当前歌曲
+ (void)setCurrentSong:(songInfo *)song{
    currentSong = song;
}

//设置当前歌曲的索引
+ (void)setCurrentSongIndex:(int)songIndex{
    currentSongIndex = songIndex;
}

//返回当前歌曲索引
+ (int)currentSongIndex{
    return currentSongIndex;
}

@end
