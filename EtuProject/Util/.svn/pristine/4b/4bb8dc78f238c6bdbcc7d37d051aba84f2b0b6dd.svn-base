//
//  UITextField+Oxygen.m
//  Oxygen
//
//  Created by 黄 时欣 on 12-9-5.
//  Copyright (c) 2012年 NYDNA. All rights reserved.
//

#import "UITextField+Oxygen.h"
#import "NSString+Oxygen.h"
#import "UILabel+Oxygen.h"
#import "UIImage+Oxygen.h"

@interface OFTextFieldDelegate : NSObject <UITextFieldDelegate>
@end

@implementation OFTextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
	NSString	*temp	= [textField.text stringByReplacingCharactersInRange:range withString:string];
	NSUInteger	max		= [textField maxLength];

	if (temp.length > max) {
		textField.text = [temp substringToIndex:max];
		return NO;
	}

	return YES;
}

@end

@implementation UITextField (Oxygen)

+ (id)textFieldWithFrame:(CGRect)frame
{
	return [UITextField textFieldWithFrame:frame font:0 isBold:NO];
}

+ (id)textFieldWithFrame:(CGRect)frame font:(int)deltaSize
{
	return [UITextField textFieldWithFrame:frame font:deltaSize isBold:NO];
}

+ (id)textFieldWithFrame:(CGRect)frame font:(int)deltaSize label:(NSString *)label
{
	return [UITextField textFieldWithFrame:frame font:deltaSize isBold:NO label:label rightView:nil];
}

+ (id)textFieldWithFrame:(CGRect)frame font:(int)deltaSize label:(NSString *)label labelTextColor:(UIColor *)textColor
{
    return [UITextField textFieldWithFrame:frame font:deltaSize isBold:NO label:label labelTextColor:textColor rightView:nil];
}

+ (id)textFieldWithFrame:(CGRect)frame font:(int)deltaSize icon:(UIImage *)img
{
	return [UITextField textFieldWithFrame:frame font:deltaSize icon:img rightView:nil];
}

+ (id)textFieldWithFrame:(CGRect)frame font:(int)deltaSize icon:(UIImage *)img rightView:(UIView *)rightView
{
	UITextField *tf			= [UITextField textFieldWithFrame:frame font:deltaSize label:nil rightView:rightView];
	UIImageView *leftView	= [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, tf.height, tf.height)];

	leftView.image			= img;
	leftView.contentMode	= UIViewContentModeCenter;
	tf.leftView				= leftView;
	tf.leftViewMode			= UITextFieldViewModeAlways;
	return tf;
}

+ (id)textFieldWithFrame:(CGRect)frame font:(int)deltaSize icon:(UIImage *)img clearButton:(UIButton *)clear
{
	__block UITextField *tf = [UITextField textFieldWithFrame:frame font:deltaSize icon:img rightView:clear];

	tf.rightViewMode = UITextFieldViewModeWhileEditing;
	[clear setClickBlock:^(UIButton *btn) {
		tf.text = @"";
	}];
	return tf;
}

+ (id)textFieldWithFrame:(CGRect)frame font:(int)deltaSize label:(NSString *)label rightView:(UIView *)rightView
{
	return [UITextField textFieldWithFrame:frame font:deltaSize isBold:NO label:label rightView:rightView];
}

+ (id)textFieldWithFrame:(CGRect)frame font:(int)deltaSize label:(NSString *)label rightImg:(UIImage *)right
{
	UIImageView *rightView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, frame.size.height, frame.size.height)];

	rightView.image			= right;
	rightView.contentMode	= UIViewContentModeScaleAspectFit;
	return [UITextField textFieldWithFrame:frame font:deltaSize isBold:NO label:label rightView:rightView];
}

+ (id)bTextFieldWithFrame:(CGRect)frame
{
	return [UITextField textFieldWithFrame:frame font:0 isBold:YES];
}

+ (id)bTextFieldWithFrame:(CGRect)frame font:(int)deltaSize
{
	return [UITextField textFieldWithFrame:frame font:deltaSize isBold:YES];
}

+ (id)bTextFieldWithFrame:(CGRect)frame font:(int)deltaSize label:(NSString *)label
{
	return [UITextField textFieldWithFrame:frame font:deltaSize isBold:YES label:label rightView:nil];
}

+ (id)bTextFieldWithFrame:(CGRect)frame font:(int)deltaSize icon:(UIImage *)img
{
	return [UITextField bTextFieldWithFrame:frame font:deltaSize icon:img rightView:nil];
}

+ (id)bTextFieldWithFrame:(CGRect)frame font:(int)deltaSize icon:(UIImage *)img rightView:(UIView *)rightView
{
	UITextField *tf = [UITextField bTextFieldWithFrame:frame font:deltaSize label:nil rightView:rightView];

	UIImageView *leftView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, tf.height, tf.height)];

	leftView.image			= img;
	leftView.contentMode	= UIViewContentModeCenter;
	tf.leftView				= leftView;
	tf.leftViewMode			= UITextFieldViewModeAlways;
	return tf;
}

+ (id)bTextFieldWithFrame:(CGRect)frame font:(int)deltaSize label:(NSString *)label rightView:(UIView *)rightView
{
	return [UITextField textFieldWithFrame:frame font:deltaSize isBold:YES label:label rightView:rightView];
}

