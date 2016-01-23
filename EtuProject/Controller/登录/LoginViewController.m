//
//  LoginViewController.m
//  EtuProject
//
//  Created by 王家兴 on 15/11/5.
//  Copyright © 2015年 王家兴. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "FindPasswordViewController.h"
#import "Login.h"

@interface LoginViewController ()
{
    UIImageView *avatorBgImageView;
}
@property (nonatomic, strong) UITextField	*phoneNum;
@property (nonatomic, strong) UITextField	*password;
@property (nonatomic, strong) UIButton		*btnLogin, *btnFindPwd, *btnRegister, *btnLook;
@property (nonatomic, strong) UIImageView   *avatorImageView;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.titleLabel.text = @"登录";
    self.titleLabel.textColor = [UIColor grayColor];
    self.headerView.backgroundColor = rgbColor(242, 242, 242);
    
    self.btnRegister			= [UIButton btnDefaultFrame:CGRectMake(mScreenWidth - 80 - 10, self.headerView.height- 25 - 5, 80, 25) title:@"新用户注册" font:2];
    [_btnRegister setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [_btnRegister setBackgroundImage:nil forState:UIControlStateNormal];
    _btnRegister.titleLabel.font = [UIFont boldSystemFontOfSize:12];
    
    [self.headerView addSubview:_btnRegister];
    
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, mScreenWidth, mScreenHeight)];
    [backgroundImageView setImage:[UIImage imageNamed:@"loginBg"]];
//    [self.view addSubview:backgroundImageView];
    
    avatorBgImageView = [[UIImageView alloc] initWithFrame:CGRectMake((mScreenWidth-80)/2, self.headerView.bottom + 20, 80, 100)];
//    avatorBgImageView.backgroundColor = [UIColor grayColor];
    [avatorBgImageView setImage:[UIImage imageNamed:@"photo2"]];
    [self.view addSubview:avatorBgImageView];
    
    UIView *container = [[UIView alloc]initWithFrame:CGRectMake(10, avatorBgImageView.bottom + 20, self.view.width - 20, 100)];
    container.backgroundColor = [UIColor whiteColor];
    container.layer.borderWidth = 0.5;
    container.layer.cornerRadius = 6;
    container.layer.borderColor = rgbaColor(238, 238, 238, 1).CGColor;
    [self.view addSubview:container];
    
    self.phoneNum			= [UITextField textFieldWithFrame:CGRectMake(10, 10, container.width - 10*2, 30) font:0 label:@"手机号:    " labelTextColor:[UIColor blackColor]];
    _phoneNum.maxLength		= 20;
//    _phoneNum.placeholder	= @"手机号";
    _phoneNum.textColor     = [UIColor blackColor];
    
    UIImageView *seperateLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, container.height/2, container.width, 0.5)];
    seperateLine.backgroundColor = rgbaColor(238, 238, 238, 1);
    
    self.password				= [UITextField textFieldWithFrame:CGRectMake(10, 50+10, container.width - 10*2, 30) font:0 label:@"密    码:    " labelTextColor:[UIColor blackColor]];
    _password.y					= _phoneNum.bottom + 24;
    _password.maxLength			= 20;
    _password.secureTextEntry	= YES;
//    _password.placeholder		= @"密码";
    _password.textColor         = [UIColor blackColor];

    [container addSubviews:_phoneNum, seperateLine, _password, nil];
    
    self.btnLogin = [UIButton btnDefaultFrame:CGRectMake(25, container.bottom + 50, mScreenWidth - 25*2, 45) title:@"登录" font:4];
    [_btnLogin setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.btnLogin.backgroundColor = rgbaColor(49, 150, 227, 1);
    _btnLogin.layer.cornerRadius		= 10.f;
    
    self.btnFindPwd = [UIButton btnDefaultFrame:CGRectMake(mScreenWidth - 25 - 136/2, _btnLogin.bottom + 20, 136/2, 30) title:@"忘记密码？" font:0];
    [_btnFindPwd setTitleColor:rgbaColor(49, 150, 227, 1) forState:UIControlStateNormal];
    _btnFindPwd	.titleLabel.font = [UIFont boldSystemFontOfSize:12];
    _btnFindPwd.contentMode = UIViewContentModeRight;
    _btnFindPwd.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    
    addBtnAction(_btnLogin, @selector(onBtnAction:));
    addBtnAction(_btnFindPwd, @selector(onBtnAction:));
    addBtnAction(_btnRegister, @selector(onBtnAction:));
    
    [self.view addSubviews:_btnLogin, _btnFindPwd, nil];
    
    addSelfAsNotificationObserver(kN_SET_USERNAME_PASSWORD, @selector(onSetUsernamePassword:));
    
    NSUserDefaults *udf = [NSUserDefaults standardUserDefaults];
    self.phoneNum.text = [udf valueForKey:kUD_LOGIN_PHONENUM];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onSetUsernamePassword:(NSNotification *)notification
{
    NSDictionary *userdata = notification.object;
    
    self.phoneNum.text	= userdata[kUSERNAME];
    self.password.text	= userdata[kPASSWORD];
}

- (void)onBtnAction:(UIButton *)sender
{
    __block NSString	*username	= self.phoneNum.text;
    __block NSString	*password	= self.password.text;
    
    if (sender == _btnLogin) {
        if ([NSString isStringEmptyOrBlank:username]) {
            showTip(@"请输入手机号");
            return;
        }
        
        //        if (![username validateMobile]) {
        //            showTip(@"请输入有效的手机号");
        //            return;
        //        }
        
        if ([NSString isStringEmptyOrBlank:password]) {
            showTip(@"请输入密码");
            return;
        }
        
        showViewHUD;
        weakObj(self);
        
        [APP_DELEGATE doLoginWithUsername:username pwd:password block:^(BOOL success, NSError *error) {
            
            hideViewHUD;
            
            if (success) {
                //                [bself.navigationController popViewControllerAnimated:YES];
                if (APP_DELEGATE.isRootViewLaunched) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"loginSuccess" object:nil];
                    [bself dismissViewControllerAnimated:YES completion:nil];
                }
                else
                {
                    if ([APP_DELEGATE.userData.isall integerValue] == 0) {
                        [APP_DELEGATE loginbyFixInfo];
                    }
                    else
                    {
                        [APP_DELEGATE loginSuccess];
                    }
                }
                
            } else {
                if (error == nil || [error.userInfo objectForKey:@"msg"] == nil)
                {
                    showTip(@"网络连接失败");
                }
                else
                {
                    showTip([error.userInfo objectForKey:@"msg"]);
                }
            }
        }];
    } else if (sender == _btnFindPwd) {
        FindPasswordViewController *findpwd = [[FindPasswordViewController alloc] init];
        
        [self.navigationController pushViewController:findpwd animated:YES];
    }else if (sender == _btnRegister) {
        RegisterViewController *registerVC = [[RegisterViewController alloc] init];
        [self.navigationController pushViewController:registerVC animated:YES];
    }
}

@end
