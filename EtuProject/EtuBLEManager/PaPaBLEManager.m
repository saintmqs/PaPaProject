//
//  PaPaBLEManager.m
//  EtuProject
//
//  Created by 王家兴 on 16/1/4.
//  Copyright © 2016年 王家兴. All rights reserved.
//

#import "PaPaBLEManager.h"

static PaPaBLEManager *papaBLEManager;

@implementation PaPaBLEManager

@synthesize bleManager;

+(PaPaBLEManager *)shareInstance
{
    if (!papaBLEManager) {
        papaBLEManager = [[PaPaBLEManager alloc] init];
    }
    return papaBLEManager;
}

-(id)init
{
    self = [super init];
    if (self) {
        bleManager = [BLEManager sharedManager];
        [bleManager setBLEDelegate:self];
    }
    return self;
}

#pragma mark - BLEManager Delegate
- (void) BLEManagerConnected//蓝牙已连接
{
    showTip(@"蓝牙已连接");
    [bleManager bindCurrentWristband];
    
    CBPeripheral *peripheral = [[BLEManager sharedManager] getCurrentConnectedPeripheral];
    
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    
    [def setObject:peripheral forKey:kUD_BIND_DEVICE];
    [def synchronize];
}

- (void) BLEManagerDisconnected:(NSError *)error//蓝牙断开连接
{
    
}

- (void) BLEManagerDiscoverNewDevice:(CBPeripheral *)peripheral//发现新设备
{
    
}

- (void) BLEManagerSendDataFailed:(NSError *)error//数据重发3次后仍然失败
{
    
}

- (void) BLEManagerReceiveDataFailed:(NSError *)error//接收数据失败
{
    
}

- (void) BLEManagerOperationFailed:(NSUInteger)errorNo//手环收到命令后操作失败
{
    NSString *errorMsg;
    switch (errorNo) {
            //绑定手环失败
        case WRISTBAND_BIND_FAILED:
        {
            errorMsg = @"绑定手环失败";
        }
            break;
            //解绑手环失败
        case WRISTBAND_UNBUND_FAILED:
        {
            errorMsg = @"解绑手环失败";
        }
            break;
        default:
            break;
    }
    
    showTip(errorMsg);
}

//- (void) BLEManagerHasBalanceData:(NSUInteger)balance;//蓝牙返回钱包余额(以分记)
//- (void) BLEManagerHasExpensesRecord:(NSArray *)record;//蓝牙返回消费记录，每个记录以NSDictionary存储
//- (void) BLEManagerStepTargetAchieved;//达到目标步数消息
//- (void) BLEManagerAlarmClockStopped;//手环闹钟触摸后停止震动
//- (void) BLEManagerHasStepData:(NSArray *)stepData;//蓝牙返回计步信息，每个记录以NSDictionary存储
//- (void) BLEManagerUpdateCurrentSteps:(NSUInteger)steps;//蓝牙返回今天的步数
//- (void) BLEManagerHasSleepData:(NSArray *)sleepData;//蓝牙返回睡眠信息，每个记录以NSDictionary存储
//- (void) BLEManagerUpdateCurrentSleepData:(NSDictionary *)mins;//蓝牙返回今天的睡眠信息
//- (void) BLEManagerHasRemainingBatteryCapacity:(NSUInteger)level;//手环返回电量，暂定返回百分比数值
//- (void) BLEManagerHasSystemInformation:(NSDictionary *)info;//手环系统信息
@end
