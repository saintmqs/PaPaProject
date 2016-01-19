//
//  SleepingRecordViewController.m
//  EtuProject
//
//  Created by 王家兴 on 15/12/1.
//  Copyright © 2015年 王家兴. All rights reserved.
//

#import "SleepingRecordViewController.h"
#import "RFSegmentView.h"
#import "RecordDataTableCell.h"
#import "SleepChartModel.h"

@interface SleepingRecordViewController ()<RFSegmentViewDelegate,UITableViewDelegate,UITableViewDataSource>
{
    UIImageView *bgView;
    
    SleepingRecordGradientView *gradientView;
    
    RFSegmentView* segmentView;
    
    UITableView *dataTable;
    
    NSMutableArray *daySleepDataArr;
    NSMutableArray *weekSleepDataArr;
    NSMutableArray *monthSleepDataArr;
    
    sleepType sleeptype;
    
    NSMutableArray *selectPointDataArray;
}

@end

@implementation SleepingRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.leftNavButton.hidden = NO;
    
    self.titleLabel.text = @"睡眠记录";
    
    CGFloat viewFrameHeight;
    CGFloat viewFrameY;
    if (!iPhone4) {
        viewFrameY = self.headerView.frameBottom+90/4;
        viewFrameHeight = 420;
    }
    else
    {
        viewFrameY = self.headerView.frameBottom+20/4;
        viewFrameHeight = 320;
    }
    
    bgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, mScreenWidth, viewFrameY + viewFrameHeight)];
    bgView.backgroundColor = rgbaColor(51, 19, 42, 1);
    [self.view insertSubview:bgView belowSubview:self.headerView];
    
    [self initData];
    
    [self configSegment];
    
//    [self configChartView];
    
    [self configTable];
    
    sleeptype = sleepDay;
    
    [self requestSleepMonitor:sleeptype Date:@""];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)didTopLeftButtonClick:(UIButton *)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(backToHome)]) {
        [_delegate backToHome];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (_chartView) {
        [_chartView coordinatesCorrection];
    }
}

-(void)initData
{
    daySleepDataArr = [NSMutableArray array];
    weekSleepDataArr = [NSMutableArray array];
    monthSleepDataArr = [NSMutableArray array];
    
    selectPointDataArray = [NSMutableArray array];
}

- (void)configSegment
{
    segmentView = [[RFSegmentView alloc] initWithFrame:CGRectMake((mScreenWidth - 180)/2, self.headerView.bottom, 180, 40) items:@[@"日",@"周",@"月"]];
    segmentView.tintColor       = rgbColor(72, 26, 54);
    segmentView.delegate        = self;
    
    [self.view addSubview:segmentView];
}

- (void)configChartView
{
    CGFloat chartHeight;
    if (!iPhone4) {
        chartHeight = 340;
    }
    else
    {
        chartHeight = 240;
    }
    
    _chartView = [[PPChart alloc]initwithPPChartDataFrame:CGRectMake(10, self.headerView.bottom + 10+50, [UIScreen mainScreen].bounds.size.width-20, chartHeight)
                                               withSource:self
                                                withStyle:PPChartLineStyle];
    _chartView.delegate = self;
    _chartView.lineChartStyle = SLEEP_TYPE;
    _chartView.rows = (chartHeight - 20) / 44;
    
    _chartView.backgroundColor = [UIColor clearColor];
    [_chartView showInView:self.view];
    
    [self.view bringSubviewToFront:gradientView];
    
    gradientView = [[SleepingRecordGradientView alloc] initWithFrame:CGRectMake(10+50, _chartView.frameY, mScreenWidth - 60, _chartView.frameHeight - 10)];
    gradientView.locations = @[ @0.0f, @0.2f,@0.5f, @0.8, @1.f];
    gradientView.CGColors = @[  (id)rgbaColor(51, 19, 42, 0.9).CGColor,
                                (id)rgbaColor(51, 19, 42, 0.2).CGColor,
                                (id)rgbaColor(51, 19, 42, 0.1).CGColor,
                                (id)rgbaColor(51, 19, 42, 0.2).CGColor,
                                (id)rgbaColor(51, 19, 42, 0.9).CGColor ];
    
    [self.view addSubview:gradientView];
}

