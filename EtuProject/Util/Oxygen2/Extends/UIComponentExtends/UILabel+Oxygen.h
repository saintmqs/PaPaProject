//
//  UILabel+Oxygen.h
//  Oxygen
//
//  Created by 黄 时欣 on 12-9-4.
//  Copyright (c) 2012年 NYDNA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (Oxygen)

+ (id)labelWithFrame:(CGRect)frame;
+ (id)labelWithFrame:(CGRect)frame font:(int)deltaSize;
+ (id)labelWithFrame:(CGRect)frame color:(NSObject *)color;
+ (id)labelWithFrame:(CGRect)frame font:(int)deltaSize color:(NSObject *)color;

+ (id)bLabelWithFrame:(CGRect)frame;
+ (id)bLabelWithFrame:(CGRect)frame font:(int)deltaSize;
+ (id)bLabelWithFrame:(CGRect)frame color:(NSObject *)color;
+ (id)bLabelWithFrame:(CGRect)frame font:(int)deltaSize color:(NSObject *)color;

// 文本合适的size
- (CGSize)textSize:(CGSize)origin;
// 改变frame到文本的大小，在setText后调用
- (CGRect)frameFitToTextWidth;
- (CGSize)resizeHeightByContentText;
- (CGSize)setTextAndResizeHeight:(NSString *)text;

//上下对齐
- (void)alignTop;
- (void)alignBottom;
@end

