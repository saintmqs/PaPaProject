//
//  CustomPicker.h
//  EtuProject
//
//  Created by 王家兴 on 15/11/7.
//  Copyright © 2015年 王家兴. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CustomPicker;

typedef enum{
    PickerStyle_YearMonthDay,
    PickerStyle_Height,
    PickerStyle_Weight,
    PickerStyle_Step,
} PickerStyle;

@protocol CustomPickerDelegate <NSObject>

- (void)customPicker:(CustomPicker *)picker
                year:(NSString *)year
               month:(NSString *)month
                 day:(NSString *)day
              height:(NSString *)height
              weight:(NSString *)weight
                step:(NSString *)step;

@end

typedef void (^FinishBlock)(NSString * year,
                            NSString * month,
                            NSString * day,
                            NSString * height,
                            NSString * weight,
                            NSString * step);

@interface CustomPicker : UIView<UIPickerViewDelegate,UIPickerViewDataSource>

@property (nonatomic, assign) id <CustomPickerDelegate> delegate;

@property (nonatomic, assign) PickerStyle pickerStyle;

@property (nonatomic, retain) NSDate *ScrollToDate;//滚到指定年龄
@property (nonatomic, retain) NSDate *maxLimitDate;//限制最大年龄（没有设置默认2049）
@property (nonatomic, retain) NSDate *minLimitDate;//限制最小年龄（没有设置默认1970)

@property (nonatomic, assign) NSInteger ScrollToIndex;//滚到指定身高/体重/步数
@property (nonatomic, assign) NSInteger maxLimitIndex;//限制最大身高/体重/步数
@property (nonatomic, assign) NSInteger minLimitIndex;//限制最小身高/体重/步数

- (NSDate *)dateFromString:(NSString *)string withFormat:(NSString *)format;
- (id)initWithframe:(CGRect)frame Delegate:(id<CustomPickerDelegate>)delegate PickerStyle:(PickerStyle)pickerStyle;
- (id)initWithframe:(CGRect)frame PickerStyle:(PickerStyle)pickerStyle didSelected:(FinishBlock)finishBlock;
@end
