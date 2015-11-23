//
//  PPLoadingView.h
//  EtuProject
//
//  Created by 王家兴 on 15/11/22.
//  Copyright © 2015年 王家兴. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PPLoadingView : UIButton

@property (nonatomic, assign) CGFloat lineWidth;
@property (nonatomic, strong) UIColor *lineColor;
@property (nonatomic, readonly) BOOL isAnimating;

- (id)initWithFrame:(CGRect)frame;
- (void)startAnimation;
- (void)stopAnimation;
@end

#pragma mark - Gradient View

@interface PPGradientView : UIView

@property (nonatomic) NSArray *CGColors;
@property (nonatomic) NSArray *locations;

@end