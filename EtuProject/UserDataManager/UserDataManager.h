//
//  UserDataManager.h
//  EtuProject
//
//  Created by 王家兴 on 16/1/1.
//  Copyright © 2016年 王家兴. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RegistModel.h"

@interface UserDataManager : NSObject

@property (nonatomic, strong) RegistModel *registModel;

+(UserDataManager *)shareInstance;
@end
