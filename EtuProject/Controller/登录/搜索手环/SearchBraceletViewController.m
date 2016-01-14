//
//  SearchBraceletViewController.m
//  EtuProject
//
//  Created by 王家兴 on 15/11/22.
//  Copyright © 2015年 王家兴. All rights reserved.
//

#import <objc/runtime.h>
#import "SearchBraceletViewController.h"
#import "SelectBraceletViewController.h"

static NSString *LOOP_ITEM_ASS_KEY = @"loopview";

@interface SearchBraceletViewController ()<CBCentralManagerDelegate>
{
    UIButton *setBleButton;   //开启蓝牙按钮
    
    UIButton *reSearchButton; //重新搜索按钮
    
    UIButton *cancelButton;   //暂不绑定按钮
}

@property (nonatomic, strong) CBCentralManager *centralManager;

@end

@implementation SearchBraceletViewController

@synthesize searchView,bleOffView,noResultView;

- (id)init
{
    self = [super init];
    if (self) {
        [SystemStateManager shareInstance].activeController = self;
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
        
    if ([[PaPaBLEManager shareInstance] blePoweredOn]) {
        [self startScan];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = rgbaColor(51, 46, 53, 1);
    self.headerView.hidden = YES;
    
    //初始化搜索View
    [self setupSearchView];
    
    //初始化蓝牙未开启提示View
    [self setupBleOffView];
    
    //初始化无搜索结果提示View
    [self setupNoResultView];
    
    if ([[PaPaBLEManager shareInstance] blePoweredOn]) {
        searchView.hidden = NO;
        [_loadingView startAnimation];
        bleOffView.hidden = YES;
    }
    else
    {
        searchView.hidden = YES;
        bleOffView.hidden = NO;
    }
    
    cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.frame = CGRectMake((mScreenWidth - 110)/2, self.view.frameBottom - 60, 110, 30);
    [cancelButton setTitle:@"暂时不绑定 >" forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    cancelButton.titleLabel.font = [UIFont systemFontOfSize:13];
    
    addBtnAction(cancelButton, @selector(cancelBind));
    [self.view addSubview:cancelButton];
    
    [self setupGradientView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 搜索手环View
- (void)setupSearchView
{
    searchView = [[UIView alloc] initWithFrame:CGRectMake(0, 40, mScreenWidth, mScreenHeight - 40 - 60)];
    searchView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:searchView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake((mScreenWidth-160)/2, 0, 160, 50)];
    titleLabel.font = [UIFont boldSystemFontOfSize:25];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"搜索手环";
    [searchView addSubview:titleLabel];
    
    UILabel *descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake((mScreenWidth - 280)/2, titleLabel.frameBottom + 10, 280, 35)];
    descriptionLabel.font = [UIFont systemFontOfSize:16];
    descriptionLabel.textColor = [UIColor whiteColor];
    descriptionLabel.textAlignment = NSTextAlignmentCenter;
    descriptionLabel.text = @"打开手机蓝牙，靠近手环~";
    [searchView addSubview:descriptionLabel];
    
    _loadingView =  [[PPLoadingView alloc] initWithFrame:CGRectMake((mScreenWidth - 180)/2, descriptionLabel.bottom + (searchView.frameHeight - 50 - 45 - 180)/2, 180, 180)];
    
    objc_setAssociatedObject(self, (const void *)CFBridgingRetain(LOOP_ITEM_ASS_KEY), nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, (const void *)CFBridgingRetain(LOOP_ITEM_ASS_KEY), _loadingView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    [searchView addSubview:_loadingView];
}

#pragma mark - 蓝牙未开启View
-(void)setupBleOffView
{
    bleOffView = [[UIView alloc] initWithFrame:CGRectMake(0, 40, mScreenWidth, mScreenHeight - 40 - 60)];
    bleOffView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:bleOffView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake((mScreenWidth-160)/2, 0, 160, 50)];
    titleLabel.font = [UIFont boldSystemFontOfSize:25];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"蓝牙未开启";
    [bleOffView addSubview:titleLabel];
    
    UILabel *descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake((mScreenWidth - 280)/2, titleLabel.frameBottom + 10, 280, 35)];
    descriptionLabel.font = [UIFont systemFontOfSize:16];
    descriptionLabel.textColor = [UIColor whiteColor];
    descriptionLabel.textAlignment = NSTextAlignmentCenter;
    descriptionLabel.text = @"无法找到手环";
    [bleOffView addSubview:descriptionLabel];
    
    setBleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    setBleButton.frame = CGRectMake((mScreenWidth - 200)/2, bleOffView.frameHeight - 32 - 36, 200, 32);
    setBleButton.layer.cornerRadius = setBleButton.frameHeight/2;
    setBleButton.layer.borderWidth = 1;
    setBleButton.layer.borderColor = rgbaColor(255, 255, 255, 0.1).CGColor;
    setBleButton.backgroundColor = rgbaColor(37, 32, 39, 1);
    [setBleButton setTitle:@"开启蓝牙" forState:UIControlStateNormal];
    [setBleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    setBleButton.titleLabel.font = [UIFont systemFontOfSize:16];
    addBtnAction(setBleButton, @selector(setBlueTooth));
    [bleOffView addSubview:setBleButton];
    
    UIImageView *statusImg =  [[UIImageView alloc] initWithFrame:CGRectMake((mScreenWidth - 130)/2, descriptionLabel.bottom + (bleOffView.frameHeight - 50 - 45 - 160 - 32- 36)/2, 130, 160)];
    [statusImg setImage:[UIImage imageNamed:@"searchIco4"]];
    [bleOffView addSubview:statusImg];
}

#pragma mark - 无搜索结果View
-(void)setupNoResultView
{
    noResultView = [[UIView alloc] initWithFrame:CGRectMake(0, 40, mScreenWidth, mScreenHeight - 40 - 60)];
    noResultView.backgroundColor = [UIColor clearColor];
    noResultView.hidden = YES;
    [self.view addSubview:noResultView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake((mScreenWidth-260)/2, 0, 260, 50)];
    titleLabel.font = [UIFont boldSystemFontOfSize:25];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"手环没电或者不在附近";
    [noResultView addSubview:titleLabel];
    
    UILabel *descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake((mScreenWidth - 280)/2, titleLabel.frameBottom + 10, 280, 35)];
    descriptionLabel.font = [UIFont systemFontOfSize:16];
    descriptionLabel.textColor = [UIColor whiteColor];
    descriptionLabel.textAlignment = NSTextAlignmentCenter;
    descriptionLabel.text = @"无法找到手环";
    [noResultView addSubview:descriptionLabel];
    
    reSearchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    reSearchButton.frame = CGRectMake((mScreenWidth - 200)/2, noResultView.frameHeight - 32 -36, 200, 32);
    reSearchButton.layer.cornerRadius = reSearchButton.frameHeight/2;
    reSearchButton.layer.borderWidth = 2;
    reSearchButton.layer.borderColor = rgbaColor(255, 255, 255, 0.1).CGColor;
    reSearchButton.backgroundColor = rgbaColor(37, 32, 39, 1);
    [reSearchButton setTitle:@"重新搜索" forState:UIControlStateNormal];
    [reSearchButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    reSearchButton.titleLabel.font = [UIFont systemFontOfSize:16];
    addBtnAction(reSearchButton, @selector(reSearch));
    [noResultView addSubview:reSearchButton];
    
    UIImageView *statusImg =  [[UIImageView alloc] initWithFrame:CGRectMake((mScreenWidth - 165)/2, descriptionLabel.bottom + (noResultView.frameHeight - 50 - 45 - 165 - 32 - 36)/2, 165, 165)];
    [statusImg setImage:[UIImage imageNamed:@"searchIco3"]];
    [noResultView addSubview:statusImg];
}

#pragma mark - 蒙版View
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

#pragma mark - Scanning
-(void)startScan
{
    [[PaPaBLEManager shareInstance].bleManager startScan];
    
    PPLoadingView *loopView = objc_getAssociatedObject(self, (const void *)CFBridgingRetain(LOOP_ITEM_ASS_KEY));
    [loopView startAnimation];
    
    [self bleScanning:^{
        [[PaPaBLEManager shareInstance].bleManager stopScan];
        [loopView stopAnimation];
        
        if ([[PaPaBLEManager shareInstance].bleManager peripheralList].count != 0) {
            
            searchView.hidden = NO;
            noResultView.hidden = YES;
            
            SelectBraceletViewController *vc = [[SelectBraceletViewController alloc] init];
            vc.searchResultArray = [[PaPaBLEManager shareInstance].bleManager peripheralList];
            [self.navigationController pushViewController:vc animated:YES];
        }
        else
        {
            noResultView.hidden = NO;
            searchView.hidden = YES;
        }
        
    } blockNo:^(id time) {
        
    }];
}

#pragma mark - 侦测蓝牙
//蓝牙扫描计时block
- (void)bleScanning:(void(^)())blockYes blockNo:(void(^)(id time))blockNo {
    __block int timeout=3; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                blockYes();
            });
        }else{
            //            int minutes = timeout / 60;
            int seconds = timeout % 60;
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                NSLog(@"bleScanning____%@",strTime);
                blockNo(strTime);
                
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}

#pragma mark - ButtonAction
//暂时不绑定 代表尚未连接手环
-(void)cancelBind
{
    [SystemStateManager shareInstance].hasBindWristband = NO;
    
    if (_timer) {
        dispatch_source_cancel(_timer);
    }
    
    [APP_DELEGATE loginSuccess];
}

//重新搜索
-(void)reSearch
{
    searchView.hidden = NO;
    noResultView.hidden = YES;
    
    [self startScan];
}

#pragma mark - PaPaBLEManager Delegate
-(void)getBLEStatusToDoNext:(CBCentralManagerState)state
{
    NSString *message;
    switch (state) {
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
        {
            message = @"work";
            [self startScan];
        }
            break;
        case CBCentralManagerStateUnknown:
            break;
        default:
            break;
    }
}

//开启蓝牙
-(void)setBlueTooth
{
    _centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
}

-(void)centralManagerDidUpdateState:(CBCentralManager *)central
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
        {
            message = @"work";
        }
            break;
        case CBCentralManagerStateUnknown:
            break;
        default:
            break;
    }

}

#pragma mark - PaPaBLEManager Delegate
-(void)PaPaBLEManagerConnected
{
    [SystemStateManager shareInstance].hasBindWristband = YES;
    
    double delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        if (_timer) {
            dispatch_source_cancel(_timer);
        }
        
        [APP_DELEGATE loginSuccess];
    });
    
    
}
@end
