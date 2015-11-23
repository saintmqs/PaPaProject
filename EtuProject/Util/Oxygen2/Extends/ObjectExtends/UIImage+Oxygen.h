//
//  UIImage+Oxygen.h
//
//
//  Created by 黄 时欣 on 12-10-10.
//  Copyright (c) 2012年 NYDNA. All rights reserved.
//

#import <UIKit/UIKit.h>

UIImage *OxygenBundleImage(NSString *imgName);

@interface UIImage (Oxygen)
+ (UIImage *)imageNamed:(NSString *)name stretchX:(NSInteger)x y:(NSInteger)y;

+ (UIImage *)stretchableImageNamed:(NSString *)name leftCapWidth:(NSInteger)leftCapWidth topCapHeight:(NSInteger)topCapHeight;

// color 转 image size(1,1)
+ (UIImage *)imageWithColor:(UIColor *)color;
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;
+ (UIImage *)stretchableImageWithColor:(UIColor *)color;

// Image缩放 利用drawInRect的方式，缩放效果比下面的方法好一些
- (UIImage *)scaledToSize:(CGSize)newSize;
//等比例缩放
- (UIImage *)scaleAspectFitSize:(CGSize)size;
// Image缩放 缩小时有锯齿
- (UIImage *)imageByScalingAndCroppingForSize:(CGSize)targetSize;

@end

