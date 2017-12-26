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

#define QuickWebMainAppVersion ([[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"])
#define QUICKWEB_BUNDLE [NSBundle bundleWithPath:[[NSBundle bundleForClass:[QuickWebJSBridgeInvokeCommand class]] pathForResource:@"QuickWebKit" ofType:@"bundle"]]
#define QuickWebJSBridgeProxyNotFound(proxy) ([NSString stringWithFormat:NSLocalizedStringFromTableInBundle(@"QuickWebJSBridgeProxyNotFoundFormat", @"Localizable", QUICKWEB_BUNDLE, nil),(proxy)])

#define QuickWebJSFunctionAvailable(v)  \
(\
([v isKindOfClass:[NSString class]] && [QuickWebMainAppVersion compare:(v) options:NSNumericSearch] == NSOrderedAscending) ?  \
([NSString stringWithFormat:NSLocalizedStringFromTableInBundle(@"QuickWebJSFunctionOnlySupportVersionFormat", @"Localizable", QUICKWEB_BUNDLE, nil),(__FUNCTION__),(v)]) : \
(nil)\
)\

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
