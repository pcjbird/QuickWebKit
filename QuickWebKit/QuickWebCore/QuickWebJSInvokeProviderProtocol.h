//
//  QuickWebJSInvokeProviderProtocol.h
//  QuickWebKit
//
//  Created by pcjbird on 2017/12/25.
//  Copyright © 2017年 Zero Status. All rights reserved.
//

#ifndef QuickWebJSInvokeProviderProtocol_h
#define QuickWebJSInvokeProviderProtocol_h
#import "QuickWebJSInvokeCommand.h"
#import "QuickWebJSInvokeResult.h"


@protocol QuickWebJSInvokeProviderProtocol<NSObject>

/*
 * @brief provider名称
 */
@property(nonatomic, strong) NSString* jsProviderName;

-(void)callAction:(NSString*)actionId command:(QuickWebJSInvokeCommand*)command callback:(QuickWebJSCallBack)callback;
@end
#endif /* QuickWebJSInvokeProviderProtocol_h */
