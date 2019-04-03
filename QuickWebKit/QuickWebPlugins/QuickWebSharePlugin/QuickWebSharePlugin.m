//
//  QuickWebSharePlugin.m
//  QuickWebKit
//
//  Created by pcjbird on 2017/12/27.
//  Copyright © 2017年 Zero Status. All rights reserved.
//

#import "QuickWebSharePlugin.h"
#import "QuickWebStringUtil.h"
#import "QuickWebDataParseUtil.h"
#import "QuickWebKitDefines.h"
#if __has_include(<EasyShareKit/EasyShareKit.h>)
#import <EasyShareKit/EasyShareKit.h>
#else
#import "EasyShareKit.h"
#endif

#if __has_include(<GTMNSStringHTMLAdditions/GTMNSString+HTML.h>)
#import <GTMNSStringHTMLAdditions/GTMNSString+HTML.h>
#else
#import "GTMNSString+HTML.h"
#endif

#define SDK_BUNDLE [NSBundle bundleWithPath:[[NSBundle bundleForClass:[QuickWebSharePlugin class]] pathForResource:@"QuickWebKit" ofType:@"bundle"]]
@implementation QuickWebShareInfo
@end

@interface QuickWebSharePlugin()

@property(nonatomic, weak) QuickWebViewController*  toShareWebController;
@property(nonatomic, strong) EasyShareInfo*  autoDetectedShareInfo;
@end

@implementation QuickWebSharePlugin

-(NSString *)name
{
    return @"QuickWebSharePlugin";
}

-(void)setName:(NSString *)name
{
    
}


-(BOOL) shouldAlwaysShowShareBarButton
{
    return FALSE;
}

-(NSArray<NSString*>*)customMetaTags
{
    return nil;
}

#pragma mark - QuickWebPluginProtocol

-(void)webViewControllerDidStartLoad:(QuickWebViewController *)webViewController
{
    self.toShareWebController = webViewController;
    self.autoDetectedShareInfo = nil;
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [[NSNotificationCenter defaultCenter] postNotificationName:QUICKWEBPLUGINREQUESTUPDATEUINOTIFICATION object:webViewController.webView.secretId];
    });
}

-(void)webViewControllerDidFinishLoad:(QuickWebViewController *)webViewController
{
    self.toShareWebController = webViewController;
    weak(weakSelf);
    __weak typeof(QuickWebViewController *) weakWebVC = webViewController;
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString* url = [weakWebVC.webView.url absoluteString];
        [weakWebVC.webView evaluateJavaScript:@"document.documentElement.innerHTML" completionHandler:^(id  _Nullable result, NSError * _Nullable error) {
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
                            SDK_LOG(@"获取页面分享信息失败：%@.(%@)", error.localizedDescription, url);
                            return;
                        }
                        if(![shareInfo isKindOfClass:[EasyShareInfo class]] || !shareInfo.resolvedByMeta)
                        {
                            SDK_LOG(@"未能正确获取页面分享信息.(%@)", url);
                            return;
                        }
                        SDK_LOG(@"获取页面分享信息成功，耗时：%ldms.(%@)", cost, url);
                        
                        weakSelf.autoDetectedShareInfo = shareInfo;
                        if([QuickWebStringUtil isStringBlank:shareInfo.url])
                        {
                            weakSelf.autoDetectedShareInfo.url = url;
                        }
                        if([QuickWebStringUtil isStringBlank:shareInfo.desc])
                        {
                            [weakWebVC.webView evaluateJavaScript:@"document.body" completionHandler:^(id  _Nullable result, NSError * _Nullable error) {
                                if([error isKindOfClass:[NSError class]]) return;
                                if(![QuickWebStringUtil isStringBlank:result])
                                {
                                    shareInfo.desc = [result gtm_stringByUnescapingFromHTML];
                                    if([shareInfo.desc length] > 1024)
                                    {
                                        shareInfo.desc = [shareInfo.desc substringToIndex:1023];
                                    }
                                }
                            }];
                        }
                        if([QuickWebStringUtil isStringBlank:weakSelf.autoDetectedShareInfo.image])
                        {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [weakWebVC.webView evaluateJavaScript:@"SmartJSGetFirstImage();" completionHandler:^(id  _Nullable result, NSError * _Nullable error) {
                                    if(![error isKindOfClass:[NSError class]])
                                    {
                                        weakSelf.autoDetectedShareInfo.image = result;
                                    }
                                    [[NSNotificationCenter defaultCenter] postNotificationName:QUICKWEBPLUGINREQUESTUPDATEUINOTIFICATION object:weakWebVC.webView.secretId];
                                }];
                            });
                        }
                        else
                        {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [[NSNotificationCenter defaultCenter] postNotificationName:QUICKWEBPLUGINREQUESTUPDATEUINOTIFICATION object:weakWebVC.webView.secretId];
                            });
                        }
                    }];
                });
            }
        }];
    });
}

