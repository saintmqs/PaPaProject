//
//  HomePageDotView.m
//  EtuProject
//
//  Created by 王家兴 on 15/11/28.
//  Copyright © 2015年 王家兴. All rights reserved.
//

#import "HomePageDotView.h"

static CGFloat const kAnimateDuration = 1;

@implementation HomePageDotView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initialization];
    }
    
    return self;
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialization];
    }
    return self;
}


- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initialization];
    }
    
    return self;
}


- (void)initialization
{
    self.backgroundColor = [UIColor whiteColor];
    self.layer.cornerRadius = self.frame.size.width/2;
}


- (void)changeActivityState:(BOOL)active
{
    if (active) {
        [self animateToActiveState];
    } else {
        [self animateToDeactiveState];
    }
}


- (void)animateToActiveState
{
    [UIView animateWithDuration:kAnimateDuration delay:0 usingSpringWithDamping:.5 initialSpringVelocity:-20 options:UIViewAnimationOptionCurveLinear animations:^{
        self.backgroundColor = [UIColor yellowColor];
        self.alpha = 0.8f;
        //        self.transform = CGAffineTransformConcat(CGAffineTransformMakeScale(1.4, 1.4), CGAffineTransformMakeRotation(M_PI)) ;
    } completion:nil];
}

- (void)animateToDeactiveState
{
    self.transform = CGAffineTransformIdentity;
    
    [UIView animateWithDuration:kAnimateDuration delay:0 usingSpringWithDamping:.5 initialSpringVelocity:0 options:UIViewAnimationOptionCurveLinear animations:^{
        self.backgroundColor = [UIColor whiteColor];
        self.alpha = 0.3f;
    } completion:nil];
}

@end
