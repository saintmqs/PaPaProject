//
//  PaPaSynchronousDataView.m
//  EtuProject
//
//  Created by 王家兴 on 16/1/11.
//  Copyright © 2016年 王家兴. All rights reserved.
//

#import "PaPaSynchronousDataView.h"

@implementation PaPaSynchronousDataView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _progressIndicator = [[AMPActivityIndicator alloc] initWithFrame:CGRectMake((mScreenWidth - 40)/2, 10, 40, 40)];
        [_progressIndicator setBarColor:rgbaColor(0, 155, 232, 1)];
        [_progressIndicator setBarWidth:8.0f];
        [_progressIndicator setBarHeight:8.0f];
        [_progressIndicator setAperture:20.0f];
        [self addSubview:_progressIndicator];
        
        _progressLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 35, 15)];
        _progressLabel.center = _progressIndicator.center;
        _progressLabel.font = [UIFont systemFontOfSize:10];
        _progressLabel.textAlignment = NSTextAlignmentCenter;
        _progressLabel.textColor = [UIColor grayColor];
        [self addSubview:_progressLabel];
        
        UILabel *description = [[UILabel alloc] initWithFrame:CGRectMake((mScreenWidth - 40)/2, _progressIndicator.frameBottom + 5, 40, 10)];
        description.textColor = [UIColor grayColor];
        description.font = [UIFont systemFontOfSize:8];
        description.textAlignment = NSTextAlignmentCenter;
        description.text = @"同步数据";
        [self addSubview:description];
    }
    return self;
}
@end
