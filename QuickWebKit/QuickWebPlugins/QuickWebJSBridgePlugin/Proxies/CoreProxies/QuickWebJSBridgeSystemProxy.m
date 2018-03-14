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

@interface QuickWebJSBridgeSystemProxy()
{
    NSString * _name;
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

@end
