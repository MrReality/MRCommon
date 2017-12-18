//
//  MRPopController.m
//  test
//
//  Created by shiyuanqi on 2017/5/4.
//  Copyright © 2017年 lrz. All rights reserved.
//

#import "MRPopController.h"
#import <objc/runtime.h>

#ifndef __OPTIMIZE__
#define NSLog(...) NSLog(__VA_ARGS__)
#else
#define NSLog(...) {}
#endif

#define RANDOM_ANGLE(i, j) randomValues(i, j)
UIKIT_STATIC_INLINE int randomValues(int i, int j) {
    if (arc4random() % 2) return i;
    return j;
}

static void *PopupControllerParametersKey = &PopupControllerParametersKey;

@interface MRPopController () <UIGestureRecognizerDelegate>
@property (nonatomic, strong) UIView *superview;
@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) UIView *popupView;
@property (nonatomic, strong) UIView *contentView;
@end

@implementation MRPopController

#pragma mark - dealloc
- (void)dealloc {
    [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIApplicationWillChangeStatusBarOrientationNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
    
    [self removeSubviews];
    NSLog(@"%@ --> delloc", self);
}

+ (instancetype)popupControllerWithLocationType:(PopLocationType)locationType maskType:(PopMaskType)maskType dismissOnMaskTouched:(BOOL)dismissOnMaskTouched allowPan:(BOOL)allowPan{
    
    MRPopController *popController = [[MRPopController alloc] init];
    popController.maskType = maskType;
    popController.locationType = locationType;
    popController.dismissOnMaskTouched = dismissOnMaskTouched;
    popController.allowPan = allowPan;
    return popController;
}

+ (instancetype)popupControllerLayoutInCenterWithTransitStyle:(PopTransitStyle)transitStyle maskType:(PopMaskType)maskType dismissOnMaskTouched:(BOOL)dismissOnMaskTouched dismissOppositeDirection:(BOOL)dismissOppositeDirection allowPan:(BOOL)allowPan{
    
    MRPopController *popController = [[MRPopController alloc] init];
    popController.maskType = maskType;
    popController.locationType = PopLocationTypeCenter;
    popController.transitStyle = transitStyle;
    popController.dismissOnMaskTouched = dismissOnMaskTouched;
    popController.dismissOppositeDirection = dismissOppositeDirection;
    popController.allowPan = allowPan;
    return popController;
}

- (instancetype)init {
    self = [super init];
    if (!self)  return nil;
    
    //  default value
    _maskType                 = PopMaskTypeDefault;         // 默认黑色半透明蒙版
    _locationType             = PopLocationTypeCenter;      // 位置居中
    _transitStyle             = PopTransitStyleDefault;
    _maskAlpha                = 0.55;
    _dismissOnMaskTouched     = YES;
    _dismissOppositeDirection = NO;
    _dropTransitionAnimated   = NO;
    _allowPan                 = NO;
    _isPresenting             = NO;
    
    // superview
    _superview = [self keyWindow];
    
    // popupView
    _popupView = [[UIView alloc] init];
    _popupView.backgroundColor = [UIColor clearColor];
    
    // maskView
    _maskView = [[UIView alloc] initWithFrame:_superview.bounds];
    self.maskType = _maskType;
    [_maskView addGestureRecognizer:[self tap]];
    
    // Observer statusBar orientation changes.
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(willChangeStatusBarOrientation)
                                                 name:UIApplicationWillChangeStatusBarOrientationNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didChangeStatusBarOrientation)
                                                 name:UIApplicationDidChangeStatusBarOrientationNotification
                                               object:nil];
    return self;
}

- (UIWindow *)keyWindow {
    return [UIApplication sharedApplication].keyWindow;
}

- (UIView *)maskViewType:(PopMaskType)maskType {
    switch (maskType) {
        case PopMaskTypeDefault:        // 默认黑色半透明效果
            _maskView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:_maskAlpha];
            break;
        case PopMaskTypeWhite:          // 纯白色
            _maskView.backgroundColor = [UIColor whiteColor];
            break;
        case PopMaskTypeClear:          // 全透明
            _maskView.backgroundColor = [UIColor clearColor];
            break;
        case PopMaskTypeBlackBlur:      // 黑色半透明模糊效果
            _maskView = [self maskBlurStyle:UIBarStyleBlackTranslucent];
            break;
        case PopMaskTypeWhiteBlur:      // 白色半透明模糊效果
            _maskView = [self maskBlurStyle:UIBarStyleDefault];
            break;
        default: break;
    }
    return _maskView;
}

