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

-(BOOL)blePoweredOn
{
    return _blePoweredOn;
}

#pragma mark - BLEManager Delegate
- (void) BLEManagerCentralManagerStateUpdated:(CBCentralManagerState) state//蓝牙状态更新
{
    NSString *message;
    switch (state) {
        case CBCentralManagerStateUnsupported:
            message = @"The platform/hardware doesn't support Bluetooth Low Energy.";
            break;
        case CBCentralManagerStateUnauthorized:
            message = @"The app is not authorized to use Bluetooth Low Energy.";
            break;
        case CBCentralManagerStatePoweredOff:
            message = @"Bluetooth is currently powered off.";
            break;
        case CBCentralManagerStatePoweredOn:
        {
            message = @"work";
            _blePoweredOn = YES;
        }
            break;
        case CBCentralManagerStateUnknown:
            break;
        default:
            break;
    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(getBLEStatusToDoNext:)]) {
        [_delegate getBLEStatusToDoNext:state];
    }
}

- (void) BLEManagerConnected//蓝牙已连接
{
    showTip(@"蓝牙已连接");
    
    double delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [bleManager getSystemInformation];
        [bleManager getCardID];
    });
    
    
//    NSURL *updateUrl = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"product_test" ofType:@"zip"]];
//    
//    [bleManager setDFUDelegate:self];
//    [bleManager updateFirmware:updateUrl];

    [bleManager bindCurrentWristband]; //绑定当前手环
    [SystemStateManager shareInstance].hasBindWristband = YES;
    
    //本地缓存绑定手环
    CBPeripheral *peripheral = [bleManager getCurrentConnectedPeripheral];
    
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    
    [def setObject:[NSString stringWithFormat:@"%@",peripheral.identifier.UUIDString] forKey:kUD_BIND_DEVICE];
    [def synchronize];
    
    //代理
    if (_delegate && [_delegate respondsToSelector:@selector(PaPaBLEManagerConnected)]) {
        [_delegate PaPaBLEManagerConnected];
    }
}

- (void) BLEManagerDisconnected:(NSError *)error//蓝牙断开连接
{
    showError(error);
}

