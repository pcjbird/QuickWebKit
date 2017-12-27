//
//  QuickWebJSBridgeVideoPlayProxy.h
//  QuickWebKit
//
//  Created by pcjbird on 2017/12/27.
//  Copyright © 2017年 Zero Status. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QuickWEbJSBridgeProxyProtocol.h"

@interface QuickWebJSBridgeVideoPlayProxy : NSObject<QuickWebJSBridgeProxyProtocol>

-(void) playVideoWithUrl:(NSString*)videoUrl webViewSecretId:(NSString *)secretId;

-(BOOL) whetherRemindUseDataToPlayVideoUnderCelluarNetworks;
-(BOOL) isNetworkAvailable;
-(BOOL) isUnderCelluarNetworks;
-(UIColor *) alertTintColor;
@end