- (UIView *)maskBlurStyle:(UIBarStyle)barStyle {
    UIToolbar *mask = [[UIToolbar alloc] initWithFrame:_superview.bounds];
    mask.barStyle = barStyle;
    [mask addGestureRecognizer:[self tap]];
    return mask;
}

- (UITapGestureRecognizer *)tap {
    UITapGestureRecognizer *g = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    g.delegate = self;
    return g;
}

/// MARK: setter
- (void)setAllowPan:(BOOL)allowPan {
    _allowPan = allowPan;
    if (_allowPan) {
        UIPanGestureRecognizer *g = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
        [_popupView addGestureRecognizer:g];
    }
}

- (void)setMaskType:(PopMaskType)maskType {
    _maskType = maskType;
    _maskView = [self maskViewType:_maskType];
}

- (void)setMaskAlpha:(CGFloat)maskAlpha {
    _maskAlpha = maskAlpha;
    _maskView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:_maskAlpha];
}

- (void)setContentView:(UIView *)contentView {
    _contentView = contentView;
    if (nil == _contentView) {
        if (nil != _popupView.superview) {
            [_popupView removeFromSuperview];
        }
        return;
    }
    if (_contentView.superview != _popupView) {
        _contentView.frame = (CGRect){.origin = CGPointZero, .size = contentView.frame.size};
        _popupView.frame = _contentView.frame;
        _popupView.backgroundColor = _contentView.backgroundColor;
        if (_contentView.layer.cornerRadius > 0) {
            _popupView.layer.cornerRadius = _contentView.layer.cornerRadius;
            _popupView.clipsToBounds = NO;
        }
        [_popupView addSubview:_contentView];
        [_maskView addSubview:_popupView];
    }
}

- (void)addSubviews {
    [_superview addSubview:_maskView];
}

- (void)removeSubviews {
    if (_popupView.subviews.count > 0) {
        [_contentView removeFromSuperview];
        _contentView = nil;
    }
    [_maskView removeFromSuperview];
}

- (void)message { // cue words
    if (_locationType != PopLocationTypeCenter) {
        if (_transitStyle != PopTransitStyleDefault) {
            NSLog(@"\n ◎ Set 'transitStyle' is invalid. when 'layoutType' is not 'PopupLayoutTypeCenter'.");
        }
        if (_dismissOppositeDirection) {
            NSLog(@"\n ◎ Set 'isDismissOppositeDirection' is invalid. when 'layoutType' is not 'PopupLayoutTypeCenter'.");
        }
    }
}

#pragma mark - Present

- (void)presentContentView:(nullable UIView *)contentView duration:(NSTimeInterval)duration elasticAnimated:(BOOL)isElasticAnimated inView:(nullable UIView *)fromView {
    
    if (self.isPresenting) return;
    
    if (nil != self.willPresent) {
        self.willPresent(self);
    } else {
        if ([self.delegate respondsToSelector:@selector(popupControllerWillPresent:)]) {
            [self.delegate popupControllerWillPresent:self];
        }
    }
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithCapacity:2];
    [parameters setValue:@(duration) forKey:@"duration"];
    [parameters setValue:@(isElasticAnimated) forKey:@"isElasticAnimated"];
    objc_setAssociatedObject(self, PopupControllerParametersKey, parameters, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    [self message];
    
    if (nil != fromView) {
        _superview = fromView;
        _maskView.frame = _superview.frame;
    }
    
    [self setContentView:contentView];
    [self addSubviews];
    [self dropAnimatedInitial];
    [self maskAlphaInitial];
    _popupView.userInteractionEnabled = NO;
    _popupView.center = [self initialCenterPoint];
    
    if (isElasticAnimated) {
        
        [UIView animateWithDuration:duration
                              delay:0.0
             usingSpringWithDamping:0.6
              initialSpringVelocity:0.2
                            options:UIViewAnimationOptionCurveLinear
                         animations:^{
                             
                             [self dropAnimatedFinished];
                             [self maskAlphaFinished];
                             _popupView.center = [self finishedCenterPoint];
                             
                         } completion:^(BOOL finished) {
                             
                             if (!finished) return;
                             _popupView.userInteractionEnabled = YES;
                             _isPresenting = YES;
                             if (nil != self.didPresent) {
                                 self.didPresent(self);
                             } else {
                                 if ([self.delegate respondsToSelector:@selector(popupControllerDidPresent:)]) {
                                     [self.delegate popupControllerDidPresent:self];
                                 }
                             }
                         }];
    } else {
        
        [UIView animateWithDuration:duration
                              delay:0.0
                            options:UIViewAnimationOptionCurveLinear
                         animations:^{
                             
                             [self dropAnimatedFinished];
                             [self maskAlphaFinished];
                             _popupView.center = [self finishedCenterPoint];
                             
                         } completion:^(BOOL finished) {
                             
                             if (!finished) return;
                             _popupView.userInteractionEnabled = YES;
                             _isPresenting = YES;
                             if (nil != self.didPresent) {
                                 self.didPresent(self);
                             } else {
                                 if ([self.delegate respondsToSelector:@selector(popupControllerDidPresent:)]) {
                                     [self.delegate popupControllerDidPresent:self];
                                 }
                             }
                         }];
    }
}

- (void)presentContentView:(UIView *)contentView duration:(NSTimeInterval)duration elasticAnimated:(BOOL)isElasticAnimated {
    [self presentContentView:contentView duration:duration elasticAnimated:isElasticAnimated inView:nil];
}

- (void)presentContentView:(UIView *)contentView {
    [self presentContentView:contentView duration:0.25 elasticAnimated:NO inView:nil];
}

#pragma mark - Dismiss

- (void)dismissWithDuration:(NSTimeInterval)duration elasticAnimated:(BOOL)isElasticAnimated {
    if (!self.isPresenting) return;
    
    if (nil != self.willDismiss) {
        self.willDismiss(self);
    } else {
        if ([self.delegate respondsToSelector:@selector(popupControllerWillDismiss:)]) {
            [self.delegate popupControllerWillDismiss:self];
        }
    }
    
    if (isElasticAnimated) {
        
        NSTimeInterval duration1 = duration * 0.25, duration2 = duration - duration1;
        [UIView animateWithDuration:duration1
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             
                             _popupView.center = [self elasticSpacePoint:30];
                             [self maskAlphaElastic];
                             
                         } completion:^(BOOL finished) {
                             
                             [UIView animateWithDuration:duration2
                                                   delay:0.0
                                                 options:UIViewAnimationOptionCurveEaseInOut
                                              animations:^{
                                                  
                                                  [self dropAnimatedDismissed];
                                                  [self maskAlphaInitial];
                                                  _popupView.center = [self dismissedCenterPoint];
                                                  
                                              } completion:^(BOOL finished) {
                                                  
                                                  if (!finished) return;
                                                  [self removeSubviews];
                                                  _isPresenting = NO;
                                                  _popupView.transform = CGAffineTransformIdentity;
                                                  if (nil != self.didDismiss) {
                                                      self.didDismiss(self);
                                                  } else {
                                                      if ([self.delegate respondsToSelector:@selector(popupControllerDidDismiss:)]) {
                                                          [self.delegate popupControllerDidDismiss:self];
                                                      }
                                                  }
                                              }];
                         }];
    } else {
        
        [UIView animateWithDuration:duration
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             
                             [self dropAnimatedDismissed];
                             [self maskAlphaInitial];
                             _popupView.center = [self dismissedCenterPoint];
                             
                         } completion:^(BOOL finished) {
                             
                             if (!finished) return;
                             [self removeSubviews];
                             _isPresenting = NO;
                             _popupView.transform = CGAffineTransformIdentity;
                             if (nil != self.didDismiss) {
                                 self.didDismiss(self);
                             } else {
                                 if ([self.delegate respondsToSelector:@selector(popupControllerDidDismiss:)]) {
                                     [self.delegate popupControllerDidDismiss:self];
                                 }
                             }
                         }];
    }
}

- (void)dismiss {
    id object = objc_getAssociatedObject(self, PopupControllerParametersKey);
    if (object && [object isKindOfClass:[NSDictionary class]]) {
        NSTimeInterval duration = 0.0;
        NSNumber* durationNumber = [object valueForKey:@"duration"];
        if (nil != durationNumber) {
            duration = durationNumber.doubleValue;
        }
        BOOL flag = NO;
        NSNumber *flagNumber = [object valueForKey:@"isElasticAnimated"];
        if (nil != flagNumber) {
            flag = flagNumber.boolValue;
        }
        [self dismissWithDuration:duration elasticAnimated:flag];
    }
}

