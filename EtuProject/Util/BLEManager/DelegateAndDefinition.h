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

/*操作命令类型*/
enum _packetCmdType
{
    COMMAND_NULL = 0x00,
    //电子钱包命令，还未完善
    WALLET_GET_BALANCE = 0x01,//获取余额
    WALLET_GET_EXPENSES = 0x02,//获取消费记录
    WALLET_ADD_BALANCE = 0x03,//增加余额
    
    //运动相关
    SPORTS_SET_STEPS = 0x10,//设置目标步数
    SPORTS_GET_DATA = 0x11,//获取计步信息
    SPORTS_GET_CURRENT = 0x12,//获取今天步数
    SPROTS_DELETE_DATA = 0x13,//删除计步信息
    
    //睡眠相关
    SLEEP_GET_DATA = 0x21,//获取睡眠信息
    SLEEP_GET_CURRENT = 0x22,//获取今天睡眠时间
    SLEEP_DELETE_DATA= 0x23,//删除睡眠信息
    
    //来电和短信
    PHONE_RING_SHOCK = 0x30,//来电手环震动
    PHONE_RING_SHOCK_STOP = 0x31,//接电话停止震动
    PHONE_MESSAGE_SHOCK = 0x32,//短信手环震动
    
    //时间
    WRISTBAND_SET_TIME = 0x40,//设置手环时间
    
    //闹钟
    WRISTBAND_ALARM_CLOCK_ADD = 0x50,//增加手环闹钟
    WRISTBAND_ALARM_CLOCK_REMOVE = 0x51,//删除手环闹钟
    WRISTBAND_ALARM_CLOCK_ENABLE = 0x52,//设置手环闹钟可用或者不可用
    
    //电池
    BATTERTY_REMAINING_CAPACITY = 0x61,//获取电池剩余电量
    
    //绑定和解绑
    WRISTBAND_BIND = 0x70,//绑定手环
    WRISTBAND_UNBUND = 0x73,//解绑手环
    
    
    //系统相关
    WRISTBAND_UPDATE_FIRMWARE = 0x80,//蓝牙通讯固件升级
    WRISTBAND_GET_SYSTEM_INFO = 0x81,//获取系统信息
    WRISTBAND_CHANGE_BLE_NAME = 0x82,//修改蓝牙名称
    
    //卡号
    WRISTBAND_GET_CARD_ID = 0x91,//获取卡号
    WRISTBAND_GET_MAC_ADDR = 0x92,//获取MAC地址
    
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
- (void) BLEManagerOperationSucceed:(NSUInteger)cmdNo;//手环收到命令后操作成功
- (void) BLEManagerOperationFailed:(NSUInteger)cmdNo;//手环收到命令后操作失败
- (void) BLEManagerOperationTimeout:(NSUInteger)cmdNo;//手环收到命令后10s(暂定，获取计步、睡眠和消费记录是20s)未返回消息
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
- (void) BLEManagerHasCardID:(NSString *)cardID;//卡号
//- (void) BLEManagerHasMACAddress:(NSString *)macAddr;//MAC地址,暂不用

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
