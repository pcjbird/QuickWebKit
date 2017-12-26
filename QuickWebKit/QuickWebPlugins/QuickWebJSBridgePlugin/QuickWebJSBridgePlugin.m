//
//  QuickWebJSBridgePlugin.m
//  QuickWebKit
//
//  Created by pcjbird on 2017/12/24.
//  Copyright © 2017年 Zero Status. All rights reserved.
//

#import "QuickWebJSBridgePlugin.h"
#import "QuickWebStringUtil.h"
#import "QuickWebKitDefines.h"
#import <Toast/Toast.h>

@interface QuickWebJSBridgePlugin()
{
    NSMutableDictionary *_webViewMap;
    NSMutableDictionary *_proxyMap;
    NSMutableDictionary *_resultMap;
}
@end

@implementation QuickWebJSBridgePlugin

static QuickWebJSBridgePlugin *_sharedPlugin = nil;

+ (QuickWebJSBridgePlugin *) sharedPlugin
{
    static dispatch_once_t onceToken;
    dispatch_block_t block = ^{
        if(!_sharedPlugin)
        {
            _sharedPlugin = [QuickWebJSBridgePlugin new];
        }
    };
    if ([NSThread isMainThread])
    {
        dispatch_once(&onceToken, block);
    }
    else
    {
        dispatch_sync(dispatch_get_main_queue(), ^{
            dispatch_once(&onceToken, block);
        });
    }
    return _sharedPlugin;
}

-(instancetype)init
{
    if(self = [super init])
    {
        _webViewMap = [NSMutableDictionary dictionary];
        _proxyMap = [NSMutableDictionary dictionary];
        _resultMap = [NSMutableDictionary dictionary];
    }
    return self;
}

#pragma mark - QuickWebPluginProtocol

-(NSString *)name
{
    return @"QuickWebJSBridgePlugin";
}

-(void)setName:(NSString *)name
{
    
}

-(void)webViewControllerDidWebViewCreated:(QuickWebViewController *)webViewController
{
    weak(weakSelf);
    [webViewController.webView addJavascriptInterfaces:weakSelf WithName:@"_quickWebMobileNative"];
}

#pragma mark - SmartJSBridgeProtocol

-(void)registerWebView:(SmartJSWebView *)webView
{
    if([webView isKindOfClass:[SmartJSWebView class]] && ![QuickWebStringUtil isStringBlank:webView.secretId])
    {
        __weak typeof(SmartJSWebView*) weakWebView = webView;
        [_webViewMap setObject:weakWebView forKey:webView.secretId];
    }
}

-(id)getSmartJSWebViewBySecretId:(NSString *)secretId
{
    if(![QuickWebStringUtil isStringBlank:secretId])
    {
        return [_webViewMap objectForKey:secretId];
    }
    return nil;
}

#pragma mark - JS Interface
- (NSString*)exec:(NSString*)secretId :(NSString*)service :(NSString*)action :(NSString*)callbackId :(NSString*)args
{
    if(![service isKindOfClass:[NSString class]]) return NSStringFromBOOL(FALSE);
    id<QuickWebJSBridgeProxyProtocol> proxy = [_proxyMap objectForKey:service];
    weak(weakSelf);
    if(![proxy conformsToProtocol:@protocol(QuickWebJSBridgeProxyProtocol)])
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            SmartJSWebView *webView = [weakSelf getSmartJSWebViewBySecretId:secretId];
            if([webView isKindOfClass:[SmartJSWebView class]])
            {
                [webView makeToast:QuickWebJSBridgeProxyNotFound(service) duration:3.0f position:CSToastPositionTop];
            }
        });
        return NSStringFromBOOL(FALSE);
    }
    QuickWebJSBridgeInvokeCommand *command = [QuickWebJSBridgeInvokeCommand commandFromSecretId:secretId callbackId:callbackId jsonArgs:args];
    
    return [proxy callAction:action command:command callback:^(QuickWebJSInvokeResult *result) {
        
        if(![result isKindOfClass:[QuickWebJSInvokeResult class]]) return;
        
        SmartJSWebView *webView = [weakSelf getSmartJSWebViewBySecretId:result.secretId];
        
        NSMutableArray *cacheResults = [_resultMap objectForKey:result.secretId];
        if(![cacheResults isKindOfClass:[NSArray class]])
        {
            cacheResults= [NSMutableArray array];
        }
        [cacheResults addObject:result.results];
        [_resultMap setObject:cacheResults forKey:result.secretId];
        
        if([webView isKindOfClass:[SmartJSWebView class]])
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [webView evaluateJavaScript:@"_onQuickWebMobileNative();" completionHandler:nil];
            });
        }
    }];
}


- (NSString*)retrieve:(NSString*)secretId
{
    NSArray *results = [_resultMap objectForKey:secretId];
    if([results isKindOfClass:[NSArray class]])
    {
        NSString* res = [results componentsJoinedByString:@","];
        res = [NSString stringWithFormat:@"[%@]",res];
        [_resultMap removeObjectForKey:secretId];
        return res;
    }
    
    return @"";
}
#pragma mark - QuickWebJSInvokeResultHandlerProtocol
-(void)handleQuickWebJSInvokeResult:(QuickWebJSInvokeResult *)result
{
    if(![result isKindOfClass:[QuickWebJSInvokeResult class]]) return;
    
    SmartJSWebView *webView = [self getSmartJSWebViewBySecretId:result.secretId];
    NSMutableArray *cacheResults = [_resultMap objectForKey:result.secretId];
    if(![cacheResults isKindOfClass:[NSArray class]])
    {
        cacheResults= [NSMutableArray array];
    }
    [cacheResults addObject:result.results];
    [_resultMap setObject:cacheResults forKey:result.secretId];
    
    if([webView isKindOfClass:[SmartJSWebView class]])
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [webView evaluateJavaScript:@"_onQuickWebMobileNative();" completionHandler:nil];
        });
    }
    
}

#pragma mark - 注册Proxy
- (void)registerProxy:(id<QuickWebJSBridgeProxyProtocol>)proxy
{
    if(![proxy conformsToProtocol:@protocol(QuickWebJSBridgeProxyProtocol)])
    {
        SDK_LOG(@"注册服务失败，请确保您的服务实现了QuickWebServiceProtocol协议。");
        return;
    }
    if([QuickWebStringUtil isStringBlank:proxy.name])
    {
        SDK_LOG(@"注册服务失败，服务名不能为空。");
        return;
    }
    if([_proxyMap objectForKey:proxy.name])
    {
        SDK_LOG(@"注册服务失败，服务'%@'已经存在。", proxy.name);
        return;
    }
    [_proxyMap setObject:proxy forKey:proxy.name];
}



@end
