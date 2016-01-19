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

//9 修改性别
NSDictionary *updateSex(NSInteger uid, NSInteger sex)
{
    initDict();
    
    addParam(@"uid", [NSNumber numberWithInteger:uid]);
    addParam(@"sex", [NSNumber numberWithInteger:sex]);

    return dict;
}

//10 修改生日
NSDictionary *updateBirthday(NSInteger uid, NSString *birthday)
{
    initDict();
    
    addParam(@"uid", [NSNumber numberWithInteger:uid]);
    addParam(@"birthday", birthday);
    
    return dict;
}

//11 修改昵称
NSDictionary *updateNickname(NSInteger uid, NSString *nickname)
{
    initDict();
    
    addParam(@"uid", [NSNumber numberWithInteger:uid]);
    addParam(@"nickname", nickname);
    
    return dict;
}

//12 修改密码
NSDictionary *updatePwd(NSInteger uid, NSString *oldpassword, NSString *password, NSString *repassword)
{
    initDict();
    
    addParam(@"uid", [NSNumber numberWithInteger:uid]);
    addParam(@"oldpassword", oldpassword);
    addParam(@"password", password);
    addParam(@"repassword", repassword);
    
    return dict;
}

//13 修改头像
NSDictionary *updateAvater(NSInteger uid, NSString *avater)
{
    initDict();
    
    addParam(@"uid", [NSNumber numberWithInteger:uid]);
    addParam(@"avater", avater);
    
    return dict;
}

//14 修改身高
NSDictionary *healthUpdateHeight(NSInteger uid, NSInteger value)
{
    initDict();
    
    addParam(@"uid", [NSNumber numberWithInteger:uid]);
    addParam(@"value", [NSNumber numberWithInteger:value]);
    
    return dict;
}

//15 修改体重
NSDictionary *healthUpdateWeight(NSInteger uid, NSInteger value)
{
    initDict();
    
    addParam(@"uid", [NSNumber numberWithInteger:uid]);
    addParam(@"value", [NSNumber numberWithInteger:value]);
    
    return dict;
}

//16 修改目标步数
NSDictionary *healthUpdateStep(NSInteger uid, NSInteger value)
{
    initDict();
    
    addParam(@"uid", [NSNumber numberWithInteger:uid]);
    addParam(@"value", [NSNumber numberWithInteger:value]);
    
    return dict;
}

//17 获取用户信息
NSDictionary *getUserInfo(NSInteger uid)
{
    initDict();
    
    addParam(@"uid", [NSNumber numberWithInteger:uid]);
    
    return dict;
}

//18 找回密码发送验证码
NSDictionary *sendPwdCode(NSString *phone)
{
    initDict();
    
    addParam(@"phone", phone);
    
    return dict;
}

//19 找回密码时验证验证码
NSDictionary *checkPwdCode(NSString *phone, NSString *code)
{
    initDict();
    
    addParam(@"phone", phone);
    addParam(@"code", code);
    
    return dict;
}

//20 找回密码
NSDictionary *findPwd(NSString *phone, NSString *password, NSString *repassword, NSString *code)
{
    initDict();
    
    addParam(@"phone", phone);
    addParam(@"password", password);
    addParam(@"repassword", repassword);
    addParam(@"code", code);
    
    return dict;
}

//21 手环绑定
NSDictionary *bindingBand(NSInteger uid, NSString *bandid, NSString *cardno)
{
    initDict();
    
    addParam(@"uid", [NSNumber numberWithInteger:uid]);
    addParam(@"bandid", bandid);
    addParam(@"cardno", cardno);
    
    return dict;
}

//22 获取市民卡余额
NSDictionary *getCitizencardBalance(NSInteger uid, NSString *cardno)
{
    initDict();
    
    addParam(@"uid", [NSNumber numberWithInteger:uid]);
    addParam(@"cardno", cardno);
    
    return dict;
}

//23 更新市民卡余额
NSDictionary *updateCitizencardBalance(NSInteger uid, NSString *cardno, NSNumber *balance)
{
    initDict();
    
    addParam(@"uid", [NSNumber numberWithInteger:uid]);
    addParam(@"cardno", cardno);
    addParam(@"balance", balance);
    
    return dict;
}

//24 手环解除绑定
NSDictionary *unbindingBand(NSInteger uid)
{
    initDict();
    
    addParam(@"uid", [NSNumber numberWithInteger:uid]);
    
    return dict;
}

//25 计步数据提交
NSDictionary *stepsUpload(NSInteger uid, NSString *json)
{
    initDict();
    
    addParam(@"uid", [NSNumber numberWithInteger:uid]);
    addParam(@"json", json);
    
    return dict;
}

//26 计步数据获取
NSDictionary *stepsMonitor(NSInteger uid, stepType type, NSString *date, NSString *style)
{
    initDict();
    
    addParam(@"uid", [NSNumber numberWithInteger:uid]);
    
    NSString *stepType;
    switch (type) {
        case stepsToday:
        {
            stepType = @"stepsToday";
            date = @"";
        }
            break;
        case stepsDay:
        {
            stepType = @"stepsDay";
        }
            break;
        case stepsWeek:
        {
            stepType = @"stepsWeek";
        }
            break;
        case stepsMonth:
        {
            stepType = @"stepsMonth";
        }
            break;
        default:
            break;
    }
    addParam(@"type", stepType);
    addParam(@"date", date);
    addParam(@"style", @"");
    
    return dict;
}

//27 睡眠数据提交
NSDictionary *sleepUpload(NSInteger uid, NSString *json)
{
    initDict();
    
    addParam(@"uid", [NSNumber numberWithInteger:uid]);
    addParam(@"json", json);
    return dict;
}

//28 睡眠数据获取
NSDictionary *sleepMonitor(NSInteger uid, sleepType type, NSString *date, NSString *style)
{
    initDict();
    
    addParam(@"uid", [NSNumber numberWithInteger:uid]);
    
    NSString *sleepType;
    switch (type) {
        case sleepToday:
        {
            sleepType = @"sleepToday";
        }
            break;
        case sleepDay:
        {
            sleepType = @"sleepDay";
        }
            break;
        case sleepWeek:
        {
            sleepType = @"sleepWeek";
        }
            break;
        case sleepMonth:
        {
            sleepType = @"sleepMonth";
        }
            break;
        default:
            break;
    }
    addParam(@"type", sleepType);
    addParam(@"date", date);
    return dict;
}

//29 客户端版本更新接口
NSDictionary *appversion()
{
    initDict();
    
    return dict;
}

//30 手环固件版本更新接口
NSDictionary *bandversion()
{
    initDict();
    
    return dict;
}

//31 运动和睡眠第三方分享
NSDictionary *share(NSInteger uid, NSInteger datetype, NSInteger type)
{
    initDict();
    
    addParam(@"uid", [NSNumber numberWithInteger:uid]);
    addParam(@"detetype", [NSNumber numberWithInteger:datetype]);
    addParam(@"type", [NSNumber numberWithInteger:type]);
    
    return dict;
}

//32 运动和睡眠第三方分享
NSDictionary *sport(NSInteger uid, NSInteger step)
{
    initDict();
    
    addParam(@"uid", [NSNumber numberWithInteger:uid]);
    addParam(@"steps", [NSNumber numberWithInteger:step]);
    
    return dict;
}


@implementation PckData

@end
