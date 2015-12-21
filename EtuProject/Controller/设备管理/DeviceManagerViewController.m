//
//  DeviceManagerViewController.m
//  EtuProject
//
//  Created by 王家兴 on 15/11/5.
//  Copyright © 2015年 王家兴. All rights reserved.
//

#import "DeviceManagerViewController.h"
#import "UserInfoTableViewCell.h"
#import "ClocksManagerViewController.h"

@interface DeviceManagerViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *deviceManagerTable;
    
    NSArray *titlesArray;
}
@end

@implementation DeviceManagerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.titleLabel.text = @"设备管理";
    self.headerView.backgroundColor = rgbaColor(0, 155, 232, 1);
    
    _deviceHeadView = [[DeviceManagerHeadView alloc] initWithFrame:CGRectMake(0, self.headerView.frameBottom, mScreenWidth, 220)];
    [self.view addSubview:_deviceHeadView];
    
    titlesArray = [NSArray arrayWithObjects:@"闹        钟",@"清除数据",@"解除绑定",@"固件版本号", nil];
    
    deviceManagerTable = [[UITableView alloc] initWithFrame:CGRectMake(0, _deviceHeadView.frameBottom, mScreenWidth, mScreenHeight-_deviceHeadView.frameBottom)];
    deviceManagerTable.dataSource = self;
    deviceManagerTable.delegate = self;
    deviceManagerTable.backgroundColor = [UIColor clearColor];
    deviceManagerTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    deviceManagerTable.bounces = NO;
    deviceManagerTable.contentInset = UIEdgeInsetsMake(5, 0, 0, 0);
    [self.view addSubview:deviceManagerTable];
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
    return [titlesArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"UITableViewCell";
    UserInfoTableViewCell *cell = (UserInfoTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UserInfoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.backgroundColor = [UIColor whiteColor];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    cell.seperateLine.hidden = indexPath.row == 3;
    cell.titleLabel.text = [titlesArray objectAtIndex:indexPath.row];
    cell.titleLabel.textColor = [UIColor blackColor];
    cell.detailLabel.frame = CGRectMake(mScreenWidth/2 - 40, (60-30)/2, mScreenWidth/2, 30);
    
    if (indexPath.row == 3) {
        cell.detailLabel.text = @"1.0.11.6";
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    switch (indexPath.row) {
        case 0:
        {
            ClocksManagerViewController *vc = [[ClocksManagerViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
            
        default:
            break;
    }
}

@end
