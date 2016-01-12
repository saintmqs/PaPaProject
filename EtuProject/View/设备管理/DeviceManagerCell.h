//
//  DeviceManagerCell.h
//  EtuProject
//
//  Created by 王家兴 on 16/1/6.
//  Copyright © 2016年 王家兴. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    NORMAL_TYPE,
    DETAIL_TYPE,
    SWITCH_TYPE,
}DeviceManagerCellType;

@interface DeviceManagerCell : UITableViewCell

@property (nonatomic, assign) DeviceManagerCellType cellType;
@property (nonatomic, strong) UILabel *managerTitleLabel;
@property (nonatomic, strong) UILabel *managerDetailLabel;
@property (nonatomic, strong) UISwitch *managerSwitch;

@property (nonatomic, strong) UIImageView *seperateLine;

@end
