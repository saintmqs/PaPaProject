//
//  OFCheckButton.m
//  cpsdna
//
//  Created by 黄 时欣 on 13-11-8.
//  Copyright (c) 2013年 黄 时欣. All rights reserved.
//

#import "OFCheckButton.h"

@interface OFCheckButton ()
@property (nonatomic, assign) id				delegate;
@property (nonatomic, assign) SEL				checkChangedAction;
@property (nonatomic, copy) CheckChangedBlock	checkChangedBlock;
@end

@implementation OFCheckButton

- (id)initWithFrame:(CGRect)frame
{
	return [self initWithFrame:frame withNormalImage:OxygenBundleImage(@"of_checkbutton_n") checkedImage:OxygenBundleImage(@"of_checkbutton_c")];
}

- (id)initWithFrame:(CGRect)frame withNormalImage:(UIImage *)imageNormal checkedImage:(UIImage *)imageChecked
{
	self = [super initWithFrame:frame];

	if (self) {
		[self setNormalImage:imageNormal checkedImage:imageChecked];
		[self setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
		self.selected = NO;
		[self addTarget:self action:@selector(onAction) forControlEvents:UIControlEventTouchUpInside];
	}

	return self;
}

- (void)setNormalImage:(UIImage *)imageNormal checkedImage:(UIImage *)imageChecked
{
	[self setImage:imageNormal forState:UIControlStateNormal];
	[self setImage:imageChecked forState:UIControlStateSelected];
}

- (void)setCheckChangedObserver:(id)target action:(SEL)action
{
	self.delegate			= target;
	self.checkChangedAction = action;
}

- (void)setCheckChangedBlock:(CheckChangedBlock)block
{
	_checkChangedBlock = block;
}

- (void)onAction
{
	self.selected = !self.selected;

	if (_delegate && [_delegate respondsToSelector:_checkChangedAction]) {
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
		[_delegate performSelector:_checkChangedAction withObject:self withObject:nil];
	}

	if (_checkChangedBlock) {
		_checkChangedBlock(self);
	}
}

- (void)setChecked:(BOOL)cheked
{
	if (self.isSelected != cheked) {
		self.selected = cheked;
	}
}

- (BOOL)isChecked
{
	return self.selected;
}

@end

