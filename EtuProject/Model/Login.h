//
//  Login.h
//  EtuProject
//
//  Created by 王家兴 on 15/11/3.
//  Copyright (c) 2015年 王家兴. All rights reserved.
//

#import "BaseJSONModel.h"

@class BaseInfo;
@interface Login : BaseJSONModel

@property (nonatomic, copy) NSString	    *uid;//用户id
@property (nonatomic, copy) NSString		*apikey;//用户秘钥
@property (nonatomic, copy) NSString		*avatar;//头像
@property (nonatomic, copy) NSString        *isall;//0-资料没有完善，登录之后跳转到选择性别那里，然后一步一步的完成资料，之后调取接口8  1-资料已经完善
@property (nonatomic, copy) BaseInfo        *baseInfo;
@end

@interface BaseInfo : BaseJSONModel

@property (nonatomic, copy) NSString         *uid; //用户uid
@property (nonatomic, copy) NSString         *nickname;//用户昵称
@property (nonatomic, copy) NSString         *phone;//手机号
@property (nonatomic, copy) NSString         *birthday;//生日 格式(1989-01-30)
@property (nonatomic, copy) NSString         *sex;//1-男 2-女
@property (nonatomic, copy) NSString         *height;//身高
@property (nonatomic, copy) NSString         *weight;//身高
@property (nonatomic, copy) NSString         *step;//身高

@end