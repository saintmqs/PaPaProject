//
//  SystemStateManager.h
//  EtuProject
//
//  Created by 王家兴 on 16/1/3.
//  Copyright © 2016年 王家兴. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SystemStateManager : NSObject

@property (nonatomic, strong) BaseViewController *activeController; //当前活跃的controller, 应用后台挂起后做临时缓存

@property (nonatomic, assign) BOOL  hasBindWristband;  //是否绑定了手环；

+(SystemStateManager *)shareInstance;

@end
