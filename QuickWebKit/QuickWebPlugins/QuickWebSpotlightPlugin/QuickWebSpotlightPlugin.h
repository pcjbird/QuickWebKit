//
//  QuickWebSpotlightPlugin.h
//  QuickWebKit
//
//  Created by pcjbird on 2018/1/4.
//  Copyright © 2018年 Zero Status. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QuickWebPluginProtocol.h"
#import "QuickWebViewController.h"
/*
 * @brief Spotlight插件
 */
@interface QuickWebSpotlightPlugin : NSObject<QuickWebPluginProtocol>

/*
 * @brief 附加关键字数组，例如：附加App名称、公司信息等, 默认会添加App名称
 */
-(NSArray<NSString*>*)additionalKeywords;

/*
 * @brief 自定义元标签，参照EasyShareKit使用,用于解析项目自定义的网页信息
 */
-(NSArray<NSString*>*)customMetaTags;

/*
 * @brief 在AppDelegate中调用，示例代码如下：
 - (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray * _Nullable))restorationHandler
 {
     if([QuickWebSpotlightPlugin handleContinueUserActivity:userActivity])
     {
        return YES;
     }
    //处理其他情形
 }
 */
+(BOOL) handleContinueUserActivity:(NSUserActivity *)userActivity;
@end
