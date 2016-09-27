//
//  NetManager.h
//  DoubanFM
//
//  Created by 王振宇OneZY on 15/11/19.
//  Copyright © 2015年 王振宇. All rights reserved.
//
//频道分组 URL
#define kRecommendChannelsUrlString @"http://douban.fm/j/explore/get_recommend_chl"
#define kLoginChannelsUrlString @"http://douban.fm/j/explore/get_login_chls?uk=%@"
#define kUpTrendingChannelsUrlString @"http://douban.fm/j/explore/up_trending_channels"
#define kHotChannelsUrlString @"http://douban.fm/j/explore/hot_channels"
//登录图标URL
#define kLoginImageUrlString @"http://img3.douban.com/icon/ul%@-1.jpg"
//歌曲播放列表URL
#define kPlayListUrlString @"http://douban.fm/j/mine/playlist?type=%@&sid=%@&pt=%f&channel=%@&from=mainsite"
//登录、登出验证URL
#define kLoginUrlString @"http://www.douban.com/j/app/login"
#define kLogoutUrlString @"http://douban.fm/partner/logout"
//验证码URL
#define kCaptchaIDUrlString @"http://douban.fm/j/new_captcha"
#define kCaptchaImgUrlString @"http://douban.fm/misc/captcha?size=m&id=%@"

# pragma ---------------------------------------------------------------------

#import <Foundation/Foundation.h>

@interface NetManager : NSObject

@property (copy, nonatomic)NSMutableArray *captchaId; // 验证码字符串

- (void)loadingPlayListWithTaye:(NSString *)type; // 加载播放列表
- (void)setChannelWithChannelIndex:(NSUInteger)channelIndex withUrlString:(NSString *)urlString; //设置频道列表

- (void)loginWithUsername:(NSString *)username password:(NSString *)password captcha:(NSString *)captcha withRemember:(NSString *)remember; // 用户登录

- (void)logOut; //登出
- (void)loadingCaptchaImage; //加载验证码



@property (copy, nonatomic)void (^setCaptImgBlock)(NSString * urlString);

@property (copy, nonatomic)void (^reloadCollectionViewDataBlock)(void);

@property (copy, nonatomic)void (^loginSucess)(void);
@property (copy, nonatomic)void (^logoutSucess)(void);



@end
