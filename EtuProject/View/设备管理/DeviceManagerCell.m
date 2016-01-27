//
//  DeviceManagerCell.m
//  EtuProject
//
//  Created by 王家兴 on 16/1/6.
//  Copyright © 2016年 王家兴. All rights reserved.
//

#import "DeviceManagerCell.h"

@implementation DeviceManagerCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        _managerTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, (60-30)/2, 100, 30)];
        _managerTitleLabel.textColor = [UIColor blackColor];
        _managerTitleLabel.font = [UIFont systemFontOfSize:18];
        _managerTitleLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_managerTitleLabel];
        
        _managerDetailLabel = [[UILabel alloc] initWithFrame:CGRectMake(mScreenWidth/2 - 20, (60-30)/2, mScreenWidth/2, 30)];
        _managerDetailLabel.textColor = [UIColor lightGrayColor];
        _managerDetailLabel.font = [UIFont systemFontOfSize:16];
        _managerDetailLabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:_managerDetailLabel];
        
        _managerSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(mScreenWidth - 20 - 60, (60-30)/2, 60, 30)];
        [_managerSwitch setOnTintColor:rgbaColor(0, 156, 233, 1)];
        _managerSwitch.on = NO;//设置初始为ON的一边
        
        [_managerSwitch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
        
        [self addSubview:_managerSwitch];
        
        _seperateLine = [[UIImageView alloc] initWithFrame:CGRectMake(10, 60 - 1, mScreenWidth - 20, 1)];
        _seperateLine.backgroundColor = rgbaColor(238, 240, 241, 1);
        [self addSubview:_seperateLine];
        
    }
    return self;
}

-(void)setCellType:(DeviceManagerCellType)cellType
{
    _cellType = cellType;
    
    switch (cellType) {
        case NORMAL_TYPE:
        {
            _managerDetailLabel.hidden = YES;
            _managerSwitch.hidden = YES;
        }
            break;
        case DETAIL_TYPE:
        {
            _managerDetailLabel.hidden = NO;
            _managerSwitch.hidden = YES;
        }
            break;
        case SWITCH_TYPE:
        {
            _managerDetailLabel.hidden = YES;
            _managerSwitch.hidden = NO;
        }
            break;
        default:
            break;
    }
}

-(void) switchAction:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(deviceManagerSwitchAction:)]) {
        [_delegate deviceManagerSwitchAction:sender];
    }
}
@end
