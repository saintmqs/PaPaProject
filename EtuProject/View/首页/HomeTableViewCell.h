//
//  HomeTableViewCell.h
//  EtuProject
//
//  Created by 王家兴 on 15/11/28.
//  Copyright © 2015年 王家兴. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeTableViewCell : UITableViewCell

@property (nonatomic,strong) UIImageView *iconImageView;
@property (nonatomic,strong) UILabel     *moneyLabel;
@property (nonatomic,strong) UILabel     *updateTimeLabel;
@property (nonatomic,strong) UIButton    *updateButton;

@end

@interface HomeTableViewCommonCell : UITableViewCell

@property (nonatomic,strong) UIImageView  *iconImageView;
@property (nonatomic,strong) UILabel      *titleLabel;

@end