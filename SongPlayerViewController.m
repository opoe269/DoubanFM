//
//  SongPlayerViewController.m
//  DoubanFM
//
//  Created by 王振宇OneZY on 15/11/14.
//  Copyright © 2015年 王振宇. All rights reserved.
//

#import "SongPlayerViewController.h"
#import "AppDelegate.h"
#import "NetManager.h"
#import "Player.h"
#import "playerDelegate.h"
#import "songInfo.h"
#import "ChannelInfo.h"

#import "AFNetworking/AFNetworking.h"
#import "UIImageView+WebCache.h"

@interface SongPlayerViewController ()<PlayerDelegate>

@property (strong, nonatomic) AppDelegate *appDelegate;
@property (strong, nonatomic) NetManager *networkManager;
@property (strong, nonatomic) AFHTTPSessionManager *manager;

@property (strong, nonatomic) Player *player; //播放器实例


//定时器
@property (strong, nonatomic) NSTimer *timer;
//歌曲总播放时间
@property (strong, nonatomic) NSString *totalPlayTime;
//歌曲当前播放时间
@property (weak, nonatomic) IBOutlet UILabel *currentPlayTime;
//歌曲总播放时间
@property (weak, nonatomic) IBOutlet UILabel *playTime;


/*
 UI相关
*/

//背景动画
@property (weak, nonatomic) IBOutlet UIView *backImage;
//歌曲封面
@property (weak, nonatomic) IBOutlet UIImageView *songImage;
//歌曲标题
@property (weak, nonatomic) IBOutlet UILabel *songTitle;
//歌手
@property (weak, nonatomic) IBOutlet UILabel *artist;
//歌曲开始结束时间
@property (weak, nonatomic) IBOutlet UILabel *songStartTime;
@property (weak, nonatomic) IBOutlet UILabel *songEndTime;
//进度条
@property (weak, nonatomic) IBOutlet UIProgressView *progressBar;

//button
@property (weak, nonatomic) IBOutlet UIButton *likeBtn;
@property (strong, nonatomic) IBOutlet UIButton *playBtn;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;

- (IBAction)pauseBtnClicked:(UIButton *)sender;
- (IBAction)likeBtnClicked:(UIButton *)sender;
- (IBAction)nextBtnClicked:(UIButton *)sender;



@end

@implementation SongPlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"NowPlaying";
    //实例化工具
    self.manager = [[AFHTTPSessionManager alloc]init];
    self.appDelegate = [UIApplication sharedApplication].delegate;
    self.networkManager = [[NetManager alloc]init];
    
    //加载播放列表,n表示是一个空的播放列表
    //[self.networkManager loadingPlayListWithTaye:@"n"];
    
    //给歌曲图片添加点击手势，待添加
    
    //实例化播放器
    self.player = [[Player alloc]init];
    self.player.delegate = self;                      //为什么要给player设置代理属性? 因为player类中有一个delegate属性
    
    //创建一个定时器,每隔一段时间调用updateProgress方法
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.02f target:self selector:@selector(updateProgress) userInfo:nil repeats:YES];
    //添加至Runloop中
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    
    //把歌曲信息设置到播放器VC的各个控件上
    [self initSongInfo];
    
    //音乐条，待添加，使用Block
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.view.layer.cornerRadius = 10;
    self.view.layer.masksToBounds = YES;
}

