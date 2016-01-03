//
//  UserInfoHeadView.m
//  EtuProject
//
//  Created by 王家兴 on 15/12/3.
//  Copyright © 2015年 王家兴. All rights reserved.
//

#import "UserInfoHeadView.h"

@implementation UserInfoHeadView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = rgbaColor(0, 155, 232, 1);
        
        _headImageView = [[UIImageView alloc] initWithFrame:CGRectMake((mScreenWidth - 78)/2, 20, 78, 78)];
        _headImageView.backgroundColor = [UIColor whiteColor];
        _headImageView.layer.cornerRadius = _headImageView.frameWidth/2;
        _headImageView.layer.masksToBounds = YES;
        [_headImageView sd_setImageWithURL:[NSURL URLWithString:APP_DELEGATE.userData.avatar] placeholderImage:nil];
        [self addSubview:_headImageView];
        
        UIImageView *headBgImageView = [[UIImageView alloc] initWithFrame:CGRectMake((mScreenWidth - 90)/2, 10, 90, 90)];
        [headBgImageView setImage:[UIImage imageNamed:@"headBackground"]];
        headBgImageView.center = CGPointMake(_headImageView.center.x, _headImageView.center.y - 2);
        [self addSubview:headBgImageView];
        
        CGFloat labelsWidth = (mScreenWidth - 1)/3;
        UIView *infosView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frameHeight - 30 - 10, mScreenWidth , 30)];
        [self addSubview:infosView];
        
        {
            UILabel *stepTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, labelsWidth, 14)];
            stepTitleLabel.textAlignment = NSTextAlignmentCenter;
            stepTitleLabel.font = [UIFont systemFontOfSize:12];
            stepTitleLabel.textColor = [UIColor whiteColor];
            stepTitleLabel.alpha = 0.5;
            stepTitleLabel.text = @"日均步数";
            [infosView addSubview:stepTitleLabel];
            
            _stepLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, stepTitleLabel.frameBottom+2, labelsWidth, 14)];
            _stepLabel.textAlignment = NSTextAlignmentCenter;
            _stepLabel.font = [UIFont boldSystemFontOfSize:13];
            _stepLabel.textColor = [UIColor whiteColor];
            _stepLabel.text = @"2719";
            [infosView addSubview:_stepLabel];
            
            UIImageView *line1 = [[UIImageView alloc] initWithFrame:CGRectMake(labelsWidth, 2, 0.5, 26)];
            line1.backgroundColor = [UIColor whiteColor];
            line1.alpha = 0.3;
            [infosView addSubview:line1];
         
            UILabel *dayTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(stepTitleLabel.frameRight+0.5, 0, labelsWidth, 14)];
            dayTitleLabel.textAlignment = NSTextAlignmentCenter;
            dayTitleLabel.font = [UIFont systemFontOfSize:12];
            dayTitleLabel.textColor = [UIColor whiteColor];
            dayTitleLabel.alpha = 0.5;
            dayTitleLabel.text = @"佩戴天数";
            [infosView addSubview:dayTitleLabel];
            
            _dayLabel = [[UILabel alloc] initWithFrame:CGRectMake(stepTitleLabel.frameRight+0.5, dayTitleLabel.frameBottom+2, labelsWidth, 14)];
            _dayLabel.textAlignment = NSTextAlignmentCenter;
            _dayLabel.font = [UIFont boldSystemFontOfSize:13];
            _dayLabel.textColor = [UIColor whiteColor];
            _dayLabel.text = @"3";
            [infosView addSubview:_dayLabel];
            
            UIImageView *line2 = [[UIImageView alloc] initWithFrame:CGRectMake(labelsWidth*2+0.5, 2, 0.5, 26)];
            line2.backgroundColor = [UIColor whiteColor];
            line2.alpha = 0.3;
            [infosView addSubview:line2];
            
            UILabel *distanceTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(dayTitleLabel.frameRight+0.5, 0, labelsWidth, 14)];
            distanceTitleLabel.textAlignment = NSTextAlignmentCenter;
            distanceTitleLabel.font = [UIFont systemFontOfSize:12];
            distanceTitleLabel.textColor = [UIColor whiteColor];
            distanceTitleLabel.alpha = 0.5;
            distanceTitleLabel.text = @"总公里数";
            [infosView addSubview:distanceTitleLabel];
            
            _distanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(dayTitleLabel.frameRight+0.5, distanceTitleLabel.frameBottom+2, labelsWidth, 14)];
            _distanceLabel.textAlignment = NSTextAlignmentCenter;
            _distanceLabel.font = [UIFont boldSystemFontOfSize:13];
            _distanceLabel.textColor = [UIColor whiteColor];
            _distanceLabel.text = @"5.2";
            [infosView addSubview:_distanceLabel];
        }
    }
    return self;
}

@end
