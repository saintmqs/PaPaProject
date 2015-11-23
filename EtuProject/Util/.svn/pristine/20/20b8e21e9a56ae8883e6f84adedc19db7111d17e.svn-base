//
//  UIActionSheet+Oxygen.m
//  CheXingZhe
//
//  Created by 黄 时欣 on 13-5-10.
//  Copyright (c) 2013年 Jiang Su Nanyi Digital Dna Science & Technology CO.LTD. All rights reserved.
//

#import "UIActionSheet+Oxygen.h"
#import <objc/runtime.h>

@implementation UIActionSheet (Oxygen)

+ (id)showActionSheetInView:(UIView *)inView withTitle:(NSString *)title block:(ActionSheetDidDismissBlok)block cancelButtonTitle:(NSString *)cancelButtonTitle destructiveButtonTitle:(NSString *)destructiveButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ...
	{
	UIActionSheet *sheet = [[UIActionSheet alloc]init];
	sheet.title = title;
	[sheet setActionSheetDidDismissBlok:block];

	if (destructiveButtonTitle) {
		sheet.destructiveButtonIndex = [sheet addButtonWithTitle:destructiveButtonTitle];
	}

	va_list args;
	va_start(args, otherButtonTitles);

	for (NSString *title = otherButtonTitles; title != nil; title = va_arg(args, NSString *)) {
		[sheet addButtonWithTitle:title];
	}

	va_end(args);

	if (cancelButtonTitle) {
		sheet.cancelButtonIndex = [sheet addButtonWithTitle:cancelButtonTitle];
	}

	[sheet showInView:inView];
	return sheet;
}

- (id)initWithTitle:(NSString *)title block:(ActionSheetDidDismissBlok)block cancelButtonTitle:(NSString *)cancelButtonTitle destructiveButtonTitle:(NSString *)destructiveButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ...{
	self = [self init];

	if (self) {
		self.title = title;
		[self setActionSheetDidDismissBlok:block];

		if (destructiveButtonTitle) {
			self.destructiveButtonIndex = [self addButtonWithTitle:destructiveButtonTitle];
		}

		va_list args;
		va_start(args, otherButtonTitles);

		for (NSString *title = otherButtonTitles; title != nil; title = va_arg(args, NSString *)) {
			[self addButtonWithTitle:title];
		}

		va_end(args);

		if (cancelButtonTitle) {
			self.cancelButtonIndex = [self addButtonWithTitle:cancelButtonTitle];
		}
	}

	return self;
}

static char actionSheetDidDismissBlokKey;

- (void)setActionSheetDidDismissBlok:(ActionSheetDidDismissBlok)block
{
	self.delegate = self;
	[self willChangeValueForKey:@"ActionSheetDidDismissBlok"];
	objc_setAssociatedObject(self, &actionSheetDidDismissBlokKey, block, OBJC_ASSOCIATION_COPY_NONATOMIC);
	[self didChangeValueForKey:@"ActionSheetDidDismissBlok"];
}

- (ActionSheetDidDismissBlok)didDismissBlok
{
	id block = objc_getAssociatedObject(self, &actionSheetDidDismissBlokKey);

	return block;
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
	if ([self didDismissBlok]) {
		self.didDismissBlok(actionSheet, buttonIndex);
	}
}

@end

