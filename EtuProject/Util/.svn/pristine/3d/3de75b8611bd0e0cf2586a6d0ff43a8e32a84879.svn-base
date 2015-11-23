//
//  UIButton+Oxygen.h
//  Oxygen
//
//  Created by 黄 时欣 on 12-9-4.
//  Copyright (c) 2012年 NYDNA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#define OXYGEN_BTN_DEFAULT_TINT @"#b3df57"	// @"#B5E566"

typedef enum {
	TOP,
	LEFT,
	BOTTOM,
	RIGHT,
	CENTER
} ImageDirection;

typedef void (^ ButtonClickBlock)(UIButton *btn);

@interface UIButton (Oxygen)

+ (id)btnWithDefaultStylewithFrame:(CGRect)frame;
+ (id)btnWithDefaultStylewithFrame:(CGRect)frame withTintColor:(NSObject *)color;

// 纯色按钮 默认 OXYGEN_BTN_DEFAULT_TINT 颜色
+ (id)btnDefaultFrame:(CGRect)frame title:(NSString *)title;
+ (id)btnDefaultFrame:(CGRect)frame title:(NSString *)title font:(int)font;

// 设置按钮中 图片相对于文字的方向
- (void)setImageDirection:(ImageDirection)direction;
// span 图片和文字之间的间距
- (void)setImageDirection:(ImageDirection)direction withSpan:(float)span;

- (void)setClickBlock:(ButtonClickBlock)block;
@end

