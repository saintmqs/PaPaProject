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

@protocol PaPaBLEManagerDelegate <NSObject>

@optional
- (void) getBLEStatusToDoNext:(CBCentralManagerState)state;
//蓝牙已连接
- (void) PaPaBLEManagerConnected;
//蓝牙断开连接
- (void) PaPaBLEManagerDisconnected:(NSError *)error;

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

@property (nonatomic, assign) BOOL blePoweredOn;            //蓝牙是否打开

@property (nonatomic, strong) NSDictionary *firmwareInfo;   //系统信息

@property (nonatomic, strong) NSString     *cardId;

+(PaPaBLEManager *)shareInstance;

-(BOOL)blePoweredOn;

@end