- (void) BLEManagerDiscoverNewDevice:(CBPeripheral *)peripheral RSSI:(NSNumber *)RSSI;//发现新设备
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
    NSString *errorMsg = [NSString stringWithFormat:@"%ld",errorNo];
    switch (errorNo) {
        case WALLET_GET_BALANCE_FAILED: //获取余额失败
        {
            errorMsg = @"获取余额失败";
        }
            break;
        case WALLET_GET_EXPENSES_FAILED://获取消费记录失败
        {
            errorMsg = @"获取消费记录失败";
        }
            break;
        case WALLET_ADD_BALANCE_FAILED://增加余额
        {
            errorMsg = @"增加余额";
        }
            break;
            
            //运动相关
        case SPORTS_SET_STEPS_FAILED://设置目标步数失败
        {
            errorMsg = @"设置目标步数失败";
        }
            break;
        case SPORTS_GET_DATA_FAILED://获取计步信息失败
        {
            errorMsg = @"获取计步信息失败";
        }
            break;
        case SPORTS_GET_CURRENT_FAILED://获取今天步数失败
        {
            errorMsg = @"获取今天步数失败";
        }
            break;
        case SPROTS_DELETE_DATA_FAILED://删除计步信息失败
        {
            errorMsg = @"删除计步信息失败";
        }
            break;
            
            //睡眠相关
        case SLEEP_GET_DATA_FAILED://获取睡眠信息失败
        {
            errorMsg = @"获取睡眠信息失败";
        }
            break;
        case SLEEP_GET_CURRENT_FAILED://获取今天睡眠时间失败
        {
            errorMsg = @"获取今天睡眠时间失败";
        }
            break;
        case SLEEP_DELETE_DATA_FAILED://删除睡眠信息失败
        {
            errorMsg = @"删除睡眠信息失败";
        }
            break;
            
            //来电和短信
        case PHONE_RING_SHOCK_FAILED://来电手环震动失败
        {
            errorMsg = @"来电手环震动失败";
        }
            break;
        case PHONE_RING_SHOCK_STOP_FAILED://接电话停止震动失败
        {
            errorMsg = @"接电话停止震动失败";
        }
            break;
        case PHONE_MESSAGE_SHOCK_FAILED://短信手环震动失败
        {
            errorMsg = @"短信手环震动失败";
        }
            break;
            
            //时间
        case WRISTBAND_SET_TIME_FAILED://设置手环时间失败
        {
            errorMsg = @"设置手环时间失败";
        }
            break;
            
            //闹钟
        case WRISTBAND_ALARM_CLOCK_FAILED://设置手环闹钟失败
        {
            errorMsg = @"设置手环闹钟失败";
        }
            break;
            
            //电池
        case BATTERTY_REMAINING_CAPACITY_FAILED://获取电池剩余电量失败
        {
            errorMsg = @"获取电池剩余电量失败";
        }
            break;
            
            //绑定和解绑
        case WRISTBAND_BIND_FAILED://绑定手环失败
        {
            errorMsg = @"绑定手环失败";
            [SystemStateManager shareInstance].hasBindWristband = NO;
        }
            break;
        case WRISTBAND_UNBUND_FAILED://解绑手环失败
        {
            errorMsg = @"解绑手环失败";
            [SystemStateManager shareInstance].hasBindWristband = YES;
        }
            
            //系统相关
        case WRISTBAND_UPDATE_FIRMWARE_FAILED://蓝牙通讯固件升级失败
        {
            errorMsg = @"蓝牙通讯固件升级失败";
        }
            break;
        case WRISTBAND_GET_SYSTEM_INFO_FAILED://获取系统信息失败
        {
            errorMsg = @"修改蓝牙名称失败";
        }
            break;
        case WRISTBAND_CHANGE_BLE_NAME_FAILED://修改蓝牙名称失败
        {
            errorMsg = @"修改蓝牙名称失败";
        }
            break;
            
            //卡号
        case WRISTBAND_GET_CARD_ID_FAILED://获取卡号失败
        {
            errorMsg = @"获取卡号失败";
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

- (void) BLEManagerHasRemainingBatteryCapacity:(NSUInteger)level//手环返回电量，暂定返回百分比数值
{
    if (_delegate && [_delegate respondsToSelector:@selector(PaPaBLEManagerHasRemainingBatteryCapacity:)]) {
        [_delegate PaPaBLEManagerHasRemainingBatteryCapacity:level];
    }
}

- (void) BLEManagerHasSystemInformation:(NSDictionary *)info //手环系统信息
{
    self.firmwareInfo = info;
    if (_delegate && [_delegate respondsToSelector:@selector(PaPaBLEManagerHasSystemInformation:)]) {
        [_delegate PaPaBLEManagerHasSystemInformation:info];
    }
}

- (void) BLEManagerHasCardID:(NSString *)cardId//卡号
{
    self.cardId = cardId;
}

#pragma mark - DFU Delegate 
-(void)onDeviceConnected:(CBPeripheral *)peripheral//升级时连接蓝牙成功
{
    NSLog(@"升级时连接蓝牙成功");
}

-(void)onDeviceDisconnected:(CBPeripheral *)peripheral//升级时蓝牙连接断开
{
    NSLog(@"升级时蓝牙连接断开");
    if (_delegate && [_delegate respondsToSelector:@selector(PaPaOnDeviceDisconnected:)]) {
        [_delegate PaPaOnDeviceDisconnected:peripheral];
    }
}

-(void)onDFUStarted//升级开始
{
    showTip(@"升级开始");
    if (_delegate && [_delegate respondsToSelector:@selector(PaPaOnDFUStarted)]) {
        [_delegate PaPaOnDFUStarted];
    }
}

-(void)onDFUCancelled//升级取消
{
    showTip(@"升级取消");
}

-(void)onSoftDeviceUploadStarted//协议栈升级开始
{
    NSLog(@"协议栈升级开始");
}

-(void)onBootloaderUploadStarted//bootloader升级完成
{
    NSLog(@"bootloader升级完成");
}

-(void)onSoftDeviceUploadCompleted//协议栈升级完成
{
    NSLog(@"协议栈升级完成");
}

-(void)onBootloaderUploadCompleted//bootloader升级完成
{
    NSLog(@"bootloader升级完成");
}

-(void)onTransferPercentage:(int)percentage//发送升级文件的百分比数
{
    if (_delegate && [_delegate respondsToSelector:@selector(PaPaOnTransferPercentage:)]) {
        [_delegate PaPaOnTransferPercentage:percentage];
    }
}

-(void)onSuccessfulFileTranferred//发送文件成功(即升级成功)，升级成功后最好等个2，3秒再重连手环
{
    showTip(@"固件升级成功");
    if (_delegate && [_delegate respondsToSelector:@selector(PaPaOnSuccessfulFileTranferred)]) {
        [_delegate PaPaOnSuccessfulFileTranferred];
    }
}

-(void)onError:(NSString *)errorMessage//错误信息
{
    showTip(errorMessage);
}
@end
