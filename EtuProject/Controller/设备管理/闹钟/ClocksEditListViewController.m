//
//  ClocksEditListViewController.m
//  EtuProject
//
//  Created by 王家兴 on 15/11/5.
//  Copyright © 2015年 王家兴. All rights reserved.
//

#import "ClocksEditListViewController.h"
#import "ClockDetailSettingViewController.h"
#import "ClocksManagerTableCell.h"

@interface ClocksEditListViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *clocksEditTable;
}

@end

@implementation ClocksEditListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.titleLabel.text = @"闹钟";
    self.titleLabel.textColor = [UIColor grayColor];
    self.headerView.backgroundColor = rgbColor(242, 242, 242);
    
    [self.leftNavButton setImage:[UIImage imageNamed:@"topIcoLeft"] forState:UIControlStateNormal];
    [self.leftNavButton setImage:[UIImage imageNamed:@"topIcoLeftWrite"] forState:UIControlStateHighlighted];
    
    clocksEditTable = [[UITableView alloc] initWithFrame:CGRectMake(0, self.headerView.frameBottom, mScreenWidth, mScreenHeight-self.headerView.frameBottom)];
    clocksEditTable.dataSource = self;
    clocksEditTable.delegate = self;
    clocksEditTable.backgroundColor = [UIColor clearColor];
    clocksEditTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    clocksEditTable.bounces = NO;
    clocksEditTable.contentInset = UIEdgeInsetsMake(35, 0, 0, 0);
    [self.view addSubview:clocksEditTable];
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
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.clockSwitch.hidden = YES;
    
    cell.seperateLine.hidden = indexPath.row == 2;
    cell.clockTimeLabel.text = @"07:00";
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    ClockDetailSettingViewController *vc = [[ClockDetailSettingViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
@end
