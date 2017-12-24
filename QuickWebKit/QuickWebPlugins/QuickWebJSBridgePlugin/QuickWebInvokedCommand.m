//
//  QuickWebInvokedCommand.m
//  QuickWebKit
//
//  Created by pcjbird on 2017/12/24.
//  Copyright © 2017年 Zero Status. All rights reserved.
//

#import "QuickWebInvokedCommand.h"
#import "QuickWebDataParseUtil.h"

@implementation QuickWebInvokedCommand
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

+ (QuickWebInvokedCommand*)commandFromSecretId:(NSString *)secretId callbackId:(NSString*)callbackId jsonArgs:(NSString*)argString
{
    return [[QuickWebInvokedCommand alloc] initFromSecretId:secretId callbackId:callbackId jsonArgs:argString];
}
@end
