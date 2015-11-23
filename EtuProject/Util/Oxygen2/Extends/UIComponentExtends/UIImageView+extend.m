//
//  UIImageView+extend.m
//  consumerapp
//
//  Created by 黄 时欣 on 14-3-27.
//  Copyright (c) 2014年 黄 时欣. All rights reserved.
//

#import "UIImageView+extend.h"

@implementation UIImageView (extend)

- (void)loadImageWithUrl:(NSString *)url
{
	[self loadImageWithUrl:url placeholder:[UIImage imageNamed:@"ic_holder_small"]];
}

- (void)loadImageWithUrl:(NSString *)url placeholder:(UIImage *)imgHolder
{
	if ([NSString isStringEmptyOrBlank:url]) {
		self.image = imgHolder;
		return;
	}

//	DDLogInfo(@"==ImageLoad==:%@", url);
	NSURL *imageUrl = [NSURL URLWithString:url];

	[self sd_setImageWithURL:imageUrl placeholderImage:imgHolder];
}

@end

