//
//  PPLineChart.h
//  EtuProject
//
//  Created by 王家兴 on 15/12/1.
//  Copyright © 2015年 王家兴. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "PPColor.h"

typedef enum : NSUInteger {
    SPORT_TYPE,
    SLEEP_TYPE,
} LineChartType;

#define chartMargin     10
#define xLabelMargin    15
#define yLabelMargin    15
#define PPLabelHeight    30
#define PPYLabelwidth     60
#define PPTagLabelwidth     35

@protocol PPLineChartDelegate <NSObject>

-(void)PPLineChartLoadNext;

-(void)PPLineSelectPointAtIndex:(NSInteger)index;

@end

@interface PPLineChart : UIView<UIScrollViewDelegate>

@property (nonatomic, assign) id<PPLineChartDelegate> delegate;

@property (strong, nonatomic) NSArray * xLabels;

@property (strong, nonatomic) NSArray * yLabels;

@property (strong, nonatomic) NSArray * yValues;
@property (assign, nonatomic) CGFloat rows;

@property (nonatomic, strong) NSArray * colors;

@property (nonatomic) CGFloat xLabelWidth;
@property (nonatomic) CGFloat yValueMin;
@property (nonatomic) CGFloat yValueMax;

@property (nonatomic, assign) CGRange markRange;

@property (nonatomic, assign) CGRange chooseRange;

@property (nonatomic, assign) BOOL showRange;

@property (nonatomic, strong) UIScrollView *chartScrollView;
@property (nonatomic, strong) UIScrollView *xLabelsScrollView;
@property (nonatomic, strong) UIScrollView *yLabelsScrollView;

@property (nonatomic, retain) NSMutableArray *ShowHorizonLine;
@property (nonatomic, retain) NSMutableArray *ShowMaxMinArray;

@property (nonatomic, assign) LineChartType  chartType;

-(void)strokeChart;

-(void)coordinatesCorrection;

- (NSArray *)chartLabelsForX;

@end
