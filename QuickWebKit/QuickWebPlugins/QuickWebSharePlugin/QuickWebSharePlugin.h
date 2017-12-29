//
//  QuickWebSharePlugin.h
//  QuickWebKit
//
//  Created by pcjbird on 2017/12/27.
//  Copyright © 2017年 Zero Status. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QuickWebPluginProtocol.h"
#import "QuickWebViewController.h"
#import "QuickWebJSInvokeProviderProtocol.h"


typedef enum {
    QuickWebShareActionWeiXin = 0,
    QuickWebShareActionWeiXinTimeline,
    QuickWebShareActionWeiBo,
    QuickWebShareActionQQ,
    QuickWebShareActionQQZone,
    QuickWebShareActionSMS,
    QuickWebShareActionCopyLink,
    QuickWebShareActionSystem,
    QuickWebShareActionNone = NSNotFound
}QuickWebShareAction;

@interface QuickWebShareInfo : NSObject

@property (strong, nonatomic) NSString* title;
@property (strong, nonatomic) NSString* summary;
@property (strong, nonatomic) NSString* imageUrl;
@property (strong, nonatomic) NSString* linkUrl;

@end

/*
 * @brief 分享插件
 * @remark 不可在不同QuickWebViewController之间共享该插件
 */
@interface QuickWebSharePlugin : NSObject<QuickWebPluginProtocol, QuickWebJSInvokeProviderProtocol>


-(BOOL) shouldAlwaysShowShareBarButton;
-(NSArray<NSString*>*)customMetaTags;
-(QuickWebShareAction) resolveJSShareAction:(int) platform;

-(void) showSharePanel:(QuickWebShareInfo *)shareinfo fromWebController:(QuickWebViewController *)webController;
-(void) directShare:(QuickWebShareAction)action info:(QuickWebShareInfo *)shareinfo param:(NSDictionary *)param fromWebController:(QuickWebViewController *)webController;

@end
