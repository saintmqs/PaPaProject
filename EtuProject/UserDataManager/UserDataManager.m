//
//  UserDataManager.m
//  EtuProject
//
//  Created by 王家兴 on 16/1/1.
//  Copyright © 2016年 王家兴. All rights reserved.
//

#import "UserDataManager.h"

static UserDataManager *userDataManager;

@implementation UserDataManager

+(UserDataManager *)shareInstance
{
    if (!userDataManager) {
        userDataManager = [[UserDataManager alloc] init];
        
        RegistModel *regist = [[RegistModel alloc] init];
        userDataManager.registModel = regist;
    }
    return userDataManager;
}
@end
