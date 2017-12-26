//
//  QuickWebJSBridgePlugin.h
//  QuickWebKit
//
//  Created by pcjbird on 2017/12/24.
//  Copyright © 2017年 Zero Status. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QuickWebPluginProtocol.h"
#import "QuickWebJSInvokeResultHandlerProtocol.h"
#import "QuickWebViewController.h"
#import "QuickWebJSBridgeProxyProtocol.h"


@interface QuickWebJSBridgePlugin : NSObject<QuickWebPluginProtocol,QuickWebJSInvokeResultHandlerProtocol, SmartJSBridgeProtocol>

+ (QuickWebJSBridgePlugin *) sharedPlugin;

- (NSString*)exec:(NSString*)secretId :(NSString*)service :(NSString*)action :(NSString*)callbackId :(NSString*)args;
- (NSString*)retrieve:(NSString*)secretId;

- (void)registerProxy:(id<QuickWebJSBridgeProxyProtocol>)proxy;
@end
