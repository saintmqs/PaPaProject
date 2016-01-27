//
//  ClocksCycleSettingViewController.m
//  EtuProject
//
//  Created by 王家兴 on 16/1/20.
//  Copyright © 2016年 王家兴. All rights reserved.
//

#import "ClocksCycleSettingViewController.h"
#import "ClocksCycleTableCell.h"

@interface ClocksCycleSettingViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *clocksCycleEditTable;
    
    NSArray *weekArray;
    
    NSMutableArray *checkedDays;
}

@end

@implementation ClocksCycleSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.titleLabel.text = @"闹钟周期";
    self.titleLabel.textColor = [UIColor grayColor];
    self.headerView.backgroundColor = rgbColor(242, 242, 242);
    
    [self.leftNavButton setImage:[UIImage imageNamed:@"topIcoLeft"] forState:UIControlStateNormal];
    [self.leftNavButton setImage:[UIImage imageNamed:@"topIcoLeftWrite"] forState:UIControlStateHighlighted];
    
    weekArray = [NSArray arrayWithObjects:@"周一",@"周二",@"周三",@"周四",@"周五",@"周六",@"周日", nil];
    
    if ([self.clockModel.w isEqualToString:@"0"]) {
        checkedDays = [NSMutableArray array];
    }
    else
    {
        checkedDays = [NSMutableArray arrayWithArray:[self.clockModel.w componentsSeparatedByString:@","]] ;

    }
    
    clocksCycleEditTable = [[UITableView alloc] initWithFrame:CGRectMake(0, self.headerView.frameBottom, mScreenWidth, mScreenHeight-self.headerView.frameBottom)];
    clocksCycleEditTable.dataSource = self;
    clocksCycleEditTable.delegate = self;
    clocksCycleEditTable.backgroundColor = [UIColor clearColor];
    clocksCycleEditTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    clocksCycleEditTable.bounces = NO;
    [self.view addSubview:clocksCycleEditTable];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 
-(void)didTopLeftButtonClick:(UIButton *)sender
{
    self.clockModel.w = [checkedDays componentsJoinedByString:@","];
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableView DataSource & Delegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return weekArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"ClocksManagerTableCell";
    ClocksCycleTableCell *cell = (ClocksCycleTableCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[ClocksCycleTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.backgroundColor = [UIColor whiteColor];
    }
    cell.seperateLine.hidden = indexPath.row == weekArray.count - 1;
    cell.titleLabel.text = weekArray[indexPath.row];
    
    if ([checkedDays containsObject:strFormat(@"%ld",(long)indexPath.row+1)]) {
        cell.checked = YES;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    ClocksCycleTableCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.checked = !cell.checked;
    
    if (cell.checked) {
        if (![checkedDays containsObject:strFormat(@"%ld",(long)indexPath.row+1)]) {
            [checkedDays addObject:strFormat(@"%ld",(long)indexPath.row+1)];
        }
    }
    else
    {
        if ([checkedDays containsObject:strFormat(@"%ld",(long)indexPath.row+1)]) {
            [checkedDays removeObject:strFormat(@"%ld",(long)indexPath.row+1)];
        }
    }
}

@end
