//
//  SystemStateManager.m
//  EtuProject
//
//  Created by 王家兴 on 16/1/3.
//  Copyright © 2016年 王家兴. All rights reserved.
//

#import "SystemStateManager.h"

static SystemStateManager *systemStateManager;

@implementation SystemStateManager

+(SystemStateManager *)shareInstance
{
    if (!systemStateManager) {
        systemStateManager = [[SystemStateManager alloc] init];
    }
    return systemStateManager;
}

@end
