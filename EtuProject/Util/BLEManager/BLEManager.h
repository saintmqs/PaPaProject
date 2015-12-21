//
//  BLEManager.h
//  BLEManager
//
//  Created by LiuLewis on 15/12/3.
//  Copyright © 2015年 Focalcrest. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

//蓝牙消息代理
@protocol BLEManagerDelegate <NSObject>

- (void) BLEManagerConnected;//蓝牙已连接
- (void) BLEManagerDisconnected:(NSError *)error;//蓝牙断开连接
- (void) BLEManagerHasBalanceData:(NSDictionary *)balance;//蓝牙返回钱包余额
- (void) BLEManagerHasExpensesRecord:(NSArray *)record;//蓝牙返回消费记录，每个记录以NSDictionary存储
- (void) BLEManagerStepTargetAchieved;//达到目标步数消息
- (void) BLEManagerAlarmClockStopped;//手环闹钟触摸后停止震动
- (void) BLEManagerHasStepData:(NSArray *)stepData;//蓝牙返回计步信息，每个记录以NSDictionary存储
- (void) BLEManagerHasSleepData:(NSArray *)sleepData;//蓝牙返回睡眠信息，每个记录以NSDictionary存储
- (void) BLEManagerHasRemainingBatteryCapacity:(NSUInteger)level;//手环返回电量，暂定返回百分比数值
- (void) BLEManagerHasFirmwareVersion:(NSString *)version;//手环返回固件版本

@end
/*当前是测试版本，打开蓝牙，开始扫描后会直接连接第一个扫描到的包含服务“serviceUUID”和特征“serviceUUID”的设备
  ，然后打印出接收到的消息。
  真机测试可在xcode看到打印信息。
 */

@interface BLEManager : NSObject <CBCentralManagerDelegate, CBPeripheralDelegate>

+ (BLEManager *) sharedManager;//蓝牙管理器对象

- (void) setBLEDelegate:(id<BLEManagerDelegate>) delegate;//设置蓝牙消息代理

- (NSMutableArray *) peripheralList;//获取已搜索到的设备列表，内部数据类型是 CBPeripheral *

- (BOOL) setCurrentPeriPheral:(NSUInteger) deviceIndex;//设置当前想要连接的外部设备，deviceIndex是设备列表中的位置

- (CBPeripheral *) getCurrentConnectedPeripheral;//获取当前已连接的设备对象

- (void) startScan;//开始扫描

- (void) stopScan;//结束扫描

- (void) startConnect;//开始连接

- (void) cancelConnect;//断开连接

- (BOOL) connected;//蓝牙是否已连接

//下面的还没实现

- (void) bindCurrentWristband:(NSString *)uuid;//绑定当前手环

- (void) getRemainingBatteryCapacity;//获取电池剩余电量

- (void) setWristbandTime:(NSInteger) timestamp;//设置手环时间

- (void) getBalance;//获取余额

- (void) getExpensesRecord;//获取消费记录

- (void) addBalance: (float)value;//增加余额

- (void) setStepTarget:(NSUInteger) steps;//设置目标步数

- (void) getStepData;//获取计步信息

- (void) getSleepingData;//获取睡眠信息

- (void) startPhoneRingShock;//来电手环震动

- (void) stopPhoneRingShock;//接电话停止手环震动

- (void) startMessageShock;//消息手环震动

- (void) setAlarmClock:(NSDictionary *) alarm;//设置手环闹钟

- (void) timeSynchronization;//时间同步

- (void) removeSyncedData:(NSUInteger) type;//删除已同步的数据，type是数据类型(睡眠信息，计步信息等)，type暂未定义

- (void) getFirmwareVersion;//获取固件版本

- (void) updateFirmware;//固件升级


@end
