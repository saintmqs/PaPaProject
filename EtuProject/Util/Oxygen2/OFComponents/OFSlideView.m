//
//  OFSlideView.m
//  CGTrainning
//
//  Created by zhang cheng on 12-12-6.
//  Copyright (c) 2012年 zhang cheng. All rights reserved.
//

#import "OFSlideView.h"
@interface OFSlideView ()
@property (nonatomic, assign) CGPoint					panOrigin;
@property (nonatomic, assign) CGPoint					origin;
@property (nonatomic, strong) UIPanGestureRecognizer	*recognizer;

@property (nonatomic, assign) OFSlideStateChangedBlock stateChangedBlock;
@end

@implementation OFSlideView

- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];

	if (self) {
		// Initialization code
		_recognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(gestureRecognizerDidPan:)];
		[self addGestureRecognizer:_recognizer];
		_recognizer.delegate	= self;
		self.canDrag			= YES;
		self.origin				= frame.origin;
		self.direction			= OpenFromRightToLeft;
		self.animDuration		= 0.3f;
		_isOpen = NO;
	}

	return self;
}

- (id)initWithFrame:(CGRect)frame withContentView:(UIView *)content
{
	self = [self initWithFrame:frame];

	if (self) {
		self.contentView = content;

		if (content) {
			[self addSubview:content];
		}
	}

	return self;
}

- (void)setStateChangedBlock:(OFSlideStateChangedBlock)block
{
	_stateChangedBlock = block;
}

- (void)setDirection:(SlideOpenDirection)direction
{
	_direction = direction;
	switch (_direction) {
		case OpenFromBottomToTop:
		case OpenFromTopToBottom:
			self.slideDistance = self.frame.size.height;
			break;

		case OpenFromLeftToRight:
		case OpenFromRightToLeft:
			self.slideDistance = self.frame.size.width;
			break;

		default:
			break;
	}
}

- (void)animatOpen
{
	[UIView beginAnimations:@"open" context:nil];
	[UIView setAnimationDuration:_animDuration];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
	CGRect frame = self.frame;
	// temp.origin.x = _panOrigin.x;
	switch (_direction) {
		case OpenFromRightToLeft:
			frame.origin.x = _origin.x - _slideDistance;
			break;

		case OpenFromBottomToTop:
			frame.origin.y = _origin.y - _slideDistance;
			break;

		case OpenFromLeftToRight:
			frame.origin.x = _origin.x + _slideDistance;
			break;

		case OpenFromTopToBottom:
			frame.origin.y = _origin.y + _slideDistance;
			break;

		default:
			break;
	}
	self.frame = frame;
	[UIView commitAnimations];

	if (_delegate && [_delegate respondsToSelector:@selector(ofSlideView:stateChanged:)]) {
		[_delegate ofSlideView:self stateChanged:YES];
	}

	if (_stateChangedBlock) {
		_stateChangedBlock(self, YES);
	}

	_isOpen = YES;
}

- (void)animatClose
{
	[UIView beginAnimations:@"close" context:nil];
	[UIView setAnimationDuration:_animDuration];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
	CGRect frame = self.frame;
	frame.origin.x	= _origin.x;
	frame.origin.y	= _origin.y;
	self.frame		= frame;
	[UIView commitAnimations];

	if (self.delegate && [_delegate respondsToSelector:@selector(ofSlideView:stateChanged:)]) {
		[_delegate ofSlideView:self stateChanged:NO];
	}

	if (_stateChangedBlock) {
		_stateChangedBlock(self, NO);
	}

	_isOpen = NO;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
	if (CGRectContainsPoint(self.bounds, point)) {
		if (_delegate && [_delegate respondsToSelector:@selector(ofSlideView:shouldInterruptTouchEventAtPoint:)]) {
			return [_delegate ofSlideView:self shouldInterruptTouchEventAtPoint:point];
		}

		return YES;
	}

	return NO;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
	_panOrigin = self.frame.origin;
	return YES;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
	CGPoint translation = [(UIPanGestureRecognizer *)gestureRecognizer translationInView : self];

	if ((_direction == OpenFromTopToBottom) || (_direction == OpenFromBottomToTop)) {
		return fabs(translation.x) < fabs(translation.y);
	}

	return fabs(translation.x) > fabs(translation.y);
}

- (void)gestureRecognizerDidPan:(UIPanGestureRecognizer *)panGesture
{
	if (!self.canDrag) {
		return;
	}

	BOOL	touchEnd		= panGesture.state == UIGestureRecognizerStateEnded || panGesture.state == UIGestureRecognizerStateCancelled;
	BOOL	open			= NO;
	CGPoint currentPoint	= [panGesture translationInView:self];
	CGRect	frame			= self.frame;

	switch (_direction) {
		case OpenFromTopToBottom:
			frame.origin.y	= _panOrigin.y + currentPoint.y;
			frame.origin.y	= frame.origin.y < _origin.y ? _origin.y : frame.origin.y;
			frame.origin.y	= frame.origin.y > _origin.y + _slideDistance ? _origin.y + _slideDistance : frame.origin.y;
			open			= frame.origin.y - _origin.y > _slideDistance * 0.5;
			break;

		case OpenFromBottomToTop:
			frame.origin.y	= _panOrigin.y + currentPoint.y;
			frame.origin.y	= frame.origin.y > _origin.y ? _origin.y : frame.origin.y;
			frame.origin.y	= frame.origin.y < _origin.y - _slideDistance ? _origin.y - _slideDistance : frame.origin.y;
			open			= _origin.y - frame.origin.y > _slideDistance * 0.5;
			break;

		case OpenFromLeftToRight:
			frame.origin.x	= _panOrigin.x + currentPoint.x;
			frame.origin.x	= frame.origin.x < _origin.x ? _origin.x : frame.origin.x;
			frame.origin.x	= frame.origin.x > _origin.x + _slideDistance ? _origin.x + _slideDistance : frame.origin.x;
			open			= frame.origin.x - _origin.x > _slideDistance * 0.5;
			break;

		case OpenFromRightToLeft:
			frame.origin.x	= _panOrigin.x + currentPoint.x;
			frame.origin.x	= frame.origin.x > _origin.x ? _origin.x : frame.origin.x;
			frame.origin.x	= frame.origin.x < _origin.x - _slideDistance ? _origin.x - _slideDistance : frame.origin.x;
			open			= _origin.x - frame.origin.x > _slideDistance * 0.5;
			break;

		default:
			break;
	}
	self.frame = frame;

	if (touchEnd) {
		open ?[self animatOpen] :[self animatClose];
	}

	return;

    /*
	CGRect rect = self.frame;
	rect.origin.x = _panOrigin.x + currentPoint.x;

	if (rect.origin.x < _panOrigin.x) {
		rect.origin.x = _panOrigin.x;
	} else if (rect.origin.x > 320) {
		rect.origin.x = 320;
	}

	self.frame = rect;

	if ((panGesture.state == UIGestureRecognizerStateEnded) || (panGesture.state == UIGestureRecognizerStateCancelled)) {
		float flag = (_panOrigin.x + self.frame.size.width / 2) - rect.origin.x;

		if (flag < 0) {	// close
			[self animatClose];
		} else {		// open
			[self animatOpen];
		}
	}
    */
}

@end

