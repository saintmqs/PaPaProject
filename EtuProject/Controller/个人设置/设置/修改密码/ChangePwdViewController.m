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
    
    UIView *container = [[UIView alloc]initWithFrame:CGRectMake(0, 40, self.view.width, 180)];
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

- (void)onBtnAction:(UIButton *)sender
{
    __block NSString	*password	= self.password.text;
    __block NSString    *newpassword = self.newpassword.text;
    __block NSString	*renewpassword	= self.reNewpassword.text;
    
    if (sender == _btnFinish) {
        if ([NSString isStringEmptyOrBlank:password]) {
            showTip(@"请输入密码");
            return;
        }
        
        
        if ([NSString isStringEmptyOrBlank:newpassword]) {
            showTip(@"请输入新密码");
            return;
        }
        
        if ([NSString isStringEmptyOrBlank:renewpassword]) {
            showTip(@"请再次输入新密码");
            return;
        }
        
        if (![newpassword isEqualToString:newpassword]) {
            showTip(@"两次输入的新密码不符");
            return;
        }
        
        showViewHUD;
        weakObj(self);
        
        [self startRequestWithDict:updatePwd([APP_DELEGATE.userData.uid integerValue],password,newpassword,renewpassword) completeBlock:^(ASIHTTPRequest *request, NSDictionary *dict, NSError *error) {
            
            hideViewHUD;
            
            if (error) {
                if (error == nil || [error.userInfo objectForKey:@"msg"] == nil)
                {
                    showTip(@"网络连接失败");
                }
                else
                {
                    showTip([error.userInfo objectForKey:@"msg"]);
                }
            }
            else
            {
                showTip([dict objectForKey:@"msg"]);

                double delayInSeconds = 1.0;
                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
                dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                    
                    [bself.navigationController popViewControllerAnimated:YES];
                });

            }
            
        } url:kRequestUrl(@"user", @"updatePwd")];
        
    }
}
@end
