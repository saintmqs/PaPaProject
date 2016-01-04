//
//  PaPaBLEManager.h
//  EtuProject
//
//  Created by 王家兴 on 16/1/4.
//  Copyright © 2016年 王家兴. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BLEManager.h"

@interface PaPaBLEManager : NSObject<BLEManagerDelegate>

@property (nonatomic, strong) BLEManager *bleManager;

+(PaPaBLEManager *)shareInstance;
@end
