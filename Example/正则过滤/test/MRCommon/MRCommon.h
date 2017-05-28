//
//  MRCommon.h
//  test
//
//  Created by 刘入徵 on 2017/4/15.
//  Copyright © 2017年 Mix_Reality. All rights reserved.
//

#ifndef MRCommonPackaging_h
#define MRCommonPackaging_h

#import "UIButton+MRButton.h"
#import "UIImageView+MRImageView.h"
#import "NSArray+MRLog.h"
#import "NSAttributedString+MRAttributedString.h"
#import "NSString+MRString.h"
#import "UIColor+MRColor.h"
#import "UIScreen+MRScreen.h"
#import "UIView+MRView.h"

#import "MRSingleSwitch.h"
#import "MRInputBoxView.h"
#import "MRDropDownView.h"
#import "MRListDownView.h"
#import "MRChangeView.h"

#import "MRCommonColorAndPicture.h"
#import "MRCommonTime.h"
#import "MRCommonString.h"
#import "MRCommonOther.h"
#import "MRCommonRuntime.h"

/*
 <!-- 相册 -->
 <key>NSPhotoLibraryUsageDescription</key>
 <string>App需要您的同意,才能访问相册</string>
 <!-- 相机 -->
 <key>NSCameraUsageDescription</key>
 <string>App需要您的同意,才能访问相机</string>
 <!-- 麦克风 -->
 <key>NSMicrophoneUsageDescription</key>
 <string>App需要您的同意,才能访问麦克风</string>
 <!-- 位置 -->
 <key>NSLocationUsageDescription</key>
 <string>App需要您的同意,才能访问位置</string>
 <!-- 在使用期间访问位置 -->
 <key>NSLocationWhenInUseUsageDescription</key>
 <string>App需要您的同意,才能在使用期间访问位置</string>
 <!-- 始终访问位置 -->
 <key>NSLocationAlwaysUsageDescription</key>
 <string>App需要您的同意,才能始终访问位置</string>
 <!-- 日历 -->
 <key>NSCalendarsUsageDescription</key>
 <string>App需要您的同意,才能访问日历</string>
 <!-- 提醒事项 -->
 <key>NSRemindersUsageDescription</key>
 <string>App需要您的同意,才能访问提醒事项</string>
 <!-- 运动与健身 -->
 <key>NSMotionUsageDescription</key> <string>App需要您的同意,才能访问运动与健身</string>
 <!-- 健康更新 -->
 <key>NSHealthUpdateUsageDescription</key>
 <string>App需要您的同意,才能访问健康更新 </string>
 <!-- 健康分享 -->
 <key>NSHealthShareUsageDescription</key>
 <string>App需要您的同意,才能访问健康分享</string>
 <!-- 蓝牙 -->
 <key>NSBluetoothPeripheralUsageDescription</key>
 <string>App需要您的同意,才能访问蓝牙</string>
 <!-- 媒体资料库 -->
 <key>NSAppleMusicUsageDescription</key>
 <string>App需要您的同意,才能访问媒体资料库</string>
 */

#if 0  
弹出键盘样式
UIKeyboardTypeDefault,                  // 默认, 能输入汉字
UIKeyboardTypeASCIICapable,             // 输入英文和数字 语音
UIKeyboardTypeNumbersAndPunctuation,    // 能输入汉字
UIKeyboardTypeURL,                      // 英文 和 表情
UIKeyboardTypeNumberPad,                // 数字
UIKeyboardTypePhonePad,                 // 数字 *;等符号
UIKeyboardTypeNamePhonePad,             // 英文 数字 表情
UIKeyboardTypeEmailAddress,             // 英文 数字 表情 符号
UIKeyboardTypeDecimalPad                // 数字 .
UIKeyboardTypeTwitter                   // 英文 数字 表情 符号 @ #
UIKeyboardTypeWebSearch                 // 英文 数字 符号
UIKeyboardTypeASCIICapableNumberPad     // 数字
UIKeyboardTypeAlphabet = UIKeyboardTypeASCIICapable,
#endif

#endif /* MRCommonPackaging_h */
