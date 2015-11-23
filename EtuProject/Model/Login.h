//
//  Login.h
//  EtuProject
//
//  Created by 王家兴 on 15/11/3.
//  Copyright (c) 2015年 王家兴. All rights reserved.
//

#import "BaseJSONModel.h"

@interface Login : BaseJSONModel

@property (nonatomic, copy) NSString	    *uid;//用户id
@property (nonatomic, copy) NSString		*apikey;//用户秘钥
@property (nonatomic, copy) NSString		*sex;//性别 (1、男2、女)
@property (nonatomic, copy) NSString		*head;//头像
@property (nonatomic, copy) NSString		*birthdaytime;//生日时间戳格式
@property (nonatomic, copy) NSString        *isall;//0-资料没有完善，登录之后跳转到选择性别那里，然后一步一步的完成资料，之后调取接口8  1-资料已经完善


@end

