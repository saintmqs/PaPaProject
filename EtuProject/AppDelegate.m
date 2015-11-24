//
//  AppDelegate.m
//  EtuProject
//
//  Created by 王家兴 on 15/11/4.
//  Copyright (c) 2015年 王家兴. All rights reserved.
//

#import "AppDelegate.h"

#import "PckData.h"
#import "RDVTabBarItem.h"

@interface AppDelegate ()<UINavigationControllerDelegate, RDVTabBarControllerDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    // 设置状态栏文字为白色
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    UIImageView *splash = [[UIImageView alloc]initWithImage:[UIImage imageNamed:iPhone5 ? @"Default-568h":@"Default"]];
    [self.window addSubview:splash];
    
    [self systemInit];
    
    [self.window makeKeyAndVisible];
    
    // 新手指引
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    
    if (![[def stringForKey:kUD_INTRO_VERSION] isEqualToString:APP_VERSION]) {
        [self showBasicIntroWithBg];
        [def setObject:APP_VERSION forKey:kUD_INTRO_VERSION];
        [def synchronize];
    }
    
    [application setApplicationIconBadgeNumber:0];
#if SUPPORT_IOS8
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        UIUserNotificationType		myTypes		= UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound;
        UIUserNotificationSettings	*settings	= [UIUserNotificationSettings settingsForTypes:myTypes categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    } else
#endif
    {
        UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound;
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:myTypes];
    }
    
    return YES;
}

- (void)systemInit
{
    if (!APP_DELEGATE.userData) {
        LoginViewController *login = [[LoginViewController alloc] init];
        
        UINavigationController	*tab = [[UINavigationController alloc]initWithRootViewController:login];
        [tab setNavigationBarHidden:YES];
        
        self.window.rootViewController = tab;
    }
    else
    {
        [self setupViewControllers];
        self.window.rootViewController = _rootTabbarController;
    }
}

- (void)showBasicIntroWithBg
{
    EAIntroPage *page1 = [EAIntroPage page];
    
    
    page1.bgImage = [UIImage imageNamed:@"intro_1"];
    
    EAIntroPage *page2 = [EAIntroPage page];
    
    page2.bgImage = [UIImage imageNamed:@"intro_2"];
    
    EAIntroPage *page3 = [EAIntroPage page];
    
    page3.bgImage = [UIImage imageNamed:@"intro_3"];
    
    EAIntroView *intro = [[EAIntroView alloc] initWithFrame:self.window.bounds andPages:@[page1, page2, page3]];
    
    [intro showInView:self.window animateDuration:0.0];
}

- (void)initFailed
{
    [UIAlertView showAlertViewWithTitle:@"提示" message:@"初始化失败,请稍后重试！" block:^(UIAlertView *alertView, NSInteger buttonIndex) {
        if (buttonIndex == 1) {
            //            [self startRequestWithDict:init() tag:RInit];
        } else {
            exit(0);
        }
    } cancelButtonTitle:@"取消" otherButtonTitles:@"重试", nil];
}

- (void)loginSuccess
{
    [self setupViewControllers];
    self.window.rootViewController = _rootTabbarController;
    
    [APP_DELEGATE.rootTabbarController setSelectedIndex:1];
    // 新手指引
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    
    if (![[def stringForKey:kUD_INTRO_VERSION] isEqualToString:APP_VERSION]) {
        [_rootTabbarController showBasicIntroWithBg];
        [def setObject:APP_VERSION forKey:kUD_INTRO_VERSION];
        [def synchronize];
    }
    //
    //    NSString	*phoneNum	= [def stringForKey:kUD_LOGIN_PHONENUM];
    //    NSString	*pwd		= [def stringForKey:kUD_LOGIN_PASSWORD];
    //
    //    if (![NSString isStringEmpty:phoneNum] && ![NSString isStringEmpty:pwd]) {
    //         [self doLoginWithPhonenum:phoneNum pwd:pwd block:nil];
    //    }
}

