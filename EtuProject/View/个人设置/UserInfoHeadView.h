//
//  UserInfoHeadView.h
//  EtuProject
//
//  Created by 王家兴 on 15/12/3.
//  Copyright © 2015年 王家兴. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UserInfoHeadViewDelegate <NSObject>

-(void)editHeadImage;

@end

@interface UserInfoHeadView : UIView

@property (nonatomic, assign) id<UserInfoHeadViewDelegate> delegate;
@property (nonatomic, strong) UIButton *headImageView;
@property (nonatomic, strong) UILabel     *stepLabel;
@property (nonatomic, strong) UILabel     *dayLabel;
@property (nonatomic, strong) UILabel     *distanceLabel;
@end
