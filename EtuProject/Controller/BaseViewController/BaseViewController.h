//
//  BaseViewController.h
//  EtuProject
//
//  Created by 王家兴 on 15/11/3.
//  Copyright (c) 2015年 王家兴. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController

@property (nonatomic, strong) UIView *headerView;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) NSString *headerTitle;

@property (nonatomic, strong) UIButton *leftNavButton;

@property (nonatomic, strong) UIButton *rightNavButton;

- (void)setLeftNavBtnAsMenuBtn;
- (void)setLeftNavBtnAsCustomBack;
- (UIButton *)createRightNavBtn:(NSString *)title;
- (UIBarButtonItem *)setRightNavBtn:(NSString *)title action:(SEL)selector;

- (CGRect)bounds;
-(NSString *)setTime:(double)timeStr withType:(int)type;
- (void)didTopRightButtonClick:(UIButton *)sender;

- (void)didTopLeftButtonClick:(UIButton *)sender;

-(void)connetedViewRefreshing;
-(void)disConnetedViewRefreshing:(NSError *)error;
@end
