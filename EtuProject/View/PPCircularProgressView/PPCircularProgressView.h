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
    NSTimer *timer;
}
@property(nonatomic, strong) UIColor *trackTintColor;
@property(nonatomic, strong) UIColor *progressTintColor;
@property (nonatomic, assign) float targetProgress;
@property (nonatomic) float progress;

-(void)changeProgress;
@end

