//
//  PPCircularProgressView.h
//  EtuProject
//
//  Created by 王家兴 on 15/11/26.
//  Copyright © 2015年 王家兴. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PPCircularProgressView : UIView
{
    UIView *whitepoint;
}
@property(nonatomic, strong) UIColor *trackTintColor;
@property(nonatomic, strong) UIColor *progressTintColor;
@property (nonatomic) float progress;

@end

