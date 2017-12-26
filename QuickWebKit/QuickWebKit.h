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

#if __has_include("QuickWebViewController.h")
#import "QuickWebViewController.h"
#endif

#if __has_include("QuickWebNavigationButton.h")
#import "QuickWebNavigationButton.h"
#endif

#if __has_include("QuickWebToastPlugin.h")
#import "QuickWebToastPlugin.h"
#endif

#if __has_include("QuickWebProviderPlugin.h")
#import "QuickWebProviderPlugin.h"
#endif

#if __has_include("QuickWebJSBridgePlugin.h")
#import "QuickWebJSBridgePlugin.h"
#endif


#endif /* QuickWebKit_h */
