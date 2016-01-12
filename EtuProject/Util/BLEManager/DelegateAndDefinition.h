//
//  DelegateAndDefinition.h
//  BLEManager
//
//  Created by LiuLewis on 16/1/7.
//  Copyright © 2016年 Focalcrest. All rights reserved.
//

#ifndef DelegateAndDefinition_h
#define DelegateAndDefinition_h

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
    WRISTBAND_BIND_FAILED = 0x73,//绑定手环失败
    WRISTBAND_UNBUND_FAILED = 0x74,//解绑手环失败
    
    
    //系统相关
    WRISTBAND_UPDATE_FIRMWARE_FAILED = 0x70,//蓝牙通讯固件升级失败
    WRISTBAND_GET_SYSTEM_INFO_FAILED = 0x71,//获取系统信息失败
    WRISTBAND_CHANGE_BLE_NAME_FAILED = 0x72,//修改蓝牙名称失败
    
    //卡号
    WRISTBAND_GET_CARD_ID_FAILED = 0x81,//获取卡号失败
    
};

//蓝牙消息代理
@protocol BLEManagerDelegate <NSObject>

- (void) BLEManagerCentralManagerStateUpdated:(CBCentralManagerState) state;//蓝牙状态更新
- (void) BLEManagerConnected;//蓝牙已连接(此时还不能进行读写操作)
- (void) BLEManagerReadyToReadAndWrite;//蓝牙可进行读写操作
- (void) BLEManagerDisconnected:(NSError *)error;//蓝牙断开连接
- (void) BLEManagerDiscoverNewDevice:(CBPeripheral *)peripheral RSSI:(NSNumber *)RSSI;//发现新设备
- (void) BLEManagerFirmwaerInBootloaderMode;//手环处于bootloader模式，此时只能升级，无法获取信息。
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
- (void) BLEManagerHasCardID:(NSString *)cardId;//卡号

@end


//升级消息代理
@protocol DFUStatusDelegate <NSObject>

-(void)onDeviceConnected:(CBPeripheral *)peripheral;//升级时连接蓝牙成功
-(void)onDeviceDisconnected:(CBPeripheral *)peripheral;//升级时蓝牙连接断开
-(void)onDFUStarted;//升级开始
-(void)onDFUCancelled;//升级取消
-(void)onSoftDeviceUploadStarted;//协议栈升级开始
-(void)onBootloaderUploadStarted;//bootloader升级完成
-(void)onSoftDeviceUploadCompleted;//协议栈升级完成
-(void)onBootloaderUploadCompleted;//bootloader升级完成
-(void)onTransferPercentage:(int)percentage;//发送升级文件的百分比数
-(void)onSuccessfulFileTranferred;//发送文件成功(即升级成功)，升级成功后最好等个2，3秒再重连手环
-(void)onError:(NSString *)errorMessage;//错误信息

@end


#endif /* DelegateAndDefinition_h */
