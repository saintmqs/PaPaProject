//
//  UIAlertView+Oxygen.m
//  Oxygen
//
//  Created by 黄 时欣 on 13-5-23.
//
//

#import "UIAlertView+Oxygen.h"
#import <objc/runtime.h>

@interface UIAlertView () <UIAlertViewDelegate>

@end
@implementation UIAlertView (Oxygen)

static char alertViewDidDismissBlokKey;

- (void)setDidDismissBlok:(UIAlertViewDidDismissBlok)block
{
	self.delegate = self;
	[self willChangeValueForKey:@"AlertViewDidDismissBlok"];
	objc_setAssociatedObject(self, &alertViewDidDismissBlokKey, block, OBJC_ASSOCIATION_COPY_NONATOMIC);
	[self didChangeValueForKey:@"AlertViewDidDismissBlok"];
}

- (UIAlertViewDidDismissBlok)didDismissBlok
{
	id block = objc_getAssociatedObject(self, &alertViewDidDismissBlokKey);

	return block;
}

+ (UIAlertView *)showAlertViewWithTitle:(NSString *)title message:(NSString *)message block:(UIAlertViewDidDismissBlok)block cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ...{
	UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:title message:message delegate:nil cancelButtonTitle:cancelButtonTitle otherButtonTitles:nil];
	va_list		args;
	va_start(args, otherButtonTitles);

	for (NSString *title = otherButtonTitles; title != nil; title = va_arg(args, NSString *)) {
		[alertView addButtonWithTitle:title];
	}

	va_end(args);

	[alertView setDidDismissBlok:block];

	[alertView show];
	return alertView;
}

+ (UIAlertView *)showAlertViewWithTitle:(NSString *)title message:(NSString *)message
{
	UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:title message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];

	[alertView show];
	return alertView;
}

+ (UIAlertView *)showAlertViewWithTitle:(NSString *)title message:(NSString *)message block:(void (^)(UIAlertView *alertView))block
{
	return [UIAlertView showAlertViewWithTitle:title message:message block:^(UIAlertView *alertView, NSInteger buttonIndex) {
			   block(alertView);
		   } cancelButtonTitle:@"确定" otherButtonTitles:nil];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
	self.didDismissBlok(alertView, buttonIndex);
}

@end

