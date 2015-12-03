//
//  SportRecordViewController.m
//  EtuProject
//
//  Created by 王家兴 on 15/12/1.
//  Copyright © 2015年 王家兴. All rights reserved.
//

#import "SportRecordViewController.h"

@interface SportRecordViewController ()<PPChartDataSource>
{
    SportRecordGradientView *gradientView;
    
    PPChart *chartView;
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
    
    gradientView = [[SportRecordGradientView alloc] initWithFrame:CGRectMake(0, 0, mScreenWidth, viewFrameY + viewFrameHeight)];
    gradientView.locations = @[ @0.0f, @1.f];
    gradientView.CGColors = @[  (id)rgbaColor(2, 147, 223, 1).CGColor,
                                (id)rgbaColor(21, 88, 168, 1).CGColor ];
    
    [self.view insertSubview:gradientView belowSubview:self.headerView];
    
    [self configChartView];

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

- (void)configChartView
{
    chartView = [[PPChart alloc]initwithPPChartDataFrame:CGRectMake(10, self.headerView.bottom + 10+50, [UIScreen mainScreen].bounds.size.width-20, 300)
                                              withSource:self
                                               withStyle:PPChartLineStyle];
    chartView.backgroundColor = [UIColor clearColor];
    [chartView showInView:self.view];
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
    return CGRangeMake(20, 0);
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

