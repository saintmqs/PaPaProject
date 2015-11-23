//
//  OFButtonGroup.m
//  Oxygen
//
//  Created by 黄 时欣 on 12-10-15.
//
//

#import "OFButtonGroup.h"

@interface OFButtonGroup ()
@property (nonatomic, strong) NSMutableArray				*radios;
@property (nonatomic, copy) GroupButtonCheckedBlock			checkedBlock;
@property (nonatomic, copy) GroupButtonCheckChangedBlock	checkChangedBlock;

@end
@implementation OFButtonGroup

- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];

	if (self) {
		self.orientation		= grid;
		self.font				= [UIFont systemFontOfSize:14];
		self.radios				= [NSMutableArray arrayWithCapacity:4];
		_selectedIndex			= -1;
		self.multiSelectable	= NO;
	}

	return self;
}

- (id)initAsRadioGroupWithFrame:(CGRect)frame withBtnTitles:(NSArray *)btnTitles
{
	self = [self initWithFrame:frame];

	if (self) {
		[self initializes:NO btnTitles:btnTitles textColor:[UIColor darkGrayColor]];
	}

	return self;
}

- (id)initAsCheckGroupWithFrame:(CGRect)frame withBtnTitles:(NSArray *)btnTitles
{
	self = [self initWithFrame:frame];

	if (self) {
		[self initializes:YES btnTitles:btnTitles textColor:[UIColor darkGrayColor]];
	}

	return self;
}

- (id)initAsRadioGroupWithFrame:(CGRect)frame withBtnTitles:(NSArray *)btnTitles withTitleColor:(UIColor *)color
{
	self = [self initWithFrame:frame];

	if (self) {
		[self initializes:NO btnTitles:btnTitles textColor:color];
	}

	return self;
}

- (id)initAsCheckGroupWithFrame:(CGRect)frame withBtnTitles:(NSArray *)btnTitles withTitleColor:(UIColor *)color
{
	self = [self initWithFrame:frame];

	if (self) {
		[self initializes:YES btnTitles:btnTitles textColor:color];
	}

	return self;
}

- (void)initializes:(BOOL)multiSelectable btnTitles:(NSArray *)btnTitles textColor:(UIColor *)color
{
	self.multiSelectable = multiSelectable;
	NSUInteger count = btnTitles.count;

	if (count > 0) {
		float	w	= self.frame.size.width;
		float	h	= self.frame.size.height;
		float	dw	= 0;
		float	dh	= 0;

		if (_orientation == horizontal) {
			dw	= w / count;
			dh	= h;
		} else if (_orientation == vertical) {
			dw	= w;
			dh	= h / count;
		}

		[self.radios removeAllObjects];

		if (_orientation == horizontal) {
			for (int i = 0; i < count; i++) {
				CGRect		frame	= CGRectMake(i * dw, 0, dw, dh);
				UIButton	*btn	= [self createRadioButtonWithFrame:frame withTitile:[btnTitles objectAtIndex:i] withTitleColor:color];
				btn.tag = 100000 + i;
				[self.radios addObject:btn];
			}
		} else if (_orientation == vertical) {
			for (int i = 0; i < count; i++) {
				CGRect		frame	= CGRectMake(0, dh * i, dw, dh);
				UIButton	*btn	= [self createRadioButtonWithFrame:frame withTitile:[btnTitles objectAtIndex:i] withTitleColor:color];
				btn.tag = 100000 + i;
				[self.radios addObject:btn];
			}
		} else {
			for (int i = 0; i < count; i++) {
				CGRect		frame	= CGRectMake(0, dh * i, dw, dh);
				UIButton	*btn	= [self createRadioButtonWithFrame:frame withTitile:[btnTitles objectAtIndex:i] withTitleColor:color];
				btn.tag = 100000 + i;
				[self.radios addObject:btn];
			}
		}
	}
}

