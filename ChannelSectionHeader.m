//
//  ChannelSectionHeader.m
//  DoubanFM
//
//  Created by 王振宇OneZY on 15/11/17.
//  Copyright © 2015年 王振宇. All rights reserved.
//

#import "ChannelSectionHeader.h"

@interface ChannelSectionHeader()

@property (weak, nonatomic)IBOutlet UILabel *chHeaderLabel;

@end

@implementation ChannelSectionHeader

- (void)awakeFromNib {
    // Initialization code
    self.chHeaderLabel.numberOfLines = 0;
    self.chHeaderLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.chHeaderLabel.textColor = [UIColor blueColor];
    
    self.chHeaderLabel.font = [UIFont systemFontOfSize:15];
    
    self.backgroundColor = [UIColor orangeColor];
    
}



- (void)setHeaderTitle:(NSString *)headerTitle{
    _headerTitle = headerTitle;
    self.chHeaderLabel.text = headerTitle;
}

@end
