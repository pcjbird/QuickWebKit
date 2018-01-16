//
//  QuickWebSpotlightPlugin.m
//  QuickWebKit
//
//  Created by pcjbird on 2018/1/4.
//  Copyright © 2018年 Zero Status. All rights reserved.
//

#import "QuickWebKit.h"
#import "QuickWebSpotlightPlugin.h"
#import "QuickWebKitDefines.h"
#import "QuickWebStringUtil.h"
#import <EasyShareKit/EasyShareKit.h>
#import <GTMNSStringHTMLAdditions/GTMNSString+HTML.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <CoreSpotlight/CoreSpotlight.h>
#import <YYCategories/YYCategories.h>

@implementation QuickWebSpotlightPlugin

-(NSString *)name
{
    return @"QuickWebSpotlightPlugin";
}

-(void)setName:(NSString *)name
{
    
}

-(NSArray<NSString *> *)additionalKeywords
{
    NSString *app_name = QUICKWEB_APP_NAME;
    if([app_name isKindOfClass:[NSString class]])
    {
        return [NSArray arrayWithObject:app_name];
    }
    return [NSArray array];
}

-(NSArray<NSString*>*)customMetaTags
{
    return nil;
}

#pragma mark - QuickWebPluginProtocol

-(void)webViewControllerDidFinishLoad:(QuickWebViewController *)webViewController
{
    if([[[UIDevice currentDevice] systemVersion] floatValue] < 9.0f)
    {
        SDK_LOG(@"无法创建Spotlight，当前系统版本不支持Spotlight。");
        return;
    }
    weak(weakSelf);
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString* url = [webViewController.webView.url absoluteString];
        [webViewController.webView evaluateJavaScript:@"document.documentElement.innerHTML" completionHandler:^(id  _Nullable result, NSError * _Nullable error) {
            if([error isKindOfClass:[NSError class]]) return;
            NSString * htmlText = result;
            if(![QuickWebStringUtil isStringBlank:htmlText])
            {
                EasyShareKit * shareKit = [[EasyShareKit alloc] initWithHtml:htmlText];
                NSArray<NSString *>* metaTags = [self customMetaTags];
                if([metaTags isKindOfClass:[NSArray<NSString*> class]])
                {
                    [shareKit setCustomMetaTags:metaTags];
                }
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                    [shareKit getWebShareInfo:^(EasyShareInfo *shareInfo, long cost,NSError *error) {
                        if([error isKindOfClass:[NSError class]])
                        {
                            SDK_LOG(@"Spotlight获取页面信息失败：%@.(%@)", error.localizedDescription, url);
                            return;
                        }
                        if(![shareInfo isKindOfClass:[EasyShareInfo class]])
                        {
                            SDK_LOG(@"Spotlight未能正确获取页面信息.(%@)", url);
                            return;
                        }
                        SDK_LOG(@"Spotlight获取页面信息成功，耗时：%ldms.(%@)", cost, url);
                        

                        if([QuickWebStringUtil isStringBlank:shareInfo.url])
                        {
                            shareInfo.url = url;
                        }
                        if([QuickWebStringUtil isStringBlank:shareInfo.desc])
                        {
                            [webViewController.webView evaluateJavaScript:@"document.body" completionHandler:^(id  _Nullable result, NSError * _Nullable error) {
                                if([error isKindOfClass:[NSError class]]) return;
                                if(![QuickWebStringUtil isStringBlank:result])
                                {
                                    shareInfo.desc = [[result gtm_stringByUnescapingFromHTML] stringByReplacingOccurrencesOfString:@" " withString:@""];
                                    if([shareInfo.desc length] > 255)
                                    {
                                        shareInfo.desc = [shareInfo.desc substringToIndex:254];
                                    }
                                }
                            }];
                        }
                        if([QuickWebStringUtil isStringBlank:shareInfo.image])
                        {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [webViewController.webView evaluateJavaScript:@"SmartJSGetFirstImage();" completionHandler:^(id  _Nullable result, NSError * _Nullable error) {
                                    if(![error isKindOfClass:[NSError class]])
                                    {
                                        shareInfo.image = result;
                                    }
                                    [weakSelf createSpotlightWithInfo:shareInfo];
                                }];
                            });
                        }
                        else
                        {
                            [weakSelf createSpotlightWithInfo:shareInfo];
                        }
                    }];
                });
            }
        }];
    });
}

- (void)createSpotlightWithInfo:(EasyShareInfo *)shareInfo
{
    if([[[UIDevice currentDevice] systemVersion] floatValue] < 9.0f)
    {
        SDK_LOG(@"无法创建Spotlight，当前系统版本不支持Spotlight。");
        return;
    }
    
    if(![shareInfo isKindOfClass:[EasyShareInfo class]]) return;
    if (@available(iOS 9.0, *)) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            CSSearchableItemAttributeSet *set = [[CSSearchableItemAttributeSet alloc] initWithItemContentType:(NSString *)kUTTypeWebArchive];
            set.title = shareInfo.title;
            set.contentDescription = shareInfo.desc;
            set.version = QUICKWEB_APP_VERSION;
            NSMutableArray *keywords = [NSMutableArray array];
            NSArray<NSString *>* additionalKeywords = [self additionalKeywords];
            NSArray<NSString *>* webKeywords = shareInfo.keywords;
            if([additionalKeywords isKindOfClass:[NSArray<NSString *> class]])
            {
                [keywords addObjectsFromArray:additionalKeywords];
            }
            if([webKeywords isKindOfClass:[NSArray<NSString *> class]])
            {
                [keywords addObjectsFromArray:webKeywords];
            }
            if(![QuickWebStringUtil isStringBlank:set.title])[keywords addObject:set.title];
            set.keywords = keywords;
            if(![QuickWebStringUtil isStringBlank:shareInfo.image])
            {
                set.thumbnailURL = [NSURL URLWithString:shareInfo.image];
                set.thumbnailData = UIImageJPEGRepresentation([[UIImage imageWithData:[NSData dataWithContentsOfURL:set.thumbnailURL]] imageByResizeToSize:CGSizeMake(180.0f, 180.0f) contentMode:UIViewContentModeScaleAspectFill], 0.5);
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                CSSearchableItem *item = [[CSSearchableItem alloc] initWithUniqueIdentifier:[NSString stringWithFormat:@"%@.webview.%@", QUICKWEB_APP_BUNDLEID, [shareInfo.url stringByURLEncode]] domainIdentifier:QUICKWEB_APP_BUNDLEID attributeSet:set];
                [[CSSearchableIndex defaultSearchableIndex] indexSearchableItems:@[item] completionHandler:^(NSError * _Nullable error) {
                    if (error) {
                        SDK_LOG(@"创建Spotlight失败：%@",error.localizedDescription);
                    }
                }];
            });
        });
    }
}

+(BOOL) handleContinueUserActivity:(NSUserActivity *)userActivity
{
    if([[userActivity.userInfo valueForKey:@"kCSSearchableItemActivityIdentifier"] rangeOfString:[NSString stringWithFormat:@"%@.webview.", QUICKWEB_APP_BUNDLEID]].length > 0)
    {
        NSString *webUrl = [[userActivity.userInfo valueForKey:@"kCSSearchableItemActivityIdentifier"] stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@.webview.", QUICKWEB_APP_BUNDLEID] withString:@""];
        [[NSNotificationCenter defaultCenter] postNotificationName:QUICKWEBREQUESTURLHANDLERNOTIFICATION object:[webUrl stringByURLDecode]];
        return YES;
    }
    return NO;
}
@end
