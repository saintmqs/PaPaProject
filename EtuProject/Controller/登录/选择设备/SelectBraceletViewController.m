//
//  SelectBraceletViewController.m
//  EtuProject
//
//  Created by 王家兴 on 16/1/3.
//  Copyright © 2016年 王家兴. All rights reserved.
//

#import "SelectBraceletViewController.h"

@interface SelectBraceletViewController()
{
    UITableView *searchResultTable;
    
    UIButton *cancelButton;
}
@end

@implementation SelectBraceletViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = rgbaColor(51, 46, 53, 1);
    self.headerView.hidden = NO;
    
    self.titleLabel.text = @"选择设备";
    
    [self setupSearchResultTableView];
    
    cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.frame = CGRectMake((mScreenWidth - 110)/2, self.view.frameBottom - 60, 110, 30);
    [cancelButton setTitle:@"暂时不绑定 >" forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    cancelButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:cancelButton];
    
//    [self setupGradientView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setupSearchResultTableView
{
    
}
@end
