//
//  DeviceManagerHeadView.m
//  EtuProject
//
//  Created by 王家兴 on 15/12/7.
//  Copyright © 2015年 王家兴. All rights reserved.
//

#import "DeviceManagerHeadView.h"

@implementation DeviceManagerHeadView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = rgbaColor(0, 155, 232, 1);
        
        _circleView = [[UIImageView alloc] initWithFrame:CGRectMake((mScreenWidth - 160)/2, 10, 160, 160)];
        _circleView.backgroundColor = [UIColor clearColor];
        _circleView.layer.cornerRadius = 80;
        _circleView.layer.borderWidth = 1;
        _circleView.layer.borderColor = [UIColor whiteColor].CGColor;
        [self addSubview:_circleView];
        
        _ElectricalVoltage = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
        _ElectricalVoltage.center = CGPointMake(_circleView.center.x, _circleView.center.y);
        _ElectricalVoltage.textColor = [UIColor whiteColor];
        _ElectricalVoltage.font = [UIFont boldSystemFontOfSize:40];
        _ElectricalVoltage.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_ElectricalVoltage];
        
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:@"00%"];
        [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20] range:NSMakeRange(2, 1)];
        _ElectricalVoltage.attributedText = attrStr;
        
        _msgInfoLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, _circleView.frameBottom + 15, mScreenWidth - 20, 20)];
        _msgInfoLabel.textColor = [UIColor whiteColor];
        _msgInfoLabel.textAlignment = NSTextAlignmentCenter;
        _msgInfoLabel.font = [UIFont systemFontOfSize:13];
        _msgInfoLabel.alpha = 0.8;
        _msgInfoLabel.text = @"距离上次充电已1天";
        [self addSubview:_msgInfoLabel];
        
    }
    return self;
}

@end
