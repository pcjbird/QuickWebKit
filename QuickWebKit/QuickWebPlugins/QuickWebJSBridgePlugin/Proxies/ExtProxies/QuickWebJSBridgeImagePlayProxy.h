//
//  QuickWebJSBridgeImagePlayProxy.h
//  QuickWebKit
//
//  Created by pcjbird on 2017/12/27.
//  Copyright © 2017年 Zero Status. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QuickWebJSBridgeProxyProtocol.h"
@interface QuickWebJSBridgeImagePlayProxy : NSObject<QuickWebJSBridgeProxyProtocol>

- (BOOL)browseArtwork:(NSString *)photoUrls fromIndex:(NSString *)photoIndex webViewSecretId:(NSString *)secretId;

@end
