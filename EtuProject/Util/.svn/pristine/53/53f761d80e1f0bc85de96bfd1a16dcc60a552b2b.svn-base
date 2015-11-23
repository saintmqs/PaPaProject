//
//  OFBaseViewController.m
//  cpsdna
//
//  Created by 黄 时欣 on 13-11-12.
//  Copyright (c) 2013年 黄 时欣. All rights reserved.
//

#import "OFBaseViewController.h"
#import "NSObject+HTTPRequest.h"

@interface OFBaseViewController ()

@end

@implementation OFBaseViewController

- (id)init
{
	self = [super init];

	if (self) {
		[self registerRequestManagerObserver];
	}

	return self;
}

- (void)dealloc
{
	[self unregisterRequestManagerObserver];
//	DDLogInfo(@"\n**************************************\n[%@ dealloc]\n**************************************\n", [self class]);
	removeSelfNofificationObservers;
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	self.view.backgroundColor = color_bg;

	if (iOS7) {
		self.edgesForExtendedLayout = UIRectEdgeNone;
	}
}

- (void)setLeftNavBtnAsMenuBtn
{
	UIButton *btnMenu = [UIButton buttonWithType:UIButtonTypeCustom];

	btnMenu.frame = CGRectMake(0, 0, 60, 44);
	[btnMenu setImage:[UIImage imageNamed:@"nav_menu_n"] forState:UIControlStateNormal];
	[btnMenu setImage:[UIImage imageNamed:@"nav_menu_p"] forState:UIControlStateSelected];
	self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnMenu];

	[btnMenu setClickBlock:^(UIButton *btn) {
		[[IQKeyboardManager sharedManager] resignFirstResponder];
		// [APP_DELEGATE.drawer toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
	}];
}

- (void)setLeftNavBtnAsCustomBack
{
	if (self.navigationController) {
		UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];
		back.frame = CGRectMake(0, 0, 60, 44);
		[back setImage:[UIImage imageNamed:@"nav_back_n"] forState:UIControlStateNormal];
		[back setImage:[UIImage imageNamed:@"nav_back_p"] forState:UIControlStateSelected];

		self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:back];

		__weak typeof(self) bself = self;

		[back setClickBlock:^(UIButton *btn) {
			if (bself == bself.navigationController.viewControllers[0]) {
				[bself.navigationController dismissViewControllerAnimated:YES completion:nil];
			} else {
				[bself.navigationController popViewControllerAnimated:YES];
			}
		}];
	}
}

- (void)request:(ASIHTTPRequest *)request failedWithError:(NSError *)error
{
	hideViewHUD;
	showTip(error.domain);
//	DDLogError(@"%s   %@", __func__, error.domain);
}

- (UIBarButtonItem *)setRightNavBtn:(NSString *)title action:(SEL)selector
{
	// UIButton *btn = [self createRightNavBtn:title];

	// [btn addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
	// UIBarButtonItem *btnItem = [[UIBarButtonItem alloc]initWithCustomView:btn];

	// self.navigationItem.rightBarButtonItem = btnItem;
	UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithTitle:title style:UIBarButtonItemStylePlain target:self action:selector];

	self.navigationItem.rightBarButtonItem = item;
	return item;
}

- (UIButton *)createRightNavBtn:(NSString *)title
{
	UIButton	*btn	= [UIButton buttonWithType:UIButtonTypeCustom];
    btn.titleLabel.font = [UIFont systemFontOfSize:FONT_SIZE+2];
	float		w		= MAX(30, [title sizeWithFont:btn.titleLabel.font].width + 10);

	btn.frame = CGRectMake(0, 0, w, 44);
	[btn setTitle:title forState:UIControlStateNormal];
	[btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
	return btn;
}

- (CGRect)bounds
{
	CGRect frame = self.view.bounds;

	if (self.navigationController) {
		frame.size.height -= iOS7 ? 64 : 44;
	}

	return frame;
}

@end

