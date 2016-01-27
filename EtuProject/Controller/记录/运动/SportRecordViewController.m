//
//  SportRecordViewController.m
//  EtuProject
//
//  Created by 王家兴 on 15/12/1.
//  Copyright © 2015年 王家兴. All rights reserved.
//

#import "SportRecordViewController.h"
#import "RFSegmentView.h"
#import "RecordDataTableCell.h"
#import "SportChartModel.h"

@interface SportRecordViewController ()<RFSegmentViewDelegate,UITableViewDelegate,UITableViewDataSource>
{
    UIImageView *bgView;
    
    SportRecordGradientView *gradientView;
    
    RFSegmentView* segmentView;
    
    UITableView *dataTable;
    
    NSMutableArray *dayStepDataArr;
    NSMutableArray *weekStepDataArr;
    NSMutableArray *monthStepDataArr;
    
    stepType steptype;
    
    NSMutableArray *selectPointDataArray;
    
    NSInteger maxValue;
}
@end

@implementation SportRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.leftNavButton.hidden = NO;
    
    self.titleLabel.text = @"活动记录";
    
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
    
    bgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, mScreenWidth, viewFrameY + viewFrameHeight)];
    bgView.backgroundColor = rgbaColor(0, 156, 233, 1);
    [self.view insertSubview:bgView belowSubview:self.headerView];
    
    [self initData];
    
    [self configSegment];
    
//    [self configChartView];

    [self configTable];
    
    steptype = stepsDay;
    
    [self requestStepsMonitor:steptype Date:@""];
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
    dayStepDataArr = [NSMutableArray array];
    weekStepDataArr = [NSMutableArray array];
    monthStepDataArr = [NSMutableArray array];
    
    selectPointDataArray = [NSMutableArray array];
}


- (void)configSegment
{
    segmentView = [[RFSegmentView alloc] initWithFrame:CGRectMake((mScreenWidth - 180)/2, self.headerView.bottom, 180, 40) items:@[@"日",@"周",@"月"]];
    segmentView.tintColor       = rgbColor(0, 180, 246);
    segmentView.delegate        = self;
    
    [self.view addSubview:segmentView];
}

- (void)configChartView
{
    CGFloat chartHeight;
    if (!iPhone4) {
        chartHeight = 300;
    }
    else
    {
        chartHeight = 200;
    }

    _chartView = [[PPChart alloc]initwithPPChartDataFrame:CGRectMake(10, self.headerView.bottom + 10+50, [UIScreen mainScreen].bounds.size.width-20, 300)
                                              withSource:self
                                               withStyle:PPChartLineStyle];
    _chartView.delegate = self;
    _chartView.rows = (chartHeight - 20) / 44;
    
    _chartView.backgroundColor = [UIColor clearColor];
    [_chartView showInView:self.view];
    
    gradientView = [[SportRecordGradientView alloc] initWithFrame:CGRectMake(10+50, _chartView.frameY, mScreenWidth - 60, _chartView.frameHeight - 10)];
    gradientView.locations = @[ @0.0f, @0.2f,@0.5f, @0.8, @1.f];
    gradientView.CGColors = @[  (id)rgbaColor(0, 156, 233, 0.9).CGColor,
                                (id)rgbaColor(0, 156, 233, 0.2).CGColor,
                                (id)rgbaColor(0, 156, 233, 0.1).CGColor,
                                (id)rgbaColor(0, 156, 233, 0.2).CGColor,
                                (id)rgbaColor(0, 156, 233, 0.9).CGColor ];
    
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
        SportChartModel *chartmodel = self.currentDataArr[i];
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
    //    return [self getXTitles:20];
}
//数值多重数组
- (NSArray *)PPChart_yValueArray:(PPChart *)chart
{
    NSMutableArray *array = [NSMutableArray array];
    for (int i=0; i<self.currentDataArr.count; i++) {
        SportChartModel *chartmodel = self.currentDataArr[i];
        [array addObject:chartmodel.s];
    }
//    NSArray *ary = @[@"1",@"2.4",@"5.2",@"3.1",@"7",@"10",@"12.5",@"9",@"0",@"",@"3"];
    
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
    NSInteger rowCount = (long int)_chartView.rows;
    if ((maxValue % rowCount) !=0) {
        NSInteger modulus = maxValue%rowCount;
        maxValue = maxValue + modulus;
    }
    NSInteger rowValue =  maxValue/_chartView.rows;
    if (rowValue <= 0) {
        rowValue = 3;
    }
    return CGRangeMake(rowValue* _chartView.rows, 0);
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

#pragma mark - PPChart Delegate
-(void)PPChartLoadNextPageData
{
    SportChartModel *model;
    switch (steptype) {
        case stepsDay:
        {
            model = [dayStepDataArr lastObject];
        }
            break;
        case stepsWeek:
        {
            model = [weekStepDataArr lastObject];
        }
            break;
        case stepsMonth:
        {
            model = [monthStepDataArr lastObject];
        }
            break;
            
        default:
            break;
    }
    
    [self requestStepsMonitor:steptype Date:model.p];
}

-(void)PPChartSelectPointAtIndex:(NSInteger)index
{
    [selectPointDataArray removeAllObjects];
    
    SportChartModel *model;
    switch (steptype) {
        case sleepDay:
        {
            model = dayStepDataArr[index];
        }
            break;
        case sleepWeek:
        {
            model = weekStepDataArr[index];
        }
            break;
        case sleepMonth:
        {
            model = monthStepDataArr[index];
        }
            break;
            
        default:
            break;
    }
    
    NSString *distance = strFormat(@"%ld公里",(long)[model.b integerValue]);
    NSString *steps = strFormat(@"%ld",(long)[model.s integerValue]);
    NSString *calorie = strFormat(@"%ld千卡",(long)[model.c integerValue]);
    
    [selectPointDataArray addObjectsFromArray:@[distance,steps,calorie]];
    [dataTable reloadData];
}

#pragma mark - Segment Delegate Method
-(void)segmentViewDidSelected:(NSUInteger)index
{
    [dayStepDataArr removeAllObjects];
    [weekStepDataArr removeAllObjects];
    [monthStepDataArr removeAllObjects];
    
    steptype = (stepType)(index+1);
    
    [self requestStepsMonitor:steptype Date:@""];

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
        cell.titlesArray = @[@"全天里程",@"全天步数",@"全天消耗"];
    }
    cell.dataArray = selectPointDataArray;//@[@"1公里",@"3000",@"24千卡"];
    
    return cell;
}