-(void)configTable
{
    dataTable = [[UITableView alloc] initWithFrame:CGRectMake(0, bgView.frameBottom, mScreenWidth, mScreenHeight-bgView.frameBottom-mTabBarHeight)];
    dataTable.dataSource = self;
    dataTable.delegate = self;
    dataTable.backgroundColor = [UIColor clearColor];
    dataTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    dataTable.bounces = NO;
    [self.view addSubview:dataTable];
}

- (NSArray *)getXTitles:(int)num
{
    NSMutableArray *xTitles = [NSMutableArray array];
    for (int i=0; i<num; i++) {
        SleepChartModel *chartmodel = self.currentDataArr[i];
        if (chartmodel) {
            NSString * str = [NSString stringWithFormat:@"%@",chartmodel.t];
            if ([str rangeOfString:@"-"].location != NSNotFound) {
                str = [str stringByReplacingOccurrencesOfString:@"-" withString:@"-\n"];
            }
            [xTitles addObject:str];
        }
//        NSString * str = [NSString stringWithFormat:@"R-%d",i];
//        [xTitles addObject:str];
    }
    return xTitles;
}

#pragma mark - @required
//横坐标标题数组
- (NSArray *)PPChart_xLableArray:(PPChart *)chart
{
    
    return [self getXTitles:(int)self.currentDataArr.count];
//    int xCount = (int)self.currentDataArr.count+1 < 10 ? 8 : (int)self.currentDataArr.count+1;
//    return [self getXTitles:30];
}
//数值多重数组
- (NSArray *)PPChart_yValueArray:(PPChart *)chart
{
    NSMutableArray *array = [NSMutableArray array];
    for (int i=0; i<self.currentDataArr.count; i++) {
        SleepChartModel *chartmodel = self.currentDataArr[i];
        [array addObject:chartmodel.c];
    }
//    NSArray *array = @[@"1",@"2.4",@"5.2",@"3.1",@"7",@"10",@"12.5",@"9",@"0",@"",@"3"];
    
    return @[array];
}

#pragma mark - @optional
//颜色数组
- (NSArray *)PPChart_ColorArray:(PPChart *)chart
{
    return @[PPGreen,PPRed,PPBrown];
}

//显示数值范围
- (CGRange)PPChartChooseRangeInLineChart:(PPChart *)chart
{
    return CGRangeMake(_chartView.rows, 0);
}

#pragma mark 折线图专享功能

//标记数值区域
- (CGRange)PPChartMarkRangeInLineChart:(PPChart *)chart
{
    return CGRangeZero;
}

//判断显示横线条
- (BOOL)PPChart:(PPChart *)chart ShowHorizonLineAtIndex:(NSInteger)index
{
    return YES;
}

//判断显示最大最小值
- (BOOL)PPChart:(PPChart *)chart ShowMaxMinAtIndex:(NSInteger)index
{
    return YES;
}

#pragma mark - PPChart Delegate Method
-(void)PPChartLoadNextPageData
{
    SleepChartModel *model;
    switch (sleeptype) {
        case sleepDay:
        {
            model = [daySleepDataArr lastObject];
        }
            break;
        case sleepWeek:
        {
            model = [weekSleepDataArr lastObject];
        }
            break;
        case sleepMonth:
        {
            model = [monthSleepDataArr lastObject];
        }
            break;
            
        default:
            break;
    }
    
    [self requestSleepMonitor:sleeptype Date:model.p];
}

-(void)PPChartSelectPointAtIndex:(NSInteger)index
{
    [selectPointDataArray removeAllObjects];
    
    SleepChartModel *model;
    switch (sleeptype) {
        case sleepDay:
        {
            model = daySleepDataArr[index];
        }
            break;
        case sleepWeek:
        {
            model = weekSleepDataArr[index];
        }
            break;
        case sleepMonth:
        {
            model = monthSleepDataArr[index];
        }
            break;
            
        default:
            break;
    }
    
    NSString *totalTime = [self TimeformatFromSeconds:[model.c integerValue]];
    NSString *deepTime = [self TimeformatFromSeconds:[model.d integerValue]];
    NSString *slightTime = [self TimeformatFromSeconds:[model.s integerValue]];
    
    [selectPointDataArray addObjectsFromArray:@[totalTime,deepTime,slightTime]];
    [dataTable reloadData];
}

