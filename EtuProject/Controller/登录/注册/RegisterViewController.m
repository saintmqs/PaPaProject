//
//  RegisterViewController.m
//  EtuProject
//
//  Created by 王家兴 on 15/11/5.
//  Copyright © 2015年 王家兴. All rights reserved.
//

#import "RegisterViewController.h"
#import "PasswordViewController.h"

@interface RegisterViewController ()
{
    UIButton *getVerifyCodeBtn;
}
@property (nonatomic, strong) UITextField	*phoneNum;
@property (nonatomic, strong) UITextField	*verifyCode;
@property (nonatomic, strong) UIButton		*btnRegister;

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.titleLabel.text = @"注册E手环账号";
    self.titleLabel.textColor = [UIColor grayColor];
    self.headerView.backgroundColor = rgbColor(242, 242, 242);
    
    UIView *container = [[UIView alloc]initWithFrame:CGRectMake(10, self.headerView.bottom + 20, self.view.width - 20, 100)];
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
    
    getVerifyCodeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    getVerifyCodeBtn.frame = CGRectMake(0, 0, 80, 30);
    getVerifyCodeBtn.backgroundColor = rgbaColor(49, 150, 227, 1);
    [getVerifyCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [getVerifyCodeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    getVerifyCodeBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    getVerifyCodeBtn.layer.cornerRadius = 3;
    getVerifyCodeBtn.layer.masksToBounds = YES;
    
    self.verifyCode				= [UITextField textFieldWithFrame:CGRectMake(10, 50+10, container.width - 10*2, 30) font:0 label:@"验证码:    " labelTextColor:[UIColor blackColor]];
    
    self.verifyCode = [UITextField textFieldWithFrame:CGRectMake(10, 50+10, container.width - 10*2, 30) font:0 label:@"验证码:    " rightView:getVerifyCodeBtn];
    _verifyCode.y					= _phoneNum.bottom + 24;
    _verifyCode.maxLength			= 20;
    _verifyCode.secureTextEntry	= YES;
    _verifyCode.textColor         = [UIColor blackColor];
    
    [container addSubviews:_phoneNum, seperateLine, _verifyCode, nil];
    
    self.btnRegister = [UIButton btnDefaultFrame:CGRectMake(25, container.bottom + 50, mScreenWidth - 25*2, 45) title:@"注册" font:4];
    [_btnRegister setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.btnRegister.backgroundColor = rgbaColor(49, 150, 227, 1);
    _btnRegister.layer.cornerRadius		= 10.f;
    
    [self.view addSubview:_btnRegister];
    
    addBtnAction(getVerifyCodeBtn, @selector(onBtnAction:));
    addBtnAction(_btnRegister, @selector(onBtnAction:));
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onBtnAction:(UIButton *)sender
{
    __block NSString	*phoneNum	= self.phoneNum.text;
    __block NSString	*verifyCode	= self.verifyCode.text;
    
    if (sender == _btnRegister) {
//        if ([NSString isStringEmptyOrBlank:phoneNum]) {
//            showTip(@"请输入手机号");
//            return;
//        }
//
//        
//        if ([NSString isStringEmptyOrBlank:verifyCode]) {
//            showTip(@"请输入验证码");
//            return;
//        }
        
//        showViewHUD;
//        weakObj(self);
//        
//        [self startRequestWithDict:checkRegCode(phoneNum,verifyCode) completeBlock:^(ASIHTTPRequest *request, NSDictionary *dict, NSError *error) {
//            
//            hideViewHUD;
//            
//            if (error) {
//                showError(error);
//            }
//            else
//            {
//                NSLog(@"dict: %@", dict);
//                NSString *msg = [dict objectForKey:@"msg"];
//                showTip(msg);
//                
//                PasswordViewController *vc = [[PasswordViewController alloc] init];
//                [bself.navigationController pushViewController:vc animated:YES];
//            }
//            
//        } url:kRequestUrl(@"user", @"checkRegCode")];
        
        PasswordViewController *vc = [[PasswordViewController alloc] init];
        vc.phoneNum = phoneNum;
        [self.navigationController pushViewController:vc animated:YES];
        
    } else if (sender == getVerifyCodeBtn)
    {
        if ([NSString isStringEmptyOrBlank:phoneNum]) {
            showTip(@"请输入手机号");
            return;
        }
        
        showViewHUD;
        
        [self startRequestWithDict:sendRegCode(phoneNum) completeBlock:^(ASIHTTPRequest *request, NSDictionary *dict, NSError *error) {
            
            hideViewHUD;
            
            if (error) {
                showError(error);
            }
            else
            {
                NSLog(@"dict: %@", dict);
                NSString *msg = [dict objectForKey:@"msg"];
                showTip(msg);
            }
            
        } url:kRequestUrl(@"user", @"checkRegCode")];
    }
}


@end
