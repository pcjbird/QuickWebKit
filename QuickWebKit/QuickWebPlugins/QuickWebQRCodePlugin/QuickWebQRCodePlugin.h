//
//  QuickWebQRCodePlugin.h
//  QuickWebKit
//
//  Created by pcjbird on 2017/12/27.
//  Copyright © 2017年 Zero Status. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QuickWebPluginProtocol.h"
#import "QuickWebViewController.h"

/*
 * @brief 二维码识别插件
 * @remark 不可在不同QuickWebViewController之间共享该插件
 */
@interface QuickWebQRCodePlugin : NSObject<QuickWebPluginProtocol>

-(UIColor *) alertTintColor;
@end
