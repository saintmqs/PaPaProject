//
//  ClocksManager.m
//  EtuProject
//
//  Created by 王家兴 on 16/1/26.
//  Copyright © 2016年 王家兴. All rights reserved.
//

#import "ClocksManager.h"

#define CLOCKS_COUNT 3

static ClocksManager *clocksManager;

@implementation ClocksManager

+(ClocksManager *)shareInstance
{
    if (!clocksManager) {
        clocksManager = [[ClocksManager alloc] init];
    }
    return clocksManager;
}

-(id)init
{
    self = [super init];
    if (self) {
        self.clocksArray = [NSMutableArray array];
        for (int i = 0; i < CLOCKS_COUNT; i++) {
            ClockModel *model = [[ClockModel alloc] init];
            [self.clocksArray addObject:model];
        }
    }
    return self;
}
@end;