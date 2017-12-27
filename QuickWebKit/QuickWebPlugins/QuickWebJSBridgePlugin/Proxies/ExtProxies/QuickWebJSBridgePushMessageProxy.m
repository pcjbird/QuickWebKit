//
//  QuickWebJSBridgePushMessageProxy.m
//  QuickWebKit
//
//  Created by pcjbird on 2017/12/27.
//  Copyright © 2017年 Zero Status. All rights reserved.
//

#import "QuickWebJSBridgePushMessageProxy.h"
#import "QuickWebStringUtil.h"
#import "QuickWebJSInvokeCommand.h"

@interface QuickWebJSBridgePushMessageProxy()
{
    NSString * _name;
}

@property(nonatomic, weak) id<QuickWebJSInvokeResultHandlerProtocol, SmartJSBridgeProtocol> resultHandler;
@end

@implementation QuickWebJSBridgePushMessageProxy

-(NSString *)name
{
    return [QuickWebStringUtil isStringBlank:_name] ? @"message" : _name;
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
        return [self listenRemoteMessageEvent:command callback:callback];
    }
    
    return NSStringFromBOOL(FALSE);
}

- (NSString*)listenRemoteMessageEvent:(QuickWebJSBridgeInvokeCommand *)command callback:(QuickWebJSCallBack)callback
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
     __block QuickWebJSInvokeCommand *jsCommand = [QuickWebJSInvokeCommand commandWithSecretId:command.secretId callbackId:command.callbackId  provider:@"MasterProvider" actionId:@"" param:command.arguments resultHandler:self.resultHandler]; 
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:QUICKWEBJSINVOKENOTIFICATION object:jsCommand];
    });
    return NSStringFromBOOL(TRUE);
}

@end
