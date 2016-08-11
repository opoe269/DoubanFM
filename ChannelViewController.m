//
//  ChannelViewController.m
//  DoubanFM
//
//  Created by 王振宇OneZY on 15/11/9.
//  Copyright © 2015年 王振宇. All rights reserved.
//
#import "ChannelViewController.h"
#import "UINavigationBar+Awesome.h"
#import "AppDelegate.h"
#import "SongPlayerViewController.h"
#import "NetManager.h"

#import "ChannelCell.h"
#import "ChannelInfo.h"
#import "ChannelSectionHeader.h"

#import "MJRefresh.h"

@interface ChannelViewController()

@property (strong, nonatomic)AppDelegate *delegate;

@property (strong, nonatomic)UITableView *tableView;

@property (strong, nonatomic)ChannelCell *selectedCell;

@property (strong, nonatomic)NetManager *netManager;

@property (strong, nonatomic)SongPlayerViewController *playerVC;

@end

@implementation ChannelViewController

- (id)init{
    //alloc一个瀑布流
    UICollectionViewFlowLayout *channelFlow = [[UICollectionViewFlowLayout alloc]init];
    //每一个item的大小
    channelFlow.itemSize = CGSizeMake(125, 180);
    //item之间的间距
    channelFlow.minimumInteritemSpacing = 0;
    //item组距离顶部的距离
    channelFlow.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    
    return [self initWithCollectionViewLayout:channelFlow];
}

- (void)registerFromNib{
    //取出header和item的NIB
    UINib *cellnib = [UINib nibWithNibName:@"ChannelCell" bundle:[NSBundle mainBundle]];
    UINib *headerNib = [UINib nibWithNibName:@"ChannelSectionHeader" bundle:[NSBundle mainBundle]];
    
    //在self.collectionView中注册这两个nib，并设置header
    [self.collectionView registerNib:cellnib forCellWithReuseIdentifier:@"channelCell"];
    [self.collectionView registerNib:headerNib forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"channelSectionHeader"];
}




- (void)viewDidLoad{
    [super viewDidLoad];
    [self registerFromNib];
    
    self.delegate = [[UIApplication sharedApplication] delegate];
    self.netManager = [[NetManager alloc]init];
    __block __typeof(self) weakSelf = self;
    self.netManager.reloadCollectionViewDataBlock = ^{
        [weakSelf.collectionView reloadData];
    };
    
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.title = @"发现音乐";
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    MJRefreshGifHeader *channelHeader = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(getChannelInfo)];
    [channelHeader setTitle:@"" forState:MJRefreshStateIdle];
    channelHeader.stateLabel.textColor = [UIColor blackColor];
    channelHeader.lastUpdatedTimeLabel.hidden = NO; // 显示上一次刷新时间的label
    self.collectionView.mj_header = channelHeader;
    [channelHeader beginRefreshing];
    

    UIButton *sideButton = [UIButton buttonWithType:UIButtonTypeCustom];
    sideButton.frame = CGRectMake(0, 0, 20, 18);
    [sideButton setBackgroundImage:[UIImage imageNamed:@"menu"] forState:UIControlStateNormal];
    [sideButton addTarget:self action:@selector(oprationWithLeftList) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:sideButton];
}



- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    NSLog(@"view Will Appear!");
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    [delegate.LeftSideVC setPanEnabled:YES]; //设置是否支持滑动手势，NO意思是不支持。
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    NSLog(@"view Will Disappear!");
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    [delegate.LeftSideVC setPanEnabled:NO]; //设置是否支持滑动手势，NO意思是不支持。
}

- (void)oprationWithLeftList{
    //全局application单例
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    if (delegate.LeftSideVC.closed) {
        [delegate.LeftSideVC openLeftView];
    }else{
        [delegate.LeftSideVC closeLeftView];
    }
}

- (void)getChannelInfo{
    [self.netManager setChannelWithChannelIndex:1 withUrlString:kRecommendChannelsUrlString];
    [self.netManager setChannelWithChannelIndex:2 withUrlString:kHotChannelsUrlString];
    [self.netManager setChannelWithChannelIndex:3 withUrlString:kUpTrendingChannelsUrlString];
    [self.collectionView.mj_header endRefreshing];
}

#pragma mark -
#pragma mark TableView Data Source
//多少组
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return [ChannelInfo channelTittles].count;
}
//每组的标题
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    ChannelSectionHeader *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"channelSectionHeader" forIndexPath:indexPath];
    view.headerTitle = [ChannelInfo channelTittles][indexPath.section];
    return view;
}

//每组有多少个item
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [[ChannelInfo channelSections][section] count];
}



- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ChannelCell *cell = (ChannelCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"channelCell" forIndexPath:indexPath];
    NSMutableArray *channelSections = [ChannelInfo channelSections];
    cell.channel = channelSections[indexPath.section][indexPath.item];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(kScreenWidth, 50);
}

#pragma mark - 点击频道Cell时调用方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"selected item");
    //先取消已经选中的频道，如果有
    self.selectedCell.selected = NO;
    self.selectedCell.channelTitle.textColor = [UIColor blackColor];
    
    //接着创建一个新的selectedcell，设定为选中的状态和颜色，接着赋值给self.selectedcell
    ChannelCell *selectedCell = (ChannelCell *)[collectionView cellForItemAtIndexPath:indexPath];
    selectedCell.selected = YES;
    self.selectedCell = selectedCell;
    self.selectedCell.channelTitle.textColor = [UIColor redColor];
    
    //1.取消被点击的频道Cell
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    //2.更新当前频道
    [ChannelInfo updateCurremtChannel:[ChannelInfo channelSections][indexPath.section][indexPath.item]];
    [self.delegate.player play];
    //3.重新加载播放列表
    [self.netManager loadingPlayListWithTaye:@"n"];
    
    
    self.playerVC = [[SongPlayerViewController alloc]initWithNibName:@"SongPlayerViewController" bundle:[NSBundle mainBundle]];
    [self.delegate.navVC pushViewController:self.playerVC animated:YES];
    
    
    
    
    
    
    
    
    
//    [self.delegate.LeftSideVC closeLeftView];
//    SongPlayerViewController *songPlayer = [[SongPlayerViewController alloc]init];
//    
//    [self.delegate.navVC pushViewController:songPlayer animated:YES];
}

@end