#pragma mark - Move Elastic

- (CGPoint)elasticSpacePoint:(CGFloat)move {
    
    CGPoint point = _popupView.center;
    switch (_locationType) {
        case PopLocationTypeTop:            // 从顶部显示
            point.y += move;
            break;
        case PopLocationTypeBottom:         // 从底部显示
            point.y -= move;
            break;
        case PopLocationTypeLeft:           // 从左侧显示
            point.x += move;
            break;
        case PopLocationTypeRight:          // 从右侧显示
            point.x -= move;
            break;
        case PopLocationTypeCenter: {       // 从中间显示
            
            switch (_transitStyle) {
                case PopTransitStyleFromTop:
                    point.y += _dismissOppositeDirection ? -move : move;
                    break;
                case PopTransitStyleFromBottom:
                    point.y += _dismissOppositeDirection ? move : -move;
                    break;
                case PopTransitStyleFromLeft:
                    point.x += _dismissOppositeDirection ? -move : move;
                    break;
                case PopTransitStyleFromRight:
                    point.x += _dismissOppositeDirection ? move : -move;
                    break;
                case PopTransitStyleSlightScale:
                    _popupView.transform = _dismissOppositeDirection ? CGAffineTransformMakeScale(1.05, 1.05) : CGAffineTransformMakeScale(0.95, 0.95);
                    break;
                case PopTransitStyleShrinkInOut:
                    _popupView.transform = _dismissOppositeDirection ? CGAffineTransformMakeScale(0.95, 0.95) : CGAffineTransformMakeScale(1.05, 1.05);
                    break;
                case PopTransitStyleDefault: break;
                default: break;
            }
            
        } break;
        default: break;
    }
    return point;
}

#pragma mark - Drop Animated

- (BOOL)dropEligible {
    if (_locationType == PopLocationTypeCenter && _transitStyle == PopTransitStyleFromTop) {
        return YES;
    }
    return NO;
}

- (void)dropAnimatedInitial {
    if (_dropTransitionAnimated && [self dropEligible]) {
        _dismissOppositeDirection = YES;
        CGFloat ty = (_maskView.bounds.size.height + _popupView.frame.size.height) / 2;
        CATransform3D transform = CATransform3DMakeTranslation(0, -ty, 0);
        transform = CATransform3DRotate(transform, RANDOM_ANGLE(40, -40) * M_PI / 180, 0, 0, 1.0);
        _popupView.layer.transform = transform;
    }
}

- (void)dropAnimatedFinished {
    if (_dropTransitionAnimated && [self dropEligible]) {
        _popupView.layer.transform = CATransform3DIdentity;
    }
}

- (void)dropAnimatedDismissed {
    if (_dropTransitionAnimated && [self dropEligible]) {
        CGFloat ty = _maskView.bounds.size.height;
        CATransform3D transform = CATransform3DMakeTranslation(0, ty, 0);
        transform = CATransform3DRotate(transform, RANDOM_ANGLE(40, -40) * M_PI / 180, 0, 0, 1.0);
        _popupView.layer.transform = transform;
    }
}

#pragma mark - Mask Alpha

- (void)maskAlphaInitial {
    if (_maskType == PopMaskTypeBlackBlur || _maskType == PopMaskTypeWhiteBlur) {
        _maskView.alpha = 0;
    } else {
        _maskView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0];
    }
}

- (void)maskAlphaElastic {
    if (_maskType == PopMaskTypeBlackBlur || _maskType == PopMaskTypeWhiteBlur) {
        _maskView.alpha = 0.95;
    } else if (_maskType == PopMaskTypeDefault) {
        _maskView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:_maskAlpha - _maskAlpha * 0.15];
    }
}

- (void)maskAlphaFinished {
    if (_maskType == PopMaskTypeBlackBlur || _maskType == PopMaskTypeWhiteBlur) {
        _maskView.alpha = 1;
    } else {
        [self setMaskType:_maskType];
    }
}

#pragma mark - Center Point

