//
//  SelectHeightViewController.h
//  EtuProject
//
//  Created by 王家兴 on 15/11/10.
//  Copyright © 2015年 王家兴. All rights reserved.
//

#import "BaseViewController.h"
#import "CSPickerView.h"

@interface SelectHeightViewController : BaseViewController<CSPickerViewDataSource, CSPickerViewDelegate>

@property (nonatomic, assign) BOOL isFromUserInfoSet;
@property (nonatomic, assign) NSInteger ScrollToHeight;//滚到指定身高
@property (nonatomic, assign) NSInteger maxLimitHeight;//限制最大年龄（没有设置默认2049）
@property (nonatomic, assign) NSInteger minLimitHeight;//限制最小年龄（没有设置默认1970)

@property (nonatomic, strong) CSPickerView *heightPickerView;

// For children view controllers.
- (void)pickerView:(CSPickerView *)pickerView
         tableView:(UITableView *)tableView
      populateCell:(UITableViewCell *)cell
             atRow:(NSInteger)row;

@end
