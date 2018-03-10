//
//  QuickWebJSBridgePlugin.h
//  QuickWebKit
//
//  Created by pcjbird on 2017/12/24.
//  Copyright © 2017年 Zero Status. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QuickWebPluginProtocol.h"
#import "QuickWebJSInvokeResultHandlerProtocol.h"
#import "QuickWebViewController.h"
#import "QuickWebJSBridgeProxyProtocol.h"

/*
 * @brief Javascript Bridge 插件
 */
@interface QuickWebJSBridgePlugin : NSObject<QuickWebPluginProtocol,QuickWebJSInvokeResultHandlerProtocol, SmartJSBridgeProtocol>

/*
 * @brief 单例
 */
+ (QuickWebJSBridgePlugin *) sharedPlugin;


- (NSString*)exec:(NSString*)secretId :(NSString*)service :(NSString*)action :(NSString*)callbackId :(NSString*)args;
- (NSString*)retrieve:(NSString*)secretId;

/*
 * @brief JavascriptInterface 名称, 默认为 "_quickWebMobileNative", 若项目需要自定义, 继承该插件并实现该方法
 * @return JavascriptInterface 名称, 不能为空。
 */
- (NSString*) javascriptInterfaceName;
/*
 * @brief JavascriptInterface 异步调用结果Ready回调函数, 默认为 "_onQuickWebMobileNative();", 若项目需要自定义, 继承该插件并实现该方法
 * @return 回调函数字符串, 不能为空。
 */
- (NSString*) javascriptMethodCallbackReady;

/*
 * @brief 注册代理
 * @param proxy 代理
 */
- (void)registerProxy:(id<QuickWebJSBridgeProxyProtocol>)proxy;
@end
