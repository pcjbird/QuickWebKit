//
//  QuickWebJSBridgeAccountProxy.m
//  QuickWebKit
//
//  Created by pcjbird on 2017/12/27.
//  Copyright © 2017年 Zero Status. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "QuickWebJSBridgeAccountProxy.h"
#import "QuickWebStringUtil.h"
#import "QuickWebKit.h"

@interface QuickWebJSBridgeAccountProxy()
{
    NSString * _name;
}

@property(nonatomic, weak) id<QuickWebJSInvokeResultHandlerProtocol, SmartJSBridgeProtocol> resultHandler;
@end

@implementation QuickWebJSBridgeAccountProxy
-(NSString *)name
{
    return [QuickWebStringUtil isStringBlank:_name] ? @"account" : _name;
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
        return [self signIn:command callback:callback];
    }
    else if([actionId isEqualToString:@"101"])
    {
        return [self signOut:command callback:callback];
    }
    else if([actionId isEqualToString:@"102"])
    {
        return [self getAuthInfo:command callback:callback];
    }
    return NSStringFromBOOL(FALSE);
}


-(NSString*)signIn:(QuickWebJSBridgeInvokeCommand *)command callback:(QuickWebJSCallBack)callback
{
    if(![command isKindOfClass:[QuickWebJSBridgeInvokeCommand class]])
    {
        return NSStringFromBOOL(FALSE);
    }
    NSString * url = [self signInUrl];
    if(![QuickWebStringUtil isStringBlank:url])
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:QUICKWEBREQUESTURLHANDLERNOTIFICATION object:url];
        });
        return NSStringFromBOOL(TRUE);
    }
    return NSStringFromBOOL(FALSE);
}

-(NSString *)signInUrl
{
    return @"";
}

-(NSString*)signOut:(QuickWebJSBridgeInvokeCommand *)command callback:(QuickWebJSCallBack)callback
{
    if(![command isKindOfClass:[QuickWebJSBridgeInvokeCommand class]])
    {
        return NSStringFromBOOL(FALSE);
    }
    
    NSString * url = [self signOutUrl];
    if(![QuickWebStringUtil isStringBlank:url])
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:QUICKWEBREQUESTURLHANDLERNOTIFICATION object:url];
        });
        return NSStringFromBOOL(TRUE);
    }
    return NSStringFromBOOL(FALSE);
}

-(NSString *)signOutUrl
{
    return @"";
}

-(NSString*)getAuthInfo:(QuickWebJSBridgeInvokeCommand *)command callback:(QuickWebJSCallBack)callback
{
    if(![command isKindOfClass:[QuickWebJSBridgeInvokeCommand class]])
    {
        return NSStringFromBOOL(FALSE);
    }
    NSString *token = [self authInfoString];
    if(!token) token = @"";
    QuickWebJSInvokeResult *result = [QuickWebJSInvokeResult resultWithStatus:YES secretId:command.secretId callbackId:command.callbackId resultWithString:token];
    return [result asJsonArray];
}

-(NSString*) authInfoString
{
    return @"";
}
@end
