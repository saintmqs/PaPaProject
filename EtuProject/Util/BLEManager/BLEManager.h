//
//  BLEManager.h
//  BLEManager
//
//  Created by LiuLewis on 15/12/3.
//  Copyright © 2015年 Focalcrest. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

/*删除已同步数据的类型*/
typedef enum _deleteType {
    DELETE_STEP_DATA,
    DELETE_SLEEP_DATA,
} deleteType;

/*操作类型，请勿修改*/
enum _ble_error_Type
{
    //电子钱包命令，还未完善
    WALLET_GET_BALANCE_FAILED = 0x01,//获取余额失败
    WALLET_GET_EXPENSES_FAILED = 0x02,//获取消费记录失败
    WALLET_ADD_BALANCE_FAILED = 0x03,//增加余额
    
    //运动相关
    SPORTS_SET_STEPS_FAILED = 0x10,//设置目标步数失败
    SPORTS_GET_DATA_FAILED = 0x11,//获取计步信息失败
    SPORTS_GET_CURRENT_FAILED = 0x12,//获取今天步数失败
    SPROTS_DELETE_DATA_FAILED = 0x13,//删除计步信息失败
    
    //睡眠相关
    SLEEP_GET_DATA_FAILED = 0x21,//获取睡眠信息失败
    SLEEP_GET_CURRENT_FAILED = 0x22,//获取今天睡眠时间失败
    SLEEP_DELETE_DATA_FAILED = 0x23,//删除睡眠信息失败
    
    //来电和短信
    PHONE_RING_SHOCK_FAILED = 0x30,//来电手环震动失败
    PHONE_RING_SHOCK_STOP_FAILED = 0x31,//接电话停止震动失败
    PHONE_MESSAGE_SHOCK_FAILED = 0x32,//短信手环震动失败
    
    //时间
    WRISTBAND_SET_TIME_FAILED = 0x40,//设置手环时间失败
    
    //闹钟
    WRISTBAND_ALARM_CLOCK_FAILED = 0x50,//设置手环闹钟失败
    
    //电池
    BATTERTY_REMAINING_CAPACITY_FAILED = 0x61,//获取电池剩余电量失败
    
    //绑定和解绑
    WRISTBAND_BIND_FAILED = 0x70,//绑定手环失败
    WRISTBAND_UNBUND_FAILED = 0x73,//解绑手环失败
    
    
    //系统相关
    WRISTBAND_UPDATE_FIRMWARE_FAILED = 0x70,//蓝牙通讯固件升级失败
    WRISTBAND_GET_SYSTEM_INFO_FAILED = 0x71,//获取系统信息失败
    WRISTBAND_CHANGE_BLE_NAME_FAILED = 0x72//修改蓝牙名称失败
    
};

//蓝牙消息代理
@protocol BLEManagerDelegate <NSObject>

@optional
- (void) BLEManagerConnected;//蓝牙已连接
- (void) BLEManagerDisconnected:(NSError *)error;//蓝牙断开连接
- (void) BLEManagerDiscoverNewDevice:(CBPeripheral *)peripheral;//发现新设备
- (void) BLEManagerSendDataFailed:(NSError *)error;//数据重发3次后仍然失败
- (void) BLEManagerReceiveDataFailed:(NSError *)error;//接收数据失败
- (void) BLEManagerOperationFailed:(NSUInteger)errorNo;//手环收到命令后操作失败
- (void) BLEManagerHasBalanceData:(NSUInteger)balance;//蓝牙返回钱包余额(以分记)
- (void) BLEManagerHasExpensesRecord:(NSArray *)record;//蓝牙返回消费记录，每个记录以NSDictionary存储
- (void) BLEManagerStepTargetAchieved;//达到目标步数消息
- (void) BLEManagerAlarmClockStopped;//手环闹钟触摸后停止震动
- (void) BLEManagerHasStepData:(NSArray *)stepData;//蓝牙返回计步信息，每个记录以NSDictionary存储
- (void) BLEManagerUpdateCurrentSteps:(NSUInteger)steps;//蓝牙返回今天的步数
- (void) BLEManagerHasSleepData:(NSArray *)sleepData;//蓝牙返回睡眠信息，每个记录以NSDictionary存储
- (void) BLEManagerUpdateCurrentSleepData:(NSDictionary *)mins;//蓝牙返回今天的睡眠信息
- (void) BLEManagerHasRemainingBatteryCapacity:(NSUInteger)level;//手环返回电量，暂定返回百分比数值
- (void) BLEManagerHasSystemInformation:(NSDictionary *)info;//手环系统信息

@end

/*当前版本打开蓝牙需要调用扫描和连接接口来寻找并连接蓝牙，且断开后不会自动重连。真机测试可在xcode看到打印信息。*/

@interface BLEManager : NSObject <CBCentralManagerDelegate, CBPeripheralDelegate>

+ (BLEManager *) sharedManager;//获取蓝牙管理器唯一对象，首次调用不要和startScan(扫描)在一个函数里调用，因为还未检测蓝牙打开状态。（首次调用要创建对象，所以要注意下，非首次调用不用注意）

- (void) setBLEDelegate:(id<BLEManagerDelegate>) delegate;//设置蓝牙消息代理

- (NSMutableArray *) peripheralList;//获取已搜索到的设备列表，内部数据类型是 CBPeripheral *

- (BOOL) setCurrentPeripheralWithIndex:(NSUInteger) deviceIndex;//设置当前想要连接的外部设备，deviceIndex是设备列表中的位置

- (void) setCurrentPeripheralWithObject:(CBPeripheral *) peripheral;//设置当前想要连接的外部设备，peripheral是当前外部设备对象

- (CBPeripheral *) getCurrentConnectedPeripheral;//获取当前已连接的设备对象

- (void) startScan;//开始扫描,蓝牙没打开直接返回

- (void) stopScan;//结束扫描

- (void) startConnect;//开始连接，已连接会直接返回

- (void) cancelConnect;//断开连接，未连接会直接返回

- (BOOL) blePoweredOn;//蓝牙是否已打开

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

- (void) setAlarmClock:(NSDictionary *) alarm;//设置手环闹钟

- (void) removeSyncedData:(NSUInteger) type;//删除已同步的数据，type是数据类型(睡眠信息，计步信息等)，type类型是deleteType枚举(上面有定义)

- (void) getSystemInformation;//获取系统信息

- (void) updateFirmware;//固件升级（SDK升级未实现）

- (void) changeBLEName:(NSString *)name;//修改蓝牙名称，最长15个字符


@end
