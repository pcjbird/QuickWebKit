//
//  QuickWebViewController.h
//  QuickWebViewController
//
//  Created by pcjbird on 2017/12/18.
//  Copyright © 2017 年 Zero Status. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SmartJSWebView/SmartJSWebView.h>
#import "QuickWebPluginProtocol.h"
/// QuickWebViewController 是一款基于插件的 WebView 视图控制器。
/// 您可以基于它设计您的浏览器插件，然后像积木一样来组装它们。
@interface QuickWebViewController : UIViewController<SmartJSWebSecurityProxy>

/// Web 视图实例
@property(nonatomic, weak, readonly)SmartJSWebView* webView;

/// 已注册的插件数组
@property(nonatomic, weak, readonly)NSArray<id<QuickWebPluginProtocol>>* plugins;

/// 导航栏是否透明，默认 NO
@property(nonatomic, assign) BOOL navbarTransparent;

/// 是否隐藏进度条，默认 NO
@property(nonatomic, assign) BOOL progressHidden;

/// 是否在 iOS 26 及以后的版本中使用液态玻璃效果，默认 NO
@property(nonatomic, assign) BOOL usingLiquidGlassEffectAfteriOS26;

/// 使用指定 URL 初始化视图控制器
/// - Parameters:
///   - url: 需要加载的页面 URL 字符串
-(instancetype)initWithUrlString:(NSString *)url;

/// 加载指定 URL 的页面
/// - Parameters:
///   - url: 需要加载的页面 URL 字符串
-(void)loadPage:(NSString *)url;

/// 获取 Web 视图的背景颜色
/// - Returns: Web 视图背景颜色，默认为#f2f2f2
-(UIColor *)backgroundColor;

/// 获取进度条颜色
/// - Returns: 进度条颜色，默认为#e6001b
-(UIColor *)progressColor;

/// 获取返回按钮图标
/// - Returns: 返回按钮图标，仅在 useTextWithBackOrCloseButton 为 false 时有效
-(UIImage *)backIndicatorImage;

/// 获取关闭按钮图标
/// - Returns: 关闭按钮图标，仅在 useTextWithBackOrCloseButton 为 false 时有效
-(UIImage *)closeIndicatorImage;

/// 是否在返回或关闭按钮上使用文字
/// - Returns: 是否使用文字，默认为 YES
-(BOOL)useTextWithBackOrCloseButton;

/// 注册一个新的插件
/// - Parameters:
///   - plugin: 需要注册的插件实例
- (void)registerPlugin:(id<QuickWebPluginProtocol>)plugin;

/// 通知观察者注册完成时调用
-(void) didRegisterNotificationObserver;

/// 通知观察者移除完成时调用
-(void) didRemoveNotificationObserver;

/// 设置导航栏背景色
/// - Parameter tintColor: 导航栏背景色，传入 nil 则清除背景色
-(void) setBarTintColor:(UIColor*)tintColor;

/// 获取导航按钮的首选前景色
/// - Returns: 按钮前景色。若返回 nil 则使用全局外观设置，若全局未设置则使用默认色 [UIColor darkGrayColor]
-(UIColor *)preferNavBtnTintColor;

/// 获取导航按钮的首选高亮色
/// - Returns: 按钮高亮色。若返回 nil 则使用全局外观设置，若全局未设置则使用默认色 [UIColor darkGrayColor]
-(UIColor *)preferNavBtnHighlightColor;

/// 获取导航按钮的首选禁用状态颜色
/// - Returns: 按钮禁用状态颜色。若返回 nil 则使用全局外观设置，若全局未设置则使用默认色 [UIColor darkGrayColor]
-(UIColor *)preferNavBtnDisabledColor;

@end
