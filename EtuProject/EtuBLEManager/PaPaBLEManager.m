//
//  PaPaBLEManager.m
//  EtuProject
//
//  Created by 王家兴 on 16/1/4.
//  Copyright © 2016年 王家兴. All rights reserved.
//

#import "PaPaBLEManager.h"

static PaPaBLEManager *papaBLEManager;

#define DOWNLOAD_ZIP_PATH [NSHomeDirectory() stringByAppendingString:@"/Documents/bandUpdate.zip"]

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
        
        self.balance = @"0.00元";
        
        self.updateType = 1;
    }
    return self;
}

-(BOOL)blePoweredOn
{
    return _blePoweredOn;
}

-(void)getUpDateFirmwareFromServer:(PaPaBLEUploadDownloadSuccessBlock)successBlock
                            failed:(PaPaBLEUploadDownloadFailedBlock)failedBlock
{
    [self startRequestWithDict:bandversion() completeBlock:^(ASIHTTPRequest *request, NSDictionary *dict, NSError *error)
    {
        if (!error) {
            successBlock([dict objectForKey:@"data"]);
        }
        else
        {
            failedBlock(error);
        }
    } url:kRequestUrl(@"version", @"bandversion")];
}

#pragma mark 升级固件
-(void)updateFirmware:(NSDictionary *)info isLastestVersion:(LatestBlock)lastestblock;
{
    [self getUpDateFirmwareFromServer:^(NSDictionary *data) {
        NSString *version = [data objectForKey:@"version"];
        NSString *updateUrl = [data objectForKey:@"downloadurl"];
        
        NSString *type = [data objectForKey:@"type"];
        self.updateType = [type integerValue];
        
        NSString *firmVersion = [info objectForKey:@"f"];
        
        [MBProgressHUD hideHUD];
        
        if ([firmVersion doubleValue] < [version doubleValue]) {
            
            [MBProgressHUD showMessage:@"正在下载最新固件包..."];
            
            [self downloadFileWithOption:bandversion() withInferface:updateUrl savedPath:DOWNLOAD_ZIP_PATH downloadSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                
                [MBProgressHUD hideHUD];
                
                [MBProgressHUD showMessage:@"准备固件升级..."];
                
                [bleManager setDFUDelegate:self];
                
                if (self.updateType == 1) {
                    [bleManager updateFirmware:[NSURL URLWithString:DOWNLOAD_ZIP_PATH] FileType:UPGRADE_TYPE_APPLICATION];
                }
                else
                {
                    [bleManager updateFirmware:[NSURL URLWithString:[[SystemStateManager shareInstance] getFileDirectoryPath:@"new/boot.zip"]] FileType:UPGRADE_TYPE_BOTH_SOFTDEVICE_BOOTLOADER];
                    isBootUpdating = YES;
                    isBootUpdated = NO;
                }                
            } downloadFailure:^(AFHTTPRequestOperation *operation, NSError *error) {
                
                [MBProgressHUD hideHUD];
                
                [MBProgressHUD showError:@"固件包下载失败"];
                
            } progress:^(float progress) {
                
            }];
        }
        else
        {
            lastestblock();
            [MBProgressHUD showSuccess:@"固件版本已经是最新版本"];
        }
        
    } failed:^(NSError *error) {
        
    }];
    
}

#pragma mark - BLEManager Delegate
#pragma mark 蓝牙状态更新
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

#pragma mark 蓝牙已连接
- (void) BLEManagerConnected//蓝牙已连接(此时还不能进行读写操作)
{
    showTip(@"蓝牙已连接");
}

#pragma mark 蓝牙可进行读写操作
- (void) BLEManagerReadyToReadAndWrite//蓝牙可进行读写操作
{
    //先执行绑定操作
    CBPeripheral *peripheral = [bleManager getCurrentConnectedPeripheral];
    if (![peripheral.identifier.UUIDString isEqualToString:[SystemStateManager shareInstance].bindUUID]) {
        [bleManager bindCurrentWristband]; //绑定当前手环
        [SystemStateManager shareInstance].hasBindWristband = YES;
        
        //本地缓存绑定手环
        NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
        
        [def setObject:[NSString stringWithFormat:@"%@",peripheral.identifier.UUIDString] forKey:kUD_BIND_DEVICE];
        [def synchronize];
        
        [SystemStateManager shareInstance].bindUUID = peripheral.identifier.UUIDString;
    }
    else
    {
        [bleManager getSystemInformation]; //获取系统信息
        
        NSLog(@"%s delegate = %@", __func__,_delegate);
        //代理
        if (_delegate && [_delegate respondsToSelector:@selector(PaPaBLEManagerConnected)]) {
            [_delegate PaPaBLEManagerConnected];
        }
    }
    
    
}

#pragma mark 蓝牙断开连接
- (void) BLEManagerDisconnected:(NSError *)error//蓝牙断开连接
{
    showTip(@"蓝牙失去连接");
    
    if (_delegate && [_delegate respondsToSelector:@selector(PaPaBLEManagerDisconnected:)]) {
        [_delegate PaPaBLEManagerDisconnected:error];
    }
    
    //发起重连扫描
    if ([SystemStateManager shareInstance].hasBindWristband) {
        [bleManager startScan];
    }
}

#pragma mark 发现新设备
- (void) BLEManagerDiscoverNewDevice:(CBPeripheral *)peripheral RSSI:(NSNumber *)RSSI//发现新设备
{
    if (isBootUpdated && !isApplicationUpdated) {
//        if ([peripheral.identifier.UUIDString isEqualToString:[SystemStateManager shareInstance].bindUUID]) {
//            
//        }
        [bleManager setCurrentPeripheralWithObject:peripheral];
        [bleManager startConnect];
        return;
    }
    
    //发现新设备若和绑定手环Idenifier匹配一致自动连接手环
    if ([peripheral.identifier.UUIDString isEqualToString:[SystemStateManager shareInstance].bindUUID]) {
        [bleManager setCurrentPeripheralWithObject:peripheral];
        [bleManager startConnect];
    }
}

#pragma mark 手环处于bootloader模式，此时只能升级，无法获取信息
- (void) BLEManagerFirmwaerInBootloaderMode//手环处于bootloader模式，此时只能升级，无法获取信息。
{
    [MBProgressHUD hideHUD];
    
    [MBProgressHUD showMessage:@"您的手环需要升级固件"];
    
    if (!isApplicationUpdated) {
        [SystemStateManager shareInstance].hasBindWristband = YES;
        [APP_DELEGATE loginSuccess];
    }
    
    if (self.updateType == 2 && isBootUpdated) {
        [MBProgressHUD hideHUD];
        
        [MBProgressHUD showMessage:@"开始固件升级..."];
        
        [bleManager setDFUDelegate:self];
        
        [bleManager updateFirmware:[NSURL URLWithString:[[SystemStateManager shareInstance] getFileDirectoryPath:@"new/app.zip"]] FileType:UPGRADE_TYPE_APPLICATION];
        
        isApplicatiionUpdating = YES;
        isApplicationUpdated = NO;
        
        return;
    }
    
    [self getUpDateFirmwareFromServer:^(NSDictionary *data) {
        NSString *updateUrl = [data objectForKey:@"downloadurl"];
        
        NSString *type = [data objectForKey:@"type"];
        self.updateType = [type integerValue];
        
        [self downloadFileWithOption:bandversion() withInferface:updateUrl savedPath:DOWNLOAD_ZIP_PATH downloadSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            if (self.updateType == 1) {
                [MBProgressHUD hideHUD];
                
                [MBProgressHUD showMessage:@"准备固件升级..."];
                
                [bleManager setDFUDelegate:self];
                
                [bleManager updateFirmware:[NSURL URLWithString:DOWNLOAD_ZIP_PATH] FileType:UPGRADE_TYPE_APPLICATION];
            }
            else
            {
                [MBProgressHUD hideHUD];
                
                [MBProgressHUD showMessage:@"开始固件升级..."];
                
                [bleManager setDFUDelegate:self];
                
                [bleManager updateFirmware:[NSURL URLWithString:[[SystemStateManager shareInstance] getFileDirectoryPath:@"new/app.zip"]] FileType:UPGRADE_TYPE_APPLICATION];
                
                isApplicatiionUpdating = YES;
                isApplicationUpdated = NO;
            }
            
        } downloadFailure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            [MBProgressHUD hideHUD];
            
            [MBProgressHUD showError:@"固件包下载失败"];
            
        } progress:^(float progress) {
            
        }];
        
        
        
        
    } failed:^(NSError *error) {
        
    }];
}

#pragma mark 数据重发3次后仍然失败
- (void) BLEManagerSendDataFailed:(NSError *)error//数据重发3次后仍然失败
{
    showError(error);
}

#pragma mark 接收数据失败
- (void) BLEManagerReceiveDataFailed:(NSError *)error//接收数据失败
{
    showError(error);
}

#pragma mark 手环收到命令后10s(暂定)未返回消息
- (void) BLEManagerOperationTimeout:(NSUInteger)cmdNo;//手环收到命令后10s(暂定)未返回消息
{
    switch (cmdNo) {
        case COMMAND_NULL:
            break;
            
            //电子钱包命令，还未完善
        case WALLET_GET_BALANCE://获取余额
            break;
        case WALLET_GET_EXPENSES://获取消费记录
            break;
        case WALLET_ADD_BALANCE://增加余额
            break;
            
            //运动相关
        case SPORTS_SET_STEPS://设置目标步数
            break;
        case SPORTS_GET_DATA://获取计步信息
            break;
        case SPORTS_GET_CURRENT://获取今天步数
            break;
        case SPROTS_DELETE_DATA://删除计步信息
            break;
            
            //睡眠相关
        case SLEEP_GET_DATA://获取睡眠信息
            break;
        case SLEEP_GET_CURRENT://获取今天睡眠时间
            break;
        case SLEEP_DELETE_DATA://删除睡眠信息
            break;
            
            //来电和短信
        case PHONE_RING_SHOCK://来电手环震动
            break;
        case PHONE_RING_SHOCK_STOP://接电话停止震动
            break;
        case PHONE_MESSAGE_SHOCK://短信手环震动
            break;
            
            //时间
        case WRISTBAND_SET_TIME://设置手环时间
            break;
            
            //闹钟
        case WRISTBAND_ALARM_CLOCK_SET://设置手环闹钟
            break;
        case WRISTBAND_ALARM_CLOCK_SYN://同步手环闹钟
            break;
            
            //电池
        case BATTERTY_REMAINING_CAPACITY://获取电池剩余电量
            break;
            
            //绑定和解绑
        case WRISTBAND_BIND://绑定手环
        {
            if ([bleManager connected]) {
                
                [bleManager getSystemInformation]; //获取系统信息
                
            }
        }
            break;
        case WRISTBAND_UNBUND://解绑手环
            break;
            
            
            //系统相关
//        case WRISTBAND_UPDATE_FIRMWARE://蓝牙通讯固件升级
//            break;
        case WRISTBAND_GET_SYSTEM_INFO://获取系统信息
            break;
        case WRISTBAND_CHANGE_BLE_NAME://修改蓝牙名称
            break;
            
            //卡号
        case WRISTBAND_GET_CARD_ID://获取卡号
            break;
        default:
            break;
    }
}

#pragma mark 手环收到命令后操作成功
- (void) BLEManagerOperationSucceed:(NSUInteger)cmdNo//手环收到命令后操作成功
{
    switch (cmdNo) {
        case COMMAND_NULL:
            break;
            
            //电子钱包命令，还未完善
        case WALLET_GET_BALANCE://获取余额
            break;
        case WALLET_GET_EXPENSES://获取消费记录
            break;
        case WALLET_ADD_BALANCE://增加余额
            break;
            
            //运动相关
        case SPORTS_SET_STEPS://设置目标步数
            break;
        case SPORTS_GET_DATA://获取计步信息
            break;
        case SPORTS_GET_CURRENT://获取今天步数
            break;
        case SPROTS_DELETE_DATA://删除计步信息
            break;
            
            //睡眠相关
        case SLEEP_GET_DATA://获取睡眠信息
            break;
        case SLEEP_GET_CURRENT://获取今天睡眠时间
            break;
        case SLEEP_DELETE_DATA://删除睡眠信息
            break;
            
            //来电和短信
        case PHONE_RING_SHOCK://来电手环震动
            break;
        case PHONE_RING_SHOCK_STOP://接电话停止震动
            break;
        case PHONE_MESSAGE_SHOCK://短信手环震动
            break;
            
            //时间
        case WRISTBAND_SET_TIME://设置手环时间
            break;
            
            //闹钟
        case WRISTBAND_ALARM_CLOCK_SET://设置手环闹钟
            break;
        case WRISTBAND_ALARM_CLOCK_SYN://同步手环闹钟
            break;
            
            //电池
        case BATTERTY_REMAINING_CAPACITY://获取电池剩余电量
            break;
            
            //绑定和解绑
        case WRISTBAND_BIND://绑定手环
        {
            NSLog(@"绑定手环成功");
            if ([bleManager connected]) {
                
                [bleManager getSystemInformation]; //获取系统信息
                
                //代理
                NSLog(@"%s delegate = %@", __func__ ,_delegate);
                if (_delegate && [_delegate respondsToSelector:@selector(PaPaBLEManagerConnected)]) {
                    [_delegate PaPaBLEManagerConnected];
                }

            }
        }
            break;
        case WRISTBAND_UNBUND://解绑手环
        {
            NSLog(@"解绑手环成功");
            [SystemStateManager shareInstance].hasBindWristband = NO;
            //本地缓存绑定手环
            NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
            
            [def setObject:@"" forKey:kUD_BIND_DEVICE];
            [def synchronize];
            
            [SystemStateManager shareInstance].bindUUID = @"";
            
            //断开连接
            [bleManager cancelConnect];
            
        }
            break;
            
            
            //系统相关
//        case WRISTBAND_UPDATE_FIRMWARE://蓝牙通讯固件升级
//            break;
        case WRISTBAND_GET_SYSTEM_INFO://获取系统信息
            break;
        case WRISTBAND_CHANGE_BLE_NAME://修改蓝牙名称
            break;
            
            //卡号
        case WRISTBAND_GET_CARD_ID://获取卡号
            break;
        default:
            break;
    }
}

#pragma mark 手环收到命令后操作失败
- (void) BLEManagerOperationFailed:(NSUInteger)cmdNo//手环收到命令后操作失败
{
    NSString *errorMsg;
    switch (cmdNo) {
        case COMMAND_NULL:
            break;
            
            //电子钱包命令，还未完善
        case WALLET_GET_BALANCE://获取余额
            break;
        case WALLET_GET_EXPENSES://获取消费记录
            break;
        case WALLET_ADD_BALANCE://增加余额
             break;
            
            //运动相关
        case SPORTS_SET_STEPS://设置目标步数
             break;
        case SPORTS_GET_DATA://获取计步信息
        {
            if (_delegate && [_delegate respondsToSelector:@selector(PaPaBLEManagerHasStepDataFailed)]) {
                [_delegate PaPaBLEManagerHasStepDataFailed];
            }
        }
             break;
        case SPORTS_GET_CURRENT://获取今天步数
             break;
        case SPROTS_DELETE_DATA://删除计步信息
            break;
            
            //睡眠相关
        case SLEEP_GET_DATA://获取睡眠信息
        {
            if (_delegate && [_delegate respondsToSelector:@selector(PaPaBLEManagerHasSleepFailed)]) {
                [_delegate PaPaBLEManagerHasSleepFailed];
            }
        }
            break;
        case SLEEP_GET_CURRENT://获取今天睡眠时间
            break;
        case SLEEP_DELETE_DATA://删除睡眠信息
            break;
            
            //来电和短信
        case PHONE_RING_SHOCK://来电手环震动
            break;
        case PHONE_RING_SHOCK_STOP://接电话停止震动
            break;
        case PHONE_MESSAGE_SHOCK://短信手环震动
            break;
            
            //时间
        case WRISTBAND_SET_TIME://设置手环时间
            break;
            
            //闹钟
        case WRISTBAND_ALARM_CLOCK_SET://设置手环闹钟
            break;
        case WRISTBAND_ALARM_CLOCK_SYN://同步手环闹钟
            break;
            
            //电池
        case BATTERTY_REMAINING_CAPACITY://获取电池剩余电量
            break;
            
            //绑定和解绑
        case WRISTBAND_BIND://绑定手环
        {
            NSLog(@"绑定手环失败");
            errorMsg = @"绑定手环失败";
            [SystemStateManager shareInstance].hasBindWristband = NO;
            //本地缓存绑定手环
            NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
            
            [def setObject:@"" forKey:kUD_BIND_DEVICE];
            [def synchronize];
            
            [SystemStateManager shareInstance].bindUUID = @"";
            
            //尝试重新绑定
            [bleManager bindCurrentWristband];
        }
            break;
        case WRISTBAND_UNBUND://解绑手环
        {
            NSLog(@"解绑手环失败");
            [SystemStateManager shareInstance].hasBindWristband = NO;
            //本地缓存绑定手环
            NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
            
            [def setObject:@"" forKey:kUD_BIND_DEVICE];
            [def synchronize];
            
            [SystemStateManager shareInstance].bindUUID = @"";
            
            [APP_DELEGATE loginSuccess];
        }
            break;
            
            
            //系统相关
//        case WRISTBAND_UPDATE_FIRMWARE://蓝牙通讯固件升级
//        {
//            [SystemStateManager shareInstance].isUpdatingFirmware = NO;
//        }
//            break;
        case WRISTBAND_GET_SYSTEM_INFO://获取系统信息
        {
            errorMsg = @"获取系统信息失败";
        }
            break;
        case WRISTBAND_CHANGE_BLE_NAME://修改蓝牙名称
             break;
            
            //卡号
        case WRISTBAND_GET_CARD_ID://获取卡号
        {
            errorMsg = @"获取卡号失败";
        }
             break;
        default:
            break;
    }
    
    if (errorMsg) {
        showTip(errorMsg);
    }
}

#pragma mark 蓝牙返回钱包余额(以分记)
- (void) BLEManagerHasBalanceData:(NSString *)balance//蓝牙返回钱包余额(以分记)
{
    self.balance = strFormat(@"%@",[NSString isStringEmpty:balance] ? @"0.00": balance);
    
    if (_delegate && [_delegate respondsToSelector:@selector(PaPaBLEManagerHasBalanceData:)]) {
        [_delegate PaPaBLEManagerHasBalanceData:balance];
    }
}

#pragma mark 蓝牙返回消费记录，每个记录以NSDictionary存储
- (void) BLEManagerHasExpensesRecord:(NSArray *)record;//蓝牙返回消费记录，每个记录以NSDictionary存储
{
    
}

#pragma mark 达到目标步数消息
- (void) BLEManagerStepTargetAchieved//达到目标步数消息
{
    
}

#pragma mark 手环闹钟触摸后停止震动
- (void) BLEManagerAlarmClockStopped//手环闹钟触摸后停止震动
{
    
}

#pragma mark 蓝牙返回计步信息，每个记录以NSDictionary存储
- (void) BLEManagerHasStepData:(NSArray *)stepData//蓝牙返回计步信息，每个记录以NSDictionary存储
{
    if (_delegate && [_delegate respondsToSelector:@selector(PaPaBLEManagerHasStepData:)]) {
        [_delegate PaPaBLEManagerHasStepData:stepData];
    }
}

#pragma mark 蓝牙返回今天的步数
- (void) BLEManagerUpdateCurrentSteps:(NSUInteger)steps//蓝牙返回今天的步数
{
    if (_delegate && [_delegate respondsToSelector:@selector(PaPaBLEManagerUpdateCurrentSteps:)]) {
        [_delegate PaPaBLEManagerUpdateCurrentSteps:steps];
    }
}

#pragma mark 蓝牙返回睡眠信息，每个记录以NSDictionary存储
- (void) BLEManagerHasSleepData:(NSArray *)sleepData//蓝牙返回睡眠信息，每个记录以NSDictionary存储
{
    if (_delegate && [_delegate respondsToSelector:@selector(PaPaBLEManagerHasSleepData:)]) {
        [_delegate PaPaBLEManagerHasSleepData:sleepData];
    }
}

#pragma mark 蓝牙返回今天的睡眠信息
- (void) BLEManagerUpdateCurrentSleepData:(NSDictionary *)mins//蓝牙返回今天的睡眠信息
{
    if (_delegate && [_delegate respondsToSelector:@selector(PaPaBLEManagerUpdateCurrentSleepData:)]) {
        [_delegate PaPaBLEManagerUpdateCurrentSleepData:mins];
    }
}

#pragma mark 手环返回电量，暂定返回百分比数值
- (void) BLEManagerHasRemainingBatteryCapacity:(NSUInteger)level//手环返回电量，暂定返回百分比数值
{
    if (_delegate && [_delegate respondsToSelector:@selector(PaPaBLEManagerHasRemainingBatteryCapacity:)]) {
        [_delegate PaPaBLEManagerHasRemainingBatteryCapacity:level];
    }
}

