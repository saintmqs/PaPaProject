//
//  PasswordViewController.m
//  EtuProject
//
//  Created by 王家兴 on 15/11/5.
//  Copyright © 2015年 王家兴. All rights reserved.
//

#import "PasswordViewController.h"
#import "Login.h"
#import "SelectSexViewController.h"

@interface PasswordViewController ()

@property (nonatomic, strong) UITextField	*password;
@property (nonatomic, strong) UITextField	*rePassword;
@property (nonatomic, strong) UIButton		*btnFinish;

@end

@implementation PasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.titleLabel.text = @"设置密码";
    self.titleLabel.textColor = [UIColor grayColor];
    self.headerView.backgroundColor = rgbColor(242, 242, 242);
    
    [self.leftNavButton setImage:[UIImage imageNamed:@"topIcoLeft"] forState:UIControlStateNormal];
    [self.leftNavButton setImage:[UIImage imageNamed:@"topIcoLeftWrite"] forState:UIControlStateHighlighted];
    
    self.btnFinish			= [UIButton btnDefaultFrame:CGRectMake(mScreenWidth - 60 - 10, self.headerView.height- 25 - 5, 60, 25) title:@"完成" font:2];
    [_btnFinish setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [_btnFinish setBackgroundImage:nil forState:UIControlStateNormal];
    _btnFinish.titleLabel.font = [UIFont boldSystemFontOfSize:12];
    
    addBtnAction(_btnFinish, @selector(onBtnAction:));
    
    [self.headerView addSubview:_btnFinish];
    
    UIView *container = [[UIView alloc]initWithFrame:CGRectMake(10, self.headerView.bottom + 20, self.view.width - 20, 100)];
    container.backgroundColor = [UIColor whiteColor];
    container.layer.borderWidth = 0.5;
    container.layer.cornerRadius = 6;
    container.layer.borderColor = rgbaColor(238, 238, 238, 1).CGColor;
    [self.view addSubview:container];
    
    self.password			= [UITextField textFieldWithFrame:CGRectMake(10, 10, container.width - 10*2, 30) font:0 label:@"输入密码:    " labelTextColor:[UIColor blackColor]];
    _password.maxLength		= 16;
    _password.placeholder	= @"8-16位数字、字母、字符（至少两种）";
    _password.secureTextEntry	= YES;
    _password.textColor     = [UIColor blackColor];
    
    UIImageView *seperateLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, container.height/2, container.width, 0.5)];
    seperateLine.backgroundColor = rgbaColor(238, 238, 238, 1);
    
    self.rePassword				= [UITextField textFieldWithFrame:CGRectMake(10, 50+10, container.width - 10*2, 30) font:0 label:@"确认密码:    " labelTextColor:[UIColor blackColor]];
    _rePassword.y					= _password.bottom + 24;
    _rePassword.maxLength			= 20;
    _rePassword.secureTextEntry	= YES;
    _rePassword.textColor         = [UIColor blackColor];
    
    [container addSubviews:_password, seperateLine, _rePassword, nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onBtnAction:(UIButton *)sender
{
    __block NSString	*password	= self.password.text;
    __block NSString	*repassword	= self.rePassword.text;
    
    if (sender == _btnFinish) {
        if ([NSString isStringEmptyOrBlank:password]) {
            showTip(@"请输入密码");
            return;
        }

        
        if ([NSString isStringEmptyOrBlank:repassword]) {
            showTip(@"请再次输入密码");
            return;
        }
        
        if (![password isEqualToString:repassword]) {
            showTip(@"两次输入密码不符");
            return;
        }
        
        if (self.isFindPwd) {
            showViewHUD;
            weakObj(self);
            
            [self startRequestWithDict:findPwd(self.phoneNum, password, repassword,self.verifycode) completeBlock:^(ASIHTTPRequest *request, NSDictionary *dict, NSError *error) {
                
                hideViewHUD;
                
                if (error) {
                    showError(error);
                }
                else
                {
                    double delayInSeconds = 1.0;
                    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
                    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                        
                        [bself.navigationController popToRootViewControllerAnimated:YES];
                    });
                }
                
            } url:kRequestUrl(@"user", @"findPwd")];
        }
        else
        {
            showViewHUD;
            weakObj(self);
            
            [self startRequestWithDict:registerAccount(self.phoneNum, password, repassword,self.verifycode) completeBlock:^(ASIHTTPRequest *request, NSDictionary *dict, NSError *error) {
                
                hideViewHUD;
                
                if (error) {
                    showError(error);
                }
                else
                {
                    Login *login = [[Login alloc]initWithDictionary:[dict objectForKey:@"data"] error:nil];
                    
                    APP_DELEGATE.userData = login;
                    
                    SelectSexViewController *vc = [[SelectSexViewController alloc] init];
                    [bself.navigationController pushViewController:vc animated:YES];
                }
                
            } url:kRequestUrl(@"user", @"register")];
        }
        
        
    }
}

@end
