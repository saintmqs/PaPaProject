//
//  ClockDetailSettingViewController.m
//  EtuProject
//
//  Created by 王家兴 on 15/11/5.
//  Copyright © 2015年 王家兴. All rights reserved.
//

#import "ClockDetailSettingViewController.h"

@interface ClockDetailSettingViewController ()

@end

@implementation ClockDetailSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.titleLabel.text = @"闹钟设置";
    self.titleLabel.textColor = [UIColor grayColor];
    self.headerView.backgroundColor = rgbColor(242, 242, 242);
    
    [self resetNavButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)resetNavButton
{
    [self.leftNavButton setImage:nil forState:UIControlStateNormal];
    [self.leftNavButton setImage:nil forState:UIControlStateHighlighted];
    [self.leftNavButton setTitle:@"取消" forState:UIControlStateNormal];
    [self.leftNavButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    self.leftNavButton.titleLabel.font = [UIFont systemFontOfSize:14];
    
    self.rightNavButton.hidden = NO;
    [self.rightNavButton setImage:nil forState:UIControlStateNormal];
    [self.rightNavButton setImage:nil forState:UIControlStateHighlighted];
    [self.rightNavButton setTitle:@"确定" forState:UIControlStateNormal];
    [self.rightNavButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    self.rightNavButton.titleLabel.font = [UIFont systemFontOfSize:14];
}

@end
