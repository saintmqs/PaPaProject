//
//  OFButtonGroup.h
//  Oxygen
//
//  Created by 黄 时欣 on 12-10-15.
//
//

#import <UIKit/UIKit.h>
#import "UIButton+Oxygen.h"

typedef enum {
	horizontal,
	vertical,
	grid
} Orientation;

@class OFButtonGroup;
// 单选回调
typedef void (^ GroupButtonCheckedBlock) (OFButtonGroup *btnGroup, NSInteger indexChecked);
// 多选回调
typedef void (^ GroupButtonCheckChangedBlock) (OFButtonGroup *btnGroup, NSInteger indexCheckChanged, BOOL checked);

@protocol OFButtonGroupDelegate;

@interface OFButtonGroup : UIView
@property (nonatomic, assign) Orientation	orientation;
@property (nonatomic, assign) id			delegate;
@property (nonatomic, assign) NSInteger		selectedIndex;
@property (nonatomic, assign) NSInteger		column;
@property (nonatomic, assign) float			span;
@property (nonatomic, assign) BOOL			multiSelectable;
@property (nonatomic, strong) UIFont		*font;

// radio styles
- (id)initAsRadioGroupWithFrame:(CGRect)frame withBtnTitles:(NSArray *)btnTitles;
- (id)initAsRadioGroupWithFrame:(CGRect)frame withBtnTitles:(NSArray *)btnTitles withTitleColor:(UIColor *)color;
// check styles
- (id)initAsCheckGroupWithFrame:(CGRect)frame withBtnTitles:(NSArray *)btnTitles;
- (id)initAsCheckGroupWithFrame:(CGRect)frame withBtnTitles:(NSArray *)btnTitles withTitleColor:(UIColor *)color;

- (void)setBtnImageNormalName:(NSString *)normal selectedName:(NSString *)selected;
- (void)setBtnImageNormal:(UIImage *)normal selected:(UIImage *)selected;
- (void)setBtnBackgroudImageNormal:(UIImage *)normal selected:(UIImage *)selected;
- (void)setbtnHorizontalAlignment:(UIControlContentHorizontalAlignment)align;
- (void)setBtnImageDirection:(ImageDirection)direction withSpan:(int)span;
- (NSArray *)getAllButtons;

- (void)unSelectedIndex:(int)index;

- (void)setCheckedBlock:(GroupButtonCheckedBlock)block;
- (void)setCheckChangedBlock:(GroupButtonCheckChangedBlock)block;
@end

@protocol OFButtonGroupDelegate <NSObject>

@optional
// 单选代理
- (void)buttonGroup:(OFButtonGroup *)rbg buttonCheckedAtIndex:(NSInteger)index;
// 多选代理
- (void)buttonGroup:(OFButtonGroup *)rbg buttonCheckChangedAtIndex:(NSInteger)index;
@end

