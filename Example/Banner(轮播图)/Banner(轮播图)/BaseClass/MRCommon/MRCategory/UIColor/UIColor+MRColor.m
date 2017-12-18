//
//  UUIColor+MRColor.m
//  test
//
//  Created by 刘入徵 on 2017/4/15.
//  Copyright © 2017年 Mix_Reality. All rights reserved.
//

#import "UIColor+MRColor.h"

@implementation UIColor (MRColor)

+ (instancetype)colorWithHex:(uint32_t)hex {

    uint8_t r = (hex & 0xff0000) >> 16;
    uint8_t g = (hex & 0x00ff00) >> 8;
    uint8_t b = hex & 0x0000ff;

    return [self colorWithRed:r green:g blue:b];
}

+ (instancetype)randomColor {

    return [UIColor colorWithRed:arc4random_uniform(256) green:arc4random_uniform(256) blue:arc4random_uniform(256)];
}

+ (instancetype)colorWithRed:(uint8_t)red green:(uint8_t)green blue:(uint8_t)blue {
    
    return [UIColor colorWithRed:red / 255.0 green:green / 255.0 blue:blue / 255.0 alpha:1.0];
}

@end
