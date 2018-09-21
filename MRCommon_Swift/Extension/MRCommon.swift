//
//  MRCommon.swift
//  Panda
//
//  Created by mac on 2018/8/6.
//  Copyright © 2018年 Alpha Tech. All rights reserved.
//

import UIKit

//import RxSwift
//import RxCocoa
//import SnapKit
//import SwiftyJSON

// MARK: ----------------------- fuction -----------------------
// MARK: 打印日志
func Log<T>(_ message: T, file: String = #file, method: String = #function, line: Int = #line){
    #if DEBUG           /// debug
    let nowDate = Date.init()
    let formatter = DateFormatter.init()
    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    let time = formatter.string(from: nowDate)
    print("[\(time)] [\((file as NSString).lastPathComponent), line: \(line), method: \(method)]\t\(message)")
    #endif
}

/// 获取主线程
func getMainQueue(_ closure: @escaping NoParamClouser) {
    if Thread.current == Thread.main { closure() }  /// 主线程
    else { DispatchQueue.main.async { closure() }}  /// 子线程
}

typealias NoParamClouser = () -> ()

extension UIView {
    
}

/// app 名称
let kAppName = "EvaCam"

// MARK: ------------------------------------ 尺寸 ------------------------------------
/// 设计稿的宽
fileprivate let kDesignWidth: CGFloat = 375
/// 设计稿的高
fileprivate let kDesignHeight: CGFloat = 667

/// 屏幕宽
var kScreenWidth: CGFloat { get { return UIScreen.main.bounds.size.width }}
/// 屏幕高
var kScreenHeight: CGFloat { get { return UIScreen.main.bounds.size.height }}

/// 是否是竖屏
var kIsVerticalScreen: Bool { get { return kScreenHeight > kScreenWidth }}
/// 是否是横屏
var kIsLandscapeScreen: Bool { get { return kScreenWidth > kScreenHeight }}

/// 真实屏幕高
var kScreenRealHeight: CGFloat { get { return  max(kScreenWidth, kScreenHeight) }}
/// 真实屏幕宽
var kScreenRealWidth: CGFloat { get { return  min(kScreenWidth, kScreenHeight) }}

/// 导航栏高度
var kNavigationHeight: CGFloat { get { return kIsVerticalScreen ? 64 : 32 }}
/// tabbar 高度
let kTabbarHeight: CGFloat = 49
/// iPhoneX 顶部
var kIphoneXTop: CGFloat { get { return kis_iPhoneX ? 44 : 0 }}
/// iPhoneX 底部
var kIphoneXBottom: CGFloat { get { return kis_iPhoneX ? kScreenHeight - 34 : kScreenHeight }}

/// 缩放尺寸
var kScreenRatio: CGFloat { get { return min((kScreenWidth / kScreenWidth), (kScreenHeight / kScreenWidth)) }}
var kScreenWidthRatio: CGFloat { get { return kScreenWidth / kDesignWidth }}
var kScreenHeightRatio : CGFloat { get { return kScreenHeight / kDesignHeight }}

/// 适配宽
func MRFitWidth(_ width: CGFloat) -> CGFloat {
    return kScreenWidthRatio * width
}
/// 适配高
func MRFitHeight(_ height: CGFloat) -> CGFloat {
    return kScreenHeightRatio * height
}

// MARK: ------------------------------------ 设备信息 ------------------------------------
/// 是否是 iPhone
let kIs_iPhone = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.phone)
/// 是否是 iPad
let kIs_iPad = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad)

/// 设备版本号
let kDeviceVerson = UIDevice.current.systemVersion

fileprivate let infoDic = Bundle.main.infoDictionary
/// 软件版本号
let kAppVerson = infoDic?["CFBundleShortVersionString"] ?? ""

