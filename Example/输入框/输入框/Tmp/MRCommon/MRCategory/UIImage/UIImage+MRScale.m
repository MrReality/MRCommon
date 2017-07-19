//
//  UIImage+MRScale.m
//  画布
//
//  Created by shiyuanqi on 2017/6/6.
//  Copyright © 2017年 lrz. All rights reserved.
//

#import "UIImage+MRScale.h"

@implementation UIImage (MRScale)

- (UIImage *)scaleToSize:(CGSize)size{
    
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}


@end
