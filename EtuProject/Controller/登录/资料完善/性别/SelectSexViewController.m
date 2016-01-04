//
//  SelectSexViewController.m
//  EtuProject
//
//  Created by 王家兴 on 15/11/7.
//  Copyright © 2015年 王家兴. All rights reserved.
//

#import "SelectSexViewController.h"
#import "SelectHeightViewController.h"

#define maleNormalColor   rgbaColor(0, 139, 207, 1)
#define maleSelectedColor rgbaColor(0, 156, 233, 1)
#define maleBorderColor   rgbaColor(0, 133, 202, 1)

#define femaleNormalColor   rgbaColor(255, 118, 40, 1)
#define femaleSelectedColor  rgbaColor(255, 137, 73, 1)
#define femaleBorderColor  rgbaColor(250, 111, 26, 1)

#define maleColor   rgbaColor(0, 139, 207, 1)
#define femaleColor rgbaColor(255, 118, 40, 1)

@interface SelectSexViewController ()
{
    UIButton *maleButton;
    UIButton *femaleButton;
    
    NSString *selectedSex;
}
@end

@implementation SelectSexViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.titleLabel.text = @"您的性别";
    self.view.backgroundColor = maleColor;
    
    
    if (self.isFromUserInfoSet) {
        self.leftNavButton.hidden = NO;
        [self.rightNavButton setTitle:@"确认" forState:UIControlStateNormal];
        self.rightNavButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [self.rightNavButton setImage:nil forState:UIControlStateNormal];
    }
    else
    {
        self.leftNavButton.hidden = YES;
        [self.rightNavButton setTitle:nil forState:UIControlStateNormal];
        [self.rightNavButton setImage:[UIImage imageNamed:@"topIcoRightWrite"] forState:UIControlStateNormal];
    }
    self.rightNavButton.hidden = NO;
    
    UIScrollView *container = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.headerView.bottom, mScreenWidth, mScreenHeight - self.headerView.bottom)];
    container.showsVerticalScrollIndicator = NO;
    [self.view addSubview:container];
    
    maleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    CGFloat maleBtnFrameY = (mScreenHeight - self.headerView.bottom - 160*2)/3;
    maleButton.frame = CGRectMake((mScreenWidth - 160)/2, maleBtnFrameY, 160, 160);
    maleButton.layer.cornerRadius = 80;
    maleButton.layer.masksToBounds = YES;
    maleButton.layer.borderWidth = 1;
    [maleButton setImage:[UIImage imageNamed:@"icoSex1"] forState:UIControlStateNormal];
    [maleButton setImage:[UIImage imageNamed:@"icoSex1_Hover"] forState:UIControlStateHighlighted];
    [maleButton setImage:[UIImage imageNamed:@"icoSex1_Hover"] forState:UIControlStateSelected];
    [maleButton addTarget:self action:@selector(onHoldAction:) forControlEvents:UIControlEventTouchDown];
    
    femaleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    femaleButton.frame = CGRectMake((mScreenWidth - 160)/2, maleButton.bottom + maleBtnFrameY, 160, 160);
    
    femaleButton.layer.cornerRadius = 80;
    femaleButton.layer.masksToBounds = YES;
    femaleButton.layer.borderWidth = 1;
    femaleButton.layer.borderColor = femaleBorderColor.CGColor;
    [femaleButton setImage:[UIImage imageNamed:@"icoSex2"] forState:UIControlStateNormal];
    [femaleButton setImage:[UIImage imageNamed:@"icoSex2_Hover"] forState:UIControlStateHighlighted];
    [femaleButton setImage:[UIImage imageNamed:@"icoSex2_Hover"] forState:UIControlStateSelected];
    [femaleButton addTarget:self action:@selector(onHoldAction:) forControlEvents:UIControlEventTouchDown];
    [container addSubviews:maleButton, femaleButton, nil];
    
    if (self.isFromUserInfoSet) {
        maleButton.selected = [APP_DELEGATE.userData.baseInfo.sex isEqualToString:@"1"];
        femaleButton.selected = !maleButton.selected;
    }
    else
    {
        maleButton.selected = YES; //默认男性选择
        femaleButton.selected = NO;
        
        [UserDataManager shareInstance].registModel.sex = @"1"; //默认男
    }
    
    if (maleButton.selected) {
        maleButton.backgroundColor = maleSelectedColor;
        maleButton.layer.borderColor = maleBorderColor.CGColor;
        
        femaleButton.backgroundColor = maleNormalColor;
        femaleButton.layer.borderColor = maleBorderColor.CGColor;
        
        [self maleButtonStateTouchDown];
    }
    else
    {
        maleButton.backgroundColor = femaleNormalColor;
        maleButton.layer.borderColor = femaleBorderColor.CGColor;
        
        femaleButton.backgroundColor = femaleSelectedColor;
        femaleButton.layer.borderColor = femaleBorderColor.CGColor;
        
        [self femaleButtonStateTouchDown];
    }
    
    addBtnAction(maleButton, @selector(onBtnAction:));
    addBtnAction(femaleButton, @selector(onBtnAction:));
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TopRightButton 点击事件
-(void)didTopRightButtonClick:(UIButton *)sender
{
    if (self.isFromUserInfoSet) {
        [self updateSexRequest];
    }
    else
    {
        SelectHeightViewController *vc = [[SelectHeightViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

#pragma mark - 按钮点击事件
- (void)onBtnAction:(UIButton *)sender
{
    if (sender == maleButton) {
        maleButton.selected = YES;
        femaleButton.selected = NO;
        
        if (self.isFromUserInfoSet) {
            selectedSex = @"1";
        }
        else
        {
            [UserDataManager shareInstance].registModel.sex = @"1";
        }
    }
    else if (sender == femaleButton)
    {
        maleButton.selected = NO;
        femaleButton.selected = YES;
        
        if (self.isFromUserInfoSet) {
            selectedSex = @"2";
        }
        else
        {
            [UserDataManager shareInstance].registModel.sex = @"2";
        }
    }
}

#pragma mark - 点击按钮实现颜色转变
-(void)onHoldAction:(UIButton *)sender
{
    if (sender == maleButton) {
        [UIView animateWithDuration:0.5f animations:^{
           
            [self maleButtonStateTouchDown];
        }];
        
        CABasicAnimation *maleAnimation = [CABasicAnimation animation];
        maleAnimation.keyPath = @"borderColor";
        maleAnimation.duration = 0.5;
        maleAnimation.fromValue = (id)maleButton.layer.borderColor;
        maleButton.layer.borderColor = maleBorderColor.CGColor;
        maleAnimation.toValue = (id)maleBorderColor.CGColor;
        [maleButton.layer addAnimation:maleAnimation forKey:nil];
        
        CABasicAnimation *femaleAnimation = [CABasicAnimation animation];
        femaleAnimation.keyPath = @"borderColor";
        femaleAnimation.duration = 0.5;
        femaleAnimation.fromValue = (id)femaleButton.layer.borderColor;
        femaleButton.layer.borderColor = maleBorderColor.CGColor;
        femaleAnimation.toValue = (id)maleBorderColor.CGColor;
        [femaleButton.layer addAnimation:femaleAnimation forKey:nil];
        
    }
    else if (sender == femaleButton)
    {
        [UIView animateWithDuration:0.5f animations:^{
            [self femaleButtonStateTouchDown];
        }];
        
        CABasicAnimation *maleAnimation = [CABasicAnimation animation];
        maleAnimation.keyPath = @"borderColor";
        maleAnimation.duration = 0.5;
        maleAnimation.fromValue = (id)maleButton.layer.borderColor;
        maleButton.layer.borderColor = femaleBorderColor.CGColor;
        maleAnimation.toValue = (id)femaleBorderColor.CGColor;
        [maleButton.layer addAnimation:maleAnimation forKey:nil];
        
        CABasicAnimation *femaleAnimation = [CABasicAnimation animation];
        femaleAnimation.keyPath = @"borderColor";
        femaleAnimation.duration = 0.5;
        femaleAnimation.fromValue = (id)femaleButton.layer.borderColor;
        femaleButton.layer.borderColor = femaleBorderColor.CGColor;
        femaleAnimation.toValue = (id)femaleBorderColor.CGColor;
        [femaleButton.layer addAnimation:femaleAnimation forKey:nil];
    }
}

-(void)maleButtonStateTouchDown
{
    self.view.backgroundColor = maleColor;
    
    maleButton.backgroundColor = maleSelectedColor;
    
    femaleButton.backgroundColor = maleNormalColor;
}

-(void)femaleButtonStateTouchDown
{
    self.view.backgroundColor = femaleColor;
    
    maleButton.backgroundColor = femaleNormalColor;
    
    femaleButton.backgroundColor = femaleSelectedColor;
}

#pragma mark - Http Request
-(void)updateSexRequest
{
    showViewHUD;
    
    [self startRequestWithDict:updateSex([APP_DELEGATE.userData.uid integerValue], [selectedSex integerValue]) completeBlock:^(ASIHTTPRequest *request, NSDictionary *dict, NSError *error) {
        
        hideViewHUD;
        
        if (!error) {
            showTip([dict objectForKey:@"msg"]);
            
            double delayInSeconds = 1.0;
            __block SelectSexViewController* bself = self;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                
                APP_DELEGATE.userData.baseInfo.sex = selectedSex;
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
    } url:kRequestUrl(@"user", @"updateSex")];
}
@end
