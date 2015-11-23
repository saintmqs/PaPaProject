//
//  OFCheckButton.h
//  cpsdna
//
//  Created by 黄 时欣 on 13-11-8.
//  Copyright (c) 2013年 黄 时欣. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OFCheckButton;
typedef void (^ CheckChangedBlock) (OFCheckButton *btn);

@interface OFCheckButton : UIButton

- (id)initWithFrame:(CGRect)frame withNormalImage:(UIImage *)imageNormal checkedImage:(UIImage *)imageChecked;

- (void)setNormalImage:(UIImage *)imageNormal checkedImage:(UIImage *)imageChecked;

- (void)setCheckChangedObserver:(id)target action:(SEL)action;

- (void)setCheckChangedBlock:(CheckChangedBlock)block;

- (void)setChecked:(BOOL)cheked;

- (BOOL)isChecked;
@end

