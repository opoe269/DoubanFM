//
//  LeftSortsViewController.m
//  DoubanFM
//
//  Created by 王振宇OneZY on 15/11/12.
//  Copyright © 2015年 王振宇. All rights reserved.
//

#import "LeftSortsViewController.h"
#import "SongPlayerViewController.h"
#import "AppDelegate.h"

@interface LeftSortsViewController ()

@property (weak, nonatomic)IBOutlet UITableView *tableView;
@property (weak, nonatomic)IBOutlet UIButton *quitButton;
@property (weak, nonatomic)IBOutlet UIImageView *headerImage;
@property (weak, nonatomic) IBOutlet UILabel *idLabel;
@property (weak, nonatomic) IBOutlet UIButton *LoginButton;
- (IBAction)loginButtonClick:(id)sender;
- (IBAction)buttonClick:(id)sender;


@property(strong, nonatomic)NSArray *listArray;
@end

@implementation LeftSortsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.frame = [UIScreen mainScreen].bounds;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.idLabel.text = @"OneZY";
    NSLog(@"%@" , self.idLabel.text);
    self.idLabel.backgroundColor = [UIColor clearColor];
    
    self.listArray = @[@"",@"发现音乐",@"",@"正在播放",@"",@"本地歌曲",@"",@"",@""];

    self.headerImage.layer.cornerRadius = self.headerImage.frame.size.width / 2;
    self.headerImage.clipsToBounds = YES;
}


- (void)buttonClick:(id)sender{
    NSLog(@"quit button clicked!");
}

- (void)loginButtonClick:(id)sender{
    NSLog(@"login button clicked!");
}
#pragma mark - 
#pragma mark UITableView Data Source Methods

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
//    return 1;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.listArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *Identifier = @"Identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault
                                     reuseIdentifier:Identifier];
    }
    
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.textLabel.font = [UIFont systemFontOfSize:18.0f];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.text = self.listArray[indexPath.row];
    
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    switch (indexPath.row) {
        case 1: [delegate.LeftSideVC closeLeftView];break;
        case 3: {
            SongPlayerViewController *songPlayer = [[SongPlayerViewController alloc]init];
            [delegate.LeftSideVC closeLeftView];
            [delegate.navVC pushViewController:songPlayer animated:YES];
        }
        case 6: NSLog(@"Local Music is not reday！");
    }
        
    
    
}

@end
