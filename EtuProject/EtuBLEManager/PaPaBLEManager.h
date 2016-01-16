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

@protocol PaPaBLEManagerDelegate <NSObject>

@optional
- (void) getBLEStatusToDoNext:(CBCentralManagerState)state;
//蓝牙已连接
- (void) PaPaBLEManagerConnected;
//蓝牙断开连接
- (void) PaPaBLEManagerDisconnected:(NSError *)error;

//蓝牙返回计步信息，每个记录以NSDictionary存储
- (void) PaPaBLEManagerHasStepData:(NSArray *)stepData;
//蓝牙返回今天的步数
- (void) PaPaBLEManagerUpdateCurrentSteps:(NSUInteger)steps;
//蓝牙返回睡眠信息，每个记录以NSDictionary存储
- (void) PaPaBLEManagerHasSleepData:(NSArray *)sleepData;
//蓝牙返回今天的睡眠信息
- (void) PaPaBLEManagerUpdateCurrentSleepData:(NSDictionary *)mins;
//蓝牙返回钱包余额(以分记)
- (void) PaPaBLEManagerHasBalanceData:(NSUInteger)balance;
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

@property (nonatomic, assign) id<PaPaBLEManagerDelegate> delegate;

@property (nonatomic, strong) BLEManager *bleManager;

@property (nonatomic, assign) BOOL blePoweredOn;            //手机蓝牙是否打开

@property (nonatomic, strong) NSDictionary *firmwareInfo;   //系统信息
@property (nonatomic, strong) NSString     *balance;
@property (nonatomic, strong) NSString     *cardId;

+(PaPaBLEManager *)shareInstance;

-(BOOL)blePoweredOn;

-(void)updateFirmware:(NSDictionary *)info;

-(void)getUpDateFirmwareFromServer:(PaPaBLEUploadDownloadSuccessBlock)successBlock
                            failed:(PaPaBLEUploadDownloadFailedBlock)failedBlock;
@end
