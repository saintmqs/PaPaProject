//
//  PckData.m
//  EtuProject
//
//  Created by 王家兴 on 15/11/3.
//  Copyright (c) 2015年 王家兴. All rights reserved.
//

#import "PckData.h"

#define initDict()												\
NSMutableDictionary *dict = [NSMutableDictionary dictionary];	\

#define addParam(key, value) [dict setValue : value forKey : key]

/**********************************************************************************************************/
/*********************************************** 华丽的分割线 ***********************************************/
/**********************************************************************************************************/
/********************************************** 以下为业务接口 **********************************************/
/**********************************************************************************************************/

//4	用户登录接口
NSDictionary *login(NSString *username, NSString *password)
{
    initDict();
    
    addParam(@"login", username);
    addParam(@"password", password);
    return dict;
}

//5 注册发送验证码
NSDictionary *sendRegCode(NSString *phone)
{
    initDict();
    addParam(@"phone", phone);
    
    return dict;
}

//6	注册时验证验证码
NSDictionary *checkRegCode(NSString *phone, NSString *code)
{
    initDict();
    addParam(@"phone", phone);
    addParam(@"code", code);
    
    return dict;
}

//7	用户注册接口
NSDictionary *registerAccount(NSString *phone, NSString *password, NSString *repassword)
{
    initDict();
    addParam(@"phone", phone);
    addParam(@"password", password);
    addParam(@"repassword", repassword);
    
    return dict;
}

//8	用户二次信息添加
NSDictionary *registerbase(NSInteger uid, NSString *birthday, NSInteger sex, NSInteger height, NSInteger weight, NSInteger step)
{
    initDict();
    
    addParam(@"uid", [NSNumber numberWithInteger:uid]);
    addParam(@"birthday", birthday);
    addParam(@"sex", [NSNumber numberWithInteger:sex]);
    addParam(@"height", [NSNumber numberWithInteger:height]);
    addParam(@"weight", [NSNumber numberWithInteger:weight]);
    addParam(@"step", [NSNumber numberWithInteger:step]);
    
    return dict;
}

@implementation PckData

@end
