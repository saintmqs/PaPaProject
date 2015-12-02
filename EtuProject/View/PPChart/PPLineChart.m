//
//  PPLineChart.m
//  EtuProject
//
//  Created by shake on 14-7-24.
//  Copyright (c) 2014年 uyiuyao. All rights reserved.
//

#import "PPLineChart.h"
#import "PPColor.h"
#import "PPChartLabel.h"


@implementation PPLineChart {
    NSHashTable *_chartLabelsForX;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.clipsToBounds = YES;
        
        _yLabelsScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 50, self.bounds.size.height - PPLabelHeight)];
//        _yLabelsScrollView.backgroundColor = [UIColor redColor];
        _yLabelsScrollView.delegate = self;
        _yLabelsScrollView.transform = CGAffineTransformMakeRotation(M_PI);
        [self addSubview:_yLabelsScrollView];
        
        _chartScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(50, 0, self.bounds.size.width - 60, self.bounds.size.height - PPLabelHeight)];
//        _chartScrollView.backgroundColor = [UIColor blueColor];
        _chartScrollView.delegate = self;
        _chartScrollView.transform = CGAffineTransformMakeRotation(M_PI);
        [self addSubview:_chartScrollView];
        
        _xLabelsScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(50, _chartScrollView.frame.size.height, self.bounds.size.width - 60 , PPLabelHeight)];
//        _xLabelsScrollView.backgroundColor = [UIColor greenColor];
        _xLabelsScrollView.delegate = self;
        _xLabelsScrollView.userInteractionEnabled = NO;
        [self addSubview:_xLabelsScrollView];
    }
    return self;
}

-(void)setYValues:(NSArray *)yValues
{
    _yValues = yValues;
    [self setYLabels:yValues];
}

-(void)setYLabels:(NSArray *)yLabels
{
    NSInteger max = 0;
    NSInteger min = 1000000000;

    for (NSArray * ary in yLabels) {
        for (NSString *valueString in ary) {
            NSInteger value = [valueString integerValue];
            if (value > max) {
                max = value;
            }
            if (value < min) {
                min = value;
            }
        }
    }
//    if (max < 7) {
//        max = 7;
//    }
    if (self.showRange) {
        _yValueMin = min;
    }else{
        _yValueMin = 0;
    }
    _yValueMax = (int)max;
    
    if (_chooseRange.max!=_chooseRange.min) {
        _yValueMax = _chooseRange.max;
        _yValueMin = _chooseRange.min;
    }

    float level = (_yValueMax-_yValueMin) /6;
    CGFloat chartCavanHeight = self.frame.size.height - PPLabelHeight*3;
    CGFloat levelHeight = 44;// chartCavanHeight /7.0;

    _yLabelsScrollView.contentSize =CGSizeMake(50, 30*levelHeight+5);

    for (int i=0; i<31; i++) {
        PPChartLabel * label = [[PPChartLabel alloc] initWithFrame:CGRectMake(0.0,_yLabelsScrollView.contentSize.height - i*levelHeight, PPYLabelwidth, PPLabelHeight)];
//        label.backgroundColor = [UIColor yellowColor];
		label.text = [NSString stringWithFormat:@"%d:00",(int)(level * (30 - i)+_yValueMin)];
        label.transform = CGAffineTransformMakeRotation(M_PI);
		[_yLabelsScrollView addSubview:label];
        
        
    }
    if ([super respondsToSelector:@selector(setMarkRange:)]) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(PPYLabelwidth, (1-(_markRange.max-_yValueMin)/(_yValueMax-_yValueMin))*chartCavanHeight+PPLabelHeight, self.frame.size.width-PPYLabelwidth, (_markRange.max-_markRange.min)/(_yValueMax-_yValueMin)*chartCavanHeight)];
        view.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.1];
        [_yLabelsScrollView addSubview:view];
    }

    //画横线
    for (int i=0; i<31; i++) {
        if ([_ShowHorizonLine[i] integerValue]>0) {
            
            CAShapeLayer *shapeLayer = [CAShapeLayer layer];
            UIBezierPath *path = [UIBezierPath bezierPath];
            [path moveToPoint:CGPointMake(-200,PPLabelHeight + i*levelHeight)];
            [path addLineToPoint:CGPointMake(10+_xLabels.count*_xLabelWidth+200,PPLabelHeight + i*levelHeight)];
            [path closePath];
            shapeLayer.path = path.CGPath;
            shapeLayer.strokeColor = [[[UIColor whiteColor] colorWithAlphaComponent:0.2] CGColor];
            shapeLayer.fillColor = [[UIColor whiteColor] CGColor];
            shapeLayer.lineWidth = 1;
            [_chartScrollView.layer addSublayer:shapeLayer];
        }
    }
}

-(void)setXLabels:(NSArray *)xLabels
{
    if( !_chartLabelsForX ){
        _chartLabelsForX = [NSHashTable weakObjectsHashTable];
    }
    
    _xLabels = xLabels;
//    CGFloat num = 0;
//    if (xLabels.count>=20) {
//        num=20.0;
//    }else if (xLabels.count<=1){
//        num=1.0;
//    }else{
//        num = xLabels.count;
//    }
    _xLabelWidth = 44;//(self.frame.size.width)/num;
    
    for (int i=0; i<xLabels.count; i++) {
        NSString *labelText = xLabels[i];
        PPChartLabel * label = [[PPChartLabel alloc] initWithFrame:CGRectMake((i+7) * _xLabelWidth - 10 - _xLabels.count *_xLabelWidth, 0, _xLabelWidth, PPLabelHeight)];
        label.text = labelText;
        [_xLabelsScrollView addSubview:label];
        
        [_chartLabelsForX addObject:label];
        
        _xLabelsScrollView.contentSize = CGSizeMake(i * _xLabelWidth, PPLabelHeight);

    }
    
    //画竖线
    for (int i=0; i<xLabels.count+10; i++) {
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointMake(-88+20+i*_xLabelWidth,0)];
        [path addLineToPoint:CGPointMake(-88+20+i*_xLabelWidth,(30*_xLabelWidth + PPLabelHeight))];
        [path closePath];
        shapeLayer.path = path.CGPath;
        shapeLayer.strokeColor = [[[UIColor whiteColor] colorWithAlphaComponent:0.2] CGColor];
        shapeLayer.fillColor = [[UIColor whiteColor] CGColor];
        shapeLayer.lineWidth = 1;
        [_chartScrollView.layer addSublayer:shapeLayer];
    }
}

-(void)setColors:(NSArray *)colors
{
	_colors = colors;
}

- (void)setMarkRange:(CGRange)markRange
{
    _markRange = markRange;
}

- (void)setChooseRange:(CGRange)chooseRange
{
    _chooseRange = chooseRange;
}

- (void)setShowHorizonLine:(NSMutableArray *)ShowHorizonLine
{
    _ShowHorizonLine = ShowHorizonLine;
}


-(void)strokeChart
{
    for (int i=0; i<_yValues.count; i++) {
        NSArray *childAry = _yValues[i];
        if (childAry.count==0) {
            return;
        }
        //获取最大最小位置
        CGFloat max = [childAry[0] floatValue];
        CGFloat min = [childAry[0] floatValue];
        NSInteger max_i;
        NSInteger min_i;
        
        for (int j=0; j<childAry.count; j++){
            CGFloat num = [childAry[j] floatValue];
            if (max<=num){
                max = num;
                max_i = j;
            }
            if (min>=num){
                min = num;
                min_i = j;
            }
        }
        
        //划线
        CAShapeLayer *_chartLine = [CAShapeLayer layer];
        _chartLine.lineCap = kCALineCapRound;
        _chartLine.lineJoin = kCALineJoinBevel;
        _chartLine.fillColor   = [[UIColor whiteColor] CGColor];
        _chartLine.lineWidth   = 1.0;
        _chartLine.strokeEnd   = 0.0;
        [_chartScrollView.layer addSublayer:_chartLine];
        
        UIBezierPath *progressline = [UIBezierPath bezierPath];
        CGFloat firstValue = [[childAry objectAtIndex:0] floatValue];
        CGFloat xPosition = 20 + _xLabels.count*_xLabelWidth - _xLabelWidth;
        CGFloat chartCavanHeight =  self.frame.size.height - PPLabelHeight*3;
        
        float grade = ((float)firstValue-_yValueMin) / ((float)_yValueMax-_yValueMin);
        NSLog(@"grade = %f",grade);
       
        //第一个点
        BOOL isShowMaxAndMinPoint = YES;
        if (self.ShowMaxMinArray) {
            if ([self.ShowMaxMinArray[i] intValue]>0) {
                isShowMaxAndMinPoint = (max_i==0 || min_i==0)?NO:YES;
            }else{
                isShowMaxAndMinPoint = YES;
            }
        }
        [self addPoint:CGPointMake(xPosition,  grade * chartCavanHeight + PPLabelHeight)
                 index:i
                isShow:NO
                 value:firstValue];

        
        [progressline moveToPoint:CGPointMake(xPosition,  grade * chartCavanHeight + PPLabelHeight)];
        [progressline setLineWidth:1.0];
        [progressline setLineCapStyle:kCGLineCapRound];
        [progressline setLineJoinStyle:kCGLineJoinRound];
        NSInteger index = 0;
        for (NSString * valueString in childAry) {
            
            float grade =([valueString floatValue]-_yValueMin) / ((float)_yValueMax-_yValueMin);
            NSLog(@"grade = %f",grade);

            if (index != 0) {
                
                CGPoint point = CGPointMake(xPosition-index*_xLabelWidth,   grade * chartCavanHeight + PPLabelHeight);
                [progressline addLineToPoint:point];
                
                BOOL isShowMaxAndMinPoint = YES;
                if (self.ShowMaxMinArray) {
                    if ([self.ShowMaxMinArray[i] intValue]>0) {
                        isShowMaxAndMinPoint = (max_i==index || min_i==index)?NO:YES;
                    }else{
                        isShowMaxAndMinPoint = YES;
                    }
                }
                [progressline moveToPoint:point];
                [self addPoint:point
                         index:i
                        isShow:NO
                         value:[valueString floatValue]];
                
//                [progressline stroke];
            }
            index += 1;
        }
        
        _chartLine.path = progressline.CGPath;
        if ([[_colors objectAtIndex:i] CGColor]) {
            _chartLine.strokeColor = [[_colors objectAtIndex:i] CGColor];
        }else{
            _chartLine.strokeColor = [PPGreen CGColor];
        }
        CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        pathAnimation.duration = childAry.count*0.4;
        pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        pathAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
        pathAnimation.toValue = [NSNumber numberWithFloat:1.0f];
        pathAnimation.autoreverses = NO;
        [_chartLine addAnimation:pathAnimation forKey:@"strokeEndAnimation"];
        
        _chartLine.strokeEnd = 1.0;
        
        _chartScrollView.contentSize = CGSizeMake(10+_xLabels.count*_xLabelWidth, 31*44);
        _chartScrollView.contentOffset = CGPointMake(10+_xLabels.count*_xLabelWidth - _chartScrollView.frame.size.width, grade * chartCavanHeight);

    }
}

- (void)addPoint:(CGPoint)point index:(NSInteger)index isShow:(BOOL)isHollow value:(CGFloat)value
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(5, 5, 8, 8)];
    view.center = point;
    view.layer.masksToBounds = YES;
    view.layer.cornerRadius = 4;
    view.layer.borderWidth = 1;
    view.layer.borderColor = [UIColor whiteColor].CGColor;//[[_colors objectAtIndex:index] CGColor]?[[_colors objectAtIndex:index] CGColor]:PPGreen.CGColor;
    
    if (isHollow) {
        view.backgroundColor = [UIColor whiteColor];
    }else{
        view.backgroundColor = [_colors objectAtIndex:index]?[_colors objectAtIndex:index]:PPGreen;
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(point.x-PPTagLabelwidth/2.0, point.y+PPLabelHeight*2 < 0 ? point.y+PPLabelHeight : point.y+PPLabelHeight*2, PPTagLabelwidth, PPLabelHeight)];
        label.layer.cornerRadius = PPLabelHeight/2;
        label.layer.borderColor = [[UIColor grayColor] colorWithAlphaComponent:0.5].CGColor;
        label.layer.borderWidth = 2.0f;
        label.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        label.font = [UIFont boldSystemFontOfSize:7];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor whiteColor];
        label.text = [NSString stringWithFormat:@"%d:00",(int)value];
        label.transform = CGAffineTransformMakeRotation(M_PI);

        [_chartScrollView addSubview:label];
    }
    
    [_chartScrollView addSubview:view];
}

- (NSArray *)chartLabelsForX
{
    return [_chartLabelsForX allObjects];
}

#pragma mark - UIScrollView Delegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == _chartScrollView) {
        _xLabelsScrollView.contentOffset = CGPointMake(-scrollView.contentOffset.x, 0);
        _yLabelsScrollView.contentOffset = CGPointMake(0, scrollView.contentOffset.y);
    }
    
    if (scrollView == _xLabelsScrollView) {
        _chartScrollView.contentOffset = CGPointMake(-_xLabelsScrollView.contentOffset.x, _chartScrollView.contentOffset.y);
    }
    
    if (scrollView == _yLabelsScrollView) {
        _chartScrollView.contentOffset = CGPointMake(_chartScrollView.contentOffset.x,  _yLabelsScrollView.contentOffset.y);
    }
}
@end
