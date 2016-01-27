//
//  ClockModel.h
//  EtuProject
//
//  Created by 王家兴 on 16/1/26.
//  Copyright © 2016年 王家兴. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClockModel : NSObject

@property (nonatomic, assign) BOOL isOn; //闹钟是否开启

/*
 1 只响一次
 2 自定义(周一至周日之间选择)
*/
@property (nonatomic, assign) NSInteger y;
@property (nonatomic, strong) NSString *t; //具体唤醒时间(24小时制)  格式 07:00

/*
 如果y的值是2,该参数有值，其他情况为0
 
 1,2,3,4,5,6,7
 用英文逗号当分割符号
 
 1  星期一
 2  星期二
 3  星期三
 4  星期四
 5  星期五
 6  星期六
 7  星期日
 */
@property (nonatomic, strong) NSString *w;

@end
