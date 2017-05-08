//
//  UIScreen+MRScreen.m
//  test
//
//  Created by 刘入徵 on 2017/4/15.
//  Copyright © 2017年 Mix_Reality. All rights reserved.
//

#import "UIScreen+MRScreen.h"

@implementation UIScreen (MRScreen)

+ (CGFloat)screenWidth {
    return [UIScreen mainScreen].bounds.size.width;
}

+ (CGFloat)screenHeight {
    return [UIScreen mainScreen].bounds.size.height;
}

+ (CGFloat)scale {
    return [UIScreen mainScreen].scale;
}

@end
