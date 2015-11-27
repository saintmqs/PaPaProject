//
//  HomePageProgressItem.m
//  EtuProject
//
//  Created by 王家兴 on 15/11/27.
//  Copyright © 2015年 王家兴. All rights reserved.
//

#import "HomePageProgressItem.h"

@implementation HomePageProgressItem

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _progressView = [[PPCircularProgressView alloc] initWithFrame:CGRectMake((mScreenWidth - 240)/2, 20, 240, 240)];
        _progressView.progress = 0.4;
        [self addSubview:_progressView];
        
        _innerView = [[PPProgressInnerView alloc] initWithCenterPoint:_progressView.center];
        [self addSubview:_innerView];
    }
    return self;
}

@end
