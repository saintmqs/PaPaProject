//
//  ClockDetailSettingViewController.h
//  EtuProject
//
//  Created by 王家兴 on 15/11/5.
//  Copyright © 2015年 王家兴. All rights reserved.
//

#import "BaseViewController.h"
#import "CSPickerView.h"

@interface ClockDetailSettingViewController : BaseViewController<CSPickerViewDataSource,CSPickerViewDelegate>

@property (nonatomic, assign) BOOL isFromClockSet;
@property (nonatomic, strong) NSDate *scrollToTime; //滚动到当前时间
@property (nonatomic, strong) NSDate *maxLimitTime; //限制最大时间
@property (nonatomic, strong) NSDate *minLimitTime; //限制最小时间

@property (nonatomic, strong) CSPickerView *hourPickerView;
@property (nonatomic, strong) CSPickerView *minutePickerView;

- (void)pickerView:(CSPickerView *)pickerView
         tableView:(UITableView *)tableView
      populateCell:(UITableViewCell *)cell
             atRow:(NSInteger)row;

- (NSDate *)dateFromString:(NSString *)string withFormat:(NSString *)format;
@end
