//
//  ChangePwdViewController.m
//  EtuProject
//
//  Created by 王家兴 on 15/11/5.
//  Copyright © 2015年 王家兴. All rights reserved.
//

#import "ChangePwdViewController.h"

@interface ChangePwdViewController ()
{
    UIScrollView *contentScrollView;
}
@end

@implementation ChangePwdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.titleLabel.text = @"修改密码";
    self.titleLabel.textColor = [UIColor grayColor];
    self.headerView.backgroundColor = rgbColor(242, 242, 242);
    
    [self.leftNavButton setImage:[UIImage imageNamed:@"topIcoLeft"] forState:UIControlStateNormal];
    [self.leftNavButton setImage:[UIImage imageNamed:@"topIcoLeftWrite"] forState:UIControlStateHighlighted];
    
    contentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.headerView.frameBottom, mScreenWidth, mScreenHeight - self.headerView.frameBottom)];
    [self.view addSubview:contentScrollView];
    
    UIView *container = [[UIView alloc]initWithFrame:CGRectMake(0, 20, self.view.width, 180)];
    container.backgroundColor = [UIColor whiteColor];
    container.layer.borderWidth = 0.5;
    container.layer.borderColor = rgbaColor(238, 238, 238, 1).CGColor;
    [self.view addSubview:container];
    
    self.password			= [UITextField textFieldWithFrame:CGRectMake(10, 0, container.width - 10*2, 60) font:0 label:@"输入登录密码:    " labelTextColor:[UIColor blackColor]];
    _password.maxLength		= 20;
    _password.secureTextEntry	= YES;
    _password.textColor     = [UIColor blackColor];
    
    UIImageView *seperateLine = [[UIImageView alloc] initWithFrame:CGRectMake(10, container.height/3, container.width-20, 0.5)];
    seperateLine.backgroundColor = rgbaColor(238, 238, 238, 1);
    
    self.newpassword				= [UITextField textFieldWithFrame:CGRectMake(10, 60, container.width - 10*2, 60) font:0 label:@"输入新密码:    " labelTextColor:[UIColor blackColor]];
    _newpassword.maxLength			= 20;
    _newpassword.secureTextEntry	= YES;
    _newpassword.textColor         = [UIColor blackColor];
    
    UIImageView *seperateLine2 = [[UIImageView alloc] initWithFrame:CGRectMake(10, container.height*2/3, container.width-20, 0.5)];
    seperateLine2.backgroundColor = rgbaColor(238, 238, 238, 1);
    
    self.reNewpassword				= [UITextField textFieldWithFrame:CGRectMake(10, 120, container.width - 10*2, 60) font:0 label:@"确认新密码:    " labelTextColor:[UIColor blackColor]];
    _reNewpassword.maxLength			= 20;
    _reNewpassword.secureTextEntry	= YES;
    _reNewpassword.textColor         = [UIColor blackColor];
    [container addSubviews:_password, seperateLine, _newpassword, seperateLine2, _reNewpassword, nil];
    
    self.btnFinish = [UIButton btnDefaultFrame:CGRectMake(0, container.frameBottom + 40, mScreenWidth, 50) title:@"完成" font:4];
    [_btnFinish setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.btnFinish.backgroundColor = [UIColor whiteColor];
    
    [contentScrollView addSubviews:container, _btnFinish, nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
