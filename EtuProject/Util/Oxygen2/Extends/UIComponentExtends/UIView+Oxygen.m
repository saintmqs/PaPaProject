//
//  UIView+Oxygen.m
//  Oxygen
//
//  Created by 黄 时欣 on 13-5-23.
//  Copyright (c) 2013年 zhang cheng. All rights reserved.
//

#import "UIView+Oxygen.h"

CGPoint CGRectGetCenter(CGRect rect)
{
	CGPoint pt;

	pt.x	= CGRectGetMidX(rect);
	pt.y	= CGRectGetMidY(rect);
	return pt;
}

CGRect CGRectMoveToCenter(CGRect rect, CGPoint center)
{
	CGRect newrect = CGRectZero;

	newrect.origin.x	= center.x - CGRectGetMidX(rect);
	newrect.origin.y	= center.y - CGRectGetMidY(rect);
	newrect.size		= rect.size;
	return newrect;
}

@interface UIView (WhenTappedBlocks_Private) <UIGestureRecognizerDelegate>

- (void)runBlockForKey:(void *)blockKey;
- (void)setBlock:(WhenTappedBlock)block forKey:(void *)blockKey;

- (UITapGestureRecognizer *)addTapGestureRecognizerWithTaps:(NSUInteger)taps touches:(NSUInteger)touches selector:(SEL)selector;
- (void)addRequirementToSingleTapsRecognizer:(UIGestureRecognizer *)recognizer;
- (void)addRequiredToDoubleTapsRecognizer:(UIGestureRecognizer *)recognizer;

@end

@implementation UIView (Oxygen)

// Query other frame locations
- (CGPoint)bottomRight
{
	CGFloat x	= self.frame.origin.x + self.frame.size.width;
	CGFloat y	= self.frame.origin.y + self.frame.size.height;

	return CGPointMake(x, y);
}

- (CGPoint)bottomLeft
{
	CGFloat x	= self.frame.origin.x;
	CGFloat y	= self.frame.origin.y + self.frame.size.height;

	return CGPointMake(x, y);
}

- (CGPoint)topRight
{
	CGFloat x	= self.frame.origin.x + self.frame.size.width;
	CGFloat y	= self.frame.origin.y;

	return CGPointMake(x, y);
}

// Move via offset
- (void)moveBy:(CGPoint)delta
{
	CGPoint newcenter = self.center;

	newcenter.x += delta.x;
	newcenter.y += delta.y;
	self.center = newcenter;
}

// Scaling
- (void)scaleBy:(CGFloat)scaleFactor
{
	CGRect newframe = self.frame;

	newframe.size.width		*= scaleFactor;
	newframe.size.height	*= scaleFactor;
	self.frame				= newframe;
}

// Ensure that both dimensions fit within the given size by scaling down
- (void)fitInSize:(CGSize)aSize
{
	CGFloat scale;
	CGRect	newframe = self.frame;

	if (newframe.size.height && (newframe.size.height > aSize.height)) {
		scale = aSize.height / newframe.size.height;
		newframe.size.width		*= scale;
		newframe.size.height	*= scale;
	}

	if (newframe.size.width && (newframe.size.width >= aSize.width)) {
		scale = aSize.width / newframe.size.width;
		newframe.size.width		*= scale;
		newframe.size.height	*= scale;
	}

	self.frame = newframe;
}

- (CALayer *)addLine:(CGRect)frame color:(UIColor *)color
{
	CALayer *layer = [CALayer layer];

	layer.frame				= frame;
	layer.backgroundColor	= color.CGColor;
	[self.layer addSublayer:layer];
	return layer;
}

- (void)addHDiverLines:(NSInteger)num lineWidth:(CGFloat)width color:(UIColor *)color
{
	[self addLine:CGRectMake(0, 0, self.width, .6f) color:color];
	[self addLine:CGRectMake(0, self.height - .6f, self.width, .6f) color:color];

	width = MIN(width, self.width);
	CGFloat x = (self.width - width) / 2;

	for (int i = 1; i < num; i++) {
		[self addLine:CGRectMake(x, i * (self.height / num), width, .6f) color:color];
	}
}

- (void)addVDiverLines:(NSInteger)num lineHeight:(CGFloat)height color:(UIColor *)color
{
	[self addLine:CGRectMake(0, 0, self.width, .6f) color:color];
	[self addLine:CGRectMake(0, self.height - .6f, self.width, .6f) color:color];

	height = MIN(height, self.height);
	CGFloat y = (self.height - height) / 2;

	for (int i = 1; i < num; i++) {
		[self addLine:CGRectMake(i * (self.width / num), y, .55f, height) color:color];
	}
}

- (CALayer *)addFrameLayer:(CGRect)frame
{
	CALayer *bgLayer = [CALayer layer];

	bgLayer.frame		= frame;
	bgLayer.borderWidth = .5f;
	bgLayer.borderColor = [UIColor lightGrayColor].CGColor;
	// bgLayer.shadowOffset	= CGSizeMake(0, 1);
	// bgLayer.shadowRadius	= 1.f;
	// bgLayer.shadowOpacity	= .5f;
	bgLayer.cornerRadius	= 2.f;
	bgLayer.backgroundColor = [UIColor whiteColor].CGColor;
	[self.layer addSublayer:bgLayer];
	return bgLayer;
}

- (void)setFrameBorder
{
	[self setFrameBorderWithColor:[UIColor lightGrayColor] width:.5f cornerRadius:2.f];
}

- (void)setFrameBorderWithColor:(UIColor *)borderColor width:(float)borderWidth cornerRadius:(float)cornerRadius
{
	self.layer.borderColor	= borderColor.CGColor;
	self.layer.cornerRadius = cornerRadius;
	self.layer.borderWidth	= borderWidth;
	self.clipsToBounds		= YES;
}

- (void)addSubviews:(UIView *)sub, ...
	{
	va_list args;
	va_start(args, sub);

	for (UIView *view = sub; view != nil; view = va_arg(args, UIView *)) {
		[self addSubview:view];
	}

	va_end(args);
}
- (void)removeAllSubviews
{
	for (UIView *v in self.subviews) {
		[v removeFromSuperview];
	}
}

- (id)view4tag:(NSInteger)tag
{
	return [self viewWithTag:tag];
}

#pragma mark - WhenTappedBlock

static char kWhenTappedBlockKey;
static char kWhenDoubleTappedBlockKey;
static char kWhenTwoFingerTappedBlockKey;
static char kWhenTouchedDownBlockKey;
static char kWhenTouchedUpBlockKey;

#pragma mark -
#pragma mark Set blocks

- (void)runBlockForKey:(void *)blockKey
{
	WhenTappedBlock block = objc_getAssociatedObject(self, blockKey);

	if (block) {
		block(self);
	}
}

- (void)setBlock:(WhenTappedBlock)block forKey:(void *)blockKey
{
	self.userInteractionEnabled = YES;
	objc_setAssociatedObject(self, blockKey, block, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

#pragma mark -
#pragma mark When Tapped

- (void)whenTapped:(WhenTappedBlock)block
{
	UITapGestureRecognizer *gesture = [self addTapGestureRecognizerWithTaps:1 touches:1 selector:@selector(viewWasTapped)];

	[self addRequiredToDoubleTapsRecognizer:gesture];

	[self setBlock:block forKey:&kWhenTappedBlockKey];
}

- (void)whenDoubleTapped:(WhenTappedBlock)block
{
	UITapGestureRecognizer *gesture = [self addTapGestureRecognizerWithTaps:2 touches:1 selector:@selector(viewWasDoubleTapped)];

	[self addRequirementToSingleTapsRecognizer:gesture];

	[self setBlock:block forKey:&kWhenDoubleTappedBlockKey];
}

- (void)whenTwoFingerTapped:(WhenTappedBlock)block
{
	[self addTapGestureRecognizerWithTaps:1 touches:2 selector:@selector(viewWasTwoFingerTapped)];

	[self setBlock:block forKey:&kWhenTwoFingerTappedBlockKey];
}

- (void)whenTouchedDown:(WhenTappedBlock)block
{
	[self setBlock:block forKey:&kWhenTouchedDownBlockKey];
}

- (void)whenTouchedUp:(WhenTappedBlock)block
{
	[self setBlock:block forKey:&kWhenTouchedUpBlockKey];
}

#pragma mark -
#pragma mark Callbacks

- (void)viewWasTapped
{
	[self runBlockForKey:&kWhenTappedBlockKey];
}

- (void)viewWasDoubleTapped
{
	[self runBlockForKey:&kWhenDoubleTappedBlockKey];
}

- (void)viewWasTwoFingerTapped
{
	[self runBlockForKey:&kWhenTwoFingerTappedBlockKey];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	[super touchesBegan:touches withEvent:event];
	[self runBlockForKey:&kWhenTouchedDownBlockKey];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	[super touchesEnded:touches withEvent:event];
	[self runBlockForKey:&kWhenTouchedUpBlockKey];
}

#pragma mark -
#pragma mark Helpers

- (UITapGestureRecognizer *)addTapGestureRecognizerWithTaps:(NSUInteger)taps touches:(NSUInteger)touches selector:(SEL)selector
{
	UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:selector];

	tapGesture.delegate					= self;
	tapGesture.numberOfTapsRequired		= taps;
	tapGesture.numberOfTouchesRequired	= touches;
	[self addGestureRecognizer:tapGesture];

	return tapGesture;
}

- (void)addRequirementToSingleTapsRecognizer:(UIGestureRecognizer *)recognizer
{
	for (UIGestureRecognizer *gesture in [self gestureRecognizers]) {
		if ([gesture isKindOfClass:[UITapGestureRecognizer class]]) {
			UITapGestureRecognizer *tapGesture = (UITapGestureRecognizer *)gesture;

			if ((tapGesture.numberOfTouchesRequired == 1) && (tapGesture.numberOfTapsRequired == 1)) {
				[tapGesture requireGestureRecognizerToFail:recognizer];
			}
		}
	}
}

- (void)addRequiredToDoubleTapsRecognizer:(UIGestureRecognizer *)recognizer
{
	for (UIGestureRecognizer *gesture in [self gestureRecognizers]) {
		if ([gesture isKindOfClass:[UITapGestureRecognizer class]]) {
			UITapGestureRecognizer *tapGesture = (UITapGestureRecognizer *)gesture;

			if ((tapGesture.numberOfTouchesRequired == 2) && (tapGesture.numberOfTapsRequired == 1)) {
				[recognizer requireGestureRecognizerToFail:tapGesture];
			}
		}
	}
}

#pragma mark --

- (NSString *)layers2String
{
	NSString *str = @"******************************\n";

	str = [self recursiveSubLayer:self str:str index:@""];
	return [str stringByAppendingString:@"\n******************************"];
}

- (NSString *)recursiveSubLayer:(UIView *)view str:(NSString *)str index:(NSString *)index
{
	str		= [str stringByAppendingFormat:@"%@%@\n", index, NSStringFromClass(view.class)];
	index	= [index stringByAppendingString:@"--"];

	for (UIView *c in view.subviews) {
		str = [self recursiveSubLayer:c str:str index:index];
	}

	return str;
}

#pragma mark - screenshot
- (UIImage *)viewshot
{
	CGFloat scale = [UIScreen screenScale];

	if (scale > 1.5) {
		UIGraphicsBeginImageContextWithOptions(self.frame.size, NO, scale);
	} else {
		UIGraphicsBeginImageContext(self.frame.size);
	}

	[self.layer renderInContext:UIGraphicsGetCurrentContext()];
	UIImage *screenshot = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return screenshot;
}

- (UIImage *)screenshot
{
	CGFloat scale = [UIScreen screenScale];

	if (scale > 1.5) {
		UIGraphicsBeginImageContextWithOptions(self.frame.size, NO, scale);
	} else {
		UIGraphicsBeginImageContext(self.frame.size);
	}

	[self.layer renderInContext:UIGraphicsGetCurrentContext()];
	UIImage *screenshot = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return screenshot;
}

@end

@implementation UIScreen (Scale)

+ (CGFloat)screenScale
{
	CGFloat scale = 1.0;// 缩放率

	if ([[UIScreen mainScreen]respondsToSelector:@selector(scale)]) {
		CGFloat tmp = [[UIScreen mainScreen] scale];

		if (tmp > 1.5) {
			scale = 2.0;
		}
	}

	return scale;
}

@end

