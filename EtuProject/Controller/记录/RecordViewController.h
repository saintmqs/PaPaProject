//
//  RecordViewController.h
//  EtuProject
//
//  Created by 王家兴 on 15/11/5.
//  Copyright © 2015年 王家兴. All rights reserved.
//

#import "BaseViewController.h"
#import "SleepingRecordViewController.h"
#import "SportRecordViewController.h"
#import "RecordViewControllerDelegate.h"

@interface RecordViewController : RDVTabBarController<RecordViewControllerDelegate>

@property (nonatomic,strong) SleepingRecordViewController *sleep;
@property (nonatomic,strong) SportRecordViewController *sport;

@property (nonatomic,assign) BOOL isRootViewLaunched;

- (void)customizeTabBarForController:(RDVTabBarController *)tabBarController;

@end