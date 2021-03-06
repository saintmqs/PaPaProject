//
//  PaPaBLEManager.h
//  EtuProject
//
//  Created by 王家兴 on 16/1/4.
//  Copyright © 2016年 王家兴. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BLEManager.h"

typedef void(^PaPaBLEBlock)(CBCentralManagerState state);
typedef void(^PaPaBLEUploadDownloadSuccessBlock)(NSDictionary *data);
typedef void(^PaPaBLEUploadDownloadFailedBlock)(NSError *error);
typedef void(^LatestBlock)(void);

@protocol PaPaBLEManagerDelegate <NSObject>

@optional
- (void) getBLEStatusToDoNext:(CBCentralManagerState)state;
//蓝牙已连接
- (void) PaPaBLEManagerConnected;
- (void) PaPaBLEManagerReadyToReadAndWrite;
//蓝牙断开连接
- (void) PaPaBLEManagerDisconnected:(NSError *)error;

//蓝牙返回计步信息，每个记录以NSDictionary存储
- (void) PaPaBLEManagerHasStepData:(NSArray *)stepData;
- (void) PaPaBLEManagerHasStepDataFailed;
//蓝牙返回今天的步数
- (void) PaPaBLEManagerUpdateCurrentSteps:(NSUInteger)steps;
//蓝牙返回睡眠信息，每个记录以NSDictionary存储
- (void) PaPaBLEManagerHasSleepData:(NSArray *)sleepData;
- (void) PaPaBLEManagerHasSleepFailed;
//蓝牙返回今天的睡眠信息
- (void) PaPaBLEManagerUpdateCurrentSleepData:(NSDictionary *)mins;
//蓝牙返回钱包余额(以元计，小数点后2位)
- (void) PaPaBLEManagerHasBalanceData:(NSString *)balance;
//剩余电量
- (void) PaPaBLEManagerHasRemainingBatteryCapacity:(NSUInteger)level;
//获取系统信息
- (void) PaPaBLEManagerHasSystemInformation:(NSDictionary *)info;

/*--------------DFU----------------*/
//升级成功
-(void)PaPaOnDFUStarted;
//升级百分比
-(void)PaPaOnTransferPercentage:(int)percentage;
//升级成功
-(void)PaPaOnSuccessfulFileTranferred;
//升级时断开
-(void)PaPaOnDeviceDisconnected:(CBPeripheral *)peripheral;
@end

@interface PaPaBLEManager : NSObject<BLEManagerDelegate,DFUStatusDelegate>
{
    BOOL isBootUpdating,isBootUpdated;
    BOOL isApplicatiionUpdating,isApplicationUpdated;
}
@property (nonatomic, assign) id<PaPaBLEManagerDelegate> delegate;

@property (nonatomic, strong) BLEManager *bleManager;

@property (nonatomic, assign) BOOL blePoweredOn;            //手机蓝牙是否打开

@property (nonatomic, strong) NSDictionary *firmwareInfo;   //系统信息
@property (nonatomic, assign) NSInteger    updateType;   //1 普通升级 2 复杂升级

@property (nonatomic, strong) NSString     *balance;
@property (nonatomic, strong) NSString     *cardId;
@property (nonatomic, assign) BOOL         isUpdateDisconnect;

+(PaPaBLEManager *)shareInstance;

-(BOOL)blePoweredOn;

-(void)updateFirmware:(NSDictionary *)info isLastestVersion:(LatestBlock)lastestblock;

-(void)getUpDateFirmwareFromServer:(PaPaBLEUploadDownloadSuccessBlock)successBlock
                            failed:(PaPaBLEUploadDownloadFailedBlock)failedBlock;
@end
