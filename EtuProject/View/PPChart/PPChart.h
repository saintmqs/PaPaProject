//
//  PPChart.h
//  EtuProject
//
//  Created by 王家兴 on 15/12/1.
//  Copyright © 2015年 王家兴. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPChart.h"
#import "PPColor.h"
#import "PPLineChart.h"
#import "PPBarChart.h"
//类型
typedef enum {
	PPChartLineStyle,
	PPChartBarStyle
} PPChartStyle;


@class PPChart;
@protocol PPChartDataSource <NSObject>

@required
//横坐标标题数组
- (NSArray *)PPChart_xLableArray:(PPChart *)chart;

//数值多重数组
- (NSArray *)PPChart_yValueArray:(PPChart *)chart;

@optional
//颜色数组
- (NSArray *)PPChart_ColorArray:(PPChart *)chart;

//显示数值范围
- (CGRange)PPChartChooseRangeInLineChart:(PPChart *)chart;

#pragma mark 折线图专享功能
//标记数值区域
- (CGRange)PPChartMarkRangeInLineChart:(PPChart *)chart;

//判断显示横线条
- (BOOL)PPChart:(PPChart *)chart ShowHorizonLineAtIndex:(NSInteger)index;

//判断显示最大最小值
- (BOOL)PPChart:(PPChart *)chart ShowMaxMinAtIndex:(NSInteger)index;
@end


@interface PPChart : UIView

//是否自动显示范围
@property (nonatomic, assign) BOOL showRange;

@property (assign) PPChartStyle chartStyle;

-(id)initwithPPChartDataFrame:(CGRect)rect withSource:(id<PPChartDataSource>)dataSource withStyle:(PPChartStyle)style;

- (void)showInView:(UIView *)view;

-(void)strokeChart;

@end

#pragma mark - Gradient View

@interface ChatGradientView : UIView

@property (nonatomic, strong) NSArray *CGColors;
@property (nonatomic, strong) NSArray *locations;

@end
