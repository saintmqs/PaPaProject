//
//  UIView+dynamic.m
//  Demo2C
//
//  Created by 黄 时欣 on 13-11-25.
//  Copyright (c) 2013年 黄 时欣. All rights reserved.
//

#import "UIView+dynamic.h"

#define dynamicDelta	.02f	// 动态刷新间隔
#define percentStep		.025f	// 百分比步长

@implementation UIView (dynamic)
@dynamic rootScrollView;
@dynamic isShow;

static char isShowKey;
- (void)setIsShow:(BOOL)isShow
{
	objc_setAssociatedObject(self, &isShowKey, [NSNumber numberWithBool:isShow], OBJC_ASSOCIATION_ASSIGN);
}

- (BOOL)isShow
{
	return [objc_getAssociatedObject(self, &isShowKey) boolValue];
}

static char dynamicThreadKey;
- (void)setDynamicThread:(NSThread *)dynamicThread
{
	objc_setAssociatedObject(self, &dynamicThreadKey, dynamicThread, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSThread *)dynamicThread
{
	return objc_getAssociatedObject(self, &dynamicThreadKey);
}

static NSString *percentKey;
- (void)setPercent:(float)percent
{
	objc_setAssociatedObject(self, &percentKey, [NSNumber numberWithFloat:percent], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (float)percent
{
	return [objc_getAssociatedObject(self, &percentKey) floatValue];
}

static NSString *rootScrollViewKey;
- (UIScrollView *)rootScrollView;
{
	id value = objc_getAssociatedObject(self, &rootScrollViewKey);
	return value;
}

- (void)setRootScrollView:(UIScrollView *)scrollView
{
	[[self rootScrollView] removeObserver:self forKeyPath:@"contentOffset" context:nil];

	[self willChangeValueForKey:@"rootScrollViewKey"];
	objc_setAssociatedObject(self, &rootScrollViewKey, scrollView, OBJC_ASSOCIATION_ASSIGN);
	[self didChangeValueForKey:@"rootScrollViewKey"];

	// 监听contentOffset
	[[self rootScrollView] addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
}

#pragma mark 监听UIScrollView的contentOffset属性
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
	if ([@"contentOffset" isEqualToString : keyPath]) {
		float	offsetY = self.rootScrollView.contentOffset.y;
		CGRect	frame	= [self convertRect:self.bounds toView:self.rootScrollView];

		if ((CGRectGetMinY(frame) < offsetY) || (CGRectGetMaxY(frame) > (offsetY + self.rootScrollView.frame.size.height))) {
			// 隐藏
			//            NSLog(@"===========out============show:%d",self.isShow);
			if (self.isShow) {
				self.isShow = NO;
				[self animationHide];
			}
		} else {
			//            NSLog(@"===========int=============show:%d",self.isShow);
			// 显示
			if (!self.isShow) {
				self.isShow = YES;
				[self animationShow];
			}
		}
	}
}

- (void)animationShow
{
	[self.dynamicThread cancel];
	self.dynamicThread = [[NSThread alloc]initWithTarget:self selector:@selector(dynamicRun) object:nil];
	[self.dynamicThread start];
	//    NSLog(@"***************animationShow****************");
}

- (void)animationHide
{
	[self.dynamicThread cancel];
	self.dynamicThread = [[NSThread alloc]initWithTarget:self selector:@selector(dynamicRun) object:nil];
	[self.dynamicThread start];
	//    NSLog(@"***************animationHide****************");
}

- (void)dynamicRun
{
	//    NSLog(@"=======percent:%f",self.percent);

	while (self.percent >= 0 && self.percent <= 1) {
		//        NSLog(@"==========percent:%f",self.percent);
		if ([[NSThread currentThread] isCancelled]) {
			[NSThread exit];
			return;
		}

		[self performSelectorOnMainThread:@selector(update) withObject:nil waitUntilDone:YES];
		[NSThread sleepForTimeInterval:dynamicDelta];

		if (self.isShow) {
			self.percent += percentStep;
		} else {
			self.percent -= percentStep;
		}

		// -----------EaseInOut 算法------------

		/*
		 *   float	a		= 0.5, b = 0.0, d = 0.1;// a + b + a = 1;
		 *   float	p		= (b + 1) * d / 2;
		 *   float	r		= d / a;
		 *
		 *   if (t <= a) {
		 *    percent = t * t * r / 2 / p;
		 *   } else if (t <= (a + b)) {
		 *    percent = (t * d - (a * d) / 2) / p;
		 *   } else {
		 *    percent = (t * d - (a * d) / 2 - (t - a - b) * (t - a - b) * r / 2) / p;
		 *   }
		 */
		// -------------------------------------
	}

	self.percent = MAX(0, MIN(1, self.percent));
	[self performSelectorOnMainThread:@selector(update) withObject:nil waitUntilDone:YES];
}

- (void)update
{
	[self dynamicBlock](self, self.percent);
}

- (void)clearAnimation:(BOOL)refresh
{
	if (self.dynamicThread) {
		[self.dynamicThread cancel];
	}

	if (refresh) {
		self.percent = self.isShow ? 0 : 1;
	}
}

- (void)dynamicShow:(BOOL)reset
{
	self.isShow = YES;
	[self clearAnimation:reset];
	[self animationShow];
}

- (void)dynamicHide:(BOOL)reset
{
	self.isShow = NO;
	[self clearAnimation:reset];
	[self animationHide];
}

#pragma mark - blocks
static char kDynamicBlock;

- (void)setOnDynamicBlock:(DynamicBlock)block
{
	objc_setAssociatedObject(self, &kDynamicBlock, block, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (DynamicBlock)dynamicBlock
{
	return objc_getAssociatedObject(self, &kDynamicBlock);
}

@end

