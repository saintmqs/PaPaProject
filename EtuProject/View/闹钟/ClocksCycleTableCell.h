//
//  ClocksCycleTableCell.h
//  EtuProject
//
//  Created by 王家兴 on 16/1/20.
//  Copyright © 2016年 王家兴. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClocksCycleTableCell : UITableViewCell

@property (nonatomic, assign) BOOL    checked;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *checkButton;
@property (nonatomic, strong) UIImageView *seperateLine;
@end
