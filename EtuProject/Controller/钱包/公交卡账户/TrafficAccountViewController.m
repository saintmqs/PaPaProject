//
//  TrafficAccountViewController.m
//  EtuProject
//
//  Created by 王家兴 on 15/12/22.
//  Copyright © 2015年 王家兴. All rights reserved.
//

#import "TrafficAccountViewController.h"
#import "LastPurchaseHistoryCell.h"

@interface TrafficAccountViewController()<UITableViewDataSource,UITableViewDelegate>
{
    UIView *headInfoView;
    UILabel *balanceLabel;
    
    UITableView *lastPurchaseHistoryTable;
    
    UIView *bottomView;
    
    NSMutableArray *dataArray;
}
@end

@implementation TrafficAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.leftNavButton.hidden = NO;
    
    self.titleLabel.text = @"公交卡账户";
    
    self.headerView.backgroundColor = rgbaColor(255, 118, 40, 1);
    
    dataArray = [NSMutableArray array];
    
    [self configTopView];
    [self configBottomView];
    
    [self configListTable];
    
    [[PaPaBLEManager shareInstance].bleManager getExpensesRecord];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)didTopLeftButtonClick:(UIButton *)sender
{
    [APP_DELEGATE backToLastPage];
    APP_DELEGATE.rootTabbarController.tabBarHidden = NO;
}

-(void)configTopView
{
    headInfoView = [[UIView alloc] initWithFrame:CGRectMake(0, self.headerView.frameBottom, mScreenWidth, 90)];
    headInfoView.backgroundColor = rgbaColor(255, 118, 40, 1);
    [self.view addSubview:headInfoView];
    
    balanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 15, mScreenWidth - 40, 40)];
    balanceLabel.textColor = [UIColor whiteColor];
    balanceLabel.font = [UIFont boldSystemFontOfSize:40];
    balanceLabel.textAlignment = NSTextAlignmentCenter;
    balanceLabel.text = [PaPaBLEManager shareInstance].balance;
    [headInfoView addSubview:balanceLabel];
    
    UILabel *descripitonLabel = [[UILabel alloc] initWithFrame:CGRectMake((mScreenWidth - 100)/2, balanceLabel.frameBottom + 5, 100, 14)];
    descripitonLabel.text = @"账户余额（元）";
    descripitonLabel.textColor = [UIColor colorWithWhite:1.0 alpha:0.5];
    descripitonLabel.font = [UIFont systemFontOfSize:12];
    descripitonLabel.textAlignment = NSTextAlignmentCenter;
    [headInfoView addSubview:descripitonLabel];
}

-(void)configBottomView
{
    bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, mScreenHeight-35, mScreenWidth, 35)];
    
    UIButton *checkLogsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    checkLogsButton.frame = bottomView.bounds;
    [checkLogsButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [checkLogsButton setTitle:@"查看所有消费记录>" forState:UIControlStateNormal];
    checkLogsButton.titleLabel.font = [UIFont systemFontOfSize:14];
//    addBtnAction(checkLogsButton, @selector(checkAllLogs));
    
    
}

-(void)configListTable
{
    lastPurchaseHistoryTable = [[UITableView alloc] initWithFrame:CGRectMake(0, headInfoView.frameBottom, mScreenWidth, mScreenHeight - headInfoView.frameBottom)];
    lastPurchaseHistoryTable.dataSource = self;
    lastPurchaseHistoryTable.delegate = self;
    lastPurchaseHistoryTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:lastPurchaseHistoryTable];
}

#pragma mark - UITableView DataSource & Delegate
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, mScreenWidth, 30)];
    view.backgroundColor = rgbaColor(247, 246, 250, 1);
    
    UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 5, mScreenWidth - 30, 20)];
    tipLabel.textColor = [UIColor grayColor];
    tipLabel.textAlignment = NSTextAlignmentLeft;
    tipLabel.font = [UIFont systemFontOfSize:13];
    tipLabel.text = @"最近消费记录";
    [view addSubview:tipLabel];
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"LastPurchaseHistoryCell";
    LastPurchaseHistoryCell *cell = (LastPurchaseHistoryCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[LastPurchaseHistoryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.backgroundColor = [UIColor whiteColor];
    }
    
    return cell;
}

#pragma mark - PaPa
- (void) BLEManagerHasExpensesRecord:(NSArray *)record//蓝牙返回消费记录，每个记录以NSDictionary存储
{
    NSLog(@"%@",record);
    dataArray = [NSMutableArray arrayWithArray:record];
}
@end
