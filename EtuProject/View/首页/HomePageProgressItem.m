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
        
        CGFloat radius;
        CGFloat frameY;
        if (!iPhone4) {
            frameY = 20;
            radius = 270;
        }
        else
        {
            frameY = 0;
            radius = 220;
        }
        
        _progressView = [[PPCircularProgressView alloc] initWithFrame:CGRectMake((mScreenWidth - radius)/2, frameY, radius, radius)];
        [self addSubview:_progressView];
        
        _innerView = [[PPProgressInnerView alloc] initWithCenterPoint:_progressView.center];
        [self addSubview:_innerView];
    }
    return self;
}

@end
