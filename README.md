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

    pcjbird    
    2018-03-10  
    Version:1.1.8 
    Build:201803100002
    1.新增支持自定义QuickWebJSBridgePlugin JavascriptInterface 名称以及异步回调Ready的javscript函数。

    pcjbird    
    2018-03-10  
    Version:1.1.7 
    Build:201803100001
    1.新增白名单功能。

    pcjbird    
    2018-02-20  
    Version:1.1.6 
    Build:201802200001
    1.修复当网页加载到一半返回，仍然显示NetworkActivityIndicator的问题。
    2.修改注册和移除通知观察者函数名，防止被继承类复写，导致BUG排查困难的问题。

    pcjbird    
    2018-02-02  
    Version:1.1.5 
    Build:201802020001
    1.修改JSProxy引用头文件大小写问题。

    pcjbird    
    2018-01-16  
    Version:1.1.4 
    Build:201801160002
    1.修改QuickWebSpotlightPlugin导致crash的BUG。

    pcjbird    
    2018-01-16  
    Version:1.1.3 
    Build:201801160001
    1.修改toast样式为共享样式。

    pcjbird    
    2018-01-14  
    Version:1.1.2 
    Build:201801140001
    1.修复QuickWebSpotlightPlugin无法处理Spotlight搜索点击结果的BUG。

    pcjbird    
    2018-01-10  
    Version:1.1.1 
    Build:201801100001
    1.修复QuickWebSharePlugin无法显示导航栏右侧分享按钮的BUG。

    pcjbird    
    2018-01-09  
    Version:1.1.0 
    Build:201801090004
    1.修复QuickWebQRCodePlugin链接检测到却无法打开的BUG。

    pcjbird    
    2018-01-09  
    Version:1.0.9 
    Build:201801090003
    1.修复QuickWebQRCodePlugin手势导致不能复制网页文本的BUG。

    pcjbird    
    2018-01-09  
    Version:1.0.8 
    Build:201801090002
    1.优化QuickWebQRCodePlugin插件手势。
    2.修复QuickWebQRCodePlugin本地化错误。

    pcjbird    
    2018-01-09  
    Version:1.0.7 
    Build:201801090001
    1.优化当作为navigationController的根视图时的显示问题。

    pcjbird    
    2018-01-06  
    Version:1.0.6 
    Build:201801060001
    1.修复Share插件与Spotlight插件导致Crash的问题。

    pcjbird    
    2018-01-05  
    Version:1.0.5 
    Build:201801050001
    1.修复当UINavigationBar的translucent为No时的显示问题。

    pcjbird    
    2018-01-04  
    Version:1.0.4 
    Build:201801040001
    1.新增Spotlight插件

    pcjbird    
    2018-01-02  
    Version:1.0.3 
    Build:201801020003
    1.新增LNRefresh和MJRefresh插件
    2.新增是否优先使用WKWebView初始化函数

    pcjbird    
    2018-01-02  
    Version:1.0.2 
    Build:201801020002
    1.修复QuickWebProviderPlugin字体颜色的问题

    pcjbird    
    2018-01-02  
    Version:1.0.1 
    Build:201801020001
    1.修复dealloc中使用了weak导致的crash问题

    pcjbird    
    2017-12-24  
    Version:1.0.0 
    Build:201712240001
    1.首次发布SDK版本
    

## 特性 / Features

1. 基于插件的 WebView 视图控制器, 像积木一样自由组装插件, 为 iOS 应用提供一个强大的 H5 容器。
2. 基础 [SmartJSWebView](https://github.com/pcjbird/SmartJSWebView), 支持 H5 页面通过 JavaScript 与 Native App 交互的 WebView，兼容 UIWebView 和 WKWebView。
3. 支持扩展, 您可以基于该 WebView 视图控制器定制开发您自己的插件。
4. 强大的基础插件支持，您几乎无需写一行代码即可运行起一个强大的 H5 容器，满足大部分应用场景：

*   QuickWebToastPlugin(toast插件) - 当页面出现错误时会以 toast 方式进行提示。
*   QuickWebProviderPlugin(provider插件) - 类似微信中的“此网页由xxx提供”。
*   QuickWebQRCodePlugin(qrcode插件) - 支持长按二维码图片进行二维码识别。
*   QuickWebSharePlugin(share插件) - 支持将页面分享到社交平台的插件。
*   QuickWebSpotlightPlugin(spotlight插件) - 支持将页面信息自动添加到 spotlight 搜索的插件。
*   QuickWebLNRefreshPlugin(LNRefresh插件) - 基于 LNRefresh 下拉刷新的插件。
*   QuickWebMJRefreshPlugin(MJRefresh插件) - 基于 MJRefresh 下拉刷新的插件。
*   QuickWebJSBridgePlugin(JSBridge插件) - 基于 JS 与 Native 交互的插件, 已实现多个 proxies, 详见 CoreProxies 和 ExtProxies 目录。
   
   将持续更新......

## 演示 / Demo

<p align="center"><img src="demo.png" title="demo"></p>

##  安装 / Installation

方法一：`QuickWebKit` is available through CocoaPods. To install it, simply add the following line to your Podfile:

```
pod 'QuickWebKit'
```

## 使用 / Usage
  
```
  QuickWebViewController *webVC = [QuickWebViewController alloc] initWithUrlString:@"https://www.baidu.com"];
  QuickWebProviderPlugin *providerPlugin = [QuickWebProviderPlugin new];
  [webVC registerPlugin:providerPlugin];
  //...
  [self.navigationController pushViewController:webVC animated:YES];
``` 
  or
```  
  @interface BaseWebViewController : QuickWebViewController

  @end
  
  @implementation BaseWebViewController

  - (void)viewDidLoad {
    // register your plugins here ...
    [self registerPlugins];
    [super viewDidLoad];
  }
  
  -(void)registerPlugins
  {
    QuickWebProviderPlugin *providerPlugin = [QuickWebProviderPlugin new];
    [self registerPlugin:providerPlugin];
    //...
  }
  @end
  
  BaseWebViewController *webVC = [BaseWebViewController alloc] initWithUrlString:@"https://www.baidu.com"];
  [self.navigationController pushViewController:webVC animated:YES];
```

待续...

## 关注我们 / Follow us
  
<a href="https://itunes.apple.com/cn/app/iclock-一款满足-挑剔-的翻页时钟与任务闹钟/id1128196970?pt=117947806&ct=com.github.pcjbird.QuickWebViewController&mt=8"><img src="https://github.com/pcjbird/AssetsExtractor/raw/master/iClock.gif" width="400" title="iClock - 一款满足“挑剔”的翻页时钟与任务闹钟"></a>

[![Twitter URL](https://img.shields.io/twitter/url/http/shields.io.svg?style=social)](https://twitter.com/intent/tweet?text=https://github.com/pcjbird/QuickWebViewController)
[![Twitter Follow](https://img.shields.io/twitter/follow/pcjbird.svg?style=social)](https://twitter.com/pcjbird)
