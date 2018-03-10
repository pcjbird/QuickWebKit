![logo](logo.png)
[![Build Status](http://img.shields.io/travis/pcjbird/QuickWebViewController/master.svg?style=flat)](https://travis-ci.org/pcjbird/QuickWebViewController)
[![Pod Version](http://img.shields.io/cocoapods/v/QuickWebKit.svg?style=flat)](http://cocoadocs.org/docsets/QuickWebKit/)
[![Pod Platform](http://img.shields.io/cocoapods/p/QuickWebKit.svg?style=flat)](http://cocoadocs.org/docsets/QuickWebKit/)
[![Pod License](http://img.shields.io/cocoapods/l/QuickWebKit.svg?style=flat)](https://www.apache.org/licenses/LICENSE-2.0.html)
[![CocoaPods](https://img.shields.io/cocoapods/at/QuickWebKit.svg)](https://github.com/pcjbird/QuickWebViewController)
[![GitHub release](https://img.shields.io/github/release/pcjbird/QuickWebViewController.svg)](https://github.com/pcjbird/QuickWebViewController/releases)

# QuickWebViewController
### A great & strong plugin based WebViewController. 一款基于插件的 WebView 视图控制器，您可以基于它设计您的浏览器插件，然后像积木一样来组装它们。

## 版本 / Releases

###   2018-03-10 V1.1.8
![](https://avatars3.githubusercontent.com/u/6175452?s=16) **pcjbird** released build201803100002
> 1.新增支持自定义QuickWebJSBridgePlugin JavascriptInterface 名称以及异步回调Ready的javscript函数。

###   2018-03-10 V1.1.7
![](https://avatars3.githubusercontent.com/u/6175452?s=16) **pcjbird** released build201803100001
> 1.新增白名单功能。

###   2018-02-20 V1.1.6
![](https://avatars3.githubusercontent.com/u/6175452?s=16) **pcjbird** released build201802200001
> 1.修复当网页加载到一半返回，仍然显示NetworkActivityIndicator的问题。
> 2.修改注册和移除通知观察者函数名，防止被继承类复写，导致BUG排查困难的问题。

###   2018-02-02 V1.1.5
![](https://avatars3.githubusercontent.com/u/6175452?s=16) **pcjbird** released build201802020001
> 1.修改JSProxy引用头文件大小写问题。

###   2018-01-16 V1.1.4 
![](https://avatars3.githubusercontent.com/u/6175452?s=16) **pcjbird** released build201801160002
> 1.修改QuickWebSpotlightPlugin导致crash的BUG。

###   2018-01-16 V1.1.3 
![](https://avatars3.githubusercontent.com/u/6175452?s=16) **pcjbird** released build201801160001
> 1.修改toast样式为共享样式。

###   2018-01-14 V1.1.2 
![](https://avatars3.githubusercontent.com/u/6175452?s=16) **pcjbird** released build201801140001
> 1.修复QuickWebSpotlightPlugin无法处理Spotlight搜索点击结果的BUG。

###   2018-01-10 V1.1.1 
![](https://avatars3.githubusercontent.com/u/6175452?s=16) **pcjbird** released build201801100001
> 1.修复QuickWebSharePlugin无法显示导航栏右侧分享按钮的BUG。

###   2018-01-09 V1.1.0 
![](https://avatars3.githubusercontent.com/u/6175452?s=16) **pcjbird** released build201801090004
> 1.修复QuickWebQRCodePlugin链接检测到却无法打开的BUG。

###   2018-01-09 V1.0.9 
![](https://avatars3.githubusercontent.com/u/6175452?s=16) **pcjbird** released build201801090003
> 1.修复QuickWebQRCodePlugin手势导致不能复制网页文本的BUG。

###   2018-01-09 V1.0.8 
![](https://avatars3.githubusercontent.com/u/6175452?s=16) **pcjbird** released build201801090002
> 1.优化QuickWebQRCodePlugin插件手势。
> 2.修复QuickWebQRCodePlugin本地化错误。

###   2018-01-09 V1.0.7 
![](https://avatars3.githubusercontent.com/u/6175452?s=16) **pcjbird** released build201801090001
> 1.优化当作为navigationController的根视图时的显示问题。

###   2018-01-06 V1.0.6 
![](https://avatars3.githubusercontent.com/u/6175452?s=16) **pcjbird** released build201801060001
> 1.修复Share插件与Spotlight插件导致Crash的问题。

###   2018-01-05 V1.0.5 
![](https://avatars3.githubusercontent.com/u/6175452?s=16) **pcjbird** released build201801050001
> 1.修复当UINavigationBar的translucent为No时的显示问题。

###   2018-01-04 V1.0.4 
![](https://avatars3.githubusercontent.com/u/6175452?s=16) **pcjbird** released build201801040001
> 1.新增Spotlight插件

###   2018-01-02 V1.0.3
![](https://avatars3.githubusercontent.com/u/6175452?s=16) **pcjbird** released build201801020003
> 1.新增LNRefresh和MJRefresh插件
> 2.新增是否优先使用WKWebView初始化函数

###   2018-01-02 V1.0.2
![](https://avatars3.githubusercontent.com/u/6175452?s=16) **pcjbird** released build201801020002
> 1.修复QuickWebProviderPlugin字体颜色的问题

###   2018-01-02 V1.0.1
![](https://avatars3.githubusercontent.com/u/6175452?s=16) **pcjbird** released build201801020001
> 1.修复dealloc中使用了weak导致的crash问题

###   2017-12-24 V1.0.0
![](https://avatars3.githubusercontent.com/u/6175452?s=16) **pcjbird** released build201712240001
> 1.首次发布SDK版本
    

## 特性 / Features

1. 基于插件的 WebView 视图控制器, 像积木一样自由组装插件, 为 iOS 应用提供一个强大的 H5 容器。
2. 基础 [SmartJSWebView](https://github.com/pcjbird/SmartJSWebView), 支持 H5 页面通过 JavaScript 与 Native App 交互的 WebView，兼容 UIWebView 和 WKWebView。
3. 支持扩展, 您可以基于该 WebView 视图控制器定制开发您自己的插件。
4. 强大的基础插件支持，您几乎无需写一行代码即可运行起一个强大的 H5 容器，满足大部分应用场景：

*   QuickWebToastPlugin(toast插件) - 当页面出现错误时会以 toast 方式进行提示。
*   QuickWebProviderPlugin(provider插件) - 类似微信中的“此网页由xxx提供”。
*   QuickWebQRCodePlugin(qrcode插件) - 支持长按二维码图片进行二维码识别。
*   QuickWebShare
