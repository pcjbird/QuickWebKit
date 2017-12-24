//
//  QuickWebServiceProtocol.h
//  QuickWebKit
//
//  Created by pcjbird on 2017/12/24.
//  Copyright © 2017年 Zero Status. All rights reserved.
//

#ifndef QuickWebServiceProtocol_h
#define QuickWebServiceProtocol_h
#import "QuickWebServiceInvokeResult.h"
#import "QuickWebInvokedCommand.h"

#define QUICKWEB_JSBRIDGE_PLUGIN_BUNDLE [NSBundle bundleWithPath:[[NSBundle bundleForClass:[QuickWebInvokedCommand class]] pathForResource:@"QuickWebJSBridgePlugin" ofType:@"bundle"]]
#define QuickWebServiceNotFound(service) ([NSString stringWithFormat:NSLocalizedStringFromTableInBundle(@"QuickWebServiceNotFoundFormat", @"Localizable", QUICKWEB_JSBRIDGE_PLUGIN_BUNDLE, nil),(service)])
#define NSStringFromBOOL(v) ( (v) ? @"TRUE" : @"FALSE")

typedef void(^QuickWebServiceCallBack)(QuickWebServiceInvokeResult* result);

@protocol QuickWebServiceProtocol <NSObject>
/*
 * @brief 服务名称
 */
@property(nonatomic, strong) NSString* name;


-(NSString*)callAction:(NSString*)actionId command:(QuickWebInvokedCommand*)command callback:(QuickWebServiceCallBack)callback;
@end

#endif /* QuickWebServiceProtocol_h */
