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
 * @remark 如果项目需要继承该类，请务必在子类中实现exec和retrieve方法,其实现直接调用父类的exec和retrieve方法,如果子类没有实现这两个方法，将无法暴露给H5调用。
 */
@interface QuickWebJSBridgePlugin : NSObject<QuickWebPluginProtocol,QuickWebJSInvokeResultHandlerProtocol, SmartJSBridgeProtocol>

/*
 * @brief 单例
 */
+ (QuickWebJSBridgePlugin *) sharedPlugin;


/**
 * @brief 调用本地（Native）方法。
 * @param secretId 秘钥，同一个 WebView 拥有相同全球唯一的秘钥。
 * @param service 服务名称（模块）, 用于将调用功能进行分类，可以将不同的功能分类到系统模块、账号模块、分享模块等， 例如"system","account","share"等。
 * @param action 服务模块下的子功能行为编号， 例如系统模块下的“复制到剪贴板”这样一个功能，我们可以将其行为编号定义为100
 * @param callbackId 回调Id （回调id为每次请求生成的串码，位数无要求，主要作为js端回调时使用）, 最终会包含在回调结果中，JS根据这个确定是哪一个调用行为的调用结果
 * @param args H5调用native方法时传入的参数，请求参数必须为jsonobj，其中具体key和value，几参数的个数，由具体协议定义。例如：{"content":"通过plugin打印我"}
 * @return 请求为异步请求时，调用是否成功，成功返回 TRUE，失败返回 FALSE；请求为同步请求时，可根据具体协议返回同步调用结果（格式同异步请求调用结果格式，
 *         参照“H5取回调用结果”部分）。
 */
- (NSString*)exec:(NSString*)secretId :(NSString*)service :(NSString*)action :(NSString*)callbackId :(NSString*)args;

/**
 * @brief H5取回调用结果。（取回是一个调用结果数组，当前 WebView 的未取回的所有调用结果）
 * @param secretId 秘钥，同一个 WebView 拥有相同全球唯一的秘钥。
 * @return 调用结果数组
 *          [{"callbackId":"9028","result":"WIFI","status":"SUCCESS"}, ...]
 *           callbackId 请求时传递的回调id
 *           status 表示请求是否成功   "SUCCESS"表示成功，"FAIL"表示失败。
 *           result 调用请求返回的结果，格式为jsonObject，其中具体的参数规则需要参见每个对应的请求结果, 由具体协议定义。
 *           如果有多个调用结果，则数组包含多个调用结果字典数据，否则只有一个。
 */
- (NSString*)retrieve:(NSString*)secretId;

/*
 * @brief JavascriptInterface 名称, 默认为 "_quickWebMobileNative", 若项目需要自定义, 继承该插件并实现该方法
 * @remark 如果项目需要继承该类，请务必在子类中实现exec和retrieve方法,其实现直接调用父类的exec和retrieve方法,如果子类没有实现这两个方法，将无法暴露给H5调用。
 * @return JavascriptInterface 名称, 不能为空。
 */
- (NSString*) javascriptInterfaceName;
/*
 * @brief JavascriptInterface 异步调用结果Ready回调函数, 默认为 "_onQuickWebMobileNative();", 若项目需要自定义, 继承该插件并实现该方法
 * @remark 如果项目需要继承该类，请务必在子类中实现exec和retrieve方法,其实现直接调用父类的exec和retrieve方法,如果子类没有实现这两个方法，将无法暴露给H5调用。
 * @return 回调函数字符串, 不能为空。
 */
- (NSString*) javascriptMethodCallbackReady;

/*
 * @brief 注册代理
 * @param proxy 代理
 */
- (void)registerProxy:(id<QuickWebJSBridgeProxyProtocol>)proxy;
@end
