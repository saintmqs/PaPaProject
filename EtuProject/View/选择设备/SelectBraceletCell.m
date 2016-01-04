//
//  SelectBraceletCell.m
//  EtuProject
//
//  Created by 王家兴 on 16/1/4.
//  Copyright © 2016年 王家兴. All rights reserved.
//

#import "SelectBraceletCell.h"

@implementation SelectBraceletCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        _iconImage = [[UIImageView alloc] initWithFrame:CGRectMake(20, (60 - 20)/2, 20, 20)];
        [_iconImage setImage:[UIImage imageNamed:@"searchIco1"]];
        [self addSubview:_iconImage];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(_iconImage.frameRight + 20, 10, 200, 40)];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.font = [UIFont systemFontOfSize:18];
        _titleLabel.text = @"啪啪手环";
        [self addSubview:_titleLabel];
        
        _bindLabel = [[UILabel alloc] initWithFrame:CGRectMake(mScreenWidth - 20 - 20 - 70, 10, 70, 40)];
        _bindLabel.textColor = [UIColor whiteColor];
        _bindLabel.font = [UIFont systemFontOfSize:16];
        _bindLabel.textAlignment = NSTextAlignmentCenter;
        _bindLabel.text = @"立即绑定";
        [self addSubview:_bindLabel];
        
        
        _seperateLine = [[UIImageView alloc] initWithFrame:CGRectMake(10, 60 - 1, mScreenWidth - 20, 1)];
        _seperateLine.backgroundColor = rgbaColor(238, 240, 241, 0.1);
        [self addSubview:_seperateLine];
        
    }
    return self;
}
@end
