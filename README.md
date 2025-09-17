![logo](https://github.com/pcjbird/QuickWebKit/raw/master/logo.png)
[![Pod Version](http://img.shields.io/cocoapods/v/QuickWebKit.svg?style=flat)](http://cocoadocs.org/docsets/QuickWebKit/)
[![Pod Platform](http://img.shields.io/cocoapods/p/QuickWebKit.svg?style=flat)](http://cocoadocs.org/docsets/QuickWebKit/)
[![Pod License](http://img.shields.io/cocoapods/l/QuickWebKit.svg?style=flat)](https://www.apache.org/licenses/LICENSE-2.0.html)
[![GitHub release](https://img.shields.io/github/release/pcjbird/QuickWebKit.svg)](https://github.com/pcjbird/QuickWebKit/releases)
[![GitHub release](https://img.shields.io/github/release-date/pcjbird/QuickWebKit.svg)](https://github.com/pcjbird/QuickWebKit/releases)
[![Website](https://img.shields.io/website-pcjbird-down-green-red/https/shields.io.svg?label=author)](https://pcjbird.github.io)

# QuickWebKit
### A great & strong plugin based WebViewController. 一款基于插件的 WebView 视图控制器，您可以基于它设计您的浏览器插件，然后像积木一样来组装它们。

## 特性 / Features

1. 基于插件的 WebView 视图控制器，像积木一样自由组装插件，为 iOS 应用提供一个强大的 H5 容器。
2. 基础 [SmartJSWebView](https://github.com/pcjbird/SmartJSWebView), 支持 H5 页面通过 JavaScript 与 Native App 交互的 WebView。
3. 支持扩展，您可以基于该 WebView 视图控制器定制开发您自己的插件。
4. 强大的基础插件支持，您几乎无需写一行代码即可运行起一个强大的 H5 容器，满足大部分应用场景：

*   QuickWebToastPlugin(toast 插件) - 当页面出现错误时会以 toast 方式进行提示。
*   QuickWebProviderPlugin(provider 插件) - 类似微信中的“此网页由 xxx 提供”。
*   QuickWebQRCodePlugin(qrcode 插件) - 支持长按二维码图片进行二维码识别。
*   QuickWebSharePlugin(share 插件) - 支持将页面分享到社交平台的插件。
*   QuickWebSpotlightPlugin(spotlight 插件) - 支持将页面信息自动添加到 spotlight 搜索的插件。
*   QuickWebLNRefreshPlugin(LNRefresh 插件) - 基于 LNRefresh 下拉刷新的插件。
*   QuickWebMJRefreshPlugin(MJRefresh 插件) - 基于 MJRefresh 下拉刷新的插件。
*   QuickWebJSBridgePlugin(JSBridge 插件) - 基于 JS 与 Native 交互的插件，已实现多个 proxies, 详见 CoreProxies 和 ExtProxies 目录。
   
   将持续更新......

## 演示 / Demo

<p align="center"><img src="https://github.com/pcjbird/QuickWebKit/raw/master/demo.png" title="demo"></p>

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

## 版本 / Releases

####   2025-09-17 V2.0.6
![](https://avatars3.githubusercontent.com/u/6175452?s=16) **pcjbird** released build202509170001
> 1.新增属性设置 iOS26 及之后版本是否使用液态玻璃效果。

####   2022-06-17 V2.0.5
![](https://avatars3.githubusercontent.com/u/6175452?s=16) **pcjbird** released build202206170001
> 1.修正 webview 标题在某些情况下加载不了的问题。
> 
####   2020-06-11 V2.0.4
![](https://avatars3.githubusercontent.com/u/6175452?s=16) **pcjbird** released build202006110001
> 1.新增日语翻译。

####   2020-06-10 V2.0.3
![](https://avatars3.githubusercontent.com/u/6175452?s=16) **pcjbird** released build202006100001
> 1.修正 Bundle 中其他语言翻译的问题。

####   2020-05-07 V2.0.2
![](https://avatars3.githubusercontent.com/u/6175452?s=16) **pcjbird** released build202005070002
> 1.调整回调日志的内容。


####   2020-05-07 V2.0.1
![](https://avatars3.githubusercontent.com/u/6175452?s=16) **pcjbird** released build202005070001
> 1.新增浏览器控制台打印 JS 方法。

####   2020-03-02 V2.0.0
![](https://avatars3.githubusercontent.com/u/6175452?s=16) **pcjbird** released build202003020001
> 1.remove UIWebView。

####   2019-04-03 V1.3.5
![](https://avatars3.githubusercontent.com/u/6175452?s=16) **pcjbird** released build201904030001
> 1.build as static library bug fixed。

####   2018-10-27 V1.3.4
![](https://avatars3.githubusercontent.com/u/6175452?s=16) **pcjbird** released build201810270001
> 1.try fix some crash bugs。

####   2018-09-29 V1.3.3
![](https://avatars3.githubusercontent.com/u/6175452?s=16) **pcjbird** released build201809290001
> 1.恢复 QuickWebLNRefreshPlugin。

####   2018-09-18 V1.3.2
![](https://avatars3.githubusercontent.com/u/6175452?s=16) **pcjbird** released build201809180001
> 1.XCode 10 support。

####   2018-08-30 V1.3.1
![](https://avatars3.githubusercontent.com/u/6175452?s=16) **pcjbird** released build201808300001
> 1.remove some build warnings。

####   2018-08-17 V1.3.0
![](https://avatars3.githubusercontent.com/u/6175452?s=16) **pcjbird** released build201808170001
> 1.新增导航栏按钮颜色偏好设置。

####   2018-06-20 V1.2.9
![](https://avatars3.githubusercontent.com/u/6175452?s=16) **pcjbird** released build201806200001
> 1.兼容 ZFPlayer 最新版本。

####   2018-04-10 V1.2.8
![](https://avatars3.githubusercontent.com/u/6175452?s=16) **pcjbird** released build201804100001
> 1.插件新增 didCreateJavaScriptContext 回调代理。
    
####   2018-03-26 V1.2.7
![](https://avatars3.githubusercontent.com/u/6175452?s=16) **pcjbird** released build201803260001
> 1.修改分享内容 description 长度限制，取消空格替换 (因为英文描述会有 bug)。

####   2018-03-21 V1.2.6
![](https://avatars3.githubusercontent.com/u/6175452?s=16) **pcjbird** released build201803210002
> 1.放弃修改弹出菜单 icon 图片前景色。

####   2018-03-21 V1.2.5
![](https://avatars3.githubusercontent.com/u/6175452?s=16) **pcjbird** released build201803210001
> 1.修复导航设置网络图片失真的问题。        
> 2.控制设置导航标题为网络图片的显示大小。

####   2018-03-20 V1.2.4
![](https://avatars3.githubusercontent.com/u/6175452?s=16) **pcjbird** released build201803200002
> 1.修复设置导航 title 为网络图片时显示的大小问题。    
> 2.支持项目通过 YPNavigationBarTransition 修改导航背景色。

####   2018-03-20 V1.2.3
![](https://avatars3.githubusercontent.com/u/6175452?s=16) **pcjbird** released build201803200001
> 1.修复点击导航右侧按钮没有回调的问题。    
> 2.修复分享插件总是显示更多按钮的 BUG。   
> 3.修改导航弹出菜单样式。   
> 4.修改导航右侧按钮顺序。      

####   2018-03-15 V1.2.2
![](https://avatars3.githubusercontent.com/u/6175452?s=16) **pcjbird** released build201803150001
> 1.QuickWebJSBridgeContactProxy: 新增一些浏览器控制台调试日志。

####   2018-03-14 V1.2.1
![](https://avatars3.githubusercontent.com/u/6175452?s=16) **pcjbird** released build201803140003
> 1.新增一些浏览器控制台调试日志。

####   2018-03-14 V1.2.0
![](https://avatars3.githubusercontent.com/u/6175452?s=16) **pcjbird** released build201803140002
> 1.修复 JS 插件 system proxy 部分接口无法调用的问题。

####   2018-03-14 V1.1.9
![](https://avatars3.githubusercontent.com/u/6175452?s=16) **pcjbird** released build201803140001
> 1.修复模糊查找联系人的 BUG。

####   2018-03-10 V1.1.8
![](https://avatars3.githubusercontent.com/u/6175452?s=16) **pcjbird** released build201803100002
> 1.新增支持自定义 QuickWebJSBridgePlugin JavascriptInterface 名称以及异步回调结果 Ready 回调通知的 javscript 函数。

####   2018-03-10 V1.1.7
![](https://avatars3.githubusercontent.com/u/6175452?s=16) **pcjbird** released build201803100001
> 1.新增白名单功能。

####   2018-02-20 V1.1.6
![](https://avatars3.githubusercontent.com/u/6175452?s=16) **pcjbird** released build201802200001
> 1.修复当网页加载到一半返回，仍然显示 NetworkActivityIndicator 的问题。    
> 2.修改注册和移除通知观察者函数名，防止被继承类复写，导致 BUG 排查困难的问题。

####   2018-02-02 V1.1.5
![](https://avatars3.githubusercontent.com/u/6175452?s=16) **pcjbird** released build201802020001
> 1.修改 JSProxy 引用头文件大小写问题。

####   2018-01-16 V1.1.4 
![](https://avatars3.githubusercontent.com/u/6175452?s=16) **pcjbird** released build201801160002
> 1.修改 QuickWebSpotlightPlugin 导致 crash 的 BUG。

####   2018-01-16 V1.1.3 
![](https://avatars3.githubusercontent.com/u/6175452?s=16) **pcjbird** released build201801160001
> 1.修改 toast 样式为共享样式。

####   2018-01-14 V1.1.2 
![](https://avatars3.githubusercontent.com/u/6175452?s=16) **pcjbird** released build201801140001
> 1.修复 QuickWebSpotlightPlugin 无法处理 Spotlight 搜索点击结果的 BUG。

####   2018-01-10 V1.1.1 
![](https://avatars3.githubusercontent.com/u/6175452?s=16) **pcjbird** released build201801100001
> 1.修复 QuickWebSharePlugin 无法显示导航栏右侧分享按钮的 BUG。

####   2018-01-09 V1.1.0 
![](https://avatars3.githubusercontent.com/u/6175452?s=16) **pcjbird** released build201801090004
> 1.修复 QuickWebQRCodePlugin 链接检测到却无法打开的 BUG。

####   2018-01-09 V1.0.9 
![](https://avatars3.githubusercontent.com/u/6175452?s=16) **pcjbird** released build201801090003
> 1.修复 QuickWebQRCodePlugin 手势导致不能复制网页文本的 BUG。

####   2018-01-09 V1.0.8 
![](https://avatars3.githubusercontent.com/u/6175452?s=16) **pcjbird** released build201801090002
> 1.优化 QuickWebQRCodePlugin 插件手势。    
> 2.修复 QuickWebQRCodePlugin 本地化错误。

####   2018-01-09 V1.0.7 
![](https://avatars3.githubusercontent.com/u/6175452?s=16) **pcjbird** released build201801090001
> 1.优化当作为 navigationController 的根视图时的显示问题。

####   2018-01-06 V1.0.6 
![](https://avatars3.githubusercontent.com/u/6175452?s=16) **pcjbird** released build201801060001
> 1.修复 Share 插件与 Spotlight 插件导致 Crash 的问题。

####   2018-01-05 V1.0.5 
![](https://avatars3.githubusercontent.com/u/6175452?s=16) **pcjbird** released build201801050001
> 1.修复当 UINavigationBar 的 translucent 为 No 时的显示问题。

####   2018-01-04 V1.0.4 
![](https://avatars3.githubusercontent.com/u/6175452?s=16) **pcjbird** released build201801040001
> 1.新增 Spotlight 插件

####   2018-01-02 V1.0.3
![](https://avatars3.githubusercontent.com/u/6175452?s=16) **pcjbird** released build201801020003
> 1.新增 LNRefresh 和 MJRefresh 插件    
> 2.新增是否优先使用 WKWebView 初始化函数

####   2018-01-02 V1.0.2
![](https://avatars3.githubusercontent.com/u/6175452?s=16) **pcjbird** released build201801020002
> 1.修复 QuickWebProviderPlugin 字体颜色的问题

####   2018-01-02 V1.0.1
![](https://avatars3.githubusercontent.com/u/6175452?s=16) **pcjbird** released build201801020001
> 1.修复 dealloc 中使用了 weak 导致的 crash 问题

####   2017-12-24 V1.0.0
![](https://avatars3.githubusercontent.com/u/6175452?s=16) **pcjbird** released build201712240001
> 1.首次发布 SDK 版本
    
## 关注我们 / Follow us
  
<a href="https://itunes.apple.com/cn/app/iclock-一款满足-挑剔-的翻页时钟与任务闹钟/id1128196970?pt=117947806&ct=com.github.pcjbird.QuickWebViewController&mt=8"><img src="https://github.com/pcjbird/AssetsExtractor/raw/master/iClock.gif" width="400" title="iClock - 一款满足“挑剔”的翻页时钟与任务闹钟"></a>

[![Twitter URL](https://img.shields.io/twitter/url/http/shields.io.svg?style=social)](https://twitter.com/intent/tweet?text=https://github.com/pcjbird/QuickWebViewController)
[![Twitter Follow](https://img.shields.io/twitter/follow/pcjbird.svg?style=social)](https://twitter.com/pcjbird)
