//
//  UIView+MRView.m
//  test
//
//  Created by 刘入徵 on 2017/4/15.
//  Copyright © 2017年 Mix_Reality. All rights reserved.
//

#import "UIView+MRView.h"
#import <objc/runtime.h>

static char kDTActionHandlerTapGestureKey;
static char kDTActionHandlerTapBlockKey;

@implementation UIView (MRView)

/**
 添加轻击手势
 */
- (void)tapActionWithBlock:(void (^)(void))block{

    if(!block){
        return;
    }

    self.userInteractionEnabled = YES;

    UITapGestureRecognizer *gesture = objc_getAssociatedObject(self, &kDTActionHandlerTapGestureKey);

    if (!gesture){

        gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(__handleActionForTapGesture:)];
        [self addGestureRecognizer:gesture];
        objc_setAssociatedObject(self, &kDTActionHandlerTapGestureKey, gesture, OBJC_ASSOCIATION_RETAIN);
    }
    objc_setAssociatedObject(self, &kDTActionHandlerTapBlockKey, block, OBJC_ASSOCIATION_COPY);
}

// 这段代码检测了手势识别的关联对象。如果没有，则创建并建立关联关系。同时，将传入的块对象连接到指定的 key 上。注意 `block` 对象的关联内存管理策略。
// 手势识别对象需要一个`target`和`action`，所以接下来我们定义处理方法：
// objc
- (void)__handleActionForTapGesture:(UITapGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateRecognized)
    {
        void(^action)(void) = objc_getAssociatedObject(self, &kDTActionHandlerTapBlockKey);
        if (action)
        {
            action();
        }
    }
}

@end
