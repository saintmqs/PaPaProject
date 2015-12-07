//
//  RecordViewController.m
//  EtuProject
//
//  Created by 王家兴 on 15/11/5.
//  Copyright © 2015年 王家兴. All rights reserved.
//

#import "RecordViewController.h"
#import "RDVTabBarItem.h"

@interface RecordViewController ()<RDVTabBarControllerDelegate,UINavigationControllerDelegate>

@end

@implementation RecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.sport.delegate = self;
    self.sleep.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)backToHome
{
    [APP_DELEGATE backToLastPage];
    APP_DELEGATE.rootTabbarController.tabBarHidden = NO;
    [self setTabBarHidden:YES animated:NO];
}

- (void)customizeTabBarForController:(RDVTabBarController *)tabBarController
{
    UIImage *selectedBg = [UIImage imageNamed:@"tabbar_selected_background"];
    UIImage *normalBg	= [UIImage imageNamed:@"tabbar_normal_background"];
    
    int index = 1;
    
    NSArray *titiles = [NSArray arrayWithObjects:@"运动",@"睡眠", nil];
    
    for (RDVTabBarItem *item in [[tabBarController tabBar] items]) {
        item.backgroundColor = rgbColor(242, 242, 242);
        
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

- (void)tabBar:(RDVTabBar *)tabBar didSelectItemAtIndex:(NSInteger)index {
    if (index < 0 || index >= [[self viewControllers] count]) {
        return;
    }
    
    [self setSelectedIndex:index];
    
    [self didSelectViewController:[self viewControllers][index]];
}

- (BOOL)didSelectViewController:(UIViewController *)viewController
{
    NSUInteger index = [self.viewControllers indexOfObject:viewController];
    
    if (index == 0) {
        UINavigationController *nav = (UINavigationController *)self.viewControllers[0];
        
        SportRecordViewController *vc = (SportRecordViewController *)nav.viewControllers[0];
        [vc.chartView  coordinatesCorrection];
    }
    return YES;
}

#pragma mark - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (navigationController.viewControllers.count == 1) {
        [self setTabBarHidden:NO animated:YES];
        [UIView animateWithDuration:.0f animations:^{
            self.tabBar.alpha = 1.0f;
        } completion:^(BOOL finished) {}];
    } else if (navigationController.viewControllers.count == 2) {
        [UIView animateWithDuration:.0f animations:^{
            self.tabBar.alpha = 0.0f;
        } completion:^(BOOL finished) {}];
        [self setTabBarHidden:YES animated:NO];
    }
}

@end