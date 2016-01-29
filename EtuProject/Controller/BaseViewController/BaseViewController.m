//
//  BaseViewController.m
//  EtuProject
//
//  Created by 王家兴 on 15/11/3.
//  Copyright (c) 2015年 王家兴. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()<PaPaBLEManagerDelegate>

@end

@implementation BaseViewController

- (id)init
{
    self = [super init];
    
    if (self) {
        [self registerRequestManagerObserver];
        [SystemStateManager shareInstance].activeController = self;
    }
    
    return self;
}

- (void)dealloc
{
    [self unregisterRequestManagerObserver];
    [SystemStateManager shareInstance].activeController = nil;
    removeSelfNofificationObservers;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[PaPaBLEManager shareInstance] setDelegate:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = rgbColor(249, 249, 250);
    
    [[PaPaBLEManager shareInstance] setDelegate:self];
    
    if (iOS7) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    _headerView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, mScreenWidth, mNavBarHeight)];
    _headerView.backgroundColor = [UIColor clearColor];
    _headerView.userInteractionEnabled = YES;
    [self.view addSubview:_headerView];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake((mScreenWidth - 210)/2, 0, 210, 44)];
    _titleLabel.backgroundColor = [UIColor clearColor];
    [_titleLabel setFont:[UIFont boldSystemFontOfSize:18]];//[UIFont fontWithName:@"MicrosoftYaHei" size:18]
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.textColor = [UIColor whiteColor];
    [_headerView addSubview:_titleLabel];
    
    _leftNavButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _leftNavButton.frame = CGRectMake(10, 0, 44, 44);
    _leftNavButton.backgroundColor = [UIColor clearColor];
    [_leftNavButton setImage:[UIImage imageNamed:@"topIcoLeftWrite"] forState:UIControlStateNormal];
    [_leftNavButton setImage:[UIImage imageNamed:@"topIcoLeft"] forState:UIControlStateHighlighted];
    _leftNavButton.contentMode = UIViewContentModeScaleAspectFit;
    [_leftNavButton addTarget:self action:@selector(didTopLeftButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    _rightNavButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _rightNavButton.frame = CGRectMake(mScreenWidth-44 - 10, 0, 44, 44);
    _rightNavButton.backgroundColor = [UIColor clearColor];
    [_rightNavButton setImage:[UIImage imageNamed:@"topIcoRightWrite"] forState:UIControlStateNormal];
    _rightNavButton.contentMode = UIViewContentModeScaleAspectFit;
    [_rightNavButton addTarget:self action:@selector(didTopRightButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    _rightNavButton.exclusiveTouch = YES;
    
    if([[UIDevice currentDevice].systemVersion floatValue] >= 7.0)
    {
        _headerView.frame = CGRectMake(0, 0, mScreenWidth, 64);
        _leftNavButton.frame = CGRectMake(10, 20, 44, 44);
        _rightNavButton.frame = CGRectMake(mScreenWidth-44 - 10, 20, 44, 44);
        _titleLabel.frame = CGRectMake(_titleLabel.x, 20, _titleLabel.width, 44);
    }
    [_headerView addSubview:_leftNavButton];
    [_headerView addSubview:_rightNavButton];
    _rightNavButton.hidden = YES;
    
    if([[self.navigationController viewControllers] count] <= 1)
    {
        _leftNavButton.hidden = YES;
    }
    
    self.view.userInteractionEnabled = YES;
    
    [self exclusiveTouchContols:self.view];
}

- (void)setLeftNavBtnAsMenuBtn
{
    UIButton *btnMenu = [UIButton buttonWithType:UIButtonTypeCustom];
    
    btnMenu.frame = CGRectMake(0, 0, 60, 44);
    [btnMenu setImage:[UIImage imageNamed:@"nav_menu_n"] forState:UIControlStateNormal];
    [btnMenu setImage:[UIImage imageNamed:@"nav_menu_p"] forState:UIControlStateSelected];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnMenu];
    
    [btnMenu setClickBlock:^(UIButton *btn) {
        [[IQKeyboardManager sharedManager] resignFirstResponder];
        // [APP_DELEGATE.drawer toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
    }];
}

- (void)setLeftNavBtnAsCustomBack
{
    if (self.navigationController) {
        UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];
        back.frame = CGRectMake(0, 0, 60, 44);
        [back setImage:[UIImage imageNamed:@"nav_back_n"] forState:UIControlStateNormal];
        [back setImage:[UIImage imageNamed:@"nav_back_p"] forState:UIControlStateSelected];
        
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:back];
        
        __weak typeof(self) bself = self;
        
        [back setClickBlock:^(UIButton *btn) {
            if (bself == bself.navigationController.viewControllers[0]) {
                [bself.navigationController dismissViewControllerAnimated:YES completion:nil];
            } else {
                [bself.navigationController popViewControllerAnimated:YES];
            }
        }];
    }
}

- (void)request:(ASIHTTPRequest *)request failedWithError:(NSError *)error
{
    hideViewHUD;
    showTip(error.domain);
//    DDLogError(@"%s   %@", __func__, error.domain);
}

- (UIBarButtonItem *)setRightNavBtn:(NSString *)title action:(SEL)selector
{
    // UIButton *btn = [self createRightNavBtn:title];
    
    // [btn addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    // UIBarButtonItem *btnItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
    
    // self.navigationItem.rightBarButtonItem = btnItem;
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithTitle:title style:UIBarButtonItemStylePlain target:self action:selector];
    
    self.navigationItem.rightBarButtonItem = item;
    return item;
}

- (UIButton *)createRightNavBtn:(NSString *)title
{
    UIButton	*btn	= [UIButton buttonWithType:UIButtonTypeCustom];
    btn.titleLabel.font = [UIFont systemFontOfSize:FONT_SIZE+2];
    float		w		= MAX(30, [title sizeWithFont:btn.titleLabel.font].width + 10);
    
    btn.frame = CGRectMake(0, 0, w, 44);
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    return btn;
}

- (CGRect)bounds
{
    CGRect frame = self.view.bounds;
    
    if (self.navigationController) {
        frame.size.height -= iOS7 ? 64 : 44;
    }
    
    return frame;
}


-(void)exclusiveTouchContols:(UIView *)view
{
    for (UIView *subView in view.subviews) {
        if ([subView isKindOfClass:[UIButton class]]) {
            subView.exclusiveTouch = YES;
        }
        else
            [self exclusiveTouchContols:subView];
    }
}

-(NSString *)setTime:(double)timeStr withType:(int)type
{
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    switch (type) {
        case 1:
        {
            [formatter setDateFormat:@"yyyy/MM/dd"];
        }
            break;
            
        case 2:
        {
            [formatter setDateFormat:@"yyyy-MM-dd"];
        }
            break;
        case 3:
        {
            [formatter setDateFormat:@"MM-dd"];
        }
            break;
            
        default:
            break;
    }
    
    NSDate *date=[NSDate dateWithTimeIntervalSince1970:timeStr];
    NSString *destDateString = [formatter stringFromDate:date];
    

    return destDateString;
}

- (void)didTopRightButtonClick:(UIButton *)sender
{
    
}

- (void)didTopLeftButtonClick:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)connetedViewRefreshing
{
    
}

-(void)disConnetedViewRefreshing:(NSError *)error
{
    
}


#pragma mark - PaPaBLEManager Delegate 
-(void)PaPaBLEManagerConnected
{
    [self connetedViewRefreshing];
}

-(void)PaPaBLEManagerDisconnected:(NSError *)error
{
    [self disConnetedViewRefreshing:error];
}
@end