#pragma mark 手环系统信息
- (void) BLEManagerHasSystemInformation:(NSDictionary *)info//手环系统信息
{
    NSLog(@"info = %@", info);
    
    self.firmwareInfo = info;
    
    if (_delegate && [_delegate respondsToSelector:@selector(PaPaBLEManagerHasSystemInformation:)]) {
        [_delegate PaPaBLEManagerHasSystemInformation:info];
    }
}

#pragma mark 卡号
- (void) BLEManagerHasCardID:(NSString *)cardID//卡号
{
    self.cardId = cardID;
}

#pragma mark - DFU Delegate 
-(void)onDeviceConnected:(CBPeripheral *)peripheral//升级时连接蓝牙成功
{
    NSLog(@"升级时连接蓝牙成功");
}

-(void)onDeviceDisconnected:(CBPeripheral *)peripheral//升级时蓝牙连接断开
{
    self.isUpdateDisconnect = YES;
    NSLog(@"升级时蓝牙连接断开");
    
    if (_delegate && [_delegate respondsToSelector:@selector(PaPaOnDeviceDisconnected:)]) {
        [_delegate PaPaOnDeviceDisconnected:peripheral];
    }
    
    if (isBootUpdated && !isApplicationUpdated) {
        return;
    }
    
    [SystemStateManager shareInstance].hasBindWristband = NO;
    //发起重连扫描
    double delayInSeconds = 0.5;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        NSLog(@"请重新连接手环");
        
        [MBProgressHUD hideHUD];
        
        [MBProgressHUD showSuccess:@"请重新连接手环"];
        
        //本地缓存绑定手环
        NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
        
        [def setObject:@"" forKey:kUD_BIND_DEVICE];
        [def synchronize];
        
        [SystemStateManager shareInstance].bindUUID = @"";
        
        [APP_DELEGATE loginSuccess];
        
    });
    
    
    
}

-(void)onDFUStarted//升级开始
{
    [MBProgressHUD hideHUD];
    
    [MBProgressHUD showMessage:@"开始固件升级..."];
    
    if (_delegate && [_delegate respondsToSelector:@selector(PaPaOnDFUStarted)]) {
        [_delegate PaPaOnDFUStarted];
    }
}

-(void)onDFUCancelled//升级取消
{
    [MBProgressHUD showError:@"升级取消"];
}

-(void)onSoftDeviceUploadStarted//协议栈升级开始
{
    NSLog(@"协议栈升级开始");
}

-(void)onBootloaderUploadStarted//bootloader升级开始
{
    NSLog(@"bootloader升级开始");
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
    if (self.updateType == 1) {
        [MBProgressHUD hideHUD];
        
        [MBProgressHUD showSuccess:@"固件升级成功"];
        
        if (_delegate && [_delegate respondsToSelector:@selector(PaPaOnSuccessfulFileTranferred)]) {
            [_delegate PaPaOnSuccessfulFileTranferred];
        }
    }
    else
    {
        if (isBootUpdating && !isBootUpdated) {
            //发起重连
            double delayInSeconds = 2;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                
                [MBProgressHUD hideHUD];
                
                [MBProgressHUD showSuccess:@"2s后重连手环"];
                
                [bleManager startScan];
                
            });
            
            isBootUpdated = YES;
            isApplicationUpdated = NO;
            isBootUpdating = NO;
            
            if (_delegate && [_delegate respondsToSelector:@selector(PaPaOnSuccessfulFileTranferred)]) {
                [_delegate PaPaOnSuccessfulFileTranferred];
            }
            
            return;
        }
        
        if (isApplicatiionUpdating && !isApplicationUpdated) {
            isBootUpdated = YES;
            isApplicationUpdated = YES;
            isApplicatiionUpdating = NO;
        }
        
        if ((isBootUpdated && isApplicationUpdated) || isApplicationUpdated) {
            
            [MBProgressHUD hideHUD];
            
            [MBProgressHUD showSuccess:@"固件升级成功,请重新绑定手环"];
            
            if (_delegate && [_delegate respondsToSelector:@selector(PaPaOnSuccessfulFileTranferred)]) {
                [_delegate PaPaOnSuccessfulFileTranferred];
            }
        }
    }
    
}

-(void)onError:(NSString *)errorMessage//错误信息
{
    [MBProgressHUD showError:errorMessage];
}
@end
