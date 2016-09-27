//
//  songInfo.h
//  DoubanFM
//
//  Created by 王振宇OneZY on 15/11/22.
//  Copyright © 2015年 王振宇. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface songInfo : NSObject

@property (assign, nonatomic)int index;
@property (copy, nonatomic)NSString *songId;
@property (copy, nonatomic)NSString *title;
@property (copy, nonatomic)NSString *artist;
@property (copy, nonatomic)NSString *picture;
@property (copy, nonatomic)NSString *length;
@property (copy, nonatomic)NSString *like;
@property (copy, nonatomic)NSString *url;

//解析返回的歌曲字典，从豆瓣API获得的数据
- (instancetype)initWithDict:(NSDictionary *)dict;

- (instancetype)initWithArray:(NSArray *)array;

+ (songInfo *)currentSong;//返回当前歌曲

+ (int)currentSongIndex;//返回当前歌曲索引

+ (void)setCurrentSong:(songInfo *)song;//设置当前歌曲

+ (void)setCurrentSongIndex:(int)songIndex;//设置当前歌曲索引

@end
