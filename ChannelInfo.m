//
//  ChannelInfo.m
//  DoubanFM
//
//  Created by 王振宇OneZY on 15/11/15.
//  Copyright © 2015年 王振宇. All rights reserved.
//

#import "ChannelInfo.h"

//设置静态变量？
static NSMutableArray *channelSections;
static ChannelInfo *currentChannel;
static NSArray *channelTitles;

@implementation ChannelInfo

//初始化解析返回的频道字典
- (instancetype)initWithDict:(NSDictionary *)dict{
    if (self = [super init]) {
        self.channelId = dict[@"id"];
        self.channelName = dict[@"name"];
        self.channelBanner = dict[@"banner"];
        self.cover = dict[@"cover"];
        self.channelIntro = dict[@"intro"];
    }
    return self;
}

//返回频道数组
+ (NSMutableArray *)channelSections{
    if (!channelSections) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            channelSections = [NSMutableArray array];
        });
    }
    return channelSections;
}

//返回当前频道
+ (ChannelInfo *)currentChannel{
    if (!currentChannel) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            currentChannel = [[ChannelInfo alloc]init];
        });
    }
    return currentChannel;
}

//返回当前频道标题，by array
+ (NSArray *)channelTittles{
    if (!channelTitles) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            channelTitles = [NSArray array];
        });
    }
    return channelTitles;
}

//更新当前频道
+ (void)updateCurremtChannel:(ChannelInfo *)channel{
    currentChannel = channel;
}

//更新当前频道标题数组

+ (void)updateChannelTitles:(NSArray *)channelTitlesArray{
    channelTitles = channelTitlesArray;
}

+ (ChannelInfo *)setChannelWithId:(NSString *)ID andName:(NSString *)name{
    ChannelInfo *channel = [[ChannelInfo alloc]init];
    channel.channelId = ID;
    channel.channelName = name;
    
    return channel;
}



@end



















