//
//  QuickWebJSInvokeResultHandlerProtocol.h
//  QuickWebKit
//
//  Created by pcjbird on 2017/12/26.
//  Copyright © 2017年 Zero Status. All rights reserved.
//

#ifndef QuickWebJSInvokeResultHandlerProtocol_h
#define QuickWebJSInvokeResultHandlerProtocol_h

#import "QuickWebJSInvokeResult.h"

@protocol QuickWebJSInvokeResultHandlerProtocol<NSObject>

- (void) handleQuickWebJSInvokeResult:(QuickWebJSInvokeResult*)result;
@end

#endif /* QuickWebJSInvokeResultHandlerProtocol_h */
