//
//  EditNickNameViewController.m
//  EtuProject
//
//  Created by 王家兴 on 16/1/5.
//  Copyright © 2016年 王家兴. All rights reserved.
//

#import "EditNickNameViewController.h"

@interface EditNickNameViewController ()
{
    UIScrollView *contentScrollView;
}
@end

@implementation EditNickNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.titleLabel.text = @"修改昵称";
    self.titleLabel.textColor = [UIColor grayColor];
    self.headerView.backgroundColor = rgbColor(242, 242, 242);
    
    [self.leftNavButton setImage:[UIImage imageNamed:@"topIcoLeft"] forState:UIControlStateNormal];
    [self.leftNavButton setImage:[UIImage imageNamed:@"topIcoLeftWrite"] forState:UIControlStateHighlighted];
    
    contentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.headerView.frameBottom, mScreenWidth, mScreenHeight - self.headerView.frameBottom)];
    [self.view addSubview:contentScrollView];
    
    UIView *container = [[UIView alloc]initWithFrame:CGRectMake(0, 40, self.view.width, 60)];
    container.backgroundColor = [UIColor whiteColor];
    container.layer.borderWidth = 0.5;
    container.layer.borderColor = rgbaColor(238, 238, 238, 1).CGColor;
    [self.view addSubview:container];
    
    self.nickname			= [UITextField textFieldWithFrame:CGRectMake(10, 0, container.width - 10*2, 60) font:0 label:nil labelTextColor:[UIColor blackColor]];
    _nickname.maxLength		= 30;
    _nickname.textColor     = [UIColor blackColor];
    _nickname.text          = APP_DELEGATE.userData.baseInfo.nickname;
    [container addSubview:_nickname];
    
    UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, container.frameBottom + 5, mScreenWidth - 20, 20)];
    tipLabel.textColor = [UIColor lightGrayColor];
    tipLabel.font = [UIFont systemFontOfSize:13];
    tipLabel.text = @"4-30个字符，可使用英文、数字、下划线";
    
    self.btnFinish = [UIButton btnDefaultFrame:CGRectMake(0, container.frameBottom + 80, mScreenWidth, 50) title:@"保存" font:4];
    [_btnFinish setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.btnFinish.backgroundColor = [UIColor whiteColor];
    addBtnAction(_btnFinish, @selector(saveNickName));
    
    [contentScrollView addSubviews:container, tipLabel, _btnFinish, nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Button Action
-(void)saveNickName
{
    //验证昵称
    if ([NSString isStringEmptyOrBlank:self.nickname.text]) {
        showTip(@"请输入昵称");
        return;
    }
    
    [self uploadNickNameRequest];
}

#pragma mark - Http Request
-(void)uploadNickNameRequest
{
    showViewHUD;
    
    [self startRequestWithDict:updateNickname([APP_DELEGATE.userData.uid integerValue], self.nickname.text) completeBlock:^(ASIHTTPRequest *request, NSDictionary *dict, NSError *error) {
        
        hideViewHUD;
        
        if (!error) {
            showTip([dict objectForKey:@"msg"]);
            
            double delayInSeconds = 1.0;
            __block EditNickNameViewController* bself = self;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                
                APP_DELEGATE.userData.baseInfo.nickname = self.nickname.text;
                [bself.navigationController popViewControllerAnimated:YES];
            });
        }
        else
        {
            if (error == nil || [error.userInfo objectForKey:@"msg"] == nil)
            {
                showTip(@"网络连接失败");
            }
            else
            {
                showTip([error.userInfo objectForKey:@"msg"]);
            }
        }
        
    } url:kRequestUrl(@"user", @"updateNickname")];
}
@end
