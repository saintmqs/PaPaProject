//
//  UIView+dynamic.h
//  Demo2C
//
//  Created by 黄 时欣 on 13-11-25.
//  Copyright (c) 2013年 黄 时欣. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (dynamic)

typedef void (^ DynamicBlock)(UIView *view, float percent);

@property (nonatomic, weak) UIScrollView	*rootScrollView;
@property (nonatomic, assign) BOOL			isShow;
@property (nonatomic, assign) float			percent;
@property (nonatomic, strong) NSThread		*dynamicThread;

- (void)setOnDynamicBlock:(DynamicBlock)block;

// 手动调用动态显示 reset 重置percent
- (void)dynamicShow:(BOOL)reset;
- (void)dynamicHide:(BOOL)reset;

@end

