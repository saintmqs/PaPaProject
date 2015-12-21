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

@interface SleepingRecordViewController ()<RFSegmentViewDelegate,UITableViewDelegate,UITableViewDataSource>
{
    UIImageView *bgView;
    
    SleepingRecordGradientView *gradientView;
    
    RFSegmentView* segmentView;
    
    UITableView *dataTable;
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
    
    [self configSegment];
    
    [self configChartView];
    
    [self configTable];
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
    _chartView.rows = (chartHeight - 20) / 44;
    
    _chartView.backgroundColor = [UIColor clearColor];
    [_chartView showInView:self.view];
    
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
        NSString * str = [NSString stringWithFormat:@"R-%d",i];
        [xTitles addObject:str];
    }
    return xTitles;
}

#pragma mark - @required
//横坐标标题数组
- (NSArray *)PPChart_xLableArray:(PPChart *)chart
{
    
    return [self getXTitles:30];
    //    return [self getXTitles:20];
}
//数值多重数组
- (NSArray *)PPChart_yValueArray:(PPChart *)chart
{
    NSArray *ary = @[@"1",@"2.4",@"5.2",@"3.1",@"7",@"10",@"12.5",@"9",@"0",@"",@"3"];
    
    return @[ary];
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
    return CGRangeMake(3* _chartView.rows, 0);
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

#pragma mark - Segment Delegate Method
-(void)segmentViewDidSelected:(NSUInteger)index
{
    
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
    cell.dataArray = @[@"4小时20分钟",@"1小时47分钟",@"1小时47分钟"];
    
    return cell;
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