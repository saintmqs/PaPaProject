//
//  HomeViewController.m
//  EtuProject
//
//  Created by 王家兴 on 15/11/5.
//  Copyright © 2015年 王家兴. All rights reserved.
//

#import "HomeViewController.h"
#import "HomePageProgressItem.h"
#import "HomeTableViewCell.h"

#import "UserInfoViewController.h"
#import "DeviceManagerViewController.h"
#import "SearchBraceletViewController.h"

@interface HomeViewController ()<HomeTableViewCellDelegate>
{
    HomeGradientView *gradientView;
    
    NSString *stepCount;
    NSString *distance;
    NSString *calorie;
    
    NSInteger deepsleepSec;
    NSInteger slightsleepSec;
    NSInteger totalSleepSec;
    
    
    
}
@property (nonatomic, assign) BOOL synStepDataFinish;
@property (nonatomic, assign) BOOL synSleepDataFinish;

@property (nonatomic, assign) BOOL currentStepDataFinish;
@property (nonatomic, assign) BOOL currentSleepDataFinish;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titleLabel.text = @"首页";
    
    [self.leftNavButton sd_setImageWithURL:[NSURL URLWithString:APP_DELEGATE.userData.avatar] forState:UIControlStateNormal placeholderImage:nil];
    [self.leftNavButton sd_setImageWithURL:[NSURL URLWithString:APP_DELEGATE.userData.avatar] forState:UIControlStateHighlighted placeholderImage:nil];
    CGRect leftNavButtonFrame = self.leftNavButton.frame;
    leftNavButtonFrame.size = CGSizeMake(30, 30);
    leftNavButtonFrame.origin.y = (self.headerView.frameHeight - 30)/2 + 10;
    leftNavButtonFrame.origin.x = 20;
    self.leftNavButton.frame = leftNavButtonFrame;
    self.leftNavButton.layer.cornerRadius = self.leftNavButton.frameWidth/2;
    self.leftNavButton.layer.masksToBounds = YES;

    self.leftNavButton.hidden = NO;
    
    [self.rightNavButton setImage:[UIImage imageNamed:@"topIcoBracelet"] forState:UIControlStateNormal];
    self.rightNavButton.hidden = NO;
    
    CGFloat viewFrameHeight;
    CGFloat viewFrameY;
    if (!iPhone4) {
        viewFrameY = self.headerView.frameBottom+90/4;
        viewFrameHeight = 380;
    }
    else
    {
        viewFrameY = self.headerView.frameBottom+20/4;
        viewFrameHeight = 280;
    }
    // Do any additional setup after loading the view.
    //运动睡眠进度环
    SGFocusImageItem *item = [[SGFocusImageItem alloc] initWithDict:@{@"image": @"",@"title":@""} tag:-1];
    
    _indicatorView = [[SGFocusImageFrame alloc] initWithFrame:CGRectMake(0, viewFrameY, mScreenWidth, viewFrameHeight) delegate:self imageItems:@[item] isAuto:NO];

     gradientView = [[HomeGradientView alloc] initWithFrame:CGRectMake(0, 0, mScreenWidth, _indicatorView.frameBottom)];
    
    [self.view insertSubview:gradientView belowSubview:self.headerView];
    
    [self.view addSubview:_indicatorView];
    
    //同步数据转子
    [self configSynDataView];
    
    //余额列表
    [self configTableUI];
    
    if ([SystemStateManager shareInstance].hasBindWristband) {
        gradientView.locations = @[ @0.0f, @1.f];
        gradientView.CGColors = @[  (id)rgbaColor(2, 147, 223, 1).CGColor,
                                    (id)rgbaColor(21, 88, 168, 1).CGColor ];
        
        if (APP_DELEGATE.userData) {
            [self getBandData];
        }
//        [self requestData];
    }
    else
    {
        gradientView.backgroundColor = rgbaColor(117, 118, 118, 1);
    }
    
    
    
    [self addObserver:self forKeyPath:@"synStepDataFinish" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    [self addObserver:self forKeyPath:@"synSleepDataFinish" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    
    [self addObserver:self forKeyPath:@"currentStepDataFinish" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    [self addObserver:self forKeyPath:@"currentSleepDataFinish" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    [self removeObserver:self forKeyPath:@"synStepDataFinish"];
    [self removeObserver:self forKeyPath:@"synSleepDataFinish"];
    [self removeObserver:self forKeyPath:@"currentStepDataFinish"];
    [self removeObserver:self forKeyPath:@"currentSleepDataFinish"];
}

-(void)getBandData
{
    [[PaPaBLEManager shareInstance].bleManager getCurrentStepData];
    [[PaPaBLEManager shareInstance].bleManager getStepData];
    [[PaPaBLEManager shareInstance].bleManager getCurrentSleepingData];
    [[PaPaBLEManager shareInstance].bleManager getSleepingData];
    
    [self changeBannersHeaderContent:self.indicatorView];
    
    [self startSynData];
}

-(void)configSynDataView
{
    _synDataView = [[PaPaSynchronousDataView alloc] initWithFrame:CGRectMake(0, _indicatorView.frameBottom-70, mScreenWidth, 70)];
    _synDataView.alpha = 0;
    _synDataView.hidden = YES;
    [self.view addSubview:_synDataView];
}

-(void)configTableUI
{
    _detailTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, _indicatorView.frameBottom, mScreenWidth, mScreenHeight - _indicatorView.frameBottom - mTabBarHeight)];
    _detailTableView.delegate = self;
    _detailTableView.dataSource = self;
    _detailTableView.backgroundColor = [UIColor clearColor];
    _detailTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _detailTableView.bounces = NO;
    [self.view addSubview:_detailTableView];
    
//    self.detailTableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        // 进入刷新状态后会自动调用这个block
//    }];
//    或
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
//    self.detailTableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshCardBalance)];
}

#pragma mark 改变上面滚动栏的内容
-(void)changeBannersHeaderContent:(SGFocusImageFrame *)vFocusFrame{
    int length = 2;
    
    NSMutableArray *contentDataArr = [NSMutableArray array];
    
    if ([SystemStateManager shareInstance].hasBindWristband) {
        
        NSMutableDictionary *dataDict1 = [NSMutableDictionary dictionary];
        [dataDict1 setObject:@"今日完成" forKey:@"title"];
        [dataDict1 setObject:strFormat(@"%@",stepCount)  forKey:@"content"];
        [dataDict1 setObject:strFormat(@"%@公里 | %@千卡",distance,calorie) forKey:@"detail"];
        float progress = [stepCount doubleValue]/[APP_DELEGATE.userData.baseInfo.step doubleValue] >=1? 1.0 : [stepCount doubleValue]/[APP_DELEGATE.userData.baseInfo.step doubleValue];
        [dataDict1 setObject:strFormat(@"%f",progress) forKey:@"progress"];
        [dataDict1 setObject:[UIColor whiteColor] forKey:@"trackTintColor"];
        [contentDataArr addObject:dataDict1];
        
        NSMutableDictionary *dataDict2 = [NSMutableDictionary dictionary];
        [dataDict2 setObject:@"昨日睡眠" forKey:@"title"];
        
        NSString *totalSleepTimeStr;
        if (totalSleepSec/3600 >=1) {
            totalSleepTimeStr = strFormat(@"%ld小时",totalSleepSec/3600);
        }
        else if (totalSleepSec/60 >= 1)
        {
            totalSleepTimeStr = strFormat(@"%ld分钟",totalSleepSec/60);
        }
        else
        {
            totalSleepTimeStr = strFormat(@"%ld秒",totalSleepSec);
        }
        [dataDict2 setObject:totalSleepTimeStr forKey:@"content"];
        
        NSString *deepSleepTimeStr;
        if (deepsleepSec/3600 >=1) {
            deepSleepTimeStr = strFormat(@"深度睡眠%ld小时",deepsleepSec/3600);
        }
        else if (deepsleepSec/60 >= 1)
        {
            deepSleepTimeStr = strFormat(@"深度睡眠%ld分钟",deepsleepSec/60);
        }
        else
        {
            deepSleepTimeStr = strFormat(@"深度睡眠%ld秒",deepsleepSec);
        }
        [dataDict2 setObject:deepSleepTimeStr  forKey:@"detail"];
        [dataDict2 setObject:strFormat(@"%f", (float)deepsleepSec/(float)totalSleepSec) forKey:@"progress"];
        [dataDict2 setObject:[UIColor lightGrayColor] forKey:@"trackTintColor"];
        [contentDataArr addObject:dataDict2];
    }
    else
    {
        NSMutableDictionary *dataDict1 = [NSMutableDictionary dictionary];
        [dataDict1 setObject:@"今日完成" forKey:@"title"];
        [dataDict1 setObject:@"0000" forKey:@"content"];
        [dataDict1 setObject:@"0公里 | 0千卡" forKey:@"detail"];
        [dataDict1 setObject:@"0" forKey:@"progress"];
        [dataDict1 setObject:[UIColor whiteColor] forKey:@"trackTintColor"];
        [contentDataArr addObject:dataDict1];
        
        
        NSMutableDictionary *dataDict2 = [NSMutableDictionary dictionary];
        [dataDict2 setObject:@"昨日睡眠" forKey:@"title"];
        [dataDict2 setObject:@"0小时" forKey:@"content"];
        [dataDict2 setObject:@"深度睡眠0小时" forKey:@"detail"];
        [dataDict2 setObject:@"0" forKey:@"progress"];
        [dataDict2 setObject:[UIColor lightGrayColor] forKey:@"trackTintColor"];
        [contentDataArr addObject:dataDict2];
    }
   
    
    if (length > 0) {
        NSMutableArray *itemArray = [NSMutableArray arrayWithCapacity:length+2];
        //添加最后一张图 用于循环
        if (length > 1)
        {
            NSDictionary *dict = [contentDataArr objectAtIndex:length-1];
            SGFocusImageItem *item = [[SGFocusImageItem alloc] initWithDict:dict tag:-1];
            [itemArray addObject:item];
        }
        for (int i = 0; i < length; i++)
        {
            NSDictionary *dict = [contentDataArr objectAtIndex:i];
            SGFocusImageItem *item = [[SGFocusImageItem alloc] initWithDict:dict tag:i];
            [itemArray addObject:item];
            
        }
        //添加第一张图 用于循环
        if (length >1)
        {
            NSDictionary *dict = [contentDataArr objectAtIndex:0];
            SGFocusImageItem *item = [[SGFocusImageItem alloc] initWithDict:dict tag:length];
            [itemArray addObject:item];
        }
        
        [vFocusFrame changeImageViewsContent:itemArray];
    }
}

- (void)foucusImageFrame:(SGFocusImageFrame *)imageFrame currentItem:(NSInteger)index
{
    //117,118,118
    NSLog(@"%ld",index);
    
    if ([SystemStateManager shareInstance].hasBindWristband) {
        switch (index) {
            case 0:
            {
                gradientView.locations = @[ @0.0f, @1.f];
                gradientView.CGColors = @[  (id)rgbaColor(2, 147, 223, 1).CGColor,
                                            (id)rgbaColor(21, 88, 168, 1).CGColor ];
            }
                break;
            case 1:
            {
                gradientView.locations = @[ @0.0f,@0.5f, @1.f];
                gradientView.CGColors = @[  (id)rgbaColor(44, 21, 38, 1).CGColor,
                                            (id)rgbaColor(55, 21, 42, 1).CGColor,
                                            (id)rgbaColor(44, 21, 38, 1).CGColor ];
            }
                break;
            default:
                break;
        }
    }
    else
    {
        gradientView.backgroundColor = rgbaColor(117, 118, 118, 1);
    }
    
}

#pragma mark - UITableView DataSource & Delegate
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (![SystemStateManager shareInstance].hasBindWristband) {
        HomeTableViewCommonCell * cell = (HomeTableViewCommonCell *)[tableView dequeueReusableCellWithIdentifier:@"HomeTableViewCommonCell"];
        if (cell == nil) {
            cell = [[HomeTableViewCommonCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"HomeTableViewCommonCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        cell.titleLabel.text = @"还没有绑定手环，点击绑定吧";
        return cell;
    }
    
    HomeTableViewCell * cell = (HomeTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"HomeTableViewCell"];
    if (cell == nil) {
        cell = [[HomeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"HomeTableViewCell"];
        cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.moneyLabel.text = [PaPaBLEManager shareInstance].balance;    
    cell.updateTimeLabel.text = strFormat(@"同步时间 %@",date2StringFormatMDHM([NSDate date]));
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (![SystemStateManager shareInstance].hasBindWristband) {
        SearchBraceletViewController *vc = [[SearchBraceletViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - HomeTableViewCell Delegate
-(void)updateBalace
{
    if ([[PaPaBLEManager shareInstance].bleManager connected]) {
        [[PaPaBLEManager shareInstance].bleManager getBalance];
    }
    else
    {
        showTip(@"请先连接绑定手环");
    }
}

#pragma mark - UIButton Action
-(void)didTopLeftButtonClick:(UIButton *)sender
{
    UserInfoViewController *vc = [[UserInfoViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)didTopRightButtonClick:(UIButton *)sender
{
    DeviceManagerViewController *vc = [[DeviceManagerViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)startSynData
{
    _synDataView.hidden = NO;
    [UIView animateWithDuration:0.5f animations:^{
        _synDataView.alpha = 1.f;
        CGRect frame = _synDataView.frame;
        frame.origin.y = _indicatorView.frameBottom;
        _synDataView.frame = frame;
        
        CGRect tableFrame = _detailTableView.frame;
        tableFrame.origin.y = _synDataView.frameBottom;
        tableFrame.size.height = tableFrame.size.height - _synDataView.frameHeight;
        _detailTableView.frame = tableFrame;
        
        [_synDataView.progressIndicator startAnimating];
    }];
}

-(void)endSynData
{
    [UIView animateWithDuration:0.5f animations:^{
        _synDataView.alpha = 0;
        CGRect frame = _synDataView.frame;
        frame.origin.y = _indicatorView.frameBottom - _synDataView.frameHeight;
        _synDataView.frame = frame;
        
        CGRect tableFrame = _detailTableView.frame;
        tableFrame.origin.y = _synDataView.frameBottom;
        tableFrame.size.height = tableFrame.size.height + _synDataView.frameHeight;
        _detailTableView.frame = tableFrame;
        
        [_synDataView.progressIndicator stopAnimating];
    } completion:^(BOOL finished) {
        _synDataView.hidden = YES;
    }];
}

#pragma mark - Http Request
//刷新余额
-(void)refreshCardBalance
{
    // 马上进入刷新状态
//    [self.detailTableView.header beginRefreshing];
    
    showViewHUD;
    
    [self startRequestWithDict:getCitizencardBalance([APP_DELEGATE.userData.uid integerValue], @"") completeBlock:^(ASIHTTPRequest *request, NSDictionary *dict, NSError *error) {
        
//        [self.detailTableView.header endRefreshing];
        
        hideViewHUD;
        
        if (!error) {
//            NSDictionary *data = [dict objectForKey:@"data"];
//            showTip([data objectForKey:@"msg"]);
        }
        else
        {
            if (error == nil || [error.userInfo objectForKey:@"msg"] == nil)
            {
                showTip(@"网络连接失败");
            }
            else
            {
                showTip([error.userInfo objectForKey:@"msg"]);
            }
        }
        
    } url:kRequestUrl(@"Citizencard", @"getCitizencardBalance")];
}

-(void)uploadStepsData:(NSString *)json
{
    NSLog(@"***uploadSleepData***");
    [self asynchronousGetRequest:kRequestUrl(@"Health", @"stepsUpload") parameters:sleepUpload([APP_DELEGATE.userData.uid integerValue], json) successBlock:^(BOOL success, id data, NSString *msg) {
        
        if (success) {
            self.synStepDataFinish = YES;
        }
        else
        {
            self.synStepDataFinish = NO;
        }
        
        [[PaPaBLEManager shareInstance].bleManager removeSyncedData:DELETE_STEP_DATA];
    } failureBlock:^(NSString *description) {
        
    }];
//    [self startRequestWithDict:stepsUpload([APP_DELEGATE.userData.uid integerValue], json) completeBlock:^(ASIHTTPRequest *request, NSDictionary *dict, NSError *error) {
//        if (!error) {
//            NSDictionary *data = [dict objectForKey:@"data"];
//            showTip([data objectForKey:@"msg"]);
//        }
//        else
//        {
//            if (error == nil || [error.userInfo objectForKey:@"msg"] == nil)
//            {
//                showTip(@"网络连接失败");
//            }
//            else
//            {
//                showTip([error.userInfo objectForKey:@"msg"]);
//            }
//        }
//        
//    } url:kRequestUrl(@"Health", @"stepsUpload")];
}

-(void)uploadSleepData:(NSString *)json
{
    NSLog(@"===uploadSleepData===");
    [self asynchronousGetRequest:kRequestUrl(@"Health", @"sleepUpload") parameters:sleepUpload([APP_DELEGATE.userData.uid integerValue], json) successBlock:^(BOOL success, id data, NSString *msg) {
        
        if (success) {
            self.synSleepDataFinish = YES;
        }
        else
        {
            self.synSleepDataFinish = NO;
        }
        
        [[PaPaBLEManager shareInstance].bleManager removeSyncedData:DELETE_SLEEP_DATA];
    } failureBlock:^(NSString *description) {
        
    }];
    
//    [self startRequestWithDict:sleepUpload([APP_DELEGATE.userData.uid integerValue], json) completeBlock:^(ASIHTTPRequest *request, NSDictionary *dict, NSError *error) {
//        if (!error) {
//            NSDictionary *data = [dict objectForKey:@"data"];
//            showTip([data objectForKey:@"msg"]);
//        }
//        else
//        {
//            if (error == nil || [error.userInfo objectForKey:@"msg"] == nil)
//            {
//                showTip(@"网络连接失败");
//            }
//            else
//            {
//                showTip([error.userInfo objectForKey:@"msg"]);
//            }
//        }
//    } url:kRequestUrl(@"Health", @"sleepUpload")];
}

#pragma mark - PaPaBLEManager Delegate
//固件升级开始
-(void)PaPaOnDFUStarted
{
    [self startSynData];
}

//升级进度百分比
-(void)PaPaOnTransferPercentage:(int)percentage
{
    _synDataView.progressLabel.text = [NSString stringWithFormat:@"%d%%",percentage];
}

//升级完成
-(void)PaPaOnSuccessfulFileTranferred
{
    [self endSynData];
}

//获取系统信息
- (void) PaPaBLEManagerHasSystemInformation:(NSDictionary *)info
{
    [[PaPaBLEManager shareInstance] updateFirmware:info];
}

//蓝牙返回余额
-(void)PaPaBLEManagerHasBalanceData:(NSUInteger)balance
{
    [_detailTableView reloadData];
}

//蓝牙返回计步信息，每个记录以NSDictionary存储
- (void) PaPaBLEManagerHasStepData:(NSArray *)stepData
{
    NSLog(@"stepData %@",stepData);
    
    [self uploadStepsData:[stepData JSONString]];
}

//蓝牙返回今天的步数
- (void) PaPaBLEManagerUpdateCurrentSteps:(NSUInteger)steps
{
    NSLog(@"steps = %ld",steps);
    
    [self startRequestWithDict:sport([APP_DELEGATE.userData.uid integerValue], steps) completeBlock:^(ASIHTTPRequest *request, NSDictionary *dict, NSError *error) {
        
        if (!error) {
            NSDictionary *data = [dict objectForKey:@"data"];
            distance = [data objectForKey:@"l"];
            calorie = [data objectForKey:@"c"];
            stepCount = strFormat(@"%ld",steps);
            
            self.currentStepDataFinish = YES;
            
        }
        else
        {
            if (error == nil || [error.userInfo objectForKey:@"msg"] == nil)
            {
                showTip(@"网络连接失败");
            }
            else
            {
                showTip([error.userInfo objectForKey:@"msg"]);
            }
        }
        
    } url:kRequestUrl(@"health", @"sport")];
}

//蓝牙返回睡眠信息，每个记录以NSDictionary存储
- (void) PaPaBLEManagerHasSleepData:(NSArray *)sleepData
{
    NSLog(@"sleepData = %@",sleepData);
    
    [self uploadSleepData:[sleepData JSONString]];
}

//蓝牙返回今天的睡眠信息
- (void) PaPaBLEManagerUpdateCurrentSleepData:(NSDictionary *)mins
{
    NSLog(@"min %@",mins);
    
    deepsleepSec = [[mins objectForKey:@"d"] integerValue];
    slightsleepSec = [[mins objectForKey:@"s"] integerValue];
    
    totalSleepSec = deepsleepSec + slightsleepSec;
    
    self.currentSleepDataFinish = YES;
    
}

#pragma mark - ParentViewController Method
-(void)connetedViewRefreshing
{
    NSLog(@"connetedViewRefreshing");
}

-(void)disConnetedViewRefreshing:(NSError *)error
{
    NSLog(@"disConnetedViewRefreshing");
}

#pragma mark - KVO
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if([keyPath isEqualToString:@"synStepDataFinish"] || [keyPath isEqualToString:@"synSleepDataFinish"])
    {
        if (self.synSleepDataFinish && self.synSleepDataFinish) {
            showTip(@"同步计步睡眠数据成功");
            [self endSynData];
        }
    }
    
    if([keyPath isEqualToString:@"currentStepDataFinish"] || [keyPath isEqualToString:@"currentSleepDataFinish"])
    {
        if (self.currentStepDataFinish && self.currentSleepDataFinish) {
            [self changeBannersHeaderContent:self.indicatorView];
        }
    }
}
@end


#pragma mark - Gradient View
//渐变蒙版图层
@implementation HomeGradientView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.shouldRasterize = YES;
        self.layer.rasterizationScale = [UIScreen mainScreen].scale;
        self.userInteractionEnabled = NO;
    }
    return self;
}

+ (Class)layerClass
{
    return [CAGradientLayer class];
}

- (void)setLocations:(NSArray *)locations
{
    ((CAGradientLayer *)self.layer).locations = locations;
}

- (void)setCGColors:(NSArray *)CGColors
{
    ((CAGradientLayer *)self.layer).colors = CGColors;
}
@end
