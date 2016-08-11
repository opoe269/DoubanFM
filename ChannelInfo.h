//
//  ChannelInfo.h
//  DoubanFM
//
//  Created by 王振宇OneZY on 15/11/15.
//  Copyright © 2015年 王振宇. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChannelInfo : NSObject

@property (copy, nonatomic)NSString *channelId;
@property (copy, nonatomic)NSString *channelName;
@property (copy, nonatomic)NSString *channelBanner; //封面
@property (copy, nonatomic)NSString *cover; //小封面
@property (copy, nonatomic)NSString *channelIntro; //channel介绍



- (instancetype)initWithDict:(NSDictionary *)dict; //解析返回的频道数据字典

+ (NSMutableArray *)channelSections; //频道分组

+ (ChannelInfo *)currentChannel; //当前频道

+ (NSArray *)channelTittles; //频道标题

+ (void)updateCurremtChannel:(ChannelInfo *)channel; //更新当前频道

+ (void)updateChannelTitles:(NSArray *)channelTitlesArray; //更新频道标题数组

+ (ChannelInfo *)setChannelWithId:(NSString *)ID andName:(NSString *)name; //

@end