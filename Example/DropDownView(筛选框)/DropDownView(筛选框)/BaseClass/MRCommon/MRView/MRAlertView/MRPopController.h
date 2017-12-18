//
//  MRPopController.h
//  test
//
//  Created by shiyuanqi on 2017/5/4.
//  Copyright © 2017年 lrz. All rights reserved.
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@protocol MRPopControllerDelegate;

// Control mask view of style.
// 控制蒙版视图的样式
typedef NS_ENUM(NSUInteger, PopMaskType) {
    PopMaskTypeBlackBlur = 0,         // 黑色半透明模糊效果
    PopMaskTypeWhiteBlur,             // 白色半透明模糊效果
    PopMaskTypeWhite,                 // 纯白色
    PopMaskTypeClear,                 // 全透明
    PopMaskTypeDefault,               // 默认黑色半透明效果
};

// Control popup view display position.
// 控制弹出视图的显示位置
typedef NS_ENUM(NSUInteger, PopLocationType) {
    PopLocationTypeTop = 0,           // 在顶部显示
    PopLocationTypeBottom,
    PopLocationTypeLeft,
    PopLocationTypeRight,
    PopLocationTypeCenter             // 默认居中显示
};

// Controls how the popup will be presented.
// 控制弹出视图将以哪种样式呈现
typedef NS_ENUM(NSInteger, PopTransitStyle) {
    PopTransitStyleFromTop = 0,       // 从上部滑出
    PopTransitStyleFromBottom,        // 从底部滑出
    PopTransitStyleFromLeft,          // 从左部滑出
    PopTransitStyleFromRight,         // 从右部滑出
    PopTransitStyleSlightScale,       // 轻微缩放效果
    PopTransitStyleShrinkInOut,       // 从中心点扩大或收缩
    PopTransitStyleDefault            // 默认淡入淡出效果
};


@interface MRPopController : UIViewController

@property (nonatomic, weak) id <MRPopControllerDelegate> _Nullable delegate;

/// 设置蒙版样式，default = PopMaskTypeDefault
@property (nonatomic, assign) PopMaskType maskType;

/// 视图显示位置，default = PopLocationTypeCenter
@property (nonatomic, assign) PopLocationType locationType;

/// 视图呈现方式，default = PopupTransitStyleDefault, 必须是 PopLocationTypeCenter 模式
@property (nonatomic, assign) PopTransitStyle transitStyle;

/// 设置蒙版视图的透明度，default = 0.5, 必须设置 maskType
@property (nonatomic, assign) CGFloat maskAlpha;

/// 是否反方向消失，default = NO
@property (nonatomic, assign) BOOL dismissOppositeDirection;

/// 点击蒙版视图是否响应dismiss事件，default = YES
@property (nonatomic, assign) BOOL dismissOnMaskTouched;

/// 是否允许视图拖动，default = NO
@property (nonatomic, assign) BOOL allowPan;

/// 视图倾斜掉落动画，当 transitStyle 为 PopTransitStyleFromTop 样式时可以设置为YES使用掉落动画，default = NO
@property (nonatomic, assign) BOOL dropTransitionAnimated;

// 视图是否正在显示中
@property (nonatomic, assign, readonly) BOOL isPresenting;

/// Block gets called when mask touched. 蒙版触摸事件 block，主要用来自定义 dismiss 动画时间及弹性效果
@property (nonatomic, copy) void (^maskTouched)(MRPopController *popController);

/// ContentView will present. 视图将要呈现
// Should implement this block before the presenting. 应该在 present 前实现的 block
@property (nonatomic, copy) void (^willPresent)(MRPopController *popController);

/// ContentView Did present. 视图已经呈现
@property (nonatomic, copy) void (^didPresent)(MRPopController *popController);

/// ContentView Will dismiss. 视图将要消失
@property (nonatomic, copy) void (^willDismiss)(MRPopController *popController);

/// ContentView Did dismiss. 视图已经消失
@property (nonatomic, copy) void (^didDismiss)(MRPopController *popController);

/**
 @param contentView         要弹出来的视图
 @param duration            持续时间
 @param isElasticAnimated   是否是弹性动画
 @param fromView            在哪个 view 上面显示
 */
- (void)presentContentView:(nullable UIView *)contentView duration:(NSTimeInterval)duration elasticAnimated:(BOOL)isElasticAnimated inView:(nullable UIView *)fromView;

/// inView = nil, 在 Window 显示
- (void)presentContentView:(nullable UIView *)contentView duration:(NSTimeInterval)duration elasticAnimated:(BOOL)isElasticAnimated;

/// 在 Window 显示, 默认动画时间, 不是弹性动画
- (void)presentContentView:(nullable UIView *)contentView;

/**
 页面消失
 @param duration                持续时间
 @param isElasticAnimated       是否是弹性动画
 */
- (void)dismissWithDuration:(NSTimeInterval)duration elasticAnimated:(BOOL)isElasticAnimated;

/// 默认消失
- (void)dismiss;

/// Convenience method for creating popController with custom values. 便利构造 popController 并设置相应属性值
+ (instancetype)popupControllerWithLocationType:(PopLocationType)locationType maskType:(PopMaskType)maskType dismissOnMaskTouched:(BOOL)dismissOnMaskTouched allowPan:(BOOL)allowPan;

/// When locationType = PopLocationTypeCenter
+ (instancetype)popupControllerLayoutInCenterWithTransitStyle:(PopTransitStyle)transitStyle maskType:(PopMaskType)maskType dismissOnMaskTouched:(BOOL)dismissOnMaskTouched dismissOppositeDirection:(BOOL)dismissOppositeDirection allowPan:(BOOL)allowPan;

@end

/// --------------------- delegate -----------------------
@protocol MRPopControllerDelegate <NSObject>

@optional
/// - Block对应的 Delegate 方法，block 优先
- (void)popupControllerWillPresent:(nonnull MRPopController *)popupController;
- (void)popupControllerDidPresent:(nonnull MRPopController *)popupController;
- (void)popupControllerWillDismiss:(nonnull MRPopController *)popupController;
- (void)popupControllerDidDismiss:(nonnull MRPopController *)popupController;

@end


@interface NSObject (MRPopController)

// 因为 MRPopController 内部子视图是默认添加在 keyWindow 上的，所以如果 popController 是局部变量的话不会被任何引用，生命周期也只在这个方法内。为了使内部视图正常响应，所以应将 popController 声明为全局属性，保证其生命周期，也可以直接使用 popController
@property (nonatomic, strong) MRPopController *popController;

@end

NS_ASSUME_NONNULL_END
