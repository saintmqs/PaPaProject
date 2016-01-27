//
//  ClocksManager.h
//  EtuProject
//
//  Created by 王家兴 on 16/1/26.
//  Copyright © 2016年 王家兴. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ClockModel.h"

@interface ClocksManager : NSObject

@property (nonatomic, strong) NSMutableArray *clocksArray;

+(ClocksManager *)shareInstance;

@end
