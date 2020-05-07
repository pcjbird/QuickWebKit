//
//  QuickWebJSBridgeSystemProxy.m
//  QuickWebKit
//
//  Created by pcjbird on 2017/12/27.
//  Copyright © 2017年 Zero Status. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "QuickWebJSBridgeSystemProxy.h"
#import "QuickWebStringUtil.h"
#import "QuickWebDataParseUtil.h"
#import "QuickWebJSInvokeCommand.h"
#import "QuickWebKit.h"

#define APP_NAME ([[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"CFBundleDisplayName"] ? [[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"CFBundleDisplayName"]:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"])
#define WEB_LOG_STRING(format, ...) [NSString stringWithFormat:@"[🦉%@] %s (line %d) " format, APP_NAME, __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__]

@interface QuickWebJSBridgeSystemProxy()
{
    NSString * _name;
    NSDateFormatter* _datetimeFormatter;
}

@property(nonatomic, weak) id<QuickWebJSInvokeResultHandlerProtocol, SmartJSBridgeProtocol> resultHandler;
@end

@implementation QuickWebJSBridgeSystemProxy

-(NSString *)name
{
    return [QuickWebStringUtil isStringBlank:_name] ? @"system" : _name;
}

-(void)setName:(NSString *)name
{
    _name = name;
}

-(id)initWithResultHandler:(id<QuickWebJSInvokeResultHandlerProtocol, SmartJSBridgeProtocol>)handler
{
    if(self = [super init])
    {
        _resultHandler = handler;
        _datetimeFormatter = [[NSDateFormatter alloc] init];
        _datetimeFormatter.timeZone = [NSTimeZone systemTimeZone];
        _datetimeFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss.SSS";
        _datetimeFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    }
    return self;
}

-(NSString*)callAction:(NSString*)actionId command:(QuickWebJSBridgeInvokeCommand*)command callback:(QuickWebJSCallBack)callback
{
    if([actionId isEqualToString:@"100"])
    {
        return [self copyToClipBoard:command callback:callback];
    }
    else if([actionId isEqualToString:@"101"])
    {
        return [self dial:command callback:callback];
    }
    else if([actionId isEqualToString:@"102"])
    {
        return [self getDeviceInfo:command callback:callback];
    }
    else if([actionId isEqualToString:@"103"])
    {
        return [self getNetStatus:command callback:callback];
    }
    else if([actionId isEqualToString:@"104"])
    {
        return [self webViewGoBack:command callback:callback];
    }
    else if([actionId isEqualToString:@"105"])
    {
        return [self webViewClose:command callback:callback];
    }
    else if([actionId isEqualToString:@"106"])
    {
        return [self listenWebViewPauseResumeEvent:command callback:callback];
    }
    else if([actionId isEqualToString:@"107"])
    {
        return [self openInSafari:command callback:callback];
    }
    else if([actionId isEqualToString:@"108"])
    {
        return [self openInNewWindow:command callback:callback];
    }
    else if([actionId isEqualToString:@"109"])
    {
        return [self alert:command callback:callback];
    }
    else if([actionId isEqualToString:@"110"])
    {
        return [self log:command callback:callback];
    }
    else
    {
        if([command.webView isKindOfClass:[SmartJSWebView class]])
        {
            NSString *warning = [NSString stringWithFormat:@"无效的JS调用(service=\"%@\", action=\"%@\")。", [self name], actionId];
            [command.webView tracewarning:warning];
        }
    }
    return NSStringFromBOOL(FALSE);
}


-(NSString*)copyToClipBoard:(QuickWebJSBridgeInvokeCommand*)command callback:(QuickWebJSCallBack)callback
{
    if(![command isKindOfClass:[QuickWebJSBridgeInvokeCommand class]])
    {
        return NSStringFromBOOL(FALSE);
    }
    NSDictionary* args = command.arguments;
    if(![args isKindOfClass:[NSDictionary class]])
    {
        return NSStringFromBOOL(FALSE);
    }
    NSString *text = [args objectForKey:@"content"];
    if([QuickWebStringUtil isStringBlank:text])
    {
        return NSStringFromBOOL(FALSE);
    }
    [[UIPasteboard generalPasteboard] setString:text];
    
    return NSStringFromBOOL(TRUE);
}

