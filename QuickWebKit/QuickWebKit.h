//
//  QuickWebKit.h
//  QuickWebKit
//
//  Created by pcjbird on 2017/12/23.
//  Copyright © 2017年 Zero Status. All rights reserved.
//
//  框架名称:QuickWebKit
//  框架功能:A great & strong plugin based WebViewController. 一款基于插件的 WebView 视图控制器，您可以基于它设计您的浏览器插件，然后像积木一样来组装它们。
//  修改记录:
//     pcjbird    2022-06-17  Version:2.0.5 Build:202206170001
//                            1.修正标题获取不到的问题。
//
//     pcjbird    2020-06-11  Version:2.0.4 Build:202006110001
//                            1.新增日语翻译。
//
//     pcjbird    2020-06-10  Version:2.0.3 Build:202006100001
//                            1.修正Bundle中其他语言翻译的问题。
//
//     pcjbird    2020-05-07  Version:2.0.2 Build:202005070002
//                            1.调整回调日志的内容。
//
//     pcjbird    2020-05-07  Version:2.0.1 Build:202005070001
//                            1.新增浏览器控制台打印JS方法。
//
//     pcjbird    2020-03-02  Version:2.0.0 Build:202003020001
//                            1.remove UIWebView。
//
//     pcjbird    2019-04-03  Version:1.3.5 Build:201904030001
//                            1.build as static library bug fixed。
//
//     pcjbird    2018-10-27  Version:1.3.4 Build:201810270001
//                            1.try fix some crash bugs。
//
//     pcjbird    2018-09-29  Version:1.3.3 Build:201809290001
//                            1.恢复 QuickWebLNRefreshPlugin。
//
//     pcjbird    2018-09-18  Version:1.3.2 Build:201809180001
//                            1.Xcode 10 support。
//
//     pcjbird    2018-08-30  Version:1.3.1 Build:201808300001
//                            1.remove some build warnings。
//
//     pcjbird    2018-08-17  Version:1.3.0 Build:201808170001
//                            1.新增导航栏按钮颜色偏好设置。
//
//     pcjbird    2018-06-20  Version:1.2.9 Build:201806200001
//                            1.兼容ZFPlayer最新版本。
//
//     pcjbird    2018-04-10  Version:1.2.8 Build:201804100001
//                            1.插件新增didCreateJavaScriptContext回调代理。
//
//     pcjbird    2018-03-26  Version:1.2.7 Build:201803260001
//                            1.修改分享内容description长度限制，取消空格替换(因为英文描述会有bug)。
//
//     pcjbird    2018-03-21  Version:1.2.6 Build:201803210002
//                            1.放弃修改弹出菜单icon图片前景色。
//
//     pcjbird    2018-03-21  Version:1.2.5 Build:201803210001
//                            1.修复导航设置网络图片失真的问题。
//                            2.控制设置导航标题为网络图片的显示大小。
//
//     pcjbird    2018-03-20  Version:1.2.4 Build:201803200002
//                            1.修复设置导航title为网络图片时显示的大小问题。
//                            2.支持项目通过YPNavigationBarTransition修改导航背景色。
//
//     pcjbird    2018-03-20  Version:1.2.3 Build:201803200001
//                            1.修复点击导航右侧按钮没有回调的问题。
//                            2.修复分享插件总是显示更多按钮的BUG。
//                            3.修改导航弹出菜单样式。
//                            4.修改导航右侧按钮顺序。
//
//     pcjbird    2018-03-15  Version:1.2.2 Build:201803150001
//                            1.QuickWebJSBridgeContactProxy: 新增一些浏览器控制台调试日志。
//
//     pcjbird    2018-03-14  Version:1.2.1 Build:201803140003
//                            1.新增一些浏览器控制台调试日志。
//
//     pcjbird    2018-03-14  Version:1.2.0 Build:201803140002
//                            1.修复JS插件system proxy部分接口无法调用的问题。
//
//     pcjbird    2018-03-14  Version:1.1.9 Build:201803140001
//                            1.修复模糊查找联系人的BUG。
//
//     pcjbird    2018-03-10  Version:1.1.8 Build:201803100002
//                            1.新增支持自定义QuickWebJSBridgePlugin JavascriptInterface 名称以及异步回调结果Ready回调通知的javscript函数。
//
//     pcjbird    2018-03-10  Version:1.1.7 Build:201803100001
//                            1.新增白名单功能。
//
//     pcjbird    2018-02-20  Version:1.1.6 Build:201802200001
//                            1.修复当网页加载到一半返回，仍然显示NetworkActivityIndicator的问题。
//                            2.修改注册和移除通知观察者函数名，防止被继承类复写，导致BUG排查困难的问题。
//
//     pcjbird    2018-02-02  Version:1.1.5 Build:201802020001
//                            1.修改JSProxy引用头文件大小写问题。
//
//     pcjbird    2018-01-16  Version:1.1.4 Build:201801160002
//                            1.修改QuickWebSpotlightPlugin导致crash的BUG。
//
//     pcjbird    2018-01-16  Version:1.1.3 Build:201801160001
//                            1.修改toast样式为共享样式。
//
//     pcjbird    2018-01-14  Version:1.1.2 Build:201801140001
//                            1.修复QuickWebSpotlightPlugin无法处理Spotlight搜索点击结果的BUG。
//
//     pcjbird    2018-01-10  Version:1.1.1 Build:201801100001
//                            1.修复QuickWebSharePlugin无法显示导航栏右侧分享按钮的BUG。
//
//     pcjbird    2018-01-09  Version:1.1.0 Build:201801090004
//                            1.修复QuickWebQRCodePlugin链接检测到却无法打开的BUG。
//
//     pcjbird    2018-01-09  Version:1.0.9 Build:201801090003
//                            1.修复QuickWebQRCodePlugin手势导致不能复制网页文本的BUG。
//
//     pcjbird    2018-01-09  Version:1.0.8 Build:201801090002
//                            1.优化QuickWebQRCodePlugin插件手势。
//                            2.修复QuickWebQRCodePlugin本地化错误。
//
//     pcjbird    2018-01-09  Version:1.0.7 Build:201801090001
//                            1.优化当作为navigationController的根视图时的显示问题。
//
//     pcjbird    2018-01-06  Version:1.0.6 Build:201801060001
//                            1.修复Share插件与Spotlight插件导致Crash的问题。
//
//     pcjbird    2018-01-05  Version:1.0.5 Build:201801050001
//                            1.修复当UINavigationBar的translucent为No时的显示问题。
//
//     pcjbird    2018-01-04  Version:1.0.4 Build:201801040001
//                            1.新增Spotlight插件
//
//     pcjbird    2018-01-02  Version:1.0.3 Build:201801020003
//                            1.新增LNRefresh和MJRefresh插件
//                            2.新增是否优先使用WKWebView初始化函数
//
//     pcjbird    2018-01-02  Version:1.0.2 Build:201801020002
//                            1.修复QuickWebProviderPlugin字体颜色的问题
//
//     pcjbird    2018-01-02  Version:1.0.1 Build:201801020001
//                            1.修复dealloc中使用了weak导致的crash问题
//
//     pcjbird    2017-12-24  Version:1.0.0 Build:201712240001
//                            1.首次发布SDK版本

