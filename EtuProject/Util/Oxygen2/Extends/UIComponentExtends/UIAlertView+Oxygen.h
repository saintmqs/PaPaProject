//
//  UIAlertView+Oxygen.h
//  Oxygen
//
//  Created by 黄 时欣 on 13-5-23.
//
//

#import <UIKit/UIKit.h>

typedef void (^ UIAlertViewDidDismissBlok)(UIAlertView *alertView, NSInteger buttonIndex);

@interface UIAlertView (Oxygen)

// 添加dismissBlock
+ (UIAlertView *)showAlertViewWithTitle:(NSString *)title message:(NSString *)message block:(UIAlertViewDidDismissBlok)block cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ...NS_REQUIRES_NIL_TERMINATION;

+ (UIAlertView *)showAlertViewWithTitle:(NSString *)title message:(NSString *)message block:(void (^)(UIAlertView *alert))block;

+ (UIAlertView *)showAlertViewWithTitle:(NSString *)title message:(NSString *)message;

- (void)setDidDismissBlok:(UIAlertViewDidDismissBlok)block;
@end