-(NSString*)dial:(QuickWebJSBridgeInvokeCommand*)command callback:(QuickWebJSCallBack)callback
{
    if(![command isKindOfClass:[QuickWebJSBridgeInvokeCommand class]])
    {
        return NSStringFromBOOL(FALSE);
    }
    NSDictionary* args = command.arguments;
    if(![args isKindOfClass:[NSDictionary class]])
    {
        return NSStringFromBOOL(FALSE);
    }
    NSString *text = [args objectForKey:@"content"];
    if([QuickWebStringUtil isStringBlank:text])
    {
        return NSStringFromBOOL(FALSE);
    }
    NSString *number = [NSString stringWithFormat:@"tel://%@",text];
    __block BOOL bResult = FALSE;
    if([NSThread isMainThread])
    {
        bResult = [[UIApplication sharedApplication] openURL:[NSURL URLWithString:number]];
    }
    else
    {
        dispatch_sync(dispatch_get_main_queue(), ^{
            bResult = [[UIApplication sharedApplication] openURL:[NSURL URLWithString:number]];
        });
    }
    
    return NSStringFromBOOL(bResult);
    
}

-(NSString*)getDeviceInfo:(QuickWebJSBridgeInvokeCommand*)command callback:(QuickWebJSCallBack)callback
{
    if(![command isKindOfClass:[QuickWebJSBridgeInvokeCommand class]])
    {
        return NSStringFromBOOL(FALSE);
    }
    
    NSDictionary *deviceDict = [self deviceInfoDictionary];
    QuickWebJSInvokeResult *result = [QuickWebJSInvokeResult resultWithStatus:YES secretId:command.secretId callbackId:command.callbackId resultWithDict:deviceDict];
    return [result asJsonArray];
}

-(NSDictionary *)deviceInfoDictionary
{
    NSMutableDictionary *deviceDict = [NSMutableDictionary dictionary];
    UIDevice *device = [UIDevice currentDevice];
    [deviceDict setObject:device.model forKey:@"deviceModel"];
    [deviceDict setObject:device.systemVersion forKey:@"systemVersion"];
    return [deviceDict copy];
}

-(NSString*)getNetStatus:(QuickWebJSBridgeInvokeCommand*)command callback:(QuickWebJSCallBack)callback
{
    if(![command isKindOfClass:[QuickWebJSBridgeInvokeCommand class]])
    {
        return NSStringFromBOOL(FALSE);
    }
    
    NSString *res = [self netStatus];
    QuickWebJSInvokeResult *pluginResult = [QuickWebJSInvokeResult resultWithStatus:YES secretId:command.secretId callbackId:command.callbackId resultWithString:res];
    return [pluginResult asJsonArray];
}

-(NSString*) netStatus
{
    return @"UNKNOWN";
}

-(NSString*)webViewGoBack:(QuickWebJSBridgeInvokeCommand*)command callback:(QuickWebJSCallBack)callback
{
    if(![command isKindOfClass:[QuickWebJSBridgeInvokeCommand class]])
    {
        return NSStringFromBOOL(FALSE);
    }
    __block QuickWebJSInvokeCommand *jsCommand = [QuickWebJSInvokeCommand commandWithSecretId:command.secretId callbackId:command.callbackId provider:@"MasterProvider" actionId:@"100" param:nil resultHandler:self.resultHandler];
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:QUICKWEBJSINVOKENOTIFICATION object:jsCommand];
    });
    return NSStringFromBOOL(TRUE);
}