#ifndef QuickWebKit_h
#define QuickWebKit_h
#import <CoreGraphics/CoreGraphics.h>

#if __has_include(<SmartJSWebView/SmartJSWebView.h>)
#import <SmartJSWebView/SmartJSWebView.h>
#else
#import "SmartJSWebView.h"
#endif


//! Project version number for QuickWebKit.
FOUNDATION_EXPORT double QuickWebKitVersionNumber;

//! Project version string for QuickWebKit.
FOUNDATION_EXPORT const unsigned char QuickWebKitVersionString[];

//QuickWeb通知APP 请求Url处理  notification.object 为url地址
#define QUICKWEBREQUESTURLHANDLERNOTIFICATION @"QuickWebRequestUrlHandlerNotification"

#if __has_include("QuickWebViewController.h")
#import "QuickWebViewController.h"
#endif

#if __has_include("QuickWebNavigationButton.h")
#import "QuickWebNavigationButton.h"
#endif

#if __has_include("QuickWebPluginProtocol.h")
#import "QuickWebPluginProtocol.h"
#endif

#if __has_include("QuickWebJSInvokeProviderProtocol.h")
#import "QuickWebJSInvokeProviderProtocol.h"
#endif

#if __has_include("QuickWebJSInvokeResultHandlerProtocol.h")
#import "QuickWebJSInvokeResultHandlerProtocol.h"
#endif

#if __has_include("QuickWebJSInvokeCommand.h")
#import "QuickWebJSInvokeCommand.h"
#endif

#if __has_include("QuickWebJSInvokeResult.h")
#import "QuickWebJSInvokeResult.h"
#endif

#if __has_include("QuickWebJSBridgeProxyProtocol.h")
#import "QuickWebJSBridgeProxyProtocol.h"
#endif

#if __has_include("QuickWebJSBridgeInvokeCommand.h")
#import "QuickWebJSBridgeInvokeCommand.h"
#endif

#if __has_include("QuickWebToastPlugin.h")
#import "QuickWebToastPlugin.h"
#endif

#if __has_include("QuickWebProviderPlugin.h")
#import "QuickWebProviderPlugin.h"
#endif

#if __has_include("QuickWebSharePlugin.h")
#import "QuickWebSharePlugin.h"
#endif

#if __has_include("QuickWebQRCodePlugin.h")
#import "QuickWebQRCodePlugin.h"
#endif

#if __has_include("QuickWebLNRefreshPlugin.h")
#import "QuickWebLNRefreshPlugin.h"
#endif

#if __has_include("QuickWebMJRefreshPlugin.h")
#import "QuickWebMJRefreshPlugin.h"
#endif

#if __has_include("QuickWebSpotlightPlugin.h")
#import "QuickWebSpotlightPlugin.h"
#endif

#if __has_include("QuickWebJSBridgePlugin.h")
#import "QuickWebJSBridgePlugin.h"
#endif

#if __has_include("QuickWebJSBridgeSystemProxy.h")
#import "QuickWebJSBridgeSystemProxy.h"
#endif

#if __has_include("QuickWebJSBridgeAccountProxy.h")
#import "QuickWebJSBridgeAccountProxy.h"
#endif

#if __has_include("QuickWebJSBridgeContactProxy.h")
#import "QuickWebJSBridgeContactProxy.h"
#endif

#if __has_include("QuickWebJSBridgeNavBarProxy.h")
#import "QuickWebJSBridgeNavBarProxy.h"
#endif

#if __has_include("QuickWebJSBridgeShareProxy.h")
#import "QuickWebJSBridgeShareProxy.h"
#endif

#if __has_include("QuickWebJSBridgeImagePlayProxy.h")
#import "QuickWebJSBridgeImagePlayProxy.h"
#endif

#if __has_include("QuickWebJSBridgeVideoPlayProxy.h")
#import "QuickWebJSBridgeVideoPlayProxy.h"
#endif

#if __has_include("QuickWebJSBridgePushMessageProxy.h")
#import "QuickWebJSBridgePushMessageProxy.h"
#endif


#endif /* QuickWebKit_h */
