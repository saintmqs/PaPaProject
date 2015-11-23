//
//  UIButton+Oxygen.m
//  Oxygen
//
//  Created by 黄 时欣 on 12-9-4.
//  Copyright (c) 2012年 NYDNA. All rights reserved.
//

#import "UIButton+Oxygen.h"
#import "UIColor+Oxygen.h"
#import "UIImage+Oxygen.h"
#import <objc/runtime.h>

@implementation UIButton (Oxygen)

+ (id)btnWithDefaultStylewithFrame:(CGRect)frame
{
	return [UIButton btnWithDefaultStylewithFrame:frame withTintColor:OXYGEN_BTN_DEFAULT_TINT];
}

+ (id)btnWithDefaultStylewithFrame:(CGRect)frame withTintColor:(NSObject *)color
{
	UIButton *btn = [[UIButton alloc]initWithFrame:frame];

	UIColor *tintColor = nil;

	if (color) {
		if ([color isKindOfClass:[NSString class]]) {
			tintColor = [UIColor colorWithHexString:(NSString *)color];
		} else if ([color isKindOfClass:[UIColor class]]) {
			tintColor = (UIColor *)color;
		}
	}

	if (tintColor) {
		btn.tintColor = tintColor;
	} else {
		btn.tintColor = [UIColor darkGrayColor];
	}

	[btn.titleLabel setShadowOffset:CGSizeMake(0, -1)];
	return btn;
}

+ (id)btnDefaultFrame:(CGRect)frame title:(NSString *)title
{
	return [UIButton btnDefaultFrame:frame title:title font:6];
}

+ (id)btnDefaultFrame:(CGRect)frame title:(NSString *)title font:(int)font
{
	UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];

	btn.frame = frame;
	[btn setTitle:title forState:UIControlStateNormal];
	btn.titleLabel.font			= [UIFont systemFontOfSize:FONT_SIZE + font];
	btn.titleLabel.shadowColor	= [UIColor clearColor];
	btn.titleLabel.shadowOffset = CGSizeZero;

	btn.clipsToBounds			= YES;
	return btn;
}

- (void)setImageDirection:(ImageDirection)direction
{
	[self setImageDirection:direction withSpan:0];
}

- (void)setImageDirection:(ImageDirection)direction withSpan:(float)span
{
	UIImage *image = self.imageView.image;

	if (image) {
        
        CGSize imageSize = image.size;
        CGSize titleSize = [self.titleLabel.text sizeWithFont:self.titleLabel.font];
        if(imageSize.width == 0 || imageSize.height == 0 || titleSize.width==0 || titleSize.height == 0){
            return;
        }
        
        //self.imageView.backgroundColor = [UIColor redColor];
        //self.titleLabel.backgroundColor = [UIColor greenColor];
        
        CGSize btnMinSize = CGSizeMake(imageSize.width+titleSize.width + span, imageSize.height+titleSize.height + span);
        CGSize btnSize = CGSizeMake(MAX(self.width, btnMinSize.width), MAX(self.height, btnMinSize.height));
        self.bounds = CGRectMake(0, 0, btnSize.width, btnSize.height);
        
        CGPoint btnBoundsCenter = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
        CGPoint startImageCenter = self.imageView.center;
        CGPoint startTitleCenter = self.titleLabel.center;
        CGPoint endImageCenter;
        CGPoint endTitleCenter;
        
        switch (direction) {
            case TOP:
                endImageCenter = CGPointMake(btnBoundsCenter.x, (self.height-btnMinSize.height)/2+CGRectGetMidY(self.imageView.bounds));
                endTitleCenter = CGPointMake(btnBoundsCenter.x, endImageCenter.y+self.imageView.height/2+span+ CGRectGetMidY(self.titleLabel.bounds));
                break;
            case LEFT:
                endImageCenter = CGPointMake((self.width-btnMinSize.width)/2+CGRectGetMidX(self.imageView.bounds), btnBoundsCenter.y);
                endTitleCenter = CGPointMake(endImageCenter.x+ self.imageView.width/2+span+CGRectGetMidX(self.titleLabel.bounds), btnBoundsCenter.y);
                break;
                
            case BOTTOM:
                endTitleCenter = CGPointMake(btnBoundsCenter.x, (self.height-btnMinSize.height)/2+CGRectGetMidY(self.titleLabel.bounds));
                endImageCenter = CGPointMake(btnBoundsCenter.x, endTitleCenter.y+self.titleLabel.height/2+span+ CGRectGetMidY(self.imageView.bounds));
                break;
                
            case RIGHT:
                endTitleCenter = CGPointMake((self.width-btnMinSize.width)/2 + CGRectGetMidX(self.titleLabel.bounds), btnBoundsCenter.y);
                endImageCenter = CGPointMake(endTitleCenter.x + self.titleLabel.width/2+span+CGRectGetMidX(self.imageView.bounds), btnBoundsCenter.y);
                break;
            case CENTER:
                endImageCenter = btnBoundsCenter;
                endTitleCenter = btnBoundsCenter;
                break;
        }
        
        CGFloat imageEdgeInsetsTop = endImageCenter.y - startImageCenter.y;
        CGFloat imageEdgeInsetsLeft = endImageCenter.x - startImageCenter.x;
        CGFloat imageEdgeInsetsBottom = -imageEdgeInsetsTop;
        CGFloat imageEdgeInsetsRight = -imageEdgeInsetsLeft;
        self.imageEdgeInsets = UIEdgeInsetsMake(imageEdgeInsetsTop, imageEdgeInsetsLeft, imageEdgeInsetsBottom, imageEdgeInsetsRight);
        
        CGFloat titleEdgeInsetsTop = endTitleCenter.y-startTitleCenter.y;
        CGFloat titleEdgeInsetsLeft = endTitleCenter.x - startTitleCenter.x;
        CGFloat titleEdgeInsetsBottom = -titleEdgeInsetsTop;
        CGFloat titleEdgeInsetsRight = -titleEdgeInsetsLeft;
        self.titleEdgeInsets = UIEdgeInsetsMake(titleEdgeInsetsTop, titleEdgeInsetsLeft, titleEdgeInsetsBottom, titleEdgeInsetsRight);
	}
}

static char buttonClickBlockKey;
- (void)setClickBlock:(ButtonClickBlock)block
{
	[self willChangeValueForKey:@"ButtonClickBlock"];
	objc_setAssociatedObject(self, &buttonClickBlockKey, block, OBJC_ASSOCIATION_COPY_NONATOMIC);
	[self didChangeValueForKey:@"ButtonClickBlock"];

	[self addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
}

- (ButtonClickBlock)buttonClickBlock
{
	id block = objc_getAssociatedObject(self, &buttonClickBlockKey);

	return block;
}

- (void)btnAction
{
	if ([self buttonClickBlock]) {
		self.buttonClickBlock(self);
	}
}

@end

