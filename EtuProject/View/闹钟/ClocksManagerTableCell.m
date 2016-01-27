//
//  ClocksManagerTableCell.m
//  EtuProject
//
//  Created by 王家兴 on 15/12/18.
//  Copyright © 2015年 王家兴. All rights reserved.
//

#import "ClocksManagerTableCell.h"

@implementation ClocksManagerTableCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        _clockTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, (60-30)/2, 80, 30)];
        _clockTimeLabel.textColor = [UIColor blackColor];
        _clockTimeLabel.font = [UIFont systemFontOfSize:24];
        _clockTimeLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_clockTimeLabel];
        
        
        _clockSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(mScreenWidth - 20 - 60, (60-30)/2, 60, 30)];
        [_clockSwitch setOnTintColor:rgbaColor(0, 156, 233, 1)];
        _clockSwitch.on = NO;//设置初始为ON的一边
        self.clockModel.isOn = NO;
        
        [_clockSwitch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
        
        [self addSubview:_clockSwitch];
        
        _seperateLine = [[UIImageView alloc] initWithFrame:CGRectMake(10, 60 - 1, mScreenWidth - 20, 1)];
        _seperateLine.backgroundColor = rgbaColor(238, 240, 241, 1);
        [self addSubview:_seperateLine];
        
    }
    return self;
}

-(void) switchAction:(id)sender
{
    UISwitch *tempswitch = (UISwitch *)sender;
    BOOL setting = tempswitch.isOn;
    [tempswitch setOn:setting animated:YES];
    self.clockModel.isOn = setting;
}
@end