/// 是否是 iPhone5
let kIs_iPhone5   = (kIs_iPhone && kScreenRealHeight == 568.0)
/// 是否是 iPhone6, 6s, 7, 8
let kIs_iPhone6   = (kIs_iPhone && kScreenRealHeight == 667.0)
/// 是否是 iPhone6p, 7p, 8p
let kIs_iPhone6p  = (kIs_iPhone && kScreenRealHeight == 736.0)
/// 是否是 iPhoneX, iPhoneXs
let kis_iPhoneX   = (kIs_iPhone && kScreenRealHeight == 812.0 || kIs_iPhone && kScreenRealHeight == 896.0)
/// 是否是 iPhoneXR, iPhoneXmax
let kis_iPhoneXR  = (kIs_iPhone && kScreenRealHeight == 896.0)

// MARK: ------------------------------------ 空隙 ------------------------------------
/// 空隙 10
let kSpace10: CGFloat = MRFitWidth(10.0)
/// 空隙 12
let kSpace12: CGFloat = MRFitWidth(12.0)
/// 空隙 15
let kSpace15: CGFloat = MRFitWidth(15.0)
/// 空隙 20
let kSpace20: CGFloat = MRFitWidth(20.0)

// MARK: ------------------------------------ 圆角 ------------------------------------
/// 圆角 3
let kCornerRadius3: CGFloat = 3.0
/// 圆角 5
let kCornerRadius5: CGFloat = 5.0

// MARK: ------------------------------------ 背景色 ------------------------------------
/// 白色
let kWhiteColor = UIColor(red:1.00, green:1.00, blue:1.00, alpha:1.00)
/// 黑色
let kBlackColor = UIColor(red:0.00, green:0.00, blue:0.00, alpha:1.00)
/// 主题色
//let kThemeColor = UIColor(red:0.25, green:0.19, blue:0.98, alpha:1.00)
/// 背景色
let kBaseBackGroundColor = kWhiteColor

// MARK: ------------------------------------ label ------------------------------------
let kTextFont11: CGFloat             = MRFitWidth(11.0)
/// 字号 12
let kTextFont12: CGFloat             = MRFitWidth(12.0)
/// 字号 14
let kTextFont14: CGFloat             = MRFitWidth(14.0)
/// 字号 15
let kTextFont15: CGFloat             = MRFitWidth(15.0)
/// 字号 16
let kTextFont16: CGFloat             = MRFitWidth(16.0)
let kTextFont20: CGFloat             = MRFitWidth(20.0)
/// 正常字号
let kTextFontNormal       = kTextFont14
/// 小字号
let kTextFontSmall        = kTextFont12
/// 大字号
let kTextFontLarge        = kTextFont16

let kTextFontRealLarge    = kTextFont20

/// 字体颜色
/// 字体正常颜色, 发黑
let kTextColorNormal        = UIColor(red:0.20, green:0.20, blue:0.20, alpha:1.00)
/// 字体浅灰色
let kTextColorGray           = UIColor(red: 0.65, green: 0.65, blue: 0.65, alpha: 1.00)
/// 字体白色
let kTextColorWhite          = UIColor(red: 1.00, green: 1.00, blue: 1.00, alpha: 1.00)

// MARK: ------------------------------------ 按钮 ------------------------------------
/// 按钮宽 30
let kButtonWidth: CGFloat = MRFitWidth(30.0)
/// 按钮高 30
let kButtonHeight: CGFloat = MRFitWidth(30.0)
/// 按钮宽 50
let kButtonWidthLarge: CGFloat = MRFitWidth(50.0)

/// 按钮颜色
/// 按钮蓝色
let kButtonColorBlue         = UIColor(red: 0.20, green: 0.62, blue: 0.90, alpha: 1.00)
/// 按钮灰色
let kButtonColorGray        = UIColor(red: 0.80, green: 0.80, blue: 0.80, alpha: 1.00)
/// 按钮绿色
let kButtonColorGreen       = UIColor(red: 0.23, green: 0.75, blue: 0.49, alpha: 1.00)
/// 按钮灰色
let kButtonColorRed         = UIColor(red:1.00, green:0.76, blue:0.71, alpha:1.00)

