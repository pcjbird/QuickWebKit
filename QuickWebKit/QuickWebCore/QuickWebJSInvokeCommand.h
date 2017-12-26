//
//  QuickWebJSInvokeCommand.h
//  QuickWebKit
//
//  Created by pcjbird on 2017/12/25.
//  Copyright © 2017年 Zero Status. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QuickWebJSInvokeResultHandlerProtocol.h"

//JS调用通知
#define QUICKWEBJSINVOKENOTIFICATION @"QuickWebJSInvokeNotification"

@interface QuickWebJSInvokeCommand : NSObject

@property(nonatomic, strong) NSString* secretId;
@property(nonatomic, strong) NSString* callbackId;
@property(nonatomic, strong) NSString* provider;
@property(nonatomic, strong) NSString* actionId;
@property(nonatomic, strong) NSDictionary*param;
@property(nonatomic, weak)   id<QuickWebJSInvokeResultHandlerProtocol> resultHandler;

+(QuickWebJSInvokeCommand*) commandWithSecretId:(NSString*)secretId callbackId:(NSString*)callbackId provider:(NSString*)provider actionId:(NSString*)actionId param:(NSDictionary*)dictionary resultHandler:(id<QuickWebJSInvokeResultHandlerProtocol>)handler;
@end
