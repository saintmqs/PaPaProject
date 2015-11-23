//
//  CustomSearchBar.m
//  Deji_Plaza
//
//  Created by 赵化 on 13-1-7.
//  Copyright (c) 2013年 王尧. All rights reserved.
//

#import "CustomSearchBar.h"

@implementation CustomSearchBar

#pragma mark===========初始化================
/**   函数作用 :初始化界面
 **   函数参数 :
 **   函数返回值:
 **/
-(void)initView
{
    self.backgroundColor=[UIColor clearColor];
    
    float version = [[[ UIDevice currentDevice ] systemVersion ] floatValue ];
    
    if (version > 7)
        
    {
        
        //iOS7.1
        
        [[[[ self.subviews objectAtIndex : 0 ] subviews ] objectAtIndex : 0 ] removeFromSuperview ];
        
        [ self setBackgroundColor :[ UIColor clearColor ]];
        
    }
    else if (iOS7) {
        if ([ self  respondsToSelector: @selector (barTintColor)]) {
            [ self  setBarTintColor:[UIColor clearColor]];
        }
    }
    else
    {
        for (UIView *subView in self.subviews) {
            //背景透明
            if ([subView isKindOfClass:NSClassFromString(@"UISearchBarBackground")]) {
                [subView removeFromSuperview];
            }
        }
    }
    
    
    //背景
//    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[MHFile getResourcesFile:@"searchBar_bg.png"]]];
//    imageView.frame = CGRectMake(0, 0, imageView.frame.size.width, imageView.frame.size.height );
//    [self insertSubview:imageView atIndex:0];
//    [imageView release];
    
}


#pragma mark===========life circle================

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}

-(void)awakeFromNib
{
    [self initView];
}

//重载放大镜图片
- (void)layoutSubviews {
	UITextField *searchField = nil;
    UIView *view = self;
    
    if (iOS7) {
        view = [self.subviews lastObject];
    }

    
	NSUInteger numViews = [view.subviews count];
	for(int i = 0; i< numViews; i++) {
		if([[view.subviews objectAtIndex:i] isKindOfClass:[UITextField class]]) {
			searchField = [view.subviews objectAtIndex:i];
		}
	}
	if(searchField) {
        searchField.background = _searchBarBackGround;
        searchField.backgroundColor = [UIColor clearColor];
        //放大镜
		UIImageView *iView = [[UIImageView alloc] initWithImage:_searchBarLeftIcon];
		searchField.leftView = iView;
        
        
        searchField.font = [UIFont systemFontOfSize:13];
//        searchField.textColor = UIColorWithRGB(242, 237, 202, 1);
//        [searchField setValue:UIColorWithRGB(242, 237, 202, 1) forKeyPath:@"_placeholderLabel.textColor"];
        [searchField setValue:[UIFont systemFontOfSize:13] forKeyPath:@"_placeholderLabel.font"];
	}
    
	[super layoutSubviews];
}

-(void)setSearchBarBackGround:(UIImage *)backGround
{
    if (_searchBarBackGround == backGround) return;
    _searchBarBackGround = backGround;
    [self setNeedsDisplay];
}

-(void)setSearchBarLeftIcon:(UIImage *)leftIcon
{
    if (_searchBarLeftIcon == leftIcon) return;
    _searchBarLeftIcon = leftIcon;
    [self setNeedsDisplay];
}

-(void)setSearchBarRightIcon:(UIImage *)rightIcon
{
    if (_searchBarRightIcon == rightIcon) return;
    _searchBarRightIcon = rightIcon;

    
    [self setImage:_searchBarRightIcon forSearchBarIcon:UISearchBarIconClear state:UIControlStateNormal];
}


@end

