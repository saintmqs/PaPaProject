//
//  PckData.h
//  EtuProject
//
//  Created by 王家兴 on 15/11/3.
//  Copyright (c) 2015年 王家兴. All rights reserved.
//

typedef enum : NSUInteger {
    stepsToday,
    stepsDay,
    stepsWeek,
    stepsMonth,
} stepType;

typedef enum : NSUInteger {
    sleepToday,
    sleepDay,
    sleepWeek,
    sleepMonth,
} sleepType;

#import <Foundation/Foundation.h>

NSDictionary *init();

//4	用户登录接口
NSDictionary *login(NSString *username, NSString *password);

//5 注册发送验证码
NSDictionary *sendRegCode(NSString *phone);

//6	注册时验证验证码
NSDictionary *checkRegCode(NSString *phone, NSString *code);

//7	用户注册接口
NSDictionary *registerAccount(NSString *phone, NSString *password, NSString *repassword,NSString *code);

//8	用户二次信息添加
NSDictionary *registerbase(NSInteger uid, NSString *birthday, NSInteger sex, NSInteger height, NSInteger weight, NSInteger step);

//9 修改性别
NSDictionary *updateSex(NSInteger uid, NSInteger sex);

//10 修改生日
NSDictionary *updateBirthday(NSInteger uid, NSString *birthday);

//11 修改昵称
NSDictionary *updateNickname(NSInteger uid, NSString *nickname);

//12 修改密码
NSDictionary *updatePwd(NSInteger uid, NSString *oldpassword, NSString *password, NSString *repassword);

//13 修改头像
NSDictionary *updateAvater(NSInteger uid, NSString *avater);

//14 修改身高
NSDictionary *healthUpdateHeight(NSInteger uid, NSInteger value);

//15 修改体重
NSDictionary *healthUpdateWeight(NSInteger uid, NSInteger value);

//16 修改目标步数
NSDictionary *healthUpdateStep(NSInteger uid, NSInteger value);

//17 获取用户信息
NSDictionary *getUserInfo(NSInteger uid);

//18 找回密码发送验证码
NSDictionary *sendPwdCode(NSString *phone);

//19 找回密码时验证验证码
NSDictionary *checkPwdCode(NSString *phone, NSString *code);

//20 找回密码
NSDictionary *findPwd(NSString *phone, NSString *password, NSString *repassword, NSString *code);

//21 手环绑定
NSDictionary *bindingBand(NSInteger uid, NSString *bandid, NSString *cardno);

//22 获取市民卡余额
NSDictionary *getCitizencardBalance(NSInteger uid, NSString *cardno);

//23 更新市民卡余额
NSDictionary *updateCitizencardBalance(NSInteger uid, NSString *cardno, NSNumber *balance);

//24 手环解除绑定
NSDictionary *unbindingBand(NSInteger uid);

//25 计步数据提交
NSDictionary *stepsUpload(NSInteger uid, NSString *json);

//26 计步数据获取
NSDictionary *stepsMonitor(NSInteger uid, stepType type, NSString *date, NSString *style);

//27 睡眠数据提交
NSDictionary *sleepUpload(NSInteger uid, NSString *json);

//28 睡眠数据获取
NSDictionary *sleepMonitor(NSInteger uid, sleepType type, NSString *date, NSString *style);

//29 客户端版本更新接口
NSDictionary *appversion();

//30 手环固件版本更新接口
NSDictionary *bandversion();

//31 运动和睡眠第三方分享
NSDictionary *share(NSInteger uid, NSInteger datetype, NSInteger type);

//32 运动和睡眠第三方分享
NSDictionary *sport(NSInteger uid, NSInteger step);

@interface PckData : NSObject
@end
