//
//  SelectWeightViewController.h
//  EtuProject
//
//  Created by 王家兴 on 15/11/10.
//  Copyright © 2015年 王家兴. All rights reserved.
//

#import "BaseViewController.h"
#import "CSPickerView.h"

@interface SelectWeightViewController : BaseViewController<CSPickerViewDataSource, CSPickerViewDelegate>

@property (nonatomic, assign) NSInteger ScrollToWeight;//滚到指定体重
@property (nonatomic, assign) NSInteger maxLimitWeight;//限制最大体重
@property (nonatomic, assign) NSInteger minLimitWeight;//限制最小体重

@property (nonatomic, strong) CSPickerView *weightPickerView;

- (void)pickerView:(CSPickerView *)pickerView
         tableView:(UITableView *)tableView
      populateCell:(UITableViewCell *)cell
             atRow:(NSInteger)row;

@end
