//
//  SystemStateManager.h
//  EtuProject
//
//  Created by 王家兴 on 16/1/3.
//  Copyright © 2016年 王家兴. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^versionBlock)(void);

@import CoreTelephony;

@interface SystemStateManager : NSObject

@property (nonatomic, strong) BaseViewController *activeController; //当前活跃的controller, 应用后台挂起后做临时缓存

@property (nonatomic, assign) BOOL  hasBindWristband;  //是否绑定了手环；

@property (nonatomic, strong) NSString *bindUUID;

@property (nonatomic, strong) CTCallCenter *callCenter;

@property (nonatomic, assign) BOOL isUpdatingFirmware; //正在升级固件

@property (nonatomic, assign) BOOL isSyningData;    //正在同步数据

@property (nonatomic, assign) BOOL isRingShake;     //是否来电震动

@property (nonatomic, strong) NSString *appDownloadUrl; //应用下载页面链接

+(SystemStateManager *)shareInstance;

-(void)appVersionNeedUpdate:(versionBlock)updateBlock
            isLatestVersion:(versionBlock)isLatestBlock
         checkVersionFailed:(versionBlock)failedBlock;
@end