-(void)haveAlook
{
    [self setupViewControllers];
    
    self.window.rootViewController = _rootTabbarController;
    // 新手指引
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    
    if (![[def stringForKey:kUD_INTRO_VERSION] isEqualToString:APP_VERSION]) {
        [_rootTabbarController showBasicIntroWithBg];
        [def setObject:APP_VERSION forKey:kUD_INTRO_VERSION];
        [def synchronize];
    }
}

- (void)doLoginWithUsername:(NSString *)username pwd:(NSString *)pwd block:(void (^)(BOOL success, NSError *error))block
{
    __block NSString	*uname	= username;
    __block NSString	*password	= pwd;
    
    [self startRequestWithDict:login(uname, pwd) completeBlock:^(ASIHTTPRequest *request, NSDictionary *dict, NSError *error) {
        if (!error) {
            Login *login = [[Login alloc]initWithDictionary:[dict objectForKey:@"data"] error:nil];
            
            if (login) {
                APP_DELEGATE.userData = login;
                
                NSUserDefaults *udf = [NSUserDefaults standardUserDefaults];
                [udf setValue:username forKey:kUD_LOGIN_PHONENUM];
                [udf setValue:password forKey:kUD_LOGIN_PASSWORD];
                [udf synchronize];
                
                if (block) {
                    block(YES, nil);
                }
                
                return;
            }
        }
        
        if (block) {
            block(NO, error);
        }
    } url:kRequestUrl(@"user", @"login")];
}

- (BOOL)checkNeedLogin
{
    if (!self.userData) {
        
        LoginViewController *login = [[LoginViewController alloc]init];
        
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:login];
        [nav setNavigationBarHidden:YES];
        
        [((UINavigationController *)self.rootTabbarController.selectedViewController) presentViewController:nav animated:YES completion:nil];
        //        [((UINavigationController *)self.rootTabbarController.selectedViewController) pushViewController:[[LoginViewController alloc]init] animated:YES];
        return YES;
    }
    
    return NO;
}

- (void)logOut
{
    self.userData = nil;
    [self setupViewControllers];
    self.window.rootViewController = self.rootTabbarController;
    [self checkNeedLogin];
}


#pragma mark - ViewController setup
- (void)setupViewControllers
{
    _isRootViewLaunched = YES;
    
    self.home		= [[HomeViewController alloc] init];
    self.record     = [[RecordViewController alloc] init];
    self.wallet     = [[WalletViewController alloc] init];
    self.rootTabbarController		= [[RDVTabBarController alloc]init];
    _rootTabbarController.delegate	= self;
    UINavigationController	*tab1	= [[UINavigationController alloc]initWithRootViewController:_record];
    [tab1 setNavigationBarHidden:YES];
    
    UINavigationController	*tab2	= [[UINavigationController alloc]initWithRootViewController:_home];
    [tab2 setNavigationBarHidden:YES];
    
    UINavigationController	*tab3	= [[UINavigationController alloc]initWithRootViewController:_wallet];
    [tab3 setNavigationBarHidden:YES];
    
    tab1.delegate	= self;
    tab2.delegate	= self;
    tab3.delegate	= self;
    
    // 禁用手势滑动返回 （跟tabbar冲突）
    if ([tab1 respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        tab1.interactivePopGestureRecognizer.enabled	= NO;
        tab2.interactivePopGestureRecognizer.enabled	= NO;
        tab3.interactivePopGestureRecognizer.enabled	= NO;
    }
    
    _rootTabbarController.viewControllers = @[tab1, tab2, tab3];
    [self customizeTabBarForController:self.rootTabbarController];
    
    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"lastIndex"];
}

