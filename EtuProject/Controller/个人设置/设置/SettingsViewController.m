//
//  SettingsViewController.m
//  EtuProject
//
//  Created by 王家兴 on 15/11/5.
//  Copyright © 2015年 王家兴. All rights reserved.
//

#import "SettingsViewController.h"
#import "UserInfoTableViewCell.h"

#import "ChangePwdViewController.h"

@interface SettingsViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
{
    UITableView *settingsTable;
    
    NSArray *titlesArray;
}

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.titleLabel.text = @"设置";
    self.headerView.backgroundColor = rgbaColor(0, 155, 232, 1);
    
    _infoHeadView = [[UserInfoHeadView alloc] initWithFrame:CGRectMake(0, self.headerView.frameBottom, mScreenWidth, 170)];
    [self.view addSubview:_infoHeadView];

    titlesArray = [NSArray arrayWithObjects:@"登录密码",@"支付密码",@"意见反馈",@"使用帮助",@"关于我们", nil];

    settingsTable = [[UITableView alloc] initWithFrame:CGRectMake(0, _infoHeadView.frameBottom, mScreenWidth, mScreenHeight-_infoHeadView.frameBottom)];
    settingsTable.dataSource = self;
    settingsTable.delegate = self;
    settingsTable.backgroundColor = [UIColor clearColor];
    settingsTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    settingsTable.bounces = NO;
    settingsTable.contentInset = UIEdgeInsetsMake(5, 0, 0, 0);
    [self.view addSubview:settingsTable];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)didTopLeftButtonClick:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:NO];
}

#pragma mark - UITableView DataSource & Delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        return 35;
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return [titlesArray count];
    }
    
    return 1;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, mScreenWidth, 60)];
        view.backgroundColor = [UIColor clearColor];
        return view;
    }
    
    return nil;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"UITableViewCell";
    UserInfoTableViewCell *cell = (UserInfoTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UserInfoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.backgroundColor = [UIColor whiteColor];
    }
    
    switch (indexPath.section) {
        case 0:
        {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.seperateLine.hidden = indexPath.row == 4;
            cell.titleLabel.text = [titlesArray objectAtIndex:indexPath.row];
            cell.titleLabel.textColor = [UIColor blackColor];
            cell.detailLabel.hidden = YES;
        }
            break;
        case 1:
        {
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.seperateLine.hidden = indexPath.row == 1;
            cell.detailLabel.text = @"退出";
            cell.detailLabel.textAlignment = NSTextAlignmentCenter;
            cell.detailLabel.frame = CGRectMake(0, (60-30)/2, mScreenWidth, 30);
            
        }
            break;
        default:
            break;
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    switch (indexPath.section) {
        case 0:
        {
            switch (indexPath.row) {
                case 0:
                {
                    ChangePwdViewController *vc = [[ChangePwdViewController alloc] init];
                    [self.navigationController pushViewController:vc animated:YES];
                }
                    break;
                    
                default:
                    break;
            }
        }
            break;
        case 1:
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"确定退出？" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [alertView show];
        }
            break;
        default:
            break;
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [APP_DELEGATE logOut];
    }
}
@end