- (void)resetView
{
	NSUInteger count = _radios.count;

	if (count > 0) {
		float	w	= self.frame.size.width;
		float	h	= self.frame.size.height;
		float	dw	= 0;
		float	dh	= 0;

		if (_orientation == horizontal) {
			float allSpan = _span * (count + 1);
			dw	= (w - allSpan) / count;
			dh	= h - _span * 2;
		} else if (_orientation == vertical) {
			float allSpan = _span * (count + 1);
			dw	= w - _span * 2;
			dh	= (h - allSpan) / count;
		} else if (_orientation == grid) {
			if (_column <= 0) {
				float allSpan = _span * (count + 1);
				dw	= w - _span * 2;
				dh	= (h - allSpan) / count;
			} else {
				NSInteger	row		= (count + _column - 1) / _column;
				float		hSpan	= _span * (_column + 1);
				float		vSpan	= _span * (row + 1);
				dw	= (w - hSpan) / _column;
				dh	= (h - vSpan) / row;
			}
		}

		if (_orientation == horizontal) {
			for (int i = 0; i < count; i++) {
				CGRect		frame	= CGRectMake(i * dw + (i + 1) * _span, _span, dw, dh);
				UIButton	*btn	= [_radios objectAtIndex:i];
				btn.frame = frame;
			}
		} else if (_orientation == vertical) {
			for (int i = 0; i < count; i++) {
				CGRect		frame	= CGRectMake(_span, dh * i + (i + 1) * _span, dw, dh);
				UIButton	*btn	= [_radios objectAtIndex:i];
				btn.frame = frame;
			}
		} else if (_orientation == grid) {
			for (int i = 0; i < count; i++) {
				int c	= _column <= 0 ? 0 : i % _column;
				int r	= _column <= 0 ? i : i / _column;

				CGRect		frame	= CGRectMake(dw * c + (c + 1) * _span, dh * r + (r + 1) * _span, dw, dh);
				UIButton	*btn	= [_radios objectAtIndex:i];
				btn.frame = frame;
			}
		}
	}
}

- (void)setButtonFrame:(CGRect)frame
{
	NSInteger count = _radios.count;

	for (int i = 0; i < count; i++) {
		UIButton *btn = [_radios objectAtIndex:i];
		btn.frame = frame;
	}
}

- (void)setFrame:(CGRect)frame
{
	[super setFrame:frame];
	[self resetView];
}

- (void)setOrientation:(Orientation)orientation
{
	_orientation = orientation;
	[self resetView];
}

- (void)setColumn:(NSInteger)column
{
	_column = column;
	[self resetView];
}

- (void)setSpan:(float)span
{
	_span = span;
	[self resetView];
}

- (UIButton *)createRadioButtonWithFrame:(CGRect)frame withTitile:(NSString *)title withTitleColor:(UIColor *)color
{
	UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];

	btn.frame = frame;
	btn.adjustsImageWhenHighlighted = NO;
//	[btn setImage:OxygenBundleImage(self.multiSelectable ? @"of_checkbutton_n" : @"of_radiobutton_n") forState:UIControlStateNormal];
//	[btn setImage:OxygenBundleImage(self.multiSelectable ? @"of_checkbutton_c" : @"of_radiobutton_c") forState:UIControlStateSelected];
	[btn addTarget:self action:@selector(radioAction:) forControlEvents:UIControlEventTouchUpInside];
	[btn setTitle:title forState:UIControlStateNormal];
	[btn setTitleColor:color forState:UIControlStateNormal];
	btn.titleLabel.font = self.font;
    btn.layer.cornerRadius = 4.f;
    btn.layer.borderWidth = 1.f;
//	[btn setImageDirection:LEFT withSpan:10];
	btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
	[self addSubview:btn];
	return btn;
}

- (void)setBtnImageNormal:(UIImage *)normal selected:(UIImage *)selected
{
	for (UIButton *btn in self.radios) {
		[btn setImage:normal forState:UIControlStateNormal];
		[btn setImage:selected forState:UIControlStateSelected];
	}
}

- (void)setBtnBackgroudImageNormal:(UIImage *)normal selected:(UIImage *)selected
{
    for (UIButton *btn in self.radios) {
        [btn setBackgroundImage:normal forState:UIControlStateNormal];
        [btn setBackgroundImage:selected forState:UIControlStateSelected];
    }
}

