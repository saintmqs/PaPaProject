//
//  OFSlideView.h
//  CGTrainning
//
//  Created by zhang cheng on 12-12-6.
//  Copyright (c) 2012年 zhang cheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OFMacro.h"

typedef enum {
	OpenFromLeftToRight = 0x444,
	OpenFromRightToLeft,
	OpenFromTopToBottom,
	OpenFromBottomToTop,
} SlideOpenDirection;

@class OFSlideView;
typedef void (^ OFSlideStateChangedBlock)(OFSlideView *slideView, BOOL isOpen);

@protocol OFSlideViewDelegate;
@interface OFSlideView : UIView <UIGestureRecognizerDelegate>

@property (nonatomic, assign) id <OFSlideViewDelegate>	delegate;
@property (nonatomic, assign) BOOL						canDrag;//default YES
@property (nonatomic, assign, readonly) BOOL			isOpen;
@property (nonatomic, assign) SlideOpenDirection		direction;
@property (nonatomic, assign) float						slideDistance;
@property (nonatomic, assign) float						animDuration;
@property (nonatomic, strong) UIView					*contentView;

- (id)initWithFrame:(CGRect)frame withContentView:(UIView *)content;
- (void)setStateChangedBlock:(OFSlideStateChangedBlock)block;

- (void)animatOpen;
- (void)animatClose;

@end

@protocol OFSlideViewDelegate <NSObject>

@optional
// open close 状态代理
- (void)ofSlideView:(OFSlideView *)slideView stateChanged:(BOOL)isOpen;
// touch事件穿透代理  return yes 阻断 no继续往下一层传递
- (BOOL)ofSlideView:(OFSlideView *)slideView shouldInterruptTouchEventAtPoint:(CGPoint)point;

@end

