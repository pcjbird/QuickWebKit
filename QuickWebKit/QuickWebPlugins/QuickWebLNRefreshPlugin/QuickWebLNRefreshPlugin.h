//
//  QuickWebLNRefreshPlugin.h
//  QuickWebKit
//
//  Created by pcjbird on 2018/1/2.
//  Copyright © 2018年 Zero Status. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <LNRefresh/LNRefresh.h>
#import "QuickWebPluginProtocol.h"
#import "QuickWebViewController.h"

/*
 * @brief LNRefresh下拉刷新插件
 */
@interface QuickWebLNRefreshPlugin : NSObject<QuickWebPluginProtocol>

@property(nonatomic, strong) LNHeaderAnimator * headAnimator;

@end