- (void)setbtnHorizontalAlignment:(UIControlContentHorizontalAlignment)align
{
    for (UIButton *btn in self.radios) {
        btn.contentHorizontalAlignment = align;
    }
}

- (void)setBtnImageNormalName:(NSString *)normal selectedName:(NSString *)selected
{
	for (UIButton *btn in self.radios) {
		[btn setImage:[UIImage imageNamed:normal] forState:UIControlStateNormal];
		[btn setImage:[UIImage imageNamed:selected] forState:UIControlStateSelected];
	}
}

- (void)setBtnImageDirection:(ImageDirection)direction withSpan:(int)span
{
	for (UIButton *btn in self.radios) {
		[btn setImageDirection:direction withSpan:span];
		btn.contentHorizontalAlignment = direction == CENTER ? UIControlContentHorizontalAlignmentCenter : UIControlContentHorizontalAlignmentLeft;
	}
}

- (NSArray *)getAllButtons
{
	return [NSArray arrayWithArray:self.radios];
}

- (void)radioAction:(id)sender
{
	UIButton	*btn	= (UIButton *)sender;
	NSInteger	index	= btn.tag - 100000;

	if (self.multiSelectable) {
		btn.selected = !btn.selected;

        if (btn.selected) {
            btn.layer.borderColor  = rgbColor(18, 109, 16).CGColor;
            [btn setTitleColor:rgbColor(18, 109, 16) forState:UIControlStateSelected];
        }
        else
        {
            btn.layer.borderColor  = [UIColor blackColor].CGColor;
        }
        
		if (_delegate) {
			if ([_delegate respondsToSelector:@selector(buttonGroup:buttonCheckChangedAtIndex:)]) {
				[_delegate buttonGroup:self buttonCheckChangedAtIndex:index];
			}
		}

		if (_checkChangedBlock) {
			_checkChangedBlock(self, index, btn.isSelected);
		}
	} else {
		UIButton *btnOld = nil;

		if (_selectedIndex >= 0) {
			btnOld = [_radios objectAtIndex:_selectedIndex];
		}

		if (_selectedIndex != index) {
			if (btnOld) {
				btnOld.selected = NO;
			}

			btn.selected = YES;

			if (_delegate) {
				if ([_delegate respondsToSelector:@selector(buttonGroup:buttonCheckedAtIndex:)]) {
					[_delegate buttonGroup:self buttonCheckedAtIndex:index];
				}
			}

			if (_checkedBlock) {
				_checkedBlock(self, index);
			}

			_selectedIndex = index;
		}
	}
}

- (void)setSelectedIndex:(NSInteger)selectedIndex
{
	if ((selectedIndex < 0) || (selectedIndex >= self.radios.count)) {
		return;
	}

	if (self.multiSelectable) {
		UIButton *btn = [_radios objectAtIndex:selectedIndex];
		btn.selected = YES;
	} else {
		if (selectedIndex == _selectedIndex) {
			return;
		}

		UIButton *btn = [_radios objectAtIndex:selectedIndex];
		btn.selected = YES;

		if (_selectedIndex >= 0) {
			UIButton *btnOld = [_radios objectAtIndex:_selectedIndex];
			btnOld.selected = NO;
		}

		_selectedIndex = selectedIndex;
	}
}

- (void)unSelectedIndex:(int)index
{
	if ((index < 0) || (index >= self.radios.count)) {
		return;
	}

	UIButton *btn = [_radios objectAtIndex:index];

	if (btn.selected == YES) {
		_selectedIndex = -1;
	}

	btn.selected = NO;
}

- (void)setFont:(UIFont *)font
{
	_font = font;

	for (UIButton *btn in [self getAllButtons]) {
		btn.titleLabel.font = _font;
	}
}

- (void)setCheckedBlock:(GroupButtonCheckedBlock)block
{
	_checkedBlock = block;
}

- (void)setCheckChangedBlock:(GroupButtonCheckChangedBlock)block
{
	_checkChangedBlock = block;
}

@end

