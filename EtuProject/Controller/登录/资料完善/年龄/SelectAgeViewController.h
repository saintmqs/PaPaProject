//
//  SelectAgeViewController.h
//  EtuProject
//
//  Created by 王家兴 on 15/11/8.
//  Copyright © 2015年 王家兴. All rights reserved.
//

#import "BaseViewController.h"
#import "CSPickerView.h"

@interface SelectAgeViewController : BaseViewController<CSPickerViewDataSource, CSPickerViewDelegate>

@property (nonatomic, strong) NSDate *ScrollToDate;//滚到指定年龄
@property (nonatomic, strong) NSDate *maxLimitDate;//限制最大年龄（没有设置默认2049）
@property (nonatomic, strong) NSDate *minLimitDate;//限制最小年龄（没有设置默认1970)

@property (nonatomic, strong) CSPickerView *yearPickerView;
@property (nonatomic, strong) CSPickerView *monthPickerView;
@property (nonatomic, strong) CSPickerView *dayPickerView;

- (void)pickerView:(CSPickerView *)pickerView
         tableView:(UITableView *)tableView
      populateCell:(UITableViewCell *)cell
             atRow:(NSInteger)row;

- (NSDate *)dateFromString:(NSString *)string withFormat:(NSString *)format;

@end
