//
//  QuickWebJSInvokeCommand.m
//  QuickWebKit
//
//  Created by pcjbird on 2017/12/25.
//  Copyright © 2017年 Zero Status. All rights reserved.
//

#import "QuickWebJSInvokeCommand.h"

@implementation QuickWebJSInvokeCommand

-(id)initWithSecretId:(NSString*)secretId callbackId:(NSString*)callbackId provider:(NSString*)provider actionId:(NSString*)actionId param:(NSDictionary*)dictionary resultHandler:(id<QuickWebJSInvokeResultHandlerProtocol>)handler
{
    if(self = [super init])
    {
        self.secretId = secretId;
        self.callbackId = callbackId;
        self.provider = provider;
        self.actionId = actionId;
        self.param = dictionary;
        self.resultHandler = handler;
    }
    return self;
}

+(QuickWebJSInvokeCommand*) commandWithSecretId:(NSString*)secretId callbackId:(NSString*)callbackId provider:(NSString*)provider actionId:(NSString*)actionId param:(NSDictionary*)dictionary resultHandler:(id<QuickWebJSInvokeResultHandlerProtocol>)handler
{
    return [[QuickWebJSInvokeCommand alloc] initWithSecretId:secretId callbackId:callbackId provider:provider actionId:actionId param:dictionary resultHandler:handler];
}

@end
