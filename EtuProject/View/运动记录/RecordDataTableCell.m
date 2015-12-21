//
//  RecordDataTableCell.m
//  EtuProject
//
//  Created by 王家兴 on 15/12/21.
//  Copyright © 2015年 王家兴. All rights reserved.
//

#import "RecordDataTableCell.h"

@implementation RecordDataTableCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        _seperateLine = [[UIImageView alloc] initWithFrame:CGRectMake(10, 60 - 1, mScreenWidth - 20, 1)];
        _seperateLine.backgroundColor = rgbaColor(238, 240, 241, 1);
        [self addSubview:_seperateLine];
        
    }
    return self;
}

-(void)setTitlesArray:(NSArray *)titlesArray
{
    if (_titlesArray == titlesArray) {
        return;
    }
    _titlesArray = titlesArray;
    
    CGFloat labelWidth = mScreenWidth/titlesArray.count;
    
    for (int i = 0; i<titlesArray.count; i++) {
        UILabel *titleLabel = [[UILabel alloc] initWithFrame: CGRectMake(labelWidth*i, 0, labelWidth, 30)];
        titleLabel.textColor = [UIColor lightGrayColor];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.text = [titlesArray objectAtIndex:i];
        titleLabel.font = [UIFont systemFontOfSize:13];
        [self addSubview:titleLabel];
        
        UILabel *detailLabel = [[UILabel alloc] initWithFrame: CGRectMake(labelWidth*i, 30, labelWidth, 30)];
        detailLabel.textColor = [UIColor blackColor];
        detailLabel.textAlignment = NSTextAlignmentCenter;
        detailLabel.font = [UIFont systemFontOfSize:13];
        detailLabel.tag = 100 + i;
        [self addSubview:detailLabel];
    }
}

-(void)setDataArray:(NSArray *)dataArray
{
    if (_dataArray == dataArray) {
        return;
    }
    _dataArray = dataArray;
    
    for (int i = 0; i<dataArray.count; i++) {
        UILabel *label = (UILabel *)[self view4tag:100+i];
        label.text = [dataArray objectAtIndex:i];
    }
}
@end
