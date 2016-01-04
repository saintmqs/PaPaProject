//
//  SelectStepsViewController.h
//  EtuProject
//
//  Created by 王家兴 on 15/11/10.
//  Copyright © 2015年 王家兴. All rights reserved.
//

#import "BaseViewController.h"
#import "CSPickerView.h"

@interface SelectStepsViewController : BaseViewController<CSPickerViewDataSource, CSPickerViewDelegate>

@property (nonatomic, assign) BOOL isFromUserInfoSet;
@property (nonatomic, assign) NSInteger ScrollToStep;//滚到指定步数
@property (nonatomic, assign) NSInteger maxLimitStep;//限制最大步数
@property (nonatomic, assign) NSInteger minLimitStep;//限制最小步数

@property (nonatomic, strong) CSPickerView *stepPickerView;

- (void)pickerView:(CSPickerView *)pickerView
         tableView:(UITableView *)tableView
      populateCell:(UITableViewCell *)cell
             atRow:(NSInteger)row;

@end
