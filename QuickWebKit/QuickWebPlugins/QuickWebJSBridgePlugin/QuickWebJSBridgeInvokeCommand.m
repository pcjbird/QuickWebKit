//
//  QuickWebJSBridgeInvokeCommand.m
//  QuickWebKit
//
//  Created by pcjbird on 2017/12/24.
//  Copyright © 2017年 Zero Status. All rights reserved.
//

#import "QuickWebJSBridgeInvokeCommand.h"
#import "QuickWebDataParseUtil.h"

@implementation QuickWebJSBridgeInvokeCommand
@synthesize secretId = _secretId;
@synthesize callbackId = _callbackId;
@synthesize arguments = _arguments;

-(id)initFromSecretId:(NSString *)secretId callbackId:(NSString*)callbackId jsonArgs:(NSString*)argString
{
    if(self = [super init])
    {
        _secretId = secretId;
        _callbackId = callbackId;
        _arguments = [QuickWebDataParseUtil toJsonObject:[argString dataUsingEncoding:NSUTF8StringEncoding]];
    }
    return self;
}

+ (QuickWebJSBridgeInvokeCommand*)commandFromSecretId:(NSString *)secretId callbackId:(NSString*)callbackId jsonArgs:(NSString*)argString
{
    return [[QuickWebJSBridgeInvokeCommand alloc] initFromSecretId:secretId callbackId:callbackId jsonArgs:argString];
}
@end
