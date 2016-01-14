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
}
@end

@implementation HomeViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[PaPaBLEManager shareInstance] setDelegate:self];
    [[PaPaBLEManager shareInstance].bleManager getCurrentStepData];
    [[PaPaBLEManager shareInstance].bleManager getCurrentSleepingData];
}

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
    SGFocusImageItem *item = [[SGFocusImageItem alloc] initWithDict:@{@"image": @"",@"title":@""} tag:-1];
    
    _indicatorView = [[SGFocusImageFrame alloc] initWithFrame:CGRectMake(0, viewFrameY, mScreenWidth, viewFrameHeight) delegate:self imageItems:@[item] isAuto:NO];

     gradientView = [[HomeGradientView alloc] initWithFrame:CGRectMake(0, 0, mScreenWidth, _indicatorView.frameBottom)];
    
    [self.view insertSubview:gradientView belowSubview:self.headerView];
    
    [self.view addSubview:_indicatorView];
    
    [self changeBannersHeaderContent:self.indicatorView];
    
    [self configSynDataView];
    
    [self configTableUI];
    
    if ([SystemStateManager shareInstance].hasBindWristband) {
        gradientView.locations = @[ @0.0f, @1.f];
        gradientView.CGColors = @[  (id)rgbaColor(2, 147, 223, 1).CGColor,
                                    (id)rgbaColor(21, 88, 168, 1).CGColor ];
        
        [self requestData];
    }
    else
    {
        gradientView.backgroundColor = rgbaColor(117, 118, 118, 1);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
        [dataDict1 setObject:@"3000" forKey:@"content"];
        [dataDict1 setObject:@"1公里 | 200千卡" forKey:@"detail"];
        [dataDict1 setObject:@"0.4" forKey:@"progress"];
        [dataDict1 setObject:[UIColor whiteColor] forKey:@"trackTintColor"];
        [contentDataArr addObject:dataDict1];
        
        
        NSMutableDictionary *dataDict2 = [NSMutableDictionary dictionary];
        [dataDict2 setObject:@"昨日睡眠" forKey:@"title"];
        [dataDict2 setObject:@"6小时" forKey:@"content"];
        [dataDict2 setObject:@"深度睡眠5小时" forKey:@"detail"];
        [dataDict2 setObject:@"0.3" forKey:@"progress"];
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
        
        //    SGFocusImageFrame *vFocusFrame = (SGFocusImageFrame *)aTableContent.table.tableHeaderView;
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
//        showTip(@"")
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

#pragma mark - Http Request
-(void)requestData
{
    [self startRequestWithDict:stepsMonitor([APP_DELEGATE.userData.uid integerValue], stepsToday, @"", @"") completeBlock:^(ASIHTTPRequest *request, NSDictionary *dict, NSError *error) {
        if (!error) {
            NSDictionary *data = [dict objectForKey:@"data"];
            
            NSLog(@"%@",data);
        }
    } url:kRequestUrl(@"Health", @"stepsMonitor")];
}

//刷新余额
-(void)refreshCardBalance
{
    // 马上进入刷新状态
//    [self.detailTableView.header beginRefreshing];
    
    [self startRequestWithDict:getCitizencardBalance([APP_DELEGATE.userData.uid integerValue], @"") completeBlock:^(ASIHTTPRequest *request, NSDictionary *dict, NSError *error) {
        
//        [self.detailTableView.header endRefreshing];
        
        if (!error) {
            
        }
        
    } url:kRequestUrl(@"Citizencard", @"getCitizencardBalance")];
}

#pragma mark - PaPaBLEManager Delegate
-(void)PaPaOnDFUStarted
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

-(void)PaPaOnTransferPercentage:(int)percentage
{
    _synDataView.progressLabel.text = [NSString stringWithFormat:@"%d%%",percentage];
}

-(void)PaPaOnSuccessfulFileTranferred
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

-(void)PaPaBLEManagerHasBalanceData:(NSUInteger)balance
{
    [_detailTableView reloadData];
}

//蓝牙返回计步信息，每个记录以NSDictionary存储
- (void) PaPaBLEManagerHasStepData:(NSArray *)stepData
{
    NSLog(@"stepData %@",stepData);
}

//蓝牙返回今天的步数
- (void) PaPaBLEManagerUpdateCurrentSteps:(NSUInteger)steps
{
    NSLog(@"steps = %ld",steps);
}

//蓝牙返回睡眠信息，每个记录以NSDictionary存储
- (void) PaPaBLEManagerHasSleepData:(NSArray *)sleepData
{
    NSLog(@"sleepData = %@",sleepData);
}

//蓝牙返回今天的睡眠信息
- (void) PaPaBLEManagerUpdateCurrentSleepData:(NSDictionary *)mins
{
    NSLog(@"min %@",mins);
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
@end


#pragma mark - Gradient View

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
