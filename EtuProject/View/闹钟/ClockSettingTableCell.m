//
//  ClockSettingTableCell.m
//  EtuProject
//
//  Created by 王家兴 on 16/1/5.
//  Copyright © 2016年 王家兴. All rights reserved.
//

#import "ClockSettingTableCell.h"

@implementation ClockSettingTableCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        _settingTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, (60-30)/2, 80, 30)];
        _settingTitleLabel.textColor = [UIColor grayColor];
        _settingTitleLabel.font = [UIFont systemFontOfSize:18];
        _settingTitleLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_settingTitleLabel];
        
        _settingDetailLabel = [[UILabel alloc] initWithFrame:CGRectMake(mScreenWidth/2 - 20, (60-30)/2, mScreenWidth/2, 30)];
        _settingDetailLabel.textColor = [UIColor lightGrayColor];
        _settingDetailLabel.font = [UIFont systemFontOfSize:16];
        _settingDetailLabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:_settingDetailLabel];
        
        _settingSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(mScreenWidth - 20 - 60, (60-30)/2, 60, 30)];
        [_settingSwitch setOnTintColor:rgbaColor(0, 156, 233, 1)];
        [_settingSwitch setOnDynamicBlock:^(UIView *view, float percent) {
            //激活闹钟
        }];
        [self addSubview:_settingSwitch];
        
        _seperateLine = [[UIImageView alloc] initWithFrame:CGRectMake(10, 60 - 1, mScreenWidth - 20, 1)];
        _seperateLine.backgroundColor = rgbaColor(238, 240, 241, 1);
        [self addSubview:_seperateLine];
        
    }
    return self;
}

-(void)setCellType:(ClockSettingCellType)cellType
{
    _cellType = cellType;
    
    switch (cellType) {
        case DETAIL_TYPE:
        {
            _settingDetailLabel.hidden = NO;
            _settingSwitch.hidden = YES;
        }
            break;
        case SWITCH_TYPE:
        {
            _settingDetailLabel.hidden = YES;
            _settingSwitch.hidden = NO;
        }
            break;
        default:
            break;
    }
}
@end
