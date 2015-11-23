//
//  AppDelegate.h
//  EtuProject
//
//  Created by 王家兴 on 15/11/4.
//  Copyright (c) 2015年 王家兴. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RDVTabBarController.h>
#import <EAIntroView.h>

#import "HomeViewController.h"
#import "RecordViewController.h"
#import "WalletViewController.h"

#import "LoginViewController.h"
#import "Login.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic,strong) RDVTabBarController *rootTabbarController; //根tabbar

@property (nonatomic,strong) HomeViewController *home;      //首页
@property (nonatomic,strong) RecordViewController *record;  //记录
@property (nonatomic,strong) WalletViewController *wallet;  //钱包

@property (nonatomic,strong) Login *userData;
@property (nonatomic, assign) BOOL isRootViewLaunched;

- (void)doLoginWithUsername:(NSString *)username pwd:(NSString *)pwd block:(void (^)(BOOL success, NSError *error))block;

- (BOOL)checkNeedLogin;
- (void)logOut;
- (void)loginSuccess;

@end

@interface RDVTabBarController (extend)<EAIntroDelegate>
- (void)showBasicIntroWithBg;
@end