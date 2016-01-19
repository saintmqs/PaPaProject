//
//  PPLineChart.m
//  EtuProject
//
//  Created by 王家兴 on 15/12/1.
//  Copyright © 2015年 王家兴. All rights reserved.
//

#import "PPLineChart.h"
#import "PPColor.h"
#import "PPChartLabel.h"


@implementation PPLineChart {
    NSHashTable *_chartLabelsForX;
    
    NSInteger lineYCount;
    NSInteger lineXCount;
    
    NSInteger selectTag;
    NSMutableArray *allpoints;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.clipsToBounds = YES;
        
        allpoints = [NSMutableArray array];
        
        _yLabelsScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 50, self.bounds.size.height - PPLabelHeight)];
        _yLabelsScrollView.delegate = self;
        _yLabelsScrollView.transform = CGAffineTransformMakeRotation(M_PI);
        [self addSubview:_yLabelsScrollView];
        
        _chartScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(50, 0, self.bounds.size.width - 60, self.bounds.size.height - PPLabelHeight)];
        _chartScrollView.delegate = self;
        _chartScrollView.transform = CGAffineTransformMakeRotation(M_PI);
        _chartScrollView.showsHorizontalScrollIndicator = NO;
        _chartScrollView.showsVerticalScrollIndicator = NO;
        _chartScrollView.pagingEnabled = YES;
        
        _chartScrollView.mj_footer = [MJRefreshBackFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
        [self addSubview:_chartScrollView];
        
        _xLabelsScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(50, _chartScrollView.frame.size.height +5, self.bounds.size.width - 60 , PPLabelHeight)];
        _xLabelsScrollView.delegate = self;
        _xLabelsScrollView.userInteractionEnabled = NO;
        _xLabelsScrollView.transform = CGAffineTransformMakeRotation(M_PI);
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

    float level = (_yValueMax-_yValueMin) /self.rows;
    CGFloat chartCavanHeight = self.frame.size.height - PPLabelHeight*self.rows/3;
    CGFloat levelHeight = 44;// chartCavanHeight /7.0;

    
    switch (self.chartType) {
        case SPORT_TYPE:
            lineYCount = 30;
            break;
        case SLEEP_TYPE:
            lineYCount = 24;
            break;
        default:
            break;
    }
    _yLabelsScrollView.contentSize =CGSizeMake(50, lineYCount*levelHeight+5);

    for (int i=0; i<lineYCount+1; i++) {
        PPChartLabel * label = [[PPChartLabel alloc] initWithFrame:CGRectMake(0.0,_yLabelsScrollView.contentSize.height - i*levelHeight, PPYLabelwidth, PPLabelHeight)];
//        label.backgroundColor = [UIColor yellowColor];
        switch (self.chartType) {
            case SPORT_TYPE:
            {
                label.text = strFormat(@"%d",(int)(level * (lineYCount - i)+_yValueMin)*1000);
            }
                break;
            case SLEEP_TYPE:
            {
                label.text = strFormat(@"%d小时",(int)(level * (lineYCount - i)+_yValueMin));
            }
                break;
            default:
                break;
        }

//		label.text = [NSString stringWithFormat:@"%.2f"];
        label.transform = CGAffineTransformMakeRotation(M_PI);
		[_yLabelsScrollView addSubview:label];
    }
    
    if ([super respondsToSelector:@selector(setMarkRange:)]) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(PPYLabelwidth, (1-(_markRange.max-_yValueMin)/(_yValueMax-_yValueMin))*chartCavanHeight+PPLabelHeight, self.frame.size.width-PPYLabelwidth, (_markRange.max-_markRange.min)/(_yValueMax-_yValueMin)*chartCavanHeight)];
        view.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.1];
        [_yLabelsScrollView addSubview:view];
    }

    //画横线
    for (int i=0; i<lineYCount + 1; i++) {
        if ([_ShowHorizonLine[i] integerValue]>0) {
            
            CAShapeLayer *shapeLayer = [CAShapeLayer layer];
            UIBezierPath *path = [UIBezierPath bezierPath];
            [path moveToPoint:CGPointMake(-200,PPLabelHeight + i*levelHeight)];
            [path addLineToPoint:CGPointMake(10+_xLabels.count*_xLabelWidth+mScreenWidth,PPLabelHeight + i*levelHeight)];
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
        PPChartLabel * label = [[PPChartLabel alloc] initWithFrame:CGRectMake(i * _xLabelWidth, 0, _xLabelWidth, PPLabelHeight)];
        label.numberOfLines = 0;
        label.lineBreakMode = NSLineBreakByCharWrapping;
        label.transform = CGAffineTransformMakeRotation(M_PI);
        label.text = labelText;
        [_xLabelsScrollView addSubview:label];
        
        [_chartLabelsForX addObject:label];
        
        _xLabelsScrollView.contentSize = CGSizeMake(i * _xLabelWidth, PPLabelHeight);

    }
    
    //画竖线
    for (int i=0; i<xLabels.count+15; i++) {
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
    [allpoints removeAllObjects];
    for (int i=0; i<_yValues.count; i++) {
        NSArray *childAry = _yValues[i];
        if (childAry.count==0) {
            return;
        }
        //获取最大最小位置
        CGFloat max = [childAry[0] floatValue];
        CGFloat min = [childAry[0] floatValue];
        NSInteger max_i = 0;
        NSInteger min_i = 0;
        
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
        CGFloat xPosition = 20;//_xLabels.count*_xLabelWidth - _xLabelWidth;
        CGFloat chartCavanHeight =  self.frame.size.height - PPLabelHeight*self.rows/3;
        
        float grade = ((float)firstValue-_yValueMin) / ((float)_yValueMax-_yValueMin);
        NSLog(@"grade = %f",grade);
        
        NSInteger index = 0;
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
                   tag:index
                 index:i
                isShow:NO
                 value:firstValue];

        
        [progressline moveToPoint:CGPointMake(xPosition,  grade * chartCavanHeight + PPLabelHeight)];
        [progressline setLineWidth:1.0];
        [progressline setLineCapStyle:kCGLineCapRound];
        [progressline setLineJoinStyle:kCGLineJoinRound];
        for (NSString * valueString in childAry) {
            
            float grade =([valueString floatValue]-_yValueMin) / ((float)_yValueMax-_yValueMin);
            NSLog(@"grade = %f",grade);

            if (index != 0) {
                
                CGPoint point = CGPointMake(xPosition+index*_xLabelWidth,   grade * chartCavanHeight + PPLabelHeight);
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
                [self addPoint:point tag:index
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
        pathAnimation.duration = childAry.count*0;
        pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        pathAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
        pathAnimation.toValue = [NSNumber numberWithFloat:1.0f];
        pathAnimation.autoreverses = NO;
        [_chartLine addAnimation:pathAnimation forKey:@"strokeEndAnimation"];
        
        _chartLine.strokeEnd = 1.0;
        
        CGFloat contentWidth = 10+_xLabels.count*_xLabelWidth;
        if (contentWidth < _chartScrollView.frameWidth) {
            contentWidth = _chartScrollView.frameWidth + 10;
        }
        
        CGFloat offsetX = contentWidth - _chartScrollView.frameWidth;
        if (offsetX < 0) {
            offsetX = 15;
        }
        
        _chartScrollView.contentSize = CGSizeMake(contentWidth, (lineYCount+1)*44);
        _chartScrollView.contentOffset = CGPointMake(offsetX, grade * chartCavanHeight -10);
    }
}

- (void)addPoint:(CGPoint)point tag:(NSInteger)tag index:(NSInteger)index isShow:(BOOL)isHollow value:(CGFloat)value
{
    UIButton *view = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 13, 13)];
    
    view.tag = 1000+tag;
    view.center = point;
    view.layer.masksToBounds = YES;
//    view.layer.cornerRadius = 4;
//    view.layer.borderWidth = 1;
//    view.layer.borderColor = [UIColor whiteColor].CGColor;//[[_colors objectAtIndex:index] CGColor]?[[_colors objectAtIndex:index] CGColor]:PPGreen.CGColor;
    [view setImage:[UIImage imageNamed:@"sportpoint"] forState:UIControlStateNormal];
    [view setImage:[UIImage imageNamed:@"point_select"] forState:UIControlStateSelected];
    addBtnAction(view, @selector(selectPoint:));
    
    if (isHollow) {
//        view.backgroundColor = [UIColor whiteColor];
        [view setImage:[UIImage imageNamed:@"sportpoint"] forState:UIControlStateNormal];
    }else{
        [view setImage:[UIImage imageNamed:@"sportpoint"] forState:UIControlStateNormal];
//        view.backgroundColor = [_colors objectAtIndex:index]?[_colors objectAtIndex:index]:PPGreen;
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(point.x-PPTagLabelwidth/2.0, point.y+12*2 < 0 ? point.y+12 : point.y+12*2, PPTagLabelwidth, 12)];
        label.layer.cornerRadius = 12/2;
        label.layer.borderColor = [[UIColor grayColor] colorWithAlphaComponent:0.5].CGColor;
        label.layer.borderWidth = 2.0f;
        label.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        label.font = [UIFont boldSystemFontOfSize:7];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor whiteColor];
        label.text = [NSString stringWithFormat:@"%.2f",value];
        label.transform = CGAffineTransformMakeRotation(M_PI);
        label.layer.masksToBounds = YES;

        [_chartScrollView addSubview:label];
    }
    
    [_chartScrollView addSubview:view];
    
    [allpoints addObject:view];
}

- (NSArray *)chartLabelsForX
{
    return [_chartLabelsForX allObjects];
}

-(void)coordinatesCorrection
{
//    _xLabelsScrollView.contentOffset = CGPointMake(-_chartScrollView.contentOffset.x, 0);
}

-(void)loadMoreData
{
    if (_delegate && [_delegate respondsToSelector:@selector(PPLineChartLoadNext)]) {
        [_delegate PPLineChartLoadNext];
    }
}

-(void)selectPoint:(UIButton *)pointButton
{
    pointButton.selected = YES;
    selectTag = pointButton.tag;
    
    for (UIButton *button in allpoints) {
        if (button.tag != selectTag) {
            button.selected = NO;
        }
    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(PPLineSelectPointAtIndex:)]) {
        [_delegate PPLineSelectPointAtIndex:pointButton.tag - 1000];
    }
}

#pragma mark - UIScrollView Delegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == _chartScrollView) {
        
        _xLabelsScrollView.contentOffset = CGPointMake(scrollView.contentOffset.x, 0);
        _yLabelsScrollView.contentOffset = CGPointMake(0, scrollView.contentOffset.y);
    }
//
//    if (scrollView == _xLabelsScrollView) {
//        _xLabelsScrollView.contentOffset = CGPointMake(scrollView.contentOffset.x, scrollView.contentOffset.y);
////        _chartScrollView.contentOffset = CGPointMake(-_xLabelsScrollView.contentOffset.x, _chartScrollView.contentOffset.y);
//    }
//    
    if (scrollView == _yLabelsScrollView) {
        _chartScrollView.contentOffset = CGPointMake(_chartScrollView.contentOffset.x,  _yLabelsScrollView.contentOffset.y);
    }
}
@end