-(NSString*)webViewClose:(QuickWebJSBridgeInvokeCommand*)command callback:(QuickWebJSCallBack)callback
{
    if(![command isKindOfClass:[QuickWebJSBridgeInvokeCommand class]])
    {
        return NSStringFromBOOL(FALSE);
    }
    __block QuickWebJSInvokeCommand *jsCommand = [QuickWebJSInvokeCommand commandWithSecretId:command.secretId callbackId:command.callbackId provider:@"MasterProvider" actionId:@"101" param:nil resultHandler:self.resultHandler];
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:QUICKWEBJSINVOKENOTIFICATION object:jsCommand];
    });
    return NSStringFromBOOL(TRUE);
}

-(NSString*)listenWebViewPauseResumeEvent:(QuickWebJSBridgeInvokeCommand*)command callback:(QuickWebJSCallBack)callback
{
    if(![command isKindOfClass:[QuickWebJSBridgeInvokeCommand class]])
    {
        return NSStringFromBOOL(FALSE);
    }
    __block QuickWebJSInvokeCommand *jsCommand = [QuickWebJSInvokeCommand commandWithSecretId:command.secretId callbackId:command.callbackId  provider:@"MasterProvider" actionId:@"102" param:nil resultHandler:self.resultHandler];
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:QUICKWEBJSINVOKENOTIFICATION object:jsCommand];
    });
    return NSStringFromBOOL(TRUE);
}

-(NSString*)openInSafari:(QuickWebJSBridgeInvokeCommand*)command callback:(QuickWebJSCallBack)callback
{
    if(![command isKindOfClass:[QuickWebJSBridgeInvokeCommand class]])
    {
        return NSStringFromBOOL(FALSE);
    }
    NSDictionary* args = command.arguments;
    if(![args isKindOfClass:[NSDictionary class]])
    {
        return NSStringFromBOOL(FALSE);
    }
    
    NSString *text = [args objectForKey:@"url"];
    if([QuickWebStringUtil isStringBlank:text])
    {
        return NSStringFromBOOL(FALSE);
    }
    
    NSRange schemeSepRange = [text rangeOfString:@"://"];
    if(schemeSepRange.length == 0)
    {
        text = [@"https://" stringByAppendingString:text];
    }
    
    if([QuickWebStringUtil isStringHasChineseCharacter:text])
    {
        text = [text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }
     dispatch_async(dispatch_get_main_queue(), ^{
         [[UIApplication sharedApplication] openURL:[NSURL URLWithString:text]];
     });
    return NSStringFromBOOL(TRUE);
}

-(NSString*)openInNewWindow:(QuickWebJSBridgeInvokeCommand*)command callback:(QuickWebJSCallBack)callback
{
    if(![command isKindOfClass:[QuickWebJSBridgeInvokeCommand class]])
    {
        return NSStringFromBOOL(FALSE);
    }
    NSDictionary* args = command.arguments;
    if(![args isKindOfClass:[NSDictionary class]])
    {
        return NSStringFromBOOL(FALSE);
    }
    
    NSString *text = [args objectForKey:@"url"];
    if([QuickWebStringUtil isStringBlank:text])
    {
        return NSStringFromBOOL(FALSE);
    }
    
    NSRange schemeSepRange = [text rangeOfString:@"://"];
    if(schemeSepRange.length == 0)
    {
        text = [@"https://" stringByAppendingString:text];
    }
    
    if([QuickWebStringUtil isStringHasChineseCharacter:text])
    {
        text = [text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:QUICKWEBREQUESTURLHANDLERNOTIFICATION object:text];
    });
    return NSStringFromBOOL(TRUE);
}