- (void)customizeTabBarForController:(RDVTabBarController *)tabBarController
{
    UIImage *selectedBg = [UIImage imageNamed:@"tabbar_selected_background"];
    UIImage *normalBg	= [UIImage imageNamed:@"tabbar_normal_background"];
    
    int index = 1;
    
    NSArray *titiles = [NSArray arrayWithObjects:@"运动",@"首页",@"钱包", nil];
    
    for (RDVTabBarItem *item in [[tabBarController tabBar] items]) {
        item.backgroundColor = rgbColor(225, 225, 225);
        
        [item setBackgroundSelectedImage:selectedBg withUnselectedImage:normalBg];
        UIImage *selectedimage		= [UIImage imageNamed:[NSString stringWithFormat:@"%d_selected", index]];
        UIImage *unselectedimage	= [UIImage imageNamed:[NSString stringWithFormat:@"%d_normal", index]];
        item.title = titiles[index-1];
        [item setFinishedSelectedImage:selectedimage withFinishedUnselectedImage:unselectedimage];
        [item setBadgeBackgroundColor:color_orange];
        
        item.selectedTitleAttributes	= @{NSForegroundColorAttributeName : color_orange, NSFontAttributeName:[UIFont systemFontOfSize:FONT_SIZE - 2]};
        item.unselectedTitleAttributes	= @{NSForegroundColorAttributeName : color_black, NSFontAttributeName:[UIFont systemFontOfSize:FONT_SIZE - 2]};
        
        index++;
    }
}

- (void)customizeInterface
{
    UINavigationBar *navigationBarAppearance = [UINavigationBar appearance];
    
    if ([[[UIDevice currentDevice] systemVersion] integerValue] >= 7.0) {
        [navigationBarAppearance setBackgroundImage:[UIImage imageNamed:@"navigationbar_background_tall"]
                                      forBarMetrics:UIBarMetricsDefault];
    } else {
        [navigationBarAppearance setBackgroundImage:[UIImage imageNamed:@"navigationbar_background"]
                                      forBarMetrics:UIBarMetricsDefault];
    }
    
    NSDictionary *textAttributes = nil;
    
    if ([[[UIDevice currentDevice] systemVersion] integerValue] >= 7.0) {
        [navigationBarAppearance setTintColor:[UIColor whiteColor]];
        textAttributes = @{
                           NSFontAttributeName: [UIFont boldSystemFontOfSize:20],
                           NSForegroundColorAttributeName: [UIColor whiteColor],
                           };
    } else {
#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_7_0
        textAttributes = @{
                           UITextAttributeFont: [UIFont boldSystemFontOfSize:20],
                           UITextAttributeTextColor: [UIColor whiteColor],
                           UITextAttributeTextShadowColor: [UIColor clearColor],
                           UITextAttributeTextShadowOffset: [NSValue valueWithUIOffset:UIOffsetZero],
                           };
#endif
    }
    
    [navigationBarAppearance setTitleTextAttributes:textAttributes];
}

#pragma mark - RDVTabBarControllerDelegate

- (BOOL)tabBarController:(RDVTabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    NSUInteger index = [tabBarController.viewControllers indexOfObject:viewController];
    
//    if (index == 1 || index == 2 || index == 4) {
//        if ([self checkNeedLogin]) {
//            return NO;
//        }
//    }
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%ld",index] forKey:@"lastIndex"];
    
    return YES;
}

-(void)backToLastPage
{
    NSString *lastIndex = [[NSUserDefaults standardUserDefaults] objectForKey:@"lastIndex"];
    [APP_DELEGATE.rootTabbarController setSelectedIndex:[lastIndex integerValue]];
}


#pragma mark - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (navigationController.viewControllers.count == 1) {
        [APP_DELEGATE.rootTabbarController setTabBarHidden:NO animated:NO];
        [UIView animateWithDuration:.0f animations:^{
            APP_DELEGATE.rootTabbarController.tabBar.alpha = 1.0f;
        } completion:^(BOOL finished) {}];
    } else if (navigationController.viewControllers.count == 2) {
        [UIView animateWithDuration:.0f animations:^{
            APP_DELEGATE.rootTabbarController.tabBar.alpha = .0f;
        } completion:^(BOOL finished) {}];
        [APP_DELEGATE.rootTabbarController setTabBarHidden:YES animated:NO];
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end