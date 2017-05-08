//
//  UIView+MRExtension.m
//  test
//
//  Created by 刘入徵 on 2017/4/15.
//  Copyright © 2017年 Mix_Reality. All rights reserved.
//

#import "UIView+MRExtension.h"

@implementation UIView (MRExtension)

- (void)setMr_x:(CGFloat)mr_x {
    
    CGRect frame = self.frame;
    
    frame.origin.x = mr_x;
    
    self.frame = frame;
}

- (CGFloat)mr_x {
    
    return self.frame.origin.x;
}


- (void)setMr_y:(CGFloat)mr_y {
    
    CGRect frame = self.frame;
    
    frame.origin.y = mr_y;
    
    self.frame = frame;
}

- (CGFloat)mr_y {
    
    return self.frame.origin.y;
}


- (void)setMr_centerX:(CGFloat)mr_centerX {
    
    CGPoint center = self.center;
    
    center.x = mr_centerX;
    
    self.center = center;
}

- (CGFloat)mr_centerX {
    
    return self.center.x;
}


- (void)setMr_centerY:(CGFloat)mr_centerY {
    
    CGPoint center = self.center;
    
    center.y = mr_centerY;
    
    self.center = center;
}

- (CGFloat)mr_centerY {
    
    return self.center.y;
}


- (void)setMr_origin:(CGPoint)mr_origin {
    
    CGRect frame = self.frame;
    
    frame.origin = mr_origin;
    
    self.frame = frame;
}

- (CGPoint)mr_origin {
    
    return self.frame.origin;
}


- (void)setMr_size:(CGSize)mr_size {
    
    CGRect frame = self.frame;
    
    frame.size = mr_size;
    
    self.frame = frame;
}

- (CGSize)mr_size {
    
    return self.frame.size;
}


- (void)setMr_width:(CGFloat)mr_width {
    
    CGRect frame = self.frame;
    
    frame.size.width = mr_width;
    
    self.frame = frame;
}

- (CGFloat)mr_width {
    
    return self.frame.size.width;
}


- (void)setMr_height:(CGFloat)mr_height {
    
    CGRect frame = self.frame;
    
    frame.size.height = mr_height;
    
    self.frame = frame;
}

- (CGFloat)mr_height {
    
    return self.frame.size.height;
}

@end
