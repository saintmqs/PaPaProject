//
//  SearchBraceletViewController.m
//  EtuProject
//
//  Created by 王家兴 on 15/11/22.
//  Copyright © 2015年 王家兴. All rights reserved.
//

#import "SearchBraceletViewController.h"

@interface SearchBraceletViewController ()<CBCentralManagerDelegate>
{
    UIView  *searchView;
    UILabel *titleLabel;
    UILabel *descriptionLabel;
    
    UIButton *cancelButton;
    
    CBCentralManager *manager;
    
    UITableView *searchResultTable;
}
@end

@implementation SearchBraceletViewController

- (id)init
{
    self = [super init];
    if (self) {
        manager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = rgbaColor(51, 46, 53, 1);
    self.headerView.hidden = YES;
    
    self.titleLabel.text = @"选择设备";
    
    [self setupSearchView];
    
    cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.frame = CGRectMake((mScreenWidth - 110)/2, self.view.frameBottom - 60, 110, 30);
    [cancelButton setTitle:@"暂时不绑定 >" forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    cancelButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:cancelButton];
    
    [self setupGradientView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupSearchView
{
    searchView = [[UIView alloc] initWithFrame:CGRectMake(0, 40, mScreenWidth, mScreenHeight - 40 - 60)];
    searchView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:searchView];
    
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake((mScreenWidth-160)/2, 0, 160, 50)];
    titleLabel.font = [UIFont boldSystemFontOfSize:25];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"搜索手环";
    [searchView addSubview:titleLabel];
    
    descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake((mScreenWidth - 280)/2, titleLabel.frameBottom + 10, 280, 35)];
    descriptionLabel.font = [UIFont systemFontOfSize:16];
    descriptionLabel.textColor = [UIColor whiteColor];
    descriptionLabel.textAlignment = NSTextAlignmentCenter;
    descriptionLabel.text = @"打开手机蓝牙，靠近手环~";
    [searchView addSubview:descriptionLabel];
    
    _loadingView =  [[PPLoadingView alloc] initWithFrame:CGRectMake((mScreenWidth - 180)/2, 200, 180, 180)];
    [_loadingView startAnimation];
    [searchView addSubview:_loadingView];
}

- (void)setupGradientView
{
    _gradientView = [[PPGradientView alloc] initWithFrame:self.bounds];
//    _gradientView.locations = @[ @0.0f, @0.5f, @0.5f, @1.f];
//    _gradientView.CGColors = @[ (id)[UIColor blackColor].CGColor,
//                                (id)[[UIColor blackColor] colorWithAlphaComponent:0.0f].CGColor,
//                                (id)[[UIColor blackColor] colorWithAlphaComponent:0.0f].CGColor,
//                                (id)[UIColor blackColor].CGColor ];
    [self.view addSubview:_gradientView];
}

#pragma - 侦测蓝牙开关
- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    NSString *message;
    switch (central.state) {
        case CBCentralManagerStateUnsupported:
            message = @"The platform/hardware doesn't support Bluetooth Low Energy.";
            break;
        case CBCentralManagerStateUnauthorized:
            message = @"The app is not authorized to use Bluetooth Low Energy.";
            break;
        case CBCentralManagerStatePoweredOff:
            message = @"Bluetooth is currently powered off.";
            break;
        case CBCentralManagerStatePoweredOn:
            message = @"work";
            break;
        case CBCentralManagerStateUnknown:
            break;
        default:
            break;
    }
    
    showTip(message);
}
@end