#pragma mark - Http Request
-(void)requestStepsMonitor:(stepType)type Date:(NSString *)date
{
    showViewHUD;
    
    [self startRequestWithDict:stepsMonitor([APP_DELEGATE.userData.uid integerValue], type, date ,@"") completeBlock:^(ASIHTTPRequest *request, NSDictionary *dict, NSError *error) {
        
        hideViewHUD;
        
        if (!error) {
            NSDictionary *data = [dict objectForKey:@"data"];
            
            maxValue = [[data objectForKey:@"maxYvalue"] integerValue];
            
            NSArray *sportChartData = [data objectForKey:@"chartData"];
            switch (type) {
                case sleepDay:
                {
                    NSMutableArray *tempArr = [NSMutableArray array];
                    for (int i = 0; i<sportChartData.count; i++) {
                        SportChartModel *model = [[SportChartModel alloc] initWithDictionary:sportChartData[i] error:nil];
                        [tempArr addObject:model];
                    }
                    
                    SportChartModel *lastModel = [tempArr lastObject];
                    if (![lastModel.p isEqualToString:date]) {
                        [dayStepDataArr addObjectsFromArray:tempArr];
                    }
                    
                    self.currentDataArr = dayStepDataArr;
                    
                }
                    break;
                case sleepWeek:
                {
                    NSMutableArray *tempArr = [NSMutableArray array];
                    for (int i = 0; i<sportChartData.count; i++) {
                        SportChartModel *model = [[SportChartModel alloc] initWithDictionary:sportChartData[i] error:nil];
                        [tempArr addObject:model];
                    }
                    
                    SportChartModel *lastModel = [tempArr lastObject];
                    if (![lastModel.p isEqualToString:date]) {
                        [weekStepDataArr addObjectsFromArray:tempArr];
                    }
                    
                    self.currentDataArr = weekStepDataArr;
                }
                    break;
                case sleepMonth:
                {
                    NSMutableArray *tempArr = [NSMutableArray array];
                    for (int i = 0; i<sportChartData.count; i++) {
                        SportChartModel *model = [[SportChartModel alloc] initWithDictionary:sportChartData[i] error:nil];
                        [tempArr addObject:model];
                    }
                    
                    SportChartModel *lastModel = [tempArr lastObject];
                    if (![lastModel.p isEqualToString:date]) {
                        [monthStepDataArr addObjectsFromArray:tempArr];
                    }
                    
                    self.currentDataArr = monthStepDataArr;
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
    } url:kRequestUrl(@"Health", @"stepsMonitor")];
}
@end

#pragma mark - Gradient View

@implementation SportRecordGradientView

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

