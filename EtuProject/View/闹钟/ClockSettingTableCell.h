//
//  ClockSettingTableCell.h
//  EtuProject
//
//  Created by 王家兴 on 16/1/5.
//  Copyright © 2016年 王家兴. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    DETAIL_TYPE,
    SWITCH_TYPE,
}ClockSettingCellType;

@protocol ClockSettingTableCellDelegate <NSObject>

-(void)settingSwitchAction:(id)sender;

@end

@interface ClockSettingTableCell : UITableViewCell

@property (nonatomic, assign) id<ClockSettingTableCellDelegate> delegate;
@property (nonatomic, assign) ClockSettingCellType cellType;
@property (nonatomic, strong) UILabel *settingTitleLabel;
@property (nonatomic, strong) UILabel *settingDetailLabel;
@property (nonatomic, strong) UISwitch *settingSwitch;

@property (nonatomic, strong) UIImageView *seperateLine;

@end
