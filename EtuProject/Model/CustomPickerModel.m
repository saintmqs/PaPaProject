//
//  CustomPickerModel.m
//  EtuProject
//
//  Created by 王家兴 on 15/11/7.
//  Copyright © 2015年 王家兴. All rights reserved.
//

#import "CustomPickerModel.h"

@implementation CustomPickerModel

- (id)initWithDate:(NSDate *)date
{
    self = [super init];
    if (self) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"yyyyMMdd"];
        NSString *dateString = [formatter stringFromDate:date];
        
        self.year     = [dateString substringWithRange:NSMakeRange(0, 4)];
        self.month    = [dateString substringWithRange:NSMakeRange(4, 2)];
        self.day      = [dateString substringWithRange:NSMakeRange(6, 2)];
    }
    return self;
}


- (id)initWithData:(NSInteger)data type:(ModelType)type
{
    self = [super init];
    if (self) {
        switch (type) {
            case Model_Height:
                self.heightData = [NSString stringWithFormat:@"%ld",data];
                break;
            case Model_Weight:
                self.weightData = [NSString stringWithFormat:@"%ld",data];
                break;
            case Model_Step:
                self.stepData = [NSString stringWithFormat:@"%ld",data];
                break;
            default:
                break;
        }
    }
    return self;
}
@end
