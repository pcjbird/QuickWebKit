//
//  QuickWebJSBridgeProxyProtocol.h
//  QuickWebKit
//
//  Created by pcjbird on 2017/12/24.
//  Copyright © 2017年 Zero Status. All rights reserved.
//

#ifndef QuickWebJSBridgeProxyProtocol_h
#define QuickWebJSBridgeProxyProtocol_h
#import "QuickWebJSInvokeResult.h"
#import "QuickWebJSBridgeInvokeCommand.h"
#import "QuickWebJSInvokeResultHandlerProtocol.h"

#define QUICKWEB_JSBRIDGE_PLUGIN_BUNDLE [NSBundle bundleWithPath:[[NSBundle bundleForClass:[QuickWebJSBridgeInvokeCommand class]] pathForResource:@"QuickWebJSBridgePlugin" ofType:@"bundle"]]
#define QuickWebJSBridgeProxyNotFound(service) ([NSString stringWithFormat:NSLocalizedStringFromTableInBundle(@"QuickWebJSBridgeProxyNotFoundFormat", @"Localizable", QUICKWEB_JSBRIDGE_PLUGIN_BUNDLE, nil),(service)])
#define NSStringFromBOOL(v) ( (v) ? @"TRUE" : @"FALSE")



@protocol QuickWebJSBridgeProxyProtocol <NSObject>
/*
 * @brief Proxy名称
 */
@property(nonatomic, strong) NSString* name;

-(id)initWithResultHandler:(id<QuickWebJSInvokeResultHandlerProtocol>)handler;

-(NSString*)callAction:(NSString*)actionId command:(QuickWebJSBridgeInvokeCommand*)command callback:(QuickWebJSCallBack)callback;
@end

#endif /* QuickWebJSBridgeProxyProtocol_h */
