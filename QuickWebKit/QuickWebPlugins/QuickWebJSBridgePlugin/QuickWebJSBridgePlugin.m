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
    NSMutableDictionary *_serviceMap;
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
        _serviceMap = [NSMutableDictionary dictionary];
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
    id<QuickWebServiceProtocol> servicePlugin = [_serviceMap objectForKey:service];
    weak(weakSelf);
    if(![servicePlugin conformsToProtocol:@protocol(QuickWebServiceProtocol)])
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            SmartJSWebView *webView = [weakSelf getSmartJSWebViewBySecretId:secretId];
            if([webView isKindOfClass:[SmartJSWebView class]])
            {
                [webView makeToast:QuickWebServiceNotFound(service) duration:3.0f position:CSToastPositionTop];
            }
        });
        return NSStringFromBOOL(FALSE);
    }
    QuickWebInvokedCommand *command = [QuickWebInvokedCommand commandFromSecretId:secretId callbackId:callbackId jsonArgs:args];
    
    return [servicePlugin callAction:action command:command callback:^(QuickWebServiceInvokeResult *result) {
        if(![result isKindOfClass:[QuickWebServiceInvokeResult class]]) return;
        
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

#pragma mark - Service
- (void)registerService:(id<QuickWebServiceProtocol>)service
{
    if(![service conformsToProtocol:@protocol(QuickWebServiceProtocol)])
    {
        SDK_LOG(@"注册服务失败，请确保您的服务实现了QuickWebServiceProtocol协议。");
        return;
    }
    if([QuickWebStringUtil isStringBlank:service.name])
    {
        SDK_LOG(@"注册服务失败，服务名不能为空。");
        return;
    }
    if([_serviceMap objectForKey:service.name])
    {
        SDK_LOG(@"注册服务失败，服务'%@'已经存在。", service.name);
        return;
    }
    [_serviceMap setObject:service forKey:service.name];
}

- (void) sendServiceResult:(QuickWebServiceInvokeResult*)result
{
    if(![result isKindOfClass:[QuickWebServiceInvokeResult class]]) return;
    
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

@end