- (CGPoint)finishedCenterPoint {
    
    CGPoint point = _maskView.center;
    switch (_locationType) {
        case PopLocationTypeTop:
            point = CGPointMake(point.x, _popupView.bounds.size.height * 0.5);
            break;
        case PopLocationTypeBottom:
            point = CGPointMake(point.x, _maskView.bounds.size.height - _popupView.bounds.size.height * 0.5);
            break;
        case PopLocationTypeLeft:
            point = CGPointMake(_popupView.bounds.size.width * 0.5, point.y);
            break;
        case PopLocationTypeRight:
            point = CGPointMake(_maskView.bounds.size.width - _popupView.bounds.size.width * 0.5, point.y);
            break;
        case PopLocationTypeCenter: {
            
            switch (_transitStyle) {
                case PopTransitStyleSlightScale: {
                    _maskView.alpha = 1;
                    _popupView.transform = CGAffineTransformIdentity;
                } break;
                case PopTransitStyleShrinkInOut:
                    _popupView.transform = CGAffineTransformIdentity;
                    break;
                case PopTransitStyleDefault:
                    _maskView.alpha = 1;
                    break;
                default: break;
            }
            
        } break;
        default: break;
    }
    return point;
}

- (CGPoint)initialCenterPoint {
    switch (_locationType) {
        case PopLocationTypeCenter: {
            
            switch (_transitStyle) {
                case PopTransitStyleSlightScale: {
                    _maskView.alpha = 0;
                    _popupView.transform = CGAffineTransformMakeScale(1.05, 1.05);
                    return _maskView.center;
                }
                case PopTransitStyleShrinkInOut: {
                    _popupView.transform = CGAffineTransformMakeScale(0.1, 0.1);
                    return _maskView.center;
                }
                case PopTransitStyleDefault: {
                    _maskView.alpha = 0;
                    return _maskView.center;
                }
                default: return [self pointInitialDirection:_transitStyle];
            }
            
        } break;
        default: return [self pointInitialDirection:_locationType];
    }
}

- (CGPoint)dismissedCenterPoint {
    
    switch (_locationType) {
        case PopLocationTypeCenter: {
            
            switch (_transitStyle) {
                case PopTransitStyleFromTop:
                    return _dismissOppositeDirection ? CGPointMake(_maskView.center.x, _maskView.bounds.size.height + _popupView.bounds.size.height * 0.5) : CGPointMake(_maskView.center.x, -_popupView.bounds.size.height * 0.5);
                    
                case PopTransitStyleFromBottom:
                    return _dismissOppositeDirection ? CGPointMake(_maskView.center.x, -_popupView.bounds.size.height * 0.5) : CGPointMake(_maskView.center.x, _maskView.bounds.size.height + _popupView.bounds.size.height * 0.5);
                    
                case PopTransitStyleFromLeft:
                    return _dismissOppositeDirection ? CGPointMake(_maskView.bounds.size.width + _popupView.bounds.size.width * 0.5, _maskView.center.y) : CGPointMake(-_popupView.bounds.size.width * 0.5, _maskView.center.y);
                    
                case PopTransitStyleFromRight:
                    return _dismissOppositeDirection ? CGPointMake(-_popupView.bounds.size.width * 0.5, _maskView.center.y) : CGPointMake(_maskView.bounds.size.width + _popupView.bounds.size.width * 0.5, _maskView.center.y);
                    
                case PopTransitStyleSlightScale: {
                    _popupView.transform = _dismissOppositeDirection ? CGAffineTransformMakeScale(0.95, 0.95) : CGAffineTransformMakeScale(1.05, 1.05);
                    _maskView.alpha = 0;
                    return _maskView.center;
                }
                case PopTransitStyleShrinkInOut:
                    _popupView.transform = _dismissOppositeDirection ? CGAffineTransformMakeScale(1.95, 1.95) : CGAffineTransformMakeScale(0.05, 0.05);
                    return _maskView.center;
                    
                case PopTransitStyleDefault:
                    _maskView.alpha = 0;
                    return _maskView.center;
                    
                default: return _maskView.center;
            }
            
        } break;
        default: return [self pointInitialDirection:_locationType];
    }
}

- (CGPoint)pointInitialDirection:(NSInteger)direction {
    switch (direction) {
        case 0: // top
            return CGPointMake(_maskView.center.x, -_popupView.bounds.size.height * 0.5) ;
        case 1: // bottom
            return CGPointMake(_maskView.center.x, _maskView.bounds.size.height + _popupView.bounds.size.height * 0.5);
        case 2: // left
            return CGPointMake(-_popupView.bounds.size.width * 0.5, _maskView.center.y);
        case 3: // right
            return CGPointMake(_maskView.bounds.size.width + _popupView.bounds.size.width * 0.5, _maskView.center.y);
        default:
            return _maskView.center;
    }
}

