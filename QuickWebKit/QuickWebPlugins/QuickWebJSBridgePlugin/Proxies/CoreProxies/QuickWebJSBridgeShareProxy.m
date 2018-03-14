//
//  QuickWebJSBridgeShareProxy.m
//  QuickWebKit
//
//  Created by pcjbird on 2017/12/27.
//  Copyright © 2017年 Zero Status. All rights reserved.
//

#import "QuickWebJSBridgeShareProxy.h"
#import "QuickWebStringUtil.h"
#import "QuickWebKit.h"
#import "QuickWebJSInvokeCommand.h"

@interface QuickWebJSBridgeShareProxy()
{
    NSString * _name;
}

@property(nonatomic, weak) id<QuickWebJSInvokeResultHandlerProtocol, SmartJSBridgeProtocol> resultHandler;
@end

@implementation QuickWebJSBridgeShareProxy
-(NSString *)name
{
    return [QuickWebStringUtil isStringBlank:_name] ? @"share" : _name;
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
        return [self showShare:command callback:callback];
    }
    else if([actionId isEqualToString:@"101"])
    {
        return [self directShare:command callback:callback];
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


-(NSString*)showShare:(QuickWebJSBridgeInvokeCommand *)command callback:(QuickWebJSCallBack)callback
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
    __block QuickWebJSInvokeCommand *jsCommand = [QuickWebJSInvokeCommand commandWithSecretId:command.secretId callbackId:command.callbackId provider:@"ShareProvider" actionId:@"100" param:command.arguments resultHandler:self.resultHandler];
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:QUICKWEBJSINVOKENOTIFICATION object:jsCommand];
    });
    return NSStringFromBOOL(TRUE);
}

-(NSString*)directShare:(QuickWebJSBridgeInvokeCommand *)command callback:(QuickWebJSCallBack)callback
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
    __block QuickWebJSInvokeCommand *jsCommand = [QuickWebJSInvokeCommand commandWithSecretId:command.secretId callbackId:command.callbackId provider:@"ShareProvider" actionId:@"101" param:command.arguments resultHandler:self.resultHandler];
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:QUICKWEBJSINVOKENOTIFICATION object:jsCommand];
    });
    return NSStringFromBOOL(TRUE);
}
@end
