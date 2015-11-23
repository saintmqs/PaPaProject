//
//  UIActionSheet+Oxygen.h
//  Oxygen
//
//  Created by 黄 时欣 on 13-5-10.
//  Copyright (c) 2013年 Jiang Su Nanyi Digital Dna Science & Technology CO.LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ ActionSheetDidDismissBlok)(UIActionSheet *actionSheet, NSInteger buttonIndex);

@interface UIActionSheet (Oxygen) <UIActionSheetDelegate>

// 添加dismiss block
- (id)initWithTitle:(NSString *)title block:(ActionSheetDidDismissBlok)block cancelButtonTitle:(NSString *)cancelButtonTitle destructiveButtonTitle:(NSString *)destructiveButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ...NS_REQUIRES_NIL_TERMINATION;

- (void)setActionSheetDidDismissBlok:(ActionSheetDidDismissBlok)block;

+ (id)showActionSheetInView:(UIView *)inView withTitle:(NSString *)title block:(ActionSheetDidDismissBlok)block cancelButtonTitle:(NSString *)cancelButtonTitle destructiveButtonTitle:(NSString *)destructiveButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ...NS_REQUIRES_NIL_TERMINATION;
@end

