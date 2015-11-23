//
//  CustomPickerModel.h
//  EtuProject
//
//  Created by 王家兴 on 15/11/7.
//  Copyright © 2015年 王家兴. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    Model_Height,
    Model_Weight,
    Model_Step,
} ModelType;

@interface CustomPickerModel : NSObject

@property (nonatomic, strong) NSString *year;
@property (nonatomic, strong) NSString *month;
@property (nonatomic, strong) NSString *day;

@property (nonatomic, strong) NSString *heightData;
@property (nonatomic, strong) NSString *weightData;
@property (nonatomic, strong) NSString *stepData;

- (id)initWithDate:(NSDate *)date;
- (id)initWithData:(NSInteger)data type:(ModelType)type;
@end
