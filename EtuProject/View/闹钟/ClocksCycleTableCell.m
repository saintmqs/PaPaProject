//
//  ClocksCycleTableCell.m
//  EtuProject
//
//  Created by 王家兴 on 16/1/20.
//  Copyright © 2016年 王家兴. All rights reserved.
//

#import "ClocksCycleTableCell.h"

@implementation ClocksCycleTableCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, (60-30)/2, 80, 30)];
        _titleLabel.textColor = [UIColor grayColor];
        _titleLabel.font = [UIFont systemFontOfSize:18];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_titleLabel];
        
        _checkButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _checkButton.frame = CGRectMake(mScreenWidth - 20 - 40, 10, 40, 40);
        [_checkButton setImage:[UIImage imageNamed:@"btnCheckboxA"] forState:UIControlStateNormal];
        [_checkButton setImage:[UIImage imageNamed:@"btnCheckboxB"] forState:UIControlStateSelected];
        addBtnAction(_checkButton, @selector(buttonChecked:));
        [self addSubview:_checkButton];
        
        _seperateLine = [[UIImageView alloc] initWithFrame:CGRectMake(10, 60 - 1, mScreenWidth - 20, 1)];
        _seperateLine.backgroundColor = rgbaColor(238, 240, 241, 1);
        [self addSubview:_seperateLine];
        
    }
    return self;
}


-(void)buttonChecked:(UIButton *)button
{
    button.selected =!button.selected;
    _checked = button.selected;
}

-(void)setChecked:(BOOL)checked
{
    _checked = checked;
    _checkButton.selected = checked;
}
@end
