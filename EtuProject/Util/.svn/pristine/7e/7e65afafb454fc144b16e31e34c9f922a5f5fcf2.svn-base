//
//  UITextView+Oxygen.m
//  cpsdna
//
//  Created by 黄 时欣 on 13-11-8.
//  Copyright (c) 2013年 黄 时欣. All rights reserved.
//

#import "UITextView+Oxygen.h"

@interface OFTextViewDelegate : NSObject <UITextViewDelegate>
@end

@implementation OFTextViewDelegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
	NSString	*temp	= [textView.text stringByReplacingCharactersInRange:range withString:text];
	NSUInteger	max		= [textView maxLength];

	if (temp.length > max) {
		textView.text = [temp substringToIndex:max];
		return NO;
	}

	return YES;
}

@end

@implementation UITextView (Oxygen)

static NSString * showAccessoryViewKey;
- (BOOL)isShowAccessoryView
{
	id value = objc_getAssociatedObject(self, &showAccessoryViewKey);

	return [value boolValue];
}

- (void)setShowAccessoryView:(BOOL)show
{
	[self willChangeValueForKey:@"showAccessoryView"];
	objc_setAssociatedObject(self, &showAccessoryViewKey, [NSNumber numberWithBool:show], OBJC_ASSOCIATION_ASSIGN);
	[self didChangeValueForKey:@"showAccessoryView"];

	if (show) {
		[self initKeyboardHideButton];
	} else {
		self.inputAccessoryView = nil;
	}
}

- (void)initKeyboardHideButton
{
	if (self.inputAccessoryView) {
		return;
	}

	UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 320, 25)];
	[btn addTarget:self action:@selector(hideKeyboardByTopButton) forControlEvents:UIControlEventTouchUpInside];
	[btn setBackgroundImage:OxygenBundleImage(@"of_topkeyboard") forState:UIControlStateNormal];
	self.inputAccessoryView = btn;
}

- (void)hideKeyboardByTopButton
{
	[self resignFirstResponder];
}

static NSString *ofTextViewMaxLengthKey;
- (void)setMaxLength:(NSInteger)maxLength
{
	[self willChangeValueForKey:@"ofTextViewMaxLengthKey"];
	objc_setAssociatedObject(self, &ofTextViewMaxLengthKey, [NSNumber numberWithInteger:maxLength], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
	[self didChangeValueForKey:@"ofTextViewMaxLengthKey"];

	[self setOfTextViewDelegate:[[OFTextViewDelegate alloc]init]];
}

- (NSInteger)maxLength
{
	id value = objc_getAssociatedObject(self, &ofTextViewMaxLengthKey);

	return [value integerValue];
}

static NSString *ofTextViewDelegateKey;
- (void)setOfTextViewDelegate:(OFTextViewDelegate *)delegate
{
	[self willChangeValueForKey:@"ofTextViewDelegateKey"];
	objc_setAssociatedObject(self, &ofTextViewDelegateKey, delegate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
	[self didChangeValueForKey:@"ofTextViewDelegateKey"];
	self.delegate = delegate;
}

@end

