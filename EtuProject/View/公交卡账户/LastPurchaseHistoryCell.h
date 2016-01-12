//
//  LastPurchaseHistoryCell.h
//  EtuProject
//
//  Created by 王家兴 on 16/1/9.
//  Copyright © 2016年 王家兴. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LastPurchaseHistoryCell : UITableViewCell

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *detailLabel;
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UILabel *priceLabel;

@property (nonatomic, strong) UIImageView *seperateLine;

@end