#pragma mark - Notification handlers

- (void)willChangeStatusBarOrientation {
    _maskView.frame = _superview.bounds;
    _popupView.center = [self finishedCenterPoint];
    [self dismiss];
}

- (void)didChangeStatusBarOrientation {
    if ([[UIDevice currentDevice].systemVersion compare:@"8.0" options:NSNumericSearch] == NSOrderedAscending) { // must manually fix orientation prior to iOS 8
        CGFloat angle;
        switch ([UIApplication sharedApplication].statusBarOrientation)
        {
            case UIInterfaceOrientationPortraitUpsideDown:
                angle = M_PI;
                break;
            case UIInterfaceOrientationLandscapeLeft:
                angle = -M_PI_2;
                break;
            case UIInterfaceOrientationLandscapeRight:
                angle = M_PI_2;
                break;
            default: // as UIInterfaceOrientationPortrait
                angle = 0.0;
                break;
        }
        _popupView.transform = CGAffineTransformMakeRotation(angle);
    }
    _maskView.frame = _superview.bounds;
    _popupView.center = [self finishedCenterPoint];
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([touch.view isDescendantOfView:_popupView]) {
        return NO;
    }
    return YES;
}

#pragma mark - Action selector

- (void)handleTap:(UITapGestureRecognizer *)g {
    if (_dismissOnMaskTouched) {
        if (nil != self.maskTouched) {
            self.maskTouched(self);
        } else {
            [self dismiss];
        }
    }
}