-(NSString*)TimeformatFromSeconds:(NSInteger)seconds
{
    //format of hour
    NSString *str_hour = [NSString stringWithFormat:@"%02d",(int)(seconds/3600)];
    //format of minute
    NSString *str_minute = [NSString stringWithFormat:@"%02d",(int)((seconds%3600)/60)];
    //format of second
    NSString *str_second = [NSString stringWithFormat:@"%02d",(int)seconds%60];
    //format of time
    
    NSString *format_time;
    
    if ([str_hour integerValue] > 0 && [str_minute integerValue] > 0 && [str_minute integerValue] > 0) {
        format_time = [NSString stringWithFormat:@"%@时%@分%@秒",str_hour,str_minute,str_second];
    }
    else if ([str_minute integerValue] > 0 && [str_minute integerValue] > 0)
    {
        format_time = [NSString stringWithFormat:@"%@分%@秒",str_minute,str_second];
    }
    else
    {
        format_time = [NSString stringWithFormat:@"%@秒",str_second];
    }
    
    return format_time;
}

#pragma mark - Segment Delegate Method
-(void)segmentViewDidSelected:(NSUInteger)index
{
    [daySleepDataArr removeAllObjects];
    [weekSleepDataArr removeAllObjects];
    [monthSleepDataArr removeAllObjects];
    
    sleeptype = (sleepType)(index+1);
    
    [self requestSleepMonitor:sleeptype Date:@""];
}

#pragma mark - UITableView DataSource & Delegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"RecordDataTableCell";
    RecordDataTableCell *cell = (RecordDataTableCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[RecordDataTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.backgroundColor = [UIColor whiteColor];
        cell.titlesArray = @[@"睡眠时长",@"深睡时长",@"浅睡时长"];
    }
    cell.dataArray = selectPointDataArray;
    
    return cell;
}

#pragma mark - Http Request
-(void)requestSleepMonitor:(sleepType)type Date:(NSString *)date
{
    showViewHUD;
    
    [self startRequestWithDict:sleepMonitor([APP_DELEGATE.userData.uid integerValue], type, date ,@"") completeBlock:^(ASIHTTPRequest *request, NSDictionary *dict, NSError *error) {
        
        hideViewHUD;
        
        if (!error) {
            NSDictionary *data = [dict objectForKey:@"data"];
            NSArray *sleepChartData = [data objectForKey:@"chartData"];
            switch (type) {
                case sleepDay:
                {
                    NSMutableArray *tempArr = [NSMutableArray array];
                    for (int i = 0; i<sleepChartData.count; i++) {
                        SleepChartModel *model = [[SleepChartModel alloc] initWithDictionary:sleepChartData[0] error:nil];
                        [tempArr addObject:model];
                    }
                    
                    SleepChartModel *lastModel = [tempArr lastObject];
                    if (![lastModel.p isEqualToString:date]) {
                        [daySleepDataArr addObjectsFromArray:tempArr];
                    }
                    
                    self.currentDataArr = daySleepDataArr;
                                       
                }
                    break;
                case sleepWeek:
                {
                    NSMutableArray *tempArr = [NSMutableArray array];
                    for (int i = 0; i<sleepChartData.count; i++) {
                        SleepChartModel *model = [[SleepChartModel alloc] initWithDictionary:sleepChartData[0] error:nil];
                        [tempArr addObject:model];
                    }
                    
                    SleepChartModel *lastModel = [tempArr lastObject];
                    if (![lastModel.p isEqualToString:date]) {
                        [weekSleepDataArr addObjectsFromArray:tempArr];
                    }
                    
                    self.currentDataArr = weekSleepDataArr;
                }
                    break;
                case sleepMonth:
                {
                    NSMutableArray *tempArr = [NSMutableArray array];
                    for (int i = 0; i<sleepChartData.count; i++) {
                        SleepChartModel *model = [[SleepChartModel alloc] initWithDictionary:sleepChartData[0] error:nil];
                        [tempArr addObject:model];
                    }
                    
                    SleepChartModel *lastModel = [tempArr lastObject];
                    if (![lastModel.p isEqualToString:date]) {
                        [monthSleepDataArr addObjectsFromArray:tempArr];
                    }
                    
                    self.currentDataArr = monthSleepDataArr;
                }
                    break;
                default:
                    break;
            }
//            [_chartView strokeChart];
            if (_chartView) {
                [_chartView removeFromSuperview];
            }
            [self configChartView];
        }
        else
        {
            
        }
    } url:kRequestUrl(@"Health", @"sleepMonitor")];
}
@end

#pragma mark - Gradient View

@implementation SleepingRecordGradientView

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