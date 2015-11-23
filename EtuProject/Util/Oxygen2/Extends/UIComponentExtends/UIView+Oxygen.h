//
//  UIView+Oxygen.h
//  Oxygen
//
//  Created by 黄 时欣 on 13-5-23.
//  Copyright (c) 2013年 zhang cheng. All rights reserved.
//

#import <UIKit/UIKit.h>

CGPoint CGRectGetCenter(CGRect rect);

CGRect CGRectMoveToCenter(CGRect rect, CGPoint center);

typedef void (^ WhenTappedBlock)(UIView *view);

@interface UIView (Oxygen)

@property (readonly) CGPoint	bottomLeft;
@property (readonly) CGPoint	bottomRight;
@property (readonly) CGPoint	topRight;

- (void)moveBy:(CGPoint)delta;
- (void)scaleBy:(CGFloat)scaleFactor;
- (void)fitInSize:(CGSize)aSize;

- (CALayer *)addLine:(CGRect)frame color:(UIColor *)color;
- (void)addHDiverLines:(NSInteger)num lineWidth:(CGFloat)width color:(UIColor *)color;
- (void)addVDiverLines:(NSInteger)num lineHeight:(CGFloat)height color:(UIColor *)color;
- (CALayer *)addFrameLayer:(CGRect)frame;

- (void)setFrameBorder;
- (void)setFrameBorderWithColor:(UIColor *)borderColor width:(float)borderWidth cornerRadius:(float)cornerRadius;

- (void)addSubviews:(UIView *)sub, ...NS_REQUIRES_NIL_TERMINATION;
- (void)removeAllSubviews;
- (id)view4tag:(NSInteger)tag;

#pragma mark - WhenTappedBlock

- (void)whenTapped:(WhenTappedBlock)block;
- (void)whenDoubleTapped:(WhenTappedBlock)block;
- (void)whenTwoFingerTapped:(WhenTappedBlock)block;
- (void)whenTouchedDown:(WhenTappedBlock)block;
- (void)whenTouchedUp:(WhenTappedBlock)block;

#pragma mark - view layers(层级关系) to string
- (NSString *)layers2String;

#pragma mark - screenshot
- (UIImage *)screenshot;

- (UIImage *)viewshot;

@end

@interface UIScreen (Scale)

+ (CGFloat)screenScale;

@end

