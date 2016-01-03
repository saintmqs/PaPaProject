//
//  TrafficAccountViewController.m
//  EtuProject
//
//  Created by 王家兴 on 15/12/22.
//  Copyright © 2015年 王家兴. All rights reserved.
//

#import "TrafficAccountViewController.h"

@implementation TrafficAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.leftNavButton.hidden = NO;
    
    self.titleLabel.text = @"公交卡账户";
    
    self.headerView.backgroundColor = rgbaColor(255, 118, 40, 1);
    
    [self configTopView];
    
    [self configListTable];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)didTopLeftButtonClick:(UIButton *)sender
{
    [APP_DELEGATE backToLastPage];
    APP_DELEGATE.rootTabbarController.tabBarHidden = NO;
}

-(void)configTopView
{
    
}

-(void)configListTable
{
    
}
@end