- (void)handlePan:(UIPanGestureRecognizer *)g {
    if (!_allowPan || !_isPresenting) {
        return;
    }
    
    CGPoint translation = [g translationInView:_maskView];
    switch (g.state) {
        case UIGestureRecognizerStateBegan:
            break;
        case UIGestureRecognizerStateChanged: {
            switch (_locationType) {
                case PopLocationTypeCenter: {
                    
                    BOOL verticalTransformation = NO;
                    switch (_transitStyle) {
                        case PopTransitStyleFromLeft:
                        case PopTransitStyleFromRight: break;
                        default:
                            verticalTransformation = YES;
                            break;
                    }
                    // set screen ratio `_maskView.bounds.size.height / coefficient`
                    NSInteger coefficient = 4;
                    CGFloat changeValue;
                    if (verticalTransformation) {
                        g.view.center = CGPointMake(g.view.center.x, g.view.center.y + translation.y);
                        changeValue = g.view.center.y / (_maskView.bounds.size.height / coefficient);
                    } else {
                        g.view.center = CGPointMake(g.view.center.x + translation.x, g.view.center.y);
                        changeValue = g.view.center.x / (_maskView.bounds.size.width / coefficient);
                    }
                    CGFloat alpha = coefficient * 0.5 - fabs(changeValue - coefficient * 0.5);
                    [UIView animateWithDuration:0.15 animations:^{
                        _maskView.alpha = alpha;
                    } completion:NULL];
                    
                } break;
                case PopLocationTypeBottom: {
                    if (g.view.frame.origin.y + translation.y > _maskView.bounds.size.height - g.view.bounds.size.height) {
                        g.view.center = CGPointMake(g.view.center.x, g.view.center.y + translation.y);
                    }
                } break;
                case PopLocationTypeTop: {
                    if (g.view.frame.origin.y + g.view.frame.size.height + translation.y  < g.view.bounds.size.height) {
                        g.view.center = CGPointMake(g.view.center.x, g.view.center.y + translation.y);
                    }
                } break;
                case PopLocationTypeLeft: {
                    if (g.view.frame.origin.x + g.view.frame.size.width + translation.x < g.view.bounds.size.width) {
                        g.view.center = CGPointMake(g.view.center.x + translation.x, g.view.center.y);
                    }
                } break;
                case PopLocationTypeRight: {
                    if (g.view.frame.origin.x + translation.x > _maskView.bounds.size.width - g.view.bounds.size.width) {
                        g.view.center = CGPointMake(g.view.center.x + translation.x, g.view.center.y);
                    }
                } break;
                default: break;
            }
            [g setTranslation:CGPointZero inView:_maskView];
        } break;
        case UIGestureRecognizerStateEnded: {
            BOOL willDismiss = YES, styleCentered = NO;
            switch (_locationType) {
                case PopLocationTypeCenter: {
                    styleCentered = YES;
                    if (g.view.center.y != _maskView.center.y) {
                        if (g.view.center.y > _maskView.bounds.size.height * 0.25 && g.view.center.y < _maskView.bounds.size.height * 0.75) {
                            willDismiss = NO;
                        }
                    } else {
                        if (g.view.center.x > _maskView.bounds.size.width * 0.25 && g.view.center.x < _maskView.bounds.size.width * 0.75) {
                            willDismiss = NO;
                        }
                    }
                } break;
                case PopLocationTypeBottom:
                    willDismiss = g.view.frame.origin.y > _maskView.bounds.size.height - g.view.frame.size.height * 0.75;
                    break;
                case PopLocationTypeTop:
                    willDismiss = g.view.frame.origin.y + g.view.frame.size.height < g.view.frame.size.height * 0.75;
                    break;
                case PopLocationTypeLeft:
                    willDismiss = g.view.frame.origin.x + g.view.frame.size.width < g.view.frame.size.width * 0.75;
                    break;
                case PopLocationTypeRight:
                    willDismiss = g.view.frame.origin.x > _maskView.bounds.size.width - g.view.frame.size.width * 0.75;
                    break;
                default: break;
            }
            if (willDismiss) {
                if (styleCentered) {
                    switch (_transitStyle) {
                        case PopTransitStyleSlightScale:
                        case PopTransitStyleShrinkInOut:
                        case PopTransitStyleDefault: {
                            if (g.view.center.y < _maskView.bounds.size.height * 0.25) {
                                _transitStyle = PopTransitStyleFromTop;
                            } else {
                                if (g.view.center.y > _maskView.bounds.size.height * 0.75) {
                                    _transitStyle = PopTransitStyleFromBottom;
                                }
                            }
                            _dismissOppositeDirection = NO;
                        } break;
                        case PopTransitStyleFromTop:
                            _dismissOppositeDirection = !(g.view.center.y < _maskView.bounds.size.height * 0.25);
                            break;
                        case PopTransitStyleFromBottom:
                            _dismissOppositeDirection = g.view.center.y < _maskView.bounds.size.height * 0.25;
                            break;
                        case PopTransitStyleFromLeft:
                            _dismissOppositeDirection = !(g.view.center.x < _maskView.bounds.size.width * 0.25);
                            break;
                        case PopTransitStyleFromRight:
                            _dismissOppositeDirection = g.view.center.x < _maskView.bounds.size.width * 0.25;
                            break;
                        default: break;
                    }
                }
                [self dismissWithDuration:0.20 elasticAnimated:NO];
                
            } else {
                // restore view location.
                id object = objc_getAssociatedObject(self, PopupControllerParametersKey);
                NSNumber *flagNumber = [object valueForKey:@"isElasticAnimated"];
                BOOL flag = NO;
                if (nil != flagNumber) {
                    flag = flagNumber.boolValue;
                }
                NSTimeInterval duration = 0.25;
                NSNumber* durationNumber = [object valueForKey:@"duration"];
                if (nil != durationNumber) {
                    duration = durationNumber.doubleValue;
                }
                if (flag) {
                    [UIView animateWithDuration:duration
                                          delay:0.0
                         usingSpringWithDamping:0.6
                          initialSpringVelocity:0.2
                                        options:UIViewAnimationOptionCurveLinear
                                     animations:^{
                                         g.view.center = [self finishedCenterPoint];
                                     } completion:NULL];
                } else {
                    [UIView animateWithDuration:duration
                                          delay:0.0
                                        options:UIViewAnimationOptionCurveEaseInOut
                                     animations:^{
                                         g.view.center = [self finishedCenterPoint];
                                     } completion:NULL];
                }
            }
        } break;
        case UIGestureRecognizerStateCancelled:
            break;
        default: break;
    }
}

@end

static void *MRPopControllerKey = &MRPopControllerKey;

@implementation NSObject(MRPopController)

- (void)setPopController:(MRPopController *)popController{

    objc_setAssociatedObject(self, MRPopControllerKey, popController, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (MRPopController *)popController{

    id popController = objc_getAssociatedObject(self, MRPopControllerKey);
    
    if (!popController) {
        popController = [[MRPopController alloc] init];
        self.popController = popController;
    }
    return popController;
}


@end
