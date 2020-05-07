//
//  QuickWebJSBridgeSystemProxy.h
//  QuickWebKit
//
//  Created by pcjbird on 2017/12/27.
//  Copyright © 2017年 Zero Status. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QuickWebJSBridgeProxyProtocol.h"

typedef NS_ENUM(NSInteger, QUICKWEBKITCONSOLELOGLEVEL)
{
    QUICKWEBKITCONSOLELOGLEVEL_TRACE = 0,
    QUICKWEBKITCONSOLELOGLEVEL_DEBUG,
    QUICKWEBKITCONSOLELOGLEVEL_INFO,
    QUICKWEBKITCONSOLELOGLEVEL_WARNING,
    QUICKWEBKITCONSOLELOGLEVEL_ERROR,
    QUICKWEBKITCONSOLELOGLEVEL_CRITICAL,
};

@interface QuickWebJSBridgeSystemProxy : NSObject<QuickWebJSBridgeProxyProtocol>

-(NSDictionary *)deviceInfoDictionary;
-(NSString*) netStatus;
-(void) onConsoleLog:(NSString*)log level:(QUICKWEBKITCONSOLELOGLEVEL)level result:(BOOL)invokeSucceed;
@end
