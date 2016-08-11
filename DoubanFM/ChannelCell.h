//
//  ChannelCell.h
//  DoubanFM
//
//  Created by 王振宇OneZY on 15/11/16.
//  Copyright © 2015年 王振宇. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChannelInfo.h"

@interface ChannelCell : UICollectionViewCell

@property (weak, nonatomic)ChannelInfo *channel;
@property (strong, nonatomic)IBOutlet UILabel *channelTitle;


- (instancetype)cellWithCollectionView:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath channelSections:(NSMutableArray *)channelSections;

@end