- (void)viewDidDisappear:(BOOL)animated{
    
    [super viewDidDisappear:animated];
    //结束远程控制
    [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
   
    [self resignFirstResponder];
}

#pragma mark - PlayerDelegate Method
#pragma mark - 设置播放器VC的控件内容为当前歌曲的信息
- (void)initSongInfo{

    self.isPlaying = YES;
    [self.playBtn setBackgroundImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal];
    
    if(![self isFirstResponder]){
        [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
        [self becomeFirstResponder];
    }
    NSLog(@"currentSong.title is %@",[songInfo currentSong].title);
    
    //设置播放器VC的各个控件内容
    self.songTitle.text = [songInfo currentSong].title;
    self.artist.text = [songInfo currentSong].artist;
    [self.songImage sd_setImageWithURL:[NSURL URLWithString:[songInfo currentSong].picture] placeholderImage:[UIImage imageNamed:@"defaultCover"] options:SDWebImageRetryFailed|SDWebImageLowPriority completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        NSLog(@"专辑图片已设置");
    }];
    //此处是播放时间控件
    self.totalPlayTime = [NSString stringWithFormat:@"%d:%02d",[[songInfo currentSong].length intValue] /60,[[songInfo currentSong].length intValue] %60];
    
    //设置喜欢按钮
    if(![[songInfo currentSong].like intValue]){
        
        [self.likeBtn setBackgroundImage:[UIImage imageNamed:@"like"] forState:UIControlStateNormal];
    }else{
        
        [self.likeBtn setBackgroundImage:[UIImage imageNamed:@"liked"] forState:UIControlStateNormal];
    }

    
    //定时器继续 ，并不懂是什么意思？
    [self.timer setFireDate:[NSDate date]];
    
    //配置播放信息
    [self configPlayingInfo];
}

#pragma mark - 锁屏显示播放信息
- (void)configPlayingInfo{
    //锁屏显示播放信息
    if (NSClassFromString(@"MPNowPlayingInfoCenter")) {
        if ([songInfo currentSong].title != nil) {
            
            NSMutableDictionary *nowPlayingInfo = [NSMutableDictionary dictionary];
            //存储当前歌曲的名字
            [nowPlayingInfo setObject:[songInfo currentSong].title forKey:MPMediaItemPropertyTitle];
            //存储当前歌曲的歌手
            [nowPlayingInfo setObject:[songInfo currentSong].artist forKey:MPMediaItemPropertyArtist];
            //存储当前歌曲的专辑图片
            //待添加
            
            //更新MPNowPlayingInfoCenter的nowPlayingInfo
            [MPNowPlayingInfoCenter defaultCenter].nowPlayingInfo = nowPlayingInfo;
        }
    }
}

#pragma mark - 开始/暂停按钮点击事件for锁屏
- (IBAction)pauseBtnClicked:(UIButton *)sender{

    if (self.isPlaying) {
        self.isPlaying = NO;
        [self.player pause];
        [self.playBtn setBackgroundImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
        //暂停定时器
        [self.timer setFireDate:[NSDate distantFuture]];
    }else{
        self.isPlaying = YES;
        [self.player restart];
        [self.playBtn setBackgroundImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal];
        //继续定时器
        [self.timer setFireDate:[NSDate date]];
    }
}

#pragma mark - 喜欢按钮点击事件
- (IBAction)likeBtnClicked:(UIButton *)sender{

    if (![[songInfo currentSong].like intValue]) {
        [songInfo currentSong].like = @"1";
        [self.likeBtn setBackgroundImage:[UIImage imageNamed:@"liked"] forState:UIControlStateNormal];
        [self.player like];
    }else{
        [songInfo currentSong].like = @"0";
        [self.likeBtn setBackgroundImage:[UIImage imageNamed:@"like"] forState:UIControlStateNormal];
        [self.player dislike];
    }
}

#pragma mark - 下一首按钮点击事件
- (IBAction)nextBtnClicked:(UIButton *)sender{

    [self.timer setFireDate:[NSDate distantFuture]];
    [self.player pause];
//    if (self.isPlaying == NO) {
//
//    }
    [self.player skip];
}

#pragma mark - 进度条
- (void)updateProgress{

    self.progressBar.progress = self.appDelegate.player.currentPlaybackTime / [[songInfo currentSong].length intValue];
    self.currentPlayTime.text = [NSString stringWithFormat:@"%d:%02d",(unsigned)self.appDelegate.player.currentPlaybackTime /60,(unsigned)self.appDelegate.player.currentPlaybackTime %60];
    self.playTime.text = self.totalPlayTime;
}

#pragma mark - 远程控制
- (void)remoteControlReceivedWithEvent:(UIEvent *)event{

    if (event.type == UIEventTypeRemoteControl) {
        switch (event.subtype) {
            case UIEventSubtypeRemoteControlPause:
            case UIEventSubtypeRemoteControlPlay:
                break;
                
            default:
                break;
        }
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