// MARK: ------------------------------------ UserDefalut ------------------------------------
/// 是否是第一次登陆
let kIsFirstLaunch = "isFirstLaunch"
/// 支付成功的通知
let kPurchaseSuccess = "PurchaseSuccess"
/// 性别
let kGender = "gender"
/// 推送开关
let kNotify = "pushNoti"
/// 图片尺寸
let kPhotoSize = "photoSize"
/// 是否已经展示过保存泡泡提示文案
let kHasSHowSaveBubbles = "kHasSHowSaveBubbles"
/// 是否已经展示过换脸泡泡提示文案
let kHasShowChangeFaceBubbles = "kHasShowChangeFaceBubbles"
/// 是否已经展示过对比泡泡提示文案
let kHasShowBeforeAfterBubbles = "kHasShowBeforeAfterBubbles"
/// 是否已经展示过手势引导
let khasShowPanGuideView = "khasShowPanGuideView"
/// 判断是否是已经打开过 facelift
let khasOpendFaceLift = "hasOpendFaceLift"
/// 判断是否已经打开过 bright
let khastOpendBright = "khastOpendBright"
/// 判断是否已经打开过 hair
let khasOpendHair = "khasOpendHair"
/// 已经打开过 beard
let khasOpendBeard = "khasOpendBeard"
/// 已经打开过 hairColor
let khasOpendHairColor = "khasOpendHairColor"
/// 后台控制的支付默认索引
let defaultPayIndex = "defaultPayIndex"
/// 展示评分页面的基准数值, 从后台获取的
let kScoreShow = "kScoreShow"
/// 当前编辑页保存数
let kCurrentSaveEditCount = "kCurrentSaveEditCount"
/// 取消评分之后展示评分页面的基准数值, 从后台获取, 这个没用上
let kAfterCancelScoreShow = "kAfterCancelScoreShow"


//let kIsFirs

/*
 1. 相册
 NSPhotoLibraryUsageDescription                            :        App需要您的同意,才能访问相册
 2. 相机
 NSCameraUsageDescription                                    :        App需要您的同意,才能访问相机
 3. 麦克风
 NSMicrophoneUsageDescription                              :        App需要您的同意,才能访问麦克风
 4. 位置
 NSLocationUsageDescription                                   :        App需要您的同意,才能访问位置
 5. 在使用期间访问位置
 NSLocationWhenInUseUsageDescription                 :        App需要您的同意,才能在使用期间访问位置
 6. 始终访问位置
 NSLocationAlwaysUsageDescription                        :       App需要您的同意,才能始终访问位置
 7. 日历
 NSCalendarsUsageDescription                                 :       App需要您的同意,才能访问日历
 8. 提醒事项
 NSRemindersUsageDescription                                :        App需要您的同意,才能访问提醒事项
 9. 运动与健身
 NSMotionUsageDescription                                       :        App需要您的同意,才能访问运动与健身
 10.健康更新
 NSHealthUpdateUsageDescription                            :         App需要您的同意,才能访问健康更新
 11.健康分享
 NSHealthShareUsageDescription                              :         App需要您的同意,才能访问健康分享
 12.蓝牙
 NSBluetoothPeripheralUsageDescription                  :         App需要您的同意,才能访问蓝牙
 13.媒体资料库
 NSAppleMusicUsageDescription                               :         App需要您的同意,才能访问媒体资料库
 
 
 弹出键盘样式
 UIKeyboardTypeDefault,                              // 默认, 能输入汉字
 UIKeyboardTypeASCIICapable,                   // 输入英文和数字 语音
 UIKeyboardTypeNumbersAndPunctuation,  // 能输入汉字
 UIKeyboardTypeURL,                                  // 英文 和 表情
 UIKeyboardTypeNumberPad,                      // 数字
 UIKeyboardTypePhonePad,                        // 数字 *;等符号
 UIKeyboardTypeNamePhonePad,               // 英文 数字 表情
 UIKeyboardTypeEmailAddress,                   // 英文 数字 表情 符号
 UIKeyboardTypeDecimalPad                       // 数字 .
 UIKeyboardTypeTwitter                              // 英文 数字 表情 符号 @ #
 UIKeyboardTypeWebSearch                       // 英文 数字 符号
 UIKeyboardTypeASCIICapableNumberPad // 数字
 UIKeyboardTypeAlphabet = UIKeyboardTypeASCIICapable,
 */