- (NSString*)alert:(QuickWebJSBridgeInvokeCommand *)command callback:(QuickWebJSCallBack)callback
{
    if(![command isKindOfClass:[QuickWebJSBridgeInvokeCommand class]])
    {
        return NSStringFromBOOL(FALSE);
    }
    NSDictionary* args = command.arguments;
    if(![args isKindOfClass:[NSDictionary class]])
    {
        return NSStringFromBOOL(FALSE);
    }
    
    NSString* title = [QuickWebDataParseUtil getDataAsString:[args objectForKey:@"title"]];
    NSString* content = [QuickWebDataParseUtil getDataAsString:[args objectForKey:@"content"]];
    NSString* confirm = [QuickWebDataParseUtil getDataAsString:[args objectForKey:@"confirm_title"]];
    
    
    if(![QuickWebStringUtil isStringBlank:content])
    {
        NSString* alert_url = [NSString stringWithFormat:@"quickwebalert://?content=%@", content];
        if(![QuickWebStringUtil isStringBlank:title]) alert_url = [alert_url stringByAppendingString:[NSString stringWithFormat:@"&title=%@", title]];
        if(![QuickWebStringUtil isStringBlank:confirm]) alert_url = [alert_url stringByAppendingString:[NSString stringWithFormat:@"&confirm_title=%@", confirm]];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:QUICKWEBREQUESTURLHANDLERNOTIFICATION object:alert_url];
        });
    }
    else
    {
        return NSStringFromBOOL(FALSE);
    }
    return NSStringFromBOOL(TRUE);
}

-(void) onConsoleLog:(NSString*)log level:(QUICKWEBKITCONSOLELOGLEVEL)level result:(BOOL)invokeSucceed
{
    
}

- (NSString*)log:(QuickWebJSBridgeInvokeCommand *)command callback:(QuickWebJSCallBack)callback
{
    if(![command isKindOfClass:[QuickWebJSBridgeInvokeCommand class]])
    {
        return NSStringFromBOOL(FALSE);
    }
    NSDictionary* args = command.arguments;
    if(![args isKindOfClass:[NSDictionary class]])
    {
        return NSStringFromBOOL(FALSE);
    }
    
    NSString* level = [QuickWebDataParseUtil getDataAsString:[args objectForKey:@"level"]];
    NSString* content = [QuickWebDataParseUtil getDataAsString:[args objectForKey:@"content"]];
    
    QUICKWEBKITCONSOLELOGLEVEL l = QUICKWEBKITCONSOLELOGLEVEL_INFO;
    NSString* logcolor = @"color:#008000";
    if([QuickWebStringUtil isString:level EqualTo:@"trace"])
    {
        logcolor = @"color:#000000";
        l = QUICKWEBKITCONSOLELOGLEVEL_TRACE;
    }
    else if([QuickWebStringUtil isString:level EqualTo:@"debug"])
    {
        logcolor = @"color:#46C2F2";
        l = QUICKWEBKITCONSOLELOGLEVEL_DEBUG;
    }
    else if([QuickWebStringUtil isString:level EqualTo:@"info"])
    {
        logcolor = @"color:#008000";
        l = QUICKWEBKITCONSOLELOGLEVEL_INFO;
    }
    else if([QuickWebStringUtil isString:level EqualTo:@"warning"])
    {
        logcolor = @"color:#FFC645";
        l = QUICKWEBKITCONSOLELOGLEVEL_WARNING;
    }
    else if([QuickWebStringUtil isString:level EqualTo:@"error"])
    {
        logcolor = @"color:#FF0000";
        l = QUICKWEBKITCONSOLELOGLEVEL_ERROR;
    }
    else if([QuickWebStringUtil isString:level EqualTo:@"critical"])
    {
        logcolor = @"color:#FF4500";
        l = QUICKWEBKITCONSOLELOGLEVEL_CRITICAL;
    }
    
    if(![QuickWebStringUtil isStringBlank:content])
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            content = [WEB_LOG_STRING(@"%@", log) stringByReplacingOccurrencesOfString:@"'" withString:@"\\'"];
            NSDate* now = [NSDate date];
            NSString* time = [_datetimeFormatter stringFromDate:now];
            content = [NSString stringWithFormat:@"%@ %@", time, content];
            NSString *string = [NSString stringWithFormat:@"console.log('%%c %@','%@');", content, logcolor];
            BOOL bSucceed = NO;
            if(command.webView)
            {
                [command.webView evaluateJavaScript:string completionHandler:nil];
                bSucceed = YES;
            }
            [self onConsoleLog:content level:l result:bSucceed];
        });
    }
    else
    {
        return NSStringFromBOOL(FALSE);
    }
    return NSStringFromBOOL(TRUE);
}

@end
