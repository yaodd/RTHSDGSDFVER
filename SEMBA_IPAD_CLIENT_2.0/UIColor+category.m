//
//  UIColor+category.m
//  SchoolPaperCommunicationForGD
//
//  Created by yaodd on 13-12-31.
//  Copyright (c) 2013年 yaodd. All rights reserved.
//

#import "UIColor+category.h"

@implementation UIColor (category)

- (UIImage *)createImage
{
    return [self createImageWithColor:self];
}
- (UIImage*) createImageWithColor: (UIColor*) color
{
    CGRect rect =CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage*theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}
@end
