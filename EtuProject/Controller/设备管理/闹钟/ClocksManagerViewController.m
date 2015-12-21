//
//  ClocksManagerViewController.m
//  EtuProject
//
//  Created by 王家兴 on 15/11/5.
//  Copyright © 2015年 王家兴. All rights reserved.
//

#import "ClocksManagerViewController.h"
#import "ClocksEditListViewController.h"
#import "ClocksManagerTableCell.h"

@interface ClocksManagerViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *clocksManagerTable;
}
@end

@implementation ClocksManagerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.titleLabel.text = @"闹钟";
    self.titleLabel.textColor = [UIColor grayColor];
    self.headerView.backgroundColor = rgbColor(242, 242, 242);
    
    [self.leftNavButton setImage:[UIImage imageNamed:@"topIcoLeft"] forState:UIControlStateNormal];
    [self.leftNavButton setImage:[UIImage imageNamed:@"topIcoLeftWrite"] forState:UIControlStateHighlighted];
    
    self.rightNavButton.hidden = NO;
    [self.rightNavButton setImage:[UIImage imageNamed:@"topIcoRevise"] forState:UIControlStateNormal];
    
    clocksManagerTable = [[UITableView alloc] initWithFrame:CGRectMake(0, self.headerView.frameBottom, mScreenWidth, mScreenHeight-self.headerView.frameBottom)];
    clocksManagerTable.dataSource = self;
    clocksManagerTable.delegate = self;
    clocksManagerTable.backgroundColor = [UIColor clearColor];
    clocksManagerTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    clocksManagerTable.bounces = NO;
    clocksManagerTable.contentInset = UIEdgeInsetsMake(35, 0, 0, 0);
    [self.view addSubview:clocksManagerTable];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView DataSource & Delegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"ClocksManagerTableCell";
    ClocksManagerTableCell *cell = (ClocksManagerTableCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[ClocksManagerTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.backgroundColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.seperateLine.hidden = indexPath.row == 2;
    cell.clockTimeLabel.text = @"07:00";

    return cell;
}

#pragma mark - Button Action
-(void)didTopRightButtonClick:(UIButton *)sender
{
    ClocksEditListViewController *vc = [[ClocksEditListViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
@end