-(NSArray<UIBarButtonItem *> *)webViewControllerRequestRightBarButtonItems:(QuickWebViewController *)webViewController
{
    if([self shouldAlwaysShowShareBarButton] || [self.autoDetectedShareInfo isKindOfClass:[EasyShareInfo class]])
    {
        UIBarButtonItem *moreBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navbar_more" inBundle:SDK_BUNDLE compatibleWithTraitCollection:nil] style:UIBarButtonItemStylePlain target:self action:@selector(OnShareBtnClick:)];
        return [NSArray<UIBarButtonItem*> arrayWithObject:moreBtn];
    }
    return nil;
}

-(void) OnShareBtnClick:(id)sender
{
    weak(weakSelf);
    dispatch_async(dispatch_get_main_queue(), ^{
        QuickWebShareInfo *shareinfo = nil;
        if([weakSelf.autoDetectedShareInfo isKindOfClass:[EasyShareInfo class]])
        {
            shareinfo = [QuickWebShareInfo new];
            shareinfo.title = weakSelf.autoDetectedShareInfo.title;
            shareinfo.summary = weakSelf.autoDetectedShareInfo.desc;
            shareinfo.linkUrl = weakSelf.autoDetectedShareInfo.url;
            shareinfo.imageUrl = weakSelf.autoDetectedShareInfo.image;
        }
        [weakSelf showSharePanel:shareinfo fromWebController:weakSelf.toShareWebController];
    });
}

#pragma mark - QuickWebJSInvokeProviderProtocol

-(NSString *)jsProviderName
{
    return @"ShareProvider";
}

-(void)setJsProviderName:(NSString *)jsProviderName
{
    
}

-(void)callAction:(NSString *)actionId command:(QuickWebJSInvokeCommand *)command callback:(QuickWebJSCallBack)callback
{
    if([actionId isEqualToString:@"100"])
    {
        [self showShare:command callback:callback];
    }
    else if([actionId isEqualToString:@"101"])
    {
        [self directShare:command callback:callback];
    }
}

-(void)showShare:(QuickWebJSInvokeCommand *)command callback:(QuickWebJSCallBack)callback
{
    NSDictionary*params = command.param;
    if([params isKindOfClass:[NSDictionary class]])
    {
        NSString* title = [params objectForKey:@"title"];
        NSString* summary = [params objectForKey:@"content"];
        NSString* linkUrl = [params objectForKey:@"url"];
        NSString* imageUrl = [params objectForKey:@"iconUrl"];
        weak(weakSelf);
        dispatch_async(dispatch_get_main_queue(), ^{
            QuickWebShareInfo *shareinfo = [QuickWebShareInfo new];
            shareinfo.title = title;
            shareinfo.summary = summary;
            shareinfo.linkUrl = linkUrl;
            shareinfo.imageUrl = imageUrl;
            [weakSelf showSharePanel:shareinfo fromWebController:weakSelf.toShareWebController];
        });
    }
}

-(void)directShare:(QuickWebJSInvokeCommand *)command callback:(QuickWebJSCallBack)callback
{
    NSDictionary*params = command.param;
    if([params isKindOfClass:[NSDictionary class]])
    {
        int sharePlatform = [QuickWebDataParseUtil getDataAsInt:[params objectForKey:@"platform"]];
        NSString* title = [params objectForKey:@"title"];
        NSString* summary = [params objectForKey:@"content"];
        NSString* linkUrl = [params objectForKey:@"url"];
        NSString* imageUrl = [params objectForKey:@"iconUrl"];
        weak(weakSelf);
        dispatch_async(dispatch_get_main_queue(), ^{
            QuickWebShareInfo *shareinfo = [QuickWebShareInfo new];
            shareinfo.title = title;
            shareinfo.summary = summary;
            shareinfo.linkUrl = linkUrl;
            shareinfo.imageUrl = imageUrl;
            [weakSelf directShare:[weakSelf resolveJSShareAction:sharePlatform] info:shareinfo param:nil fromWebController:weakSelf.toShareWebController];
        });
    }
}

-(QuickWebShareAction) resolveJSShareAction:(int) platform
{
    return QuickWebShareActionNone;
}

-(void)showSharePanel:(QuickWebShareInfo *)shareinfo fromWebController:(QuickWebViewController *)webController
{
    
}

-(void)directShare:(QuickWebShareAction)action info:(QuickWebShareInfo *)shareinfo param:(NSDictionary *)param fromWebController:(QuickWebViewController *)webController
{
    
}
@end
