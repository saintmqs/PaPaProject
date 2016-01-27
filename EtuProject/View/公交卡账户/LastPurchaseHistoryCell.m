//
//  LastPurchaseHistoryCell.m
//  EtuProject
//
//  Created by 王家兴 on 16/1/9.
//  Copyright © 2016年 王家兴. All rights reserved.
//

#import "LastPurchaseHistoryCell.h"

@implementation LastPurchaseHistoryCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 240, 16)];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.text = @"消费";
        [self addSubview:_titleLabel];
        
        _dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(mScreenWidth - 62 - 15, 12, 62, 12)];
        _dateLabel.textColor = [UIColor grayColor];
        _dateLabel.font = [UIFont systemFontOfSize:10];
        _dateLabel.text = @"0000-00-00";
        _dateLabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:_dateLabel];
        
//        _detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, _titleLabel.frameBottom + 8, 240, 16)];
//        _detailLabel.textColor = [UIColor grayColor];
//        _detailLabel.font = [UIFont systemFontOfSize:12];
//        _detailLabel.textAlignment = NSTextAlignmentLeft;
//        _detailLabel.text = @"余额：124.00";
//        [self addSubview:_detailLabel];
        
        _priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(_detailLabel.frameRight + 10, _dateLabel.frameBottom + 5, mScreenWidth - _detailLabel.frameRight - 10 - 15, 20)];
        _priceLabel.textColor = [UIColor blackColor];
        _priceLabel.font = [UIFont systemFontOfSize:18];
        _priceLabel.textAlignment = NSTextAlignmentRight;
        _priceLabel.text = @"0.00";
        [self addSubview:_priceLabel];
        
        _seperateLine = [[UIImageView alloc] initWithFrame:CGRectMake(10, 60 - 1, mScreenWidth - 20, 1)];
        _seperateLine.backgroundColor = rgbaColor(238, 240, 241, 1);
        [self addSubview:_seperateLine];
        
    }
    return self;
}

@end
