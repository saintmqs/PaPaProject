//
//  DeviceManagerViewController.m
//  EtuProject
//
//  Created by 王家兴 on 15/11/5.
//  Copyright © 2015年 王家兴. All rights reserved.
//

#import "DeviceManagerViewController.h"
#import "DeviceManagerCell.h"
#import "ClocksManagerViewController.h"

@interface DeviceManagerViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
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
    
    [[PaPaBLEManager shareInstance].bleManager getRemainingBatteryCapacity];
    [[PaPaBLEManager shareInstance].bleManager getSystemInformation];
    
    _deviceHeadView = [[DeviceManagerHeadView alloc] initWithFrame:CGRectMake(0, self.headerView.frameBottom, mScreenWidth, 220)];
    [self.view addSubview:_deviceHeadView];
    
    titlesArray = [NSArray arrayWithObjects:@"闹        钟",@"来电提醒",@"解除绑定",@"固件版本号", nil];
    
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
    static NSString *identifier = @"DeviceManagerCell";
    DeviceManagerCell *cell = (DeviceManagerCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[DeviceManagerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.backgroundColor = [UIColor whiteColor];
    }
    
    cell.seperateLine.hidden = indexPath.row == [titlesArray count] - 1;
    cell.managerTitleLabel.text = [titlesArray objectAtIndex:indexPath.row];
    
    switch (indexPath.row) {
        case 1:
        {
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.cellType = SWITCH_TYPE;
        }
            break;
        case 2:
        {
            
            cell.cellType = DETAIL_TYPE;
            if ([SystemStateManager shareInstance].hasBindWristband) {
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;;
                cell.managerDetailLabel.frame = CGRectMake(mScreenWidth/2 - 40, (60-30)/2, mScreenWidth/2, 30);
                CBPeripheral *peripheral = [[PaPaBLEManager shareInstance].bleManager getCurrentConnectedPeripheral];
                cell.managerDetailLabel.text = peripheral.name;
            }
            else
            {
                cell.accessoryType = UITableViewCellAccessoryNone;
                cell.managerDetailLabel.frame = CGRectMake(mScreenWidth/2 - 20, (60-30)/2, mScreenWidth/2, 30);
                cell.managerDetailLabel.text = @"尚未绑定";
            }
        }
            break;
        case 3:
        {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.cellType = DETAIL_TYPE;
            if ([SystemStateManager shareInstance].hasBindWristband) {
                
                cell.managerDetailLabel.frame = CGRectMake(mScreenWidth/2 - 40, (60-30)/2, mScreenWidth/2, 30);
                cell.managerDetailLabel.text = [[PaPaBLEManager shareInstance].firmwareInfo objectForKey:@"f"];
            }
        }
            break;
        default:
        {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.cellType = NORMAL_TYPE;
        }
            break;
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
        case 2:
        {
            if ([SystemStateManager shareInstance].hasBindWristband) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"opps!真的确定要解除么？我会难过的！" delegate:self cancelButtonTitle:@"好吧不解了~" otherButtonTitles:@"残忍的解绑", nil];
                [alertView show];
            }
        }
            break;
        case 3:
        {
           
        }
            break;
        default:
            break;
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [[PaPaBLEManager shareInstance].bleManager unbindCurrentWristband];
    }
}

#pragma mark - PaPaBLEManager Delegate
-(void)PaPaBLEManagerHasRemainingBatteryCapacity:(NSUInteger)level
{
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%ld%%",level]];
    [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20] range:NSMakeRange(2, 1)];
    _deviceHeadView.ElectricalVoltage.attributedText = attrStr;
}

-(void)PaPaBLEManagerHasSystemInformation:(NSDictionary *)info
{
    [deviceManagerTable reloadData];
}


#pragma mark - 
-(void)connetedViewRefreshing
{
    
}

-(void)disConnetedViewRefreshing:(NSError *)error
{
    //首页未绑定模式展示
    [APP_DELEGATE loginSuccess];
}
@end
