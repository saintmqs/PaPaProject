//
//  UILabel+Oxygen.m
//  Oxygen
//
//  Created by 黄 时欣 on 12-9-4.
//  Copyright (c) 2012年 NYDNA. All rights reserved.
//

#import "UILabel+Oxygen.h"
#import "UIColor+Oxygen.h"

@implementation UILabel (Oxygen)

#pragma mark - default
+ (id)labelWithFrame:(CGRect)frame
{
	UILabel *lab = [UILabel labelWithFrame:frame font:0 color:[UIColor blackColor] isBold:NO];

	return lab;
}

+ (id)labelWithFrame:(CGRect)frame font:(int)deltaSize
{
	UILabel *lab = [UILabel labelWithFrame:frame font:deltaSize color:[UIColor blackColor] isBold:NO];

	return lab;
}

+ (id)labelWithFrame:(CGRect)frame color:(NSObject *)color
{
	UILabel *lab = [UILabel labelWithFrame:frame font:0 color:color isBold:NO];

	return lab;
}

+ (id)labelWithFrame:(CGRect)frame font:(int)deltaSize color:(NSObject *)color
{
	UILabel *lab = [UILabel labelWithFrame:frame font:deltaSize color:color isBold:NO];

	return lab;
}

#pragma mark - bold
+ (id)bLabelWithFrame:(CGRect)frame
{
	UILabel *lab = [UILabel labelWithFrame:frame font:0 color:[UIColor blackColor] isBold:YES];

	return lab;
}

+ (id)bLabelWithFrame:(CGRect)frame font:(int)deltaSize
{
	UILabel *lab = [UILabel labelWithFrame:frame font:deltaSize color:[UIColor blackColor] isBold:YES];

	return lab;
}

+ (id)bLabelWithFrame:(CGRect)frame color:(NSObject *)color
{
	UILabel *lab = [UILabel labelWithFrame:frame font:0 color:color isBold:YES];

	return lab;
}

+ (id)bLabelWithFrame:(CGRect)frame font:(int)deltaSize color:(NSObject *)color
{
	UILabel *lab = [UILabel labelWithFrame:frame font:deltaSize color:color isBold:YES];

	return lab;
}

#pragma mark -----------------

+ (id)labelWithFrame:(CGRect)frame font:(int)deltaSize color:(NSObject *)color isBold:(BOOL)bold
{
	UILabel *lab = [[UILabel alloc]initWithFrame:frame];

	lab.backgroundColor = [UIColor clearColor];
	UIColor *textColor = nil;

	if (color) {
		if ([color isKindOfClass:[NSString class]]) {
			textColor = [UIColor colorWithHexString:(NSString *)color];
		} else if ([color isKindOfClass:[UIColor class]]) {
			textColor = (UIColor *)color;
		}
	}

	if (textColor) {
		lab.textColor = textColor;
	} else {
		lab.textColor = [UIColor blackColor];
	}

	if (bold) {
		lab.font = [UIFont boldSystemFontOfSize:FONT_SIZE + deltaSize];
	} else {
		lab.font = [UIFont systemFontOfSize:FONT_SIZE + deltaSize];
	}

	lab.shadowColor		= [UIColor whiteColor];
	lab.shadowOffset	= CGSizeMake(0, .5f);
	return lab;
}

- (CGSize)textSize:(CGSize)origin
{
	CGSize size = [self.text sizeWithFont:self.font
		constrainedToSize	:origin
		lineBreakMode		:self.lineBreakMode];

	return size;
}

- (CGRect)frameFitToTextWidth
{
	CGRect	frame	= self.frame;
	CGSize	size	= [self textSize:CGSizeMake(MAXFLOAT, frame.size.height)];

	frame.size.width	= size.width;
	self.frame			= frame;
	return frame;
}

- (CGSize)resizeHeightByContentText
{
    self.height = [self.text sizeWithFont:self.font constrainedToSize:CGSizeMake(self.width, CGFLOAT_MAX) lineBreakMode:self.lineBreakMode].height;
    return self.frame.size;
}

- (CGSize)setTextAndResizeHeight:(NSString *)text
{
    self.text = text;
    return [self resizeHeightByContentText];
}

- (void)alignTop {
    CGSize fontSize = [self.text sizeWithFont:self.font];
    double finalHeight = fontSize.height * self.numberOfLines;
    double finalWidth = self.frame.size.width;    //expected width of label
    CGSize theStringSize = [self.text sizeWithFont:self.font constrainedToSize:CGSizeMake(finalWidth, finalHeight) lineBreakMode:self.lineBreakMode];
    int newLinesToPad = (finalHeight  - theStringSize.height) / fontSize.height;
    for(int i=0; i<newLinesToPad; i++)
        self.text = [self.text stringByAppendingString:@"\n "];
}

- (void)alignBottom {
    CGSize fontSize = [self.text sizeWithFont:self.font];
    double finalHeight = fontSize.height * self.numberOfLines;
    double finalWidth = self.frame.size.width;    //expected width of label
    CGSize theStringSize = [self.text sizeWithFont:self.font constrainedToSize:CGSizeMake(finalWidth, finalHeight) lineBreakMode:self.lineBreakMode];
    int newLinesToPad = (finalHeight  - theStringSize.height) / fontSize.height;
    for(int i=0; i<newLinesToPad; i++)
        self.text = [NSString stringWithFormat:@" \n%@",self.text];
}

@end

