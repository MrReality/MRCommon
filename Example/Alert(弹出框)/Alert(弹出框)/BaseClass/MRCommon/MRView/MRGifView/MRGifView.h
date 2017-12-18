//
//  MRGifView.h
//  test
//
//  Created by Mac on 2017/7/7.
//  Copyright © 2017年 Mix_Reality. All rights reserved.
//

#import <UIKit/UIKit.h>

/// MARK: 加载 gif 的 view
@interface MRGifView : UIView

/// 创建 gif
- (instancetype)initWithFrame:(CGRect)frame fileURL:(NSURL *)fileURL;

/// 播放
- (void)startGif;

/// 停止
- (void)stopGif;

/// 获取 frame
+ (NSArray*)framesInGif:(NSURL*)fileURL;

@end
