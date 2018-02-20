![logo](logo.png)
[![Build Status](http://img.shields.io/travis/pcjbird/QuickWebViewController/master.svg?style=flat)](https://travis-ci.org/pcjbird/QuickWebViewController)
[![Pod Version](http://img.shields.io/cocoapods/v/QuickWebKit.svg?style=flat)](http://cocoadocs.org/docsets/QuickWebKit/)
[![Pod Platform](http://img.shields.io/cocoapods/p/QuickWebKit.svg?style=flat)](http://cocoadocs.org/docsets/QuickWebKit/)
[![Pod License](http://img.shields.io/cocoapods/l/QuickWebKit.svg?style=flat)](https://www.apache.org/licenses/LICENSE-2.0.html)
[![CocoaPods](https://img.shields.io/cocoapods/at/QuickWebKit.svg)](https://github.com/pcjbird/QuickWebViewController)
[![GitHub release](https://img.shields.io/github/release/pcjbird/QuickWebViewController.svg)](https://github.com/pcjbird/QuickWebViewController/releases)

# QuickWebViewController
### A great & strong plugin based WebViewController. 一款基于插件的 WebView 视图控制器，您可以基于它设计您的浏览器插件，然后像积木一样来组装它们。

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
