//
//  SleepingRecordViewController.m
//  EtuProject
//
//  Created by 王家兴 on 15/12/1.
//  Copyright © 2015年 王家兴. All rights reserved.
//

#import "SleepingRecordViewController.h"

@interface SleepingRecordViewController ()

@end

@implementation SleepingRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)didTopLeftButtonClick:(UIButton *)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(backToHome)]) {
        [_delegate backToHome];
    }
}
@end
