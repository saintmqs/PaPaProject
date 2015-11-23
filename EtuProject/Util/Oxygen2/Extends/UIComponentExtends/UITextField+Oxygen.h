//
//  UITextField+Oxygen.h
//  Oxygen
//
//  Created by 黄 时欣 on 12-9-5.
//  Copyright (c) 2012年 NYDNA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (Oxygen)
@property (nonatomic, assign) NSInteger maxLength;

+ (id)textFieldWithFrame:(CGRect)frame;
+ (id)textFieldWithFrame:(CGRect)frame font:(int)deltaSize;
+ (id)textFieldWithFrame:(CGRect)frame font:(int)deltaSize label:(NSString *)label;
+ (id)textFieldWithFrame:(CGRect)frame font:(int)deltaSize label:(NSString *)label labelTextColor:(UIColor *)textColor;
+ (id)textFieldWithFrame:(CGRect)frame font:(int)deltaSize icon:(UIImage *)img;
+ (id)textFieldWithFrame:(CGRect)frame font:(int)deltaSize icon:(UIImage *)img rightView:(UIView *)rightView;
+ (id)textFieldWithFrame:(CGRect)frame font:(int)deltaSize icon:(UIImage *)img clearButton:(UIButton *)clear;
+ (id)textFieldWithFrame:(CGRect)frame font:(int)deltaSize label:(NSString *)label rightView:(UIView *)rightView;
+ (id)textFieldWithFrame:(CGRect)frame font:(int)deltaSize label:(NSString *)label rightImg:(UIImage *)right;

+ (id)bTextFieldWithFrame:(CGRect)frame;
+ (id)bTextFieldWithFrame:(CGRect)frame font:(int)deltaSize;
+ (id)bTextFieldWithFrame:(CGRect)frame font:(int)deltaSize label:(NSString *)label;
+ (id)bTextFieldWithFrame:(CGRect)frame font:(int)deltaSize icon:(UIImage *)img;
+ (id)bTextFieldWithFrame:(CGRect)frame font:(int)deltaSize icon:(UIImage *)img rightView:(UIView *)rightView;
+ (id)bTextFieldWithFrame:(CGRect)frame font:(int)deltaSize label:(NSString *)label rightView:(UIView *)rightView;

// - (BOOL)isShowAccessoryView;
// - (void)setShowAccessoryView:(BOOL)show;

- (void)setMaxLength:(NSInteger)maxLength;
- (NSInteger)maxLength;
@end