+ (id)textFieldWithFrame:(CGRect)frame font:(int)deltaSize isBold:(BOOL)bold
{
	return [UITextField textFieldWithFrame:frame font:deltaSize isBold:YES label:@"" rightView:nil];
}

+ (id)textFieldWithFrame:(CGRect)frame font:(int)deltaSize isBold:(BOOL)bold label:(NSString *)lable rightView:(UIView *)rightView
{
	UITextField *tf = [[UITextField alloc]initWithFrame:frame];

	//	[tf setShowAccessoryView:YES];

	if (bold) {
		tf.font = [UIFont boldSystemFontOfSize:FONT_SIZE + deltaSize];
	} else {
		tf.font = [UIFont systemFontOfSize:FONT_SIZE + deltaSize];
	}

	tf.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
	tf.clearButtonMode			= UITextFieldViewModeWhileEditing;

	if (![NSString isStringEmptyOrBlank:lable]) {
		UILabel *lab = [UILabel labelWithFrame:CGRectMake(0, 0, frame.size.width * 0.5, frame.size.height) font:deltaSize];
		lab.text			= lable;
		lab.textAlignment	= NSTextAlignmentLeft;
		[lab frameFitToTextWidth];
		tf.leftView		= lab;
		tf.leftViewMode = UITextFieldViewModeAlways;
	}

	if (rightView) {
		tf.rightView		= rightView;
		tf.rightViewMode	= UITextFieldViewModeAlways;
	}

	return tf;
}

+ (id)textFieldWithFrame:(CGRect)frame font:(int)deltaSize isBold:(BOOL)bold label:(NSString *)lable labelTextColor:(UIColor *)textColor rightView:(UIView *)rightView
{
    UITextField *tf = [[UITextField alloc]initWithFrame:frame];
    
    //	[tf setShowAccessoryView:YES];
    
    if (bold) {
        tf.font = [UIFont boldSystemFontOfSize:FONT_SIZE + deltaSize];
    } else {
        tf.font = [UIFont systemFontOfSize:FONT_SIZE + deltaSize];
    }
    
    tf.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    tf.clearButtonMode			= UITextFieldViewModeWhileEditing;
    
    if (![NSString isStringEmptyOrBlank:lable]) {
        UILabel *lab = [UILabel labelWithFrame:CGRectMake(0, 0, frame.size.width * 0.5, frame.size.height) font:deltaSize];
        lab.text			= lable;
        lab.textColor       = textColor;
        lab.textAlignment	= NSTextAlignmentLeft;
        [lab frameFitToTextWidth];
        tf.leftView		= lab;
        tf.leftViewMode = UITextFieldViewModeAlways;
    }
    
    if (rightView) {
        tf.rightView		= rightView;
        tf.rightViewMode	= UITextFieldViewModeAlways;
    }
    
    return tf;
}

// static NSString *showAccessoryViewKey;
// - (BOOL)isShowAccessoryView
// {
//	id value = objc_getAssociatedObject(self, &showAccessoryViewKey);
//
//	return [value boolValue];
// }
//
// - (void)setShowAccessoryView:(BOOL)show
// {
//	[self willChangeValueForKey:@"showAccessoryView"];
//	objc_setAssociatedObject(self, &showAccessoryViewKey, [NSNumber numberWithBool:show], OBJC_ASSOCIATION_ASSIGN);
//	[self didChangeValueForKey:@"showAccessoryView"];
//
//	if (show) {
//		[self initKeyboardHideButton];
//	} else {
//		self.inputAccessoryView = nil;
//	}
// }
//
// - (void)initKeyboardHideButton
// {
//	if (self.inputAccessoryView) {
//		return;
//	}
//
//	UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 320, 25)];
//	[btn addTarget:self action:@selector(hideKeyboardByTopButton) forControlEvents:UIControlEventTouchUpInside];
//	[btn setBackgroundImage:OxygenBundleImage(@"of_topkeyboard") forState:UIControlStateNormal];
//	self.inputAccessoryView = btn;
// }
//
// - (void)hideKeyboardByTopButton
// {
//	[self resignFirstResponder];
// }

static NSString *ofTextFieldMaxLengthKey;
- (void)setMaxLength:(NSInteger)maxLength
{
	[self willChangeValueForKey:@"ofTextFieldMaxLengthKey"];
	objc_setAssociatedObject(self, &ofTextFieldMaxLengthKey, [NSNumber numberWithInteger:maxLength], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
	[self didChangeValueForKey:@"ofTextFieldMaxLengthKey"];

	[self setOfTextFieldDelegate:[[OFTextFieldDelegate alloc]init]];
}

- (NSInteger)maxLength
{
	id value = objc_getAssociatedObject(self, &ofTextFieldMaxLengthKey);

	return [value integerValue];
}

static NSString *ofTextFieldDelegateKey;
- (void)setOfTextFieldDelegate:(OFTextFieldDelegate *)delegate
{
	[self willChangeValueForKey:@"ofTextFieldDelegateKey"];
	objc_setAssociatedObject(self, &ofTextFieldDelegateKey, delegate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
	[self didChangeValueForKey:@"ofTextFieldDelegateKey"];
	self.delegate = delegate;
}

@end

