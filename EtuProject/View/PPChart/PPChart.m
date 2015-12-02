//
//  PPChart.m
//  EtuProject
//
//  Created by shake on 14-7-24.
//  Copyright (c) 2014年 uyiuyao. All rights reserved.
//

#import "PPChart.h"

@interface PPChart ()

@property (strong, nonatomic) PPLineChart * lineChart;

@property (strong, nonatomic) PPBarChart * barChart;

@property (assign, nonatomic) id<PPChartDataSource> dataSource;

@end

@implementation PPChart

-(id)initwithPPChartDataFrame:(CGRect)rect withSource:(id<PPChartDataSource>)dataSource withStyle:(PPChartStyle)style{
    self.dataSource = dataSource;
    self.chartStyle = style;
    return [self initWithFrame:rect];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor whiteColor];
        self.clipsToBounds = NO;
    }
    return self;
}

-(void)setUpChart{
	if (self.chartStyle == PPChartLineStyle) {
        if(!_lineChart){
            _lineChart = [[PPLineChart alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
            [self addSubview:_lineChart];
        }
        //选择标记范围
        if ([self.dataSource respondsToSelector:@selector(PPChartMarkRangeInLineChart:)]) {
            [_lineChart setMarkRange:[self.dataSource PPChartMarkRangeInLineChart:self]];
        }
        //选择显示范围
        if ([self.dataSource respondsToSelector:@selector(PPChartChooseRangeInLineChart:)]) {
            [_lineChart setChooseRange:[self.dataSource PPChartChooseRangeInLineChart:self]];
        }
        //显示颜色
        if ([self.dataSource respondsToSelector:@selector(PPChart_ColorArray:)]) {
            [_lineChart setColors:[self.dataSource PPChart_ColorArray:self]];
        }
        //显示横线
        if ([self.dataSource respondsToSelector:@selector(PPChart:ShowHorizonLineAtIndex:)]) {
            NSMutableArray *showHorizonArray = [[NSMutableArray alloc]init];
            for (int i=0; i<31; i++) {
                if ([self.dataSource PPChart:self ShowHorizonLineAtIndex:i]) {
                    [showHorizonArray addObject:@"1"];
                }else{
                    [showHorizonArray addObject:@"0"];
                }
            }
            [_lineChart setShowHorizonLine:showHorizonArray];

        }
        //判断显示最大最小值
        if ([self.dataSource respondsToSelector:@selector(PPChart:ShowMaxMinAtIndex:)]) {
            NSMutableArray *showMaxMinArray = [[NSMutableArray alloc]init];
            NSArray *y_values = [self.dataSource PPChart_yValueArray:self];
            if (y_values.count>0){
                for (int i=0; i<y_values.count; i++) {
                    if ([self.dataSource PPChart:self ShowMaxMinAtIndex:i]) {
                        [showMaxMinArray addObject:@"1"];
                    }else{
                        [showMaxMinArray addObject:@"0"];
                    }
                }
                _lineChart.ShowMaxMinArray = showMaxMinArray;
            }
        }
        
        [_lineChart setXLabels:[self.dataSource PPChart_xLableArray:self]];
		[_lineChart setYValues:[self.dataSource PPChart_yValueArray:self]];
		
        
		[_lineChart strokeChart];

	}else if (self.chartStyle == PPChartBarStyle)
	{
        if (!_barChart) {
            _barChart = [[PPBarChart alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
            [self addSubview:_barChart];
        }
        if ([self.dataSource respondsToSelector:@selector(PPChartChooseRangeInLineChart:)]) {
            [_barChart setChooseRange:[self.dataSource PPChartChooseRangeInLineChart:self]];
        }
        if ([self.dataSource respondsToSelector:@selector(PPChart_ColorArray:)]) {
            [_barChart setColors:[self.dataSource PPChart_ColorArray:self]];
        }
		[_barChart setYValues:[self.dataSource PPChart_yValueArray:self]];
		[_barChart setXLabels:[self.dataSource PPChart_xLableArray:self]];
        
        [_barChart strokeChart];
	}
}

- (void)showInView:(UIView *)view
{
    [self setUpChart];
    [view addSubview:self];
}

-(void)strokeChart
{
	[self setUpChart];
	
}



@end

#pragma mark - Gradient View

@implementation ChatGradientView

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
