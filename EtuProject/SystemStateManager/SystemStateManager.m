//
//  SystemStateManager.m
//  EtuProject
//
//  Created by 王家兴 on 16/1/3.
//  Copyright © 2016年 王家兴. All rights reserved.
//

#import "SystemStateManager.h"

static SystemStateManager *systemStateManager;

@implementation SystemStateManager

+(SystemStateManager *)shareInstance
{
    if (!systemStateManager) {
        systemStateManager = [[SystemStateManager alloc] init];
    }
    return systemStateManager;
}

-(id)init
{
    self = [super init];
    if (self) {
        
        NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
        
        _bindUUID = [def objectForKey:kUD_BIND_DEVICE];
        
        if (![NSString isStringEmptyOrBlank:_bindUUID]) {
            self.hasBindWristband = YES;
        }
        
        _callCenter = [[CTCallCenter alloc] init];
        weakObj(self);
        _callCenter.callEventHandler = ^(CTCall* call) {
            if ([call.callState isEqualToString:CTCallStateDisconnected])
            {
                NSLog(@"Call has been disconnected");
                if (bself.isRingShake) {
                    [[PaPaBLEManager shareInstance].bleManager stopPhoneRingShock];
                }
            }
            else if ([call.callState isEqualToString:CTCallStateConnected])
            {
                NSLog(@"Call has just been connected");
                if (bself.isRingShake) {
                    [[PaPaBLEManager shareInstance].bleManager stopPhoneRingShock];
                }
            }
            else if([call.callState isEqualToString:CTCallStateIncoming])
            {
                NSLog(@"Call is incoming");
                if (bself.isRingShake) {
                    [[PaPaBLEManager shareInstance].bleManager startPhoneRingShock];
                }
            }
            else if ([call.callState isEqualToString:CTCallStateDialing])
            {
                NSLog(@"call is dialing");
            }
            else
            {
                NSLog(@"Nothing is done");
            }
        };
    }
    return self;
}

-(void)appVersionNeedUpdate:(versionBlock)updateBlock
            isLatestVersion:(versionBlock)isLatestBlock
         checkVersionFailed:(versionBlock)failedBlock
{
    [self startRequestWithDict:appversion() completeBlock:^(ASIHTTPRequest *request, NSDictionary *dict, NSError *error) {
        if (!error) {
            
            NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
            // app版本
            NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
            
            NSDictionary *data = [dict objectForKey:@"data"];
            //服务器返回版本号
            NSString *lastestApp_version = [data objectForKey:@"version"];
            //服务器返回下载页面链接
            self.appDownloadUrl = [data objectForKey:@"downloadurl"];
            
            //版本比对
            if (![NSString isStringEmpty:lastestApp_version] && ![app_Version isEqualToString:lastestApp_version]) {
                updateBlock();
            }
            else
            {
                isLatestBlock();
            }
        }
        else
        {
            if (error == nil || [error.userInfo objectForKey:@"msg"] == nil)
            {
                showTip(@"网络连接失败");
            }
            else
            {
                showTip([error.userInfo objectForKey:@"msg"]);
            }
            failedBlock();
        }
    } url:kRequestUrl(@"Version", @"appversion")];
}


- (NSArray *)getAllFileNames:(NSString *)dirName
{
    // 获得此程序的沙盒路径
    NSArray *patchs = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    // 获取Documents路径
    NSString *documentsDirectory = [patchs objectAtIndex:0];
    NSString *fileDirectory = [documentsDirectory stringByAppendingPathComponent:dirName];
    
    NSArray *files = [[NSFileManager defaultManager] subpathsOfDirectoryAtPath:fileDirectory error:nil];
    return files;
}

-(NSString *)getFileDirectoryPath:(NSString *)dirName
{
    NSArray *patchs = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    // 获取Documents路径
    NSString *documentsDirectory = [patchs objectAtIndex:0];
    NSString *fileDirectory = [documentsDirectory stringByAppendingPathComponent:dirName];
    return fileDirectory;
}

-(NSString *)getFilePath:(NSString *)fileName inDirectory:(NSString *)directory
{
    NSString *filePath = [NSString stringWithFormat:@"%@/%@",directory,fileName];
    return filePath;
}
@end
