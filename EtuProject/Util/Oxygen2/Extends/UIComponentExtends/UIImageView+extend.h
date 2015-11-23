//
//  UIImageView+extend.h
//  consumerapp
//
//  Created by 黄 时欣 on 14-3-27.
//  Copyright (c) 2014年 黄 时欣. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"

@interface UIImageView (extend)

- (void)loadImageWithUrl:(NSString *)url;

- (void)loadImageWithUrl:(NSString *)url placeholder:(UIImage *)imgHolder;

@end
