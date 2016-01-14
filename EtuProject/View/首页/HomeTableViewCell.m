//
//  HomeTableViewCell.m
//  EtuProject
//
//  Created by 王家兴 on 15/11/28.
//  Copyright © 2015年 王家兴. All rights reserved.
//

#import "HomeTableViewCell.h"

@implementation HomeTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        _iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, (60 - 20)/2, 20, 20)];
        _iconImageView.backgroundColor = [UIColor clearColor];
        [_iconImageView setImage:[UIImage imageNamed:@"icoA-1"]];
        [self addSubview:_iconImageView];
        
        _moneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(_iconImageView.frameRight + 20, 6, 200, 30)];
        _moneyLabel.text = @"0.00元";
        _moneyLabel.font = [UIFont systemFontOfSize:24];
        _moneyLabel.textColor = [UIColor orangeColor];
        [self addSubview:_moneyLabel];
        
        _updateTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(_iconImageView.frameRight + 20, _moneyLabel.frameBottom+2, 150, 15)];
        _updateTimeLabel.text = @"同步时间 00-00 --:--";
        _updateTimeLabel.textColor = [UIColor grayColor];
        _updateTimeLabel.font = [UIFont systemFontOfSize:12];
        [self addSubview:_updateTimeLabel];
        
        _updateButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _updateButton.frame = CGRectMake(mScreenWidth - 10 - 70, (60 - 25)/2, 70, 25);
        [_updateButton setTitle:@"刷新余额" forState:UIControlStateNormal];
        [_updateButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _updateButton.titleLabel.font = [UIFont systemFontOfSize:16];
        addBtnAction(_updateButton, @selector(refreshBalance));
        [self addSubview:_updateButton];
        
        UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(5, 60 - 1, mScreenWidth - 10, 1)];
        line.backgroundColor = rgbaColor(238, 240, 241, 1);
        [self addSubview:line];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - Button Method
-(void)refreshBalance
{
    if (_delegate && [_delegate respondsToSelector:@selector(updateBalace)]) {
        [_delegate updateBalace];
    }
}
@end

@implementation HomeTableViewCommonCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
//        _iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, (60 - 20)/2, 20, 20)];
//        _iconImageView.backgroundColor = [UIColor redColor];
//        [self addSubview:_iconImageView];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, mScreenWidth - 40 - 20, 40)];
        _titleLabel.textColor = [UIColor grayColor];
        _titleLabel.font = [UIFont systemFontOfSize:18];
        [self addSubview:_titleLabel];
        
        UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(5, 60 - 1, mScreenWidth - 10, 1)];
        line.backgroundColor = rgbaColor(238, 240, 241, 1);
        [self addSubview:line];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
