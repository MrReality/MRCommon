//
//  NSArray+MRLog.h
//  test
//
//  Created by 刘入徵 on 2017/4/15.
//  Copyright © 2017年 Mix_Reality. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (MRLog)
/// 打印信息
- (NSString *)mrLogDescription;

@end

@interface NSDictionary (MRLog)
/// 打印
- (NSString *)mrLogDescription;
@end
