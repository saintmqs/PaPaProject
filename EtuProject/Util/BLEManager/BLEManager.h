//
//  BLEManager.h
//  BLEManager
//
//  Created by LiuLewis on 15/12/3.
//  Copyright © 2015年 Focalcrest. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "DelegateAndDefinition.h"


/*当前版本打开蓝牙需要调用扫描和连接接口来寻找并连接蓝牙，且断开后不会自动重连。真机测试可在xcode看到打印信息。*/

@interface BLEManager : NSObject 

+ (BLEManager *) sharedManager;//获取蓝牙管理器唯一对象，首次调用不要和startScan(扫描)在一个函数里调用，因为还未检测蓝牙打开状态。（首次调用要创建对象，所以要注意下，非首次调用不用注意）

- (void) setBLEDelegate:(id<BLEManagerDelegate>) delegate;//设置普通蓝牙消息代理，用于接收和发送普通消息

- (void) setDFUDelegate:(id<DFUStatusDelegate>) delegate;//设置升级过程的消息代理，用于接收升级消息

- (NSMutableArray *) peripheralList;//获取已搜索到的设备列表，内部数据类型是 CBPeripheral *

- (BOOL) setCurrentPeripheralWithIndex:(NSUInteger) deviceIndex;//设置当前想要连接的外部设备，deviceIndex是设备列表中的位置

- (void) setCurrentPeripheralWithObject:(CBPeripheral *) peripheral;//设置当前想要连接的外部设备，peripheral是当前外部设备对象

- (CBPeripheral *) getCurrentConnectedPeripheral;//获取当前已连接的设备对象

- (void) startScan;//开始扫描,蓝牙没打开直接返回

- (void) stopScan;//结束扫描

- (void) startConnect;//开始连接，已连接会直接返回

- (void) cancelConnect;//断开连接，未连接会直接返回

- (BOOL) connected;//蓝牙是否已连接

//下面的持续开发中,未标注的表明SDK已完成

- (void) bindCurrentWristband;//绑定当前手环

- (void) unbindCurrentWristband;//解绑当前手环

- (void) getRemainingBatteryCapacity;//获取电池剩余电量

- (void) setWristbandTime:(int32_t) timestamp;//设置手环时间,负数直接返回

- (void) getBalance;//获取余额

- (void) getExpensesRecord;//获取消费记录

- (void) addBalance: (int32_t)value;//增加余额

- (void) setStepTarget:(int32_t) steps;//设置目标步数,负数直接返回

- (void) getCurrentStepData;//获取今天已有的计步信息

- (void) getStepData;//获取计步信息

- (void) getCurrentSleepingData;//获取今天已有的睡眠信息

- (void) getSleepingData;//获取睡眠信息

- (void) startPhoneRingShock;//来电手环震动

- (void) stopPhoneRingShock;//接电话停止手环震动

- (void) startMessageShock;//消息手环震动

- (void) addAlarmClock:(NSDictionary *) alarm;//增加手环闹钟

- (void) removeAlarmClock:(int32_t) index;//删除手环闹钟（0-9共10个闹钟）

- (void) enableAlarmClock:(int32_t)index enableStatus:(BOOL)enable;//打开或者关闭手环闹钟（false关闭，true打开）

- (void) removeSyncedData:(NSUInteger) type;//删除已同步的数据，type是数据类型(睡眠信息，计步信息等)，type类型是deleteType枚举(上面有定义)

- (void) getSystemInformation;//获取系统信息

- (void) getCardID;//获取公交卡号

//- (void) getMACAddress;//获取手环MAC地址，目前影响app升级，暂时不用

- (void) updateFirmware:(NSURL *)url;//固件升级,升级过程中再次调用该接口会取消升级（取消升级后会断开连接，app可以选择是否再次连接）

- (void) changeBLEName:(NSString *)name;//修改蓝牙名称，最长15个字符 

@end
