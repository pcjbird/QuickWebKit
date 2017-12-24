//
//  QuickWebServiceInvokeResult.h
//  QuickWebKit
//
//  Created by pcjbird on 2017/12/24.
//  Copyright © 2017年 Zero Status. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QuickWebServiceInvokeResult : NSObject
{
    NSString* _status;
    NSString* _secretId;
    NSString* _callbackId;
    NSString* _results;
}

@property (nonatomic, readonly) NSString* secretId;
@property (nonatomic, readonly) NSString* callbackId;
@property (nonatomic, readonly) NSString* results;

+(QuickWebServiceInvokeResult *)resultWithStatus:(BOOL)bSuccess secretId:(NSString*)secretId callbackId:(NSString*)callbackId resultWithString:(NSString*)result;
+(QuickWebServiceInvokeResult *)resultWithStatus:(BOOL)bSuccess secretId:(NSString*)secretId callbackId:(NSString*)callbackId resultWithDict:(NSDictionary*)result;

-(NSString*)asJsonArray;

@end
