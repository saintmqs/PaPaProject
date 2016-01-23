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
        _callCenter.callEventHandler = ^(CTCall* call) {
            if ([call.callState isEqualToString:CTCallStateDisconnected])
            {
                NSLog(@"Call has been disconnected");
            }
            else if ([call.callState isEqualToString:CTCallStateConnected])
            {
                NSLog(@"Call has just been connected");
                [[PaPaBLEManager shareInstance].bleManager stopPhoneRingShock];
            }
            else if([call.callState isEqualToString:CTCallStateIncoming])
            {
                NSLog(@"Call is incoming");
                [[PaPaBLEManager shareInstance].bleManager startPhoneRingShock];
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
@end
