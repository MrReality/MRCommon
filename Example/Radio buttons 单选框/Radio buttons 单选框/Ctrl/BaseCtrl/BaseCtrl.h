//
//  BaseCtrl.h
//  test
//
//  Created by 刘入徵 on 2017/4/15.
//  Copyright © 2017年 Mix_Reality. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <UIKit/UIKit.h>

@interface BaseCtrl : UIViewController

/**
 没有数据时, 给出的提示
 */
@property (nonatomic, strong) UILabel *nonLabel;
/**
 中间的标题
 */
@property (nonatomic, strong) UILabel *navigationLabel;
@end
