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
                
                //改变验证码按钮状态
                [self verificationCode:^{
                    getVerifyCodeBtn.backgroundColor = rgbaColor(49, 150, 227, 1);
                    [getVerifyCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
                    [getVerifyCodeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    getVerifyCodeBtn.userInteractionEnabled = YES;

                } blockNo:^(id time) {
                    NSString *sec = [NSString stringWithFormat:@"重新发送(%@)",time];
                    [getVerifyCodeBtn setTitle:sec forState:UIControlStateNormal];
                    getVerifyCodeBtn.backgroundColor = [UIColor lightGrayColor];
                    [getVerifyCodeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    getVerifyCodeBtn.userInteractionEnabled = NO;
                }];
            }
            
        } url:kRequestUrl(@"user", @"sendRegCode")];
    }
}

//验证码block
- (void)verificationCode:(void(^)())blockYes blockNo:(void(^)(id time))blockNo {
    __block int timeout=30; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                blockYes();
            });
        }else{
            //            int minutes = timeout / 60;
            int seconds = timeout % 60;
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                NSLog(@"verificationCode____%@",strTime);
                blockNo(strTime);
                
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}
@end
