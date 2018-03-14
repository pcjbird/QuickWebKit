//
//  QuickWebJSBridgeNavBarProxy.m
//  QuickWebKit
//
//  Created by pcjbird on 2017/12/27.
//  Copyright © 2017年 Zero Status. All rights reserved.
//

#import "QuickWebJSBridgeNavBarProxy.h"
#import "QuickWebStringUtil.h"
#import "QuickWebKit.h"
#import "QuickWebJSInvokeCommand.h"

@interface QuickWebJSBridgeNavBarProxy()
{
    NSString * _name;
}

@property(nonatomic, weak) id<QuickWebJSInvokeResultHandlerProtocol, SmartJSBridgeProtocol> resultHandler;
@end

@implementation QuickWebJSBridgeNavBarProxy
-(NSString *)name
{
    return [QuickWebStringUtil isStringBlank:_name] ? @"header" : _name;
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
        return [self applyNavBar:command callback:callback];
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

-(NSString*)applyNavBar:(QuickWebJSBridgeInvokeCommand *)command callback:(QuickWebJSCallBack)callback
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
    __block QuickWebJSInvokeCommand *jsCommand = [QuickWebJSInvokeCommand commandWithSecretId:command.secretId callbackId:command.callbackId  provider:@"MasterProvider" actionId:@"103" param:command.arguments resultHandler:self.resultHandler]; 
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:QUICKWEBJSINVOKENOTIFICATION object:jsCommand];
    });
    return NSStringFromBOOL(TRUE);
}
@end
