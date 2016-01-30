//
//  Macro.h
//  ZhiKu
//
//  Created by 王家兴 on 15/8/3.
//  Copyright (c) 2015年 王家兴. All rights reserved.
//

// Common headers import
#import "SysConfig.h"
#import "ConstKeys.h"
#import "AppDelegate.h"

//#import <NSLogger-CocoaLumberjack-connector/DDNSLoggerLogger.h>
//#import <DDTTYLogger.h>
#import <UIView+Toast.h>
#import <IQKeyboardManager.h>
#import <IQUIView+Hierarchy.h>
#import <IQSegmentedNextPrevious.h>
#import <MBProgressHUD.h>
#import "MBProgressHUD+NJ.h"
#import "PckData.h"
#import "UIImageView+WebCache.h"
#import "UIView+convenience.h"
#import "UIButton+WebCache.h"
#import "UserDataManager.h"
#import "SystemStateManager.h"
#import "ClocksManager.h"
#import "NSString+WPAttributedMarkup.h"
#import "WPAttributedStyleAction.h"
#import "WPHotspotLabel.h"
#import <CoreText/CoreText.h>
// Macros

//#if DEBUG
//static const int ddLogLevel = LOG_LEVEL_VERBOSE;
//#else
//static const int ddLogLevel = LOG_LEVEL_INFO;
//#endif
// ddlog 初始化
#define ddLogInitialize																											\
	{																															\
		setenv("XcodeColors", "YES", 1);																						\
		[DDLog addLogger:[DDTTYLogger sharedInstance]];																			\
		[[DDTTYLogger sharedInstance] setColorsEnabled:YES];																	\
		[[DDTTYLogger sharedInstance] setForegroundColor:UIColorFromRGB(0xff1d00) backgroundColor:nil forFlag:LOG_FLAG_ERROR];	\
		[[DDTTYLogger sharedInstance] setForegroundColor:UIColorFromRGB(0xff7f00) backgroundColor:nil forFlag:LOG_FLAG_WARN];	\
		[[DDTTYLogger sharedInstance] setForegroundColor:UIColorFromRGB(0x067f00) backgroundColor:nil forFlag:LOG_FLAG_INFO];	\
		[[DDTTYLogger sharedInstance] setForegroundColor:UIColorFromRGB(0x000cb5) backgroundColor:nil forFlag:LOG_FLAG_DEBUG];	\
		[[DDTTYLogger sharedInstance] setForegroundColor:[UIColor darkGrayColor] backgroundColor:nil forFlag:LOG_FLAG_VERBOSE];	\
																																\
		DDLogError(@"Paper Jam!");																								\
		DDLogWarn(@"Low toner.");																								\
		DDLogInfo(@"Doc printed.");																								\
		DDLogDebug(@"Debugging");																								\
		DDLogVerbose(@"Init doc_parse");																						\
	}
// [DDLog addLogger:[DDNSLoggerLogger sharedInstance]];//NSLogger
// [DDLog addLogger:[DDASLLogger sharedInstance]];//Apple System Logger

//images
#define tf_bg				[[UIImage imageNamed:@"tf_bg"] stretchableImageWithLeftCapWidth:10 topCapHeight:10]
#define img_clear			[UIImage imageWithColor:[UIColor clearColor]]

// colors
#define color_blue			UIColorFromRGB(0x33B5E5)
#define color_grass			UIColorFromRGB(0x538f1c)
#define color_rose			UIColorFromRGB(0xEC198C)
#define color_orange		UIColorFromRGB(0XEF6526)
#define color_bg			UIColorFromRGB(0XF0F0F0)
#define color_black         UIColorFromRGB(0X000000)
#define color_text_normal   UIColorFromRGB(0X555555)
#define color_text_1        UIColorFromRGB(0x424f6a)
#define color_line          UIColorFromRGB(0xe3e3e3)
#define color_btn           UIColorFromRGB(0xf9b515)


// font
#define font_small			[UIFont systemFontOfSize:FONT_SIZE - 4]
#define font_normal			[UIFont systemFontOfSize:FONT_SIZE]
#define font_middle			[UIFont systemFontOfSize:FONT_SIZE + 2]
#define font_large			[UIFont systemFontOfSize:FONT_SIZE + 4]
#define font_xlarge			[UIFont systemFontOfSize:FONT_SIZE + 8]

#define bold_font_small		[UIFont boldSystemFontOfSize:FONT_SIZE - 4]
#define bold_font_normal	[UIFont boldSystemFontOfSize:FONT_SIZE]
#define bold_font_middle	[UIFont boldSystemFontOfSize:FONT_SIZE + 2]
#define bold_font_large		[UIFont boldSystemFontOfSize:FONT_SIZE + 4]
#define bold_font_xlarge	[UIFont boldSystemFontOfSize:FONT_SIZE + 8]

// HUD
#define showViewHUD			[MBProgressHUD showHUDAddedTo:self.view animated:YES]
#define hideViewHUD			[MBProgressHUD hideAllHUDsForView:self.view animated:YES]
#define showWindowHUD		[MBProgressHUD showHUDAddedTo:APP_DELEGATE.window animated:YES]
#define hideWindowHUD		[MBProgressHUD hideAllHUDsForView:APP_DELEGATE.window animated:YES]

#define isNilNull(obj)       (!obj || [obj isEqual:[NSNull null]])

#define trim(str)            [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]
