//
//  NetManager.m
//  DoubanFM
//
//  Created by 王振宇OneZY on 15/11/19.
//  Copyright © 2015年 王振宇. All rights reserved.
//

#import "NetManager.h"
#import "AppDelegate.h"
#import "ChannelInfo.h"
#import "songInfo.h"

#import "AFNetworking/AFNetworking.h"

@interface NetManager()<UIAlertViewDelegate>

@property (strong, nonatomic)AppDelegate *appDelegate;
@property (strong, nonatomic)AFHTTPSessionManager *manager;

@end

@implementation NetManager

- (instancetype)init{
    if (self = [super init]) {
        self.appDelegate = [[UIApplication sharedApplication] delegate];
        self.manager = [AFHTTPSessionManager manager];
        self.manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
   }
    return self;
}

//利用URL和频道index，来请求频道列表
- (void)setChannelWithChannelIndex:(NSUInteger)channelIndex withUrlString:(NSString *)urlString{
    urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"`#%^{}\"[]|\\<> "].invertedSet];
    [self.manager GET:urlString parameters:nil  progress:^(NSProgress * _Nonnull downloadProgress) {}  success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        NSLog(@"网络请求成功");
        [[ChannelInfo channelSections][channelIndex] removeAllObjects];
        NSDictionary *channels = responseObject[@"data"];
        NSLog(@"%@",channels[@"rec_chls"]);
        
        if (channelIndex != 1) {
            //如果index不为1，则说明是“上升最快兆赫” or “热门兆赫”
            for (NSDictionary *channel in channels[@"channels"]){
                ChannelInfo *channelInfo = [[ChannelInfo alloc]initWithDict:channel];
                [[ChannelInfo channelSections][channelIndex] addObject:channelInfo];
            }
        }else{
            //传进来的index为1，则说明是推荐兆赫，此处会根据用户的登录情况来加载推荐兆赫
            NSDictionary *channel = channels[@"res"];
            if ([[channels allKeys] containsObject:@"rec_chls"]) {
                //如果用户登录，加载登录频道
                for (NSDictionary *tempRecChannel in channels[@"rec_chls"]){
                    ChannelInfo *channelInfo = [[ChannelInfo alloc]initWithDict:tempRecChannel];
                    [[ChannelInfo channelSections][channelIndex] addObject:channelInfo];
                }
            }else{
                //用户没登陆，加载channel频道
                ChannelInfo *channelInfo = [[ChannelInfo alloc]initWithDict:channel];
                [[ChannelInfo channelSections][channelIndex] addObject:channelInfo];
            }
        }
        //刷新
        if (self.reloadCollectionViewDataBlock) {
            self.reloadCollectionViewDataBlock();
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"网络请求失败");
        
    }];
}

//加载播放列表
/*
 {
 "r":0,"is_show_quick_start":1,
 "song":
 [{"status":0,
 "picture":"http:\/\/img3.douban.com\/lpic\/s28105114.jpg",
 "alert_msg":"",
 "albumtitle":"Dale",
 
 "singers":
 [{"related_site_id":0,
 "is_site_artist":false,
 "id":"12984","name":"Pitbull"}],
 
 "file_ext":"mp4",
 "like":0,
 "album":"\/subject\/26420216\/",
 "ver":0,
 "ssid":"d101",
 "title":"El Party",
 "url":"http:\/\/mr7.doubanio.com\/b85a7c00b60a81eb189875e2844c4264\/0\/fm\/song\/p2491496_128k.mp4",
 "artist":"Pitbull",
 "subtype":"",
 "length":236,
 "sid":"2491496",
 "aid":"26420216",
 "sha256":"c7abd7e6fefccc7972a2e55f9fd921a289e2eb52cd598d1d8e62b63e47c7a7c7",
 "kbps":"128"}]
 }
 */
- (void)loadingPlayListWithTaye:(NSString *)type{
    NSLog(@"加载播放列表");
    
    [self.appDelegate.playList removeAllObjects];
    
    NSString *listURLString = [NSString stringWithFormat:@"http://douban.fm/j/mine/playlist?type=%@&sid=%@&pt=%f&channel=%@&from=mainsite",type,[songInfo currentSong].songId,self.appDelegate.player.currentPlaybackTime,[ChannelInfo currentChannel].channelId];
    
    listURLString = [listURLString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"`#%^{}\"[]|\\<> "].invertedSet];
    
    [self.manager GET:listURLString parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {} success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        
        for (NSDictionary *song in responseObject[@"song"]){
            if ([song[@"subtype"] isEqualToString:@"T"]) {
                continue;
            }
            //把从网上获取到的单首歌曲信息加载到播放列表中
            songInfo *songinfo = [[songInfo alloc]initWithDict:song];
            [self.appDelegate.playList addObject:songinfo];
        }
        
            if ([type isEqualToString:@"r"]) {
                [songInfo setCurrentSongIndex:-1];
            }else{
                //把播放列表的第一首歌给播放器实例
                if (self.appDelegate.playList.count != 0) {
                    [songInfo setCurrentSongIndex:0];
                    [songInfo setCurrentSong:[self.appDelegate.playList objectAtIndex:[songInfo currentSongIndex]]];
                    [self.appDelegate.player setContentURL:[NSURL URLWithString:[songInfo currentSong].url]];
                    NSLog(@"currentSong's url is %@",[songInfo currentSong].url);
                    [self.appDelegate.player play];
                }
            }
        }
    failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"获取播放列表失败");
    }];
}

//功能待实现

- (void)loadingCaptchaImage{
    NSLog(@"加载验证码图片");
}

- (void)loginWithUsername:(NSString *)username password:(NSString *)password captcha:(NSString *)captcha withRemember:(NSString *)remember{
    NSLog(@"登录");
}

- (void)logOut{
    NSLog(@"logout");
}

@end
