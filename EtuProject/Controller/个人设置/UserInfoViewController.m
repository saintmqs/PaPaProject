//
//  UserInfoViewController.m
//  EtuProject
//
//  Created by 王家兴 on 15/11/5.
//  Copyright © 2015年 王家兴. All rights reserved.
//

#import "UserInfoViewController.h"
#import "SettingsViewController.h"

@interface UserInfoViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *userInfoTable;
}
@end

@implementation UserInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.titleLabel.text = @"个人信息";
    self.headerView.backgroundColor = rgbaColor(0, 155, 232, 1);

    
    self.rightNavButton.hidden = NO;
    
    _infoHeadView = [[UserInfoHeadView alloc] initWithFrame:CGRectMake(0, self.headerView.frameBottom, mScreenWidth, 170)];
    [self.view addSubview:_infoHeadView];
    
    userInfoTable = [[UITableView alloc] initWithFrame:CGRectMake(0, _infoHeadView.frameBottom, mScreenWidth, mScreenHeight-_infoHeadView.frameBottom)];
    userInfoTable.dataSource = self;
    userInfoTable.delegate = self;
    userInfoTable.backgroundColor = [UIColor clearColor];
    userInfoTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:userInfoTable];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)didTopRightButtonClick:(UIButton *)sender
{
    SettingsViewController *vc = [[SettingsViewController alloc] init];
    [self.navigationController pushViewController:vc animated:NO];
}

#pragma mark - UITableView DataSource & Delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        return 10;
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
        return 2;
    }
    
    return 5;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"UITableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.backgroundColor = [UIColor whiteColor];
    }
    
    if (indexPath.section != 0) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    return cell;
}
@end
