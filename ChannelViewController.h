//
//  ChannelViewController.h
//  DoubanFM
//
//  Created by 王振宇OneZY on 15/11/9.
//  Copyright © 2015年 王振宇. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChannelViewController : UICollectionViewController

@property (strong, nonatomic)NSMutableArray *channels;
@property (strong, nonatomic)NSArray *channelsTitle;
@property (strong, nonatomic)NSArray *myChannel;
@property (strong, nonatomic)NSMutableArray *hotChannels;
@property (strong, nonatomic)NSMutableArray *upFastChannels;
@property (strong, nonatomic)NSMutableArray *recommendChannels;

@property (copy, nonatomic)void (^cellClickBlock)(int index);


@end
