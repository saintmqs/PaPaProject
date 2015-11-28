//
//  PPProgressInnerView.m
//  EtuProject
//
//  Created by 王家兴 on 15/11/27.
//  Copyright © 2015年 王家兴. All rights reserved.
//

#import "PPProgressInnerView.h"

#define selfWidth 140;
#define selfHeight 140;

@implementation PPProgressInnerView

-(id)initWithCenterPoint:(CGPoint)centerPoint;
{
    self = [super init];
    if (self) {
        
        CGRect selfFrame = self.frame;
        selfFrame.size.width = selfWidth;
        selfFrame.size.height = selfHeight;
        self.frame = selfFrame;
        
        self.center = centerPoint;
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frameWidth, 30)];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.font = [UIFont systemFontOfSize:16];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_titleLabel];
        
        _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _titleLabel.frameBottom + 10, self.frameWidth, 60)];
        _contentLabel.textColor = [UIColor whiteColor];
        _contentLabel.font = [UIFont boldSystemFontOfSize:45];
        _contentLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_contentLabel];
        
        _detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _contentLabel.frameBottom + 10, self.frameWidth, 30)];
        _detailLabel.textColor = [UIColor whiteColor];
        _detailLabel.font = [UIFont systemFontOfSize:14];
        _detailLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_detailLabel];
        
    }
    return self;
}

@end
