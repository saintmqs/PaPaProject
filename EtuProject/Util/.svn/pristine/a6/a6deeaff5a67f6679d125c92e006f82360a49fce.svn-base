//
//  UIImage+Oxygen.m
//  Oxygen
//
//  Created by 黄 时欣 on 12-10-10.
//  Copyright (c) 2012年 NYDNA. All rights reserved.
//

#import "UIImage+Oxygen.h"

UIImage *OxygenBundleImage(NSString *imgName)
{
	return [UIImage imageNamed:strFormat(@"Oxygen.bundle/images/%@", imgName)];
}

@implementation UIImage (Oxygen)

+ (UIImage *)imageNamed:(NSString *)name stretchX:(NSInteger)x y:(NSInteger)y
{
	return [[UIImage imageNamed:name]stretchableImageWithLeftCapWidth:x topCapHeight:y];
}

+ (UIImage *)stretchableImageNamed:(NSString *)name leftCapWidth:(NSInteger)leftCapWidth topCapHeight:(NSInteger)topCapHeight
{
	return [[UIImage imageNamed:name]stretchableImageWithLeftCapWidth:leftCapWidth topCapHeight:topCapHeight];
}

+ (UIImage *)imageWithColor:(UIColor *)color
{
	return [UIImage imageWithColor:color size:CGSizeMake(1.0f, 1.0f)];
}

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;
{
	CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
	UIGraphicsBeginImageContext(rect.size);
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSetFillColorWithColor(context, [color CGColor]);
	CGContextFillRect(context, rect);

	UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return theImage;
}

+ (UIImage *)stretchableImageWithColor:(UIColor *)color
{
	return [[UIImage imageWithColor:color] stretchableImageWithLeftCapWidth:1 topCapHeight:1];
}

- (UIImage *)imageByScalingAndCroppingForSize:(CGSize)targetSize
{
	UIImage *sourceImage	= self;
	UIImage *newImage		= nil;
	CGSize	imageSize		= sourceImage.size;
	CGFloat width			= imageSize.width;
	CGFloat height			= imageSize.height;
	CGFloat targetWidth		= targetSize.width;
	CGFloat targetHeight	= targetSize.height;
	CGFloat scaleFactor		= 0.0;
	CGFloat scaledWidth		= targetWidth;
	CGFloat scaledHeight	= targetHeight;
	CGPoint thumbnailPoint	= CGPointMake(0.0, 0.0);

	if (CGSizeEqualToSize(imageSize, targetSize) == NO) {
		CGFloat widthFactor		= targetWidth / width;
		CGFloat heightFactor	= targetHeight / height;

		if (widthFactor > heightFactor) {
			scaleFactor = widthFactor;	// scale to fit height
		} else {
			scaleFactor = heightFactor;	// scale to fit width
		}

		scaledWidth		= width * scaleFactor;
		scaledHeight	= height * scaleFactor;

		// center the image
		if (widthFactor > heightFactor) {
			thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
		} else if (widthFactor < heightFactor) {
			thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
		}
	}

	UIGraphicsBeginImageContext(targetSize);// this will crop

	CGRect thumbnailRect = CGRectZero;
	thumbnailRect.origin		= thumbnailPoint;
	thumbnailRect.size.width	= scaledWidth;
	thumbnailRect.size.height	= scaledHeight;

	[sourceImage drawInRect:thumbnailRect];

	newImage = UIGraphicsGetImageFromCurrentImageContext();

	if (newImage == nil) {
//		DDLogError(@"could not scale image");
	}

	// pop the context to get back to the default
	UIGraphicsEndImageContext();
	return newImage;
}

- (UIImage *)scaledToSize:(CGSize)newSize
{
	UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
	[self drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
	UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return newImage;
}

- (UIImage *)scaleAspectFitSize:(CGSize)size
{
    if(CGSizeEqualToSize(self.size, CGSizeZero) || CGSizeEqualToSize(size, CGSizeZero) || CGSizeEqualToSize(self.size, size)){
        return self;
    }
    
    CGSize newSize;
    if(self.size.width/self.size.height > size.width/size.height){
        newSize.width = size.width;
        newSize.height = size.width*self.size.height/self.size.width;
    }else{
        newSize.height = size.height;
        newSize.width = size.height*self.size.width/self.size.height;
    }
    return [self scaledToSize:newSize];
}
@end

