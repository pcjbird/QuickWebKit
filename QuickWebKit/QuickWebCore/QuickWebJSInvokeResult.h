//
//  QuickWebJSInvokeResult.h
//  QuickWebKit
//
//  Created by pcjbird on 2017/12/24.
//  Copyright © 2017年 Zero Status. All rights reserved.
//

#import <Foundation/Foundation.h>

@class QuickWebJSInvokeResult;
typedef void(^QuickWebJSCallBack)(QuickWebJSInvokeResult* result);

@interface QuickWebJSInvokeResult : NSObject
{
    NSString* _status;
    NSString* _secretId;
    NSString* _callbackId;
    NSString* _results;
}

@property (nonatomic, readonly) NSString* secretId;
@property (nonatomic, readonly) NSString* callbackId;
@property (nonatomic, readonly) NSString* results;

+(QuickWebJSInvokeResult *)resultWithStatus:(BOOL)bSuccess secretId:(NSString*)secretId callbackId:(NSString*)callbackId resultWithString:(NSString*)result;
+(QuickWebJSInvokeResult *)resultWithStatus:(BOOL)bSuccess secretId:(NSString*)secretId callbackId:(NSString*)callbackId resultWithDict:(NSDictionary*)result;

-(NSString*)asJsonArray;

@end
