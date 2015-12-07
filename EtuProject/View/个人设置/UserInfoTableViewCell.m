//
//  UserInfoTableViewCell.m
//  EtuProject
//
//  Created by 王家兴 on 15/12/4.
//  Copyright © 2015年 王家兴. All rights reserved.
//

#import "UserInfoTableViewCell.h"

@implementation UserInfoTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, (60-30)/2, 80, 30)];
        _titleLabel.textColor = [UIColor grayColor];
        _titleLabel.font = [UIFont systemFontOfSize:16];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_titleLabel];
        
        
        _detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(mScreenWidth/2 - 20, (60-30)/2, mScreenWidth/2, 30)];
        _detailLabel.textColor = [UIColor blackColor];
        _detailLabel.font = [UIFont systemFontOfSize:16];
        _detailLabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:_detailLabel];
        
        _seperateLine = [[UIImageView alloc] initWithFrame:CGRectMake(10, 60 - 1, mScreenWidth - 20, 1)];
        _seperateLine.backgroundColor = rgbaColor(238, 240, 241, 1);
        [self addSubview:_seperateLine];

    }
    return self;
}

@end
