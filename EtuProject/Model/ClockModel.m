//
//  ClockModel.m
//  EtuProject
//
//  Created by 王家兴 on 16/1/26.
//  Copyright © 2016年 王家兴. All rights reserved.
//

#import "ClockModel.h"

@implementation ClockModel

-(id)init
{
    self = [super init];
    if (self) {
        self.isOn = NO;
        self.y = 1;
        self.w = @"0";
        self.t = @"07:00";
    }
    return self;
}

-(void)setIsOn:(BOOL)isOn
{
    _isOn = isOn;
    
    if (isOn) {
//        [[PaPaBLEManager shareInstance].bleManager setAlarmClock:@{@"y":strFormat(@"%ld",self.y),@"w":self.w,@"t":self.t}];
    }
}
@end
