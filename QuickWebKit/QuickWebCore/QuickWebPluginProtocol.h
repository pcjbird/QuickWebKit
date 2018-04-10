//
//  QuickWebPluginProtocol.h
//  QuickWebKit
//
//  Created by pcjbird on 2017/12/23.
//  Copyright © 2017年 Zero Status. All rights reserved.
//

#ifndef QuickWebPluginProtocol_h
#define QuickWebPluginProtocol_h
#import <JavaScriptCore/JavaScriptCore.h>

//插件请求更新UI通知 notification.object 为WebView的secretId
#define QUICKWEBPLUGINREQUESTUPDATEUINOTIFICATION @"QuickWebPluginRequestUpdateUINotification"

@class UIBarButtonItem;
@class QuickWebViewController;
/*
 * @brief 浏览器插件协议
 */
@protocol QuickWebPluginProtocol<NSObject>

/*
 * @brief 插件名称
 */
@property(nonatomic, strong) NSString* name;

@optional
/*
 * @brief webView创建完成
 * @param webViewController 浏览器控制器
 */
-(void)webViewControllerDidWebViewCreated:(QuickWebViewController*)webViewController;

/*
 * @brief webView请求设置导航右侧BarButtonItems
 * @param webViewController 浏览器控制器
 * @return 返回给webViewController当前插件的UIBarButtonItem列表
 */
-(NSArray<UIBarButtonItem *>*)webViewControllerRequestRightBarButtonItems:(QuickWebViewController*)webViewController;

/*
 * @brief webView注册通知观察者完成
 * @param webViewController 浏览器控制器
 */
-(void)webViewControllerDidRegisterNotificationObserver:(QuickWebViewController*)webViewController;

/*
 * @brief webView移除通知观察者完成
 * @param webViewController 浏览器控制器
 */
-(void)webViewControllerDidRemoveNotificationObserver:(QuickWebViewController*)webViewController;

/*
 * @brief 完成子视图布局
 * @param webViewController 浏览器控制器
 */
-(void)webViewControllerDidLayoutSubviews:(QuickWebViewController*)webViewController;

/*
 * @brief 开始加载
 * @param webViewController 浏览器控制器
 */
-(void)webViewControllerDidStartLoad:(QuickWebViewController*)webViewController;

/*
 * @brief 加载完成
 * @param webViewController 浏览器控制器
 */
-(void)webViewControllerDidFinishLoad:(QuickWebViewController*)webViewController;

/*
 * @brief 加载发生错误
 * @param webViewController 浏览器控制器
 * @param error 错误信息
 */
-(void)webViewController:(QuickWebViewController*)webViewController didFailLoadWithError:(NSError *)error;

/*
 * @brief 创建JSContext
 * @param webViewController 浏览器控制器
 * @param jsContext jsContext
 */
-(void)webViewController:(QuickWebViewController*)webViewController didCreateJavaScriptContext:(JSContext*) jsContext;

@end


#endif /* QuickWebPluginProtocol_h */
