//
//  QuickWebJSInvokeResult.m
//  QuickWebKit
//
//  Created by pcjbird on 2017/12/24.
//  Copyright © 2017年 Zero Status. All rights reserved.
//

#import "QuickWebJSInvokeResult.h"
#import "QuickWebStringUtil.h"
#import "QuickWebDataParseUtil.h"

@implementation QuickWebJSInvokeResult
@synthesize secretId = _secretId;
@synthesize callbackId = _callbackId;
@synthesize results = _results;

-(id)initWithStatus:(BOOL)bSuccess secretId:(NSString*)secretId callbackId:(NSString*)callbackId resultWithString:(NSString*)result
{
    if(self = [super init])
    {
        _status = bSuccess ? @"SUCCESS" : @"FAIL";
        _secretId = secretId;
        _callbackId = callbackId;
        NSString* res =  result;
        if(![res isKindOfClass:[NSString class]])
        {
            res = @"";
        }
        _results = [NSString stringWithFormat:@"{\"callbackId\":\"%@\",\"status\":\"%@\",\"result\":\"%@\"}", _callbackId, _status, res];
    }
    return self;
}

-(id)initWithStatus:(BOOL)bSuccess secretId:(NSString*)secretId callbackId:(NSString*)callbackId resultWithDict:(NSDictionary*)result
{
    if(self = [super init])
    {
        _status = bSuccess ? @"SUCCESS" : @"FAIL";
        _secretId = secretId;
        _callbackId = callbackId;
        NSString* res =  [QuickWebDataParseUtil toJSONString:result];
        if(![res isKindOfClass:[NSString class]])
        {
            res = @"";
        }
        else
        {
            res = [res stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
        }
        _results = [NSString stringWithFormat:@"{\"callbackId\":\"%@\",\"status\":\"%@\",\"result\":\"%@\"}", _callbackId, _status, res];
    }
    return self;
}

+(QuickWebJSInvokeResult *)resultWithStatus:(BOOL)bSuccess secretId:(NSString*)secretId callbackId:(NSString*)callbackId resultWithString:(NSString*)result
{
    return [[QuickWebJSInvokeResult alloc] initWithStatus:(BOOL)bSuccess secretId:secretId callbackId:callbackId resultWithString:result];
}

+(QuickWebJSInvokeResult *)resultWithStatus:(BOOL)bSuccess secretId:(NSString*)secretId callbackId:(NSString*)callbackId resultWithDict:(NSDictionary*)result
{
    return [[QuickWebJSInvokeResult alloc] initWithStatus:(BOOL)bSuccess secretId:secretId callbackId:callbackId resultWithDict:result];
}


-(NSString*)asJsonArray
{
    if(![QuickWebStringUtil isStringBlank:_results])
    {
        return [NSString stringWithFormat:@"[%@]", _results];
    }
    return @"[]";
}
@end
