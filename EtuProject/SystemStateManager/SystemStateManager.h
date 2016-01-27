//
//  SystemStateManager.h
//  EtuProject
//
//  Created by 王家兴 on 16/1/3.
//  Copyright © 2016年 王家兴. All rights reserved.
//

#import <Foundation/Foundation.h>
@import CoreTelephony;

@interface SystemStateManager : NSObject

@property (nonatomic, strong) BaseViewController *activeController; //当前活跃的controller, 应用后台挂起后做临时缓存

@property (nonatomic, assign) BOOL  isFirstBindWristband; //第一次绑定手环
@property (nonatomic, assign) BOOL  hasBindWristband;  //是否绑定了手环；

@property (nonatomic, strong) NSString *bindUUID;

@property (nonatomic, strong) CTCallCenter *callCenter;

@property (nonatomic, assign) BOOL isSyningData;    //正在同步数据

@property (nonatomic, assign) BOOL isRingShake;     //是否来电震动

+(SystemStateManager *)shareInstance;

@end
