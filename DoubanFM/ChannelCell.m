//
//  ChannelCell.m
//  DoubanFM
//
//  Created by 王振宇OneZY on 15/11/16.
//  Copyright © 2015年 王振宇. All rights reserved.
//

#import "ChannelCell.h"
#import "ChannelInfo.h"
#import "UIImageView+WebCache.h"

@interface ChannelCell()

@property (weak, nonatomic) IBOutlet UIImageView *channelImageView;

@end

@implementation ChannelCell

- (void)awakeFromNib{
    // initialization
    self.channelTitle.numberOfLines = 0;   //UILabel
    self.channelTitle.lineBreakMode = NSLineBreakByWordWrapping; //已字符为单位显示，后面的部分省略不显示
    self.channelTitle.textColor = [UIColor blackColor];
    self.channelTitle.font = [UIFont systemFontOfSize:13];
    
    self.channelImageView.contentMode = UIViewContentModeScaleAspectFill; //图片自适应
    self.channelImageView.layer.cornerRadius = 3;
    self.channelImageView.layer.masksToBounds = YES;
    self.channelImageView.backgroundColor = [UIColor clearColor];
    
    self.channelTitle.text = @"音乐是什么？";
}


- (instancetype)cellWithCollectionView:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath channelSections:(NSMutableArray *)channelSections{
    ChannelCell *channelCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"channelcell" forIndexPath:indexPath];
    
    channelCell.channel = channelSections[indexPath.section][indexPath.item]; // channelInfo *channel
    return channelCell;
}

- (void)setChannel:(ChannelInfo *)channel{
    _channel = channel;
    self.channelTitle.text = (channel.channelIntro.length == 0? channel.channelName : channel.channelIntro);
    [self.channelImageView sd_setImageWithURL:[NSURL URLWithString:channel.channelBanner == nil? channel.cover:channel.channelBanner] placeholderImage:[UIImage imageNamed:@"defaultCover"] options:SDWebImageRetryFailed|SDWebImageLowPriority];
}




@end























