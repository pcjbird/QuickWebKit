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
#import <SmartJSWebView/SmartJSWebView.h>

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
