//
//  PckData.h
//  EtuProject
//
//  Created by 王家兴 on 15/11/3.
//  Copyright (c) 2015年 王家兴. All rights reserved.
//

#import <Foundation/Foundation.h>

NSDictionary *init();

//4	用户登录接口
NSDictionary *login(NSString *username, NSString *password);

//5 注册发送验证码
NSDictionary *sendRegCode(NSString *phone);

//6	注册时验证验证码
NSDictionary *checkRegCode(NSString *phone, NSString *code);

//7	用户注册接口
NSDictionary *registerAccount(NSString *phone, NSString *password, NSString *repassword);

//8	用户二次信息添加
NSDictionary *registerbase(NSInteger uid, NSString *birthday, NSInteger sex, NSInteger height, NSInteger weight, NSInteger step);

@interface PckData : NSObject
@end
