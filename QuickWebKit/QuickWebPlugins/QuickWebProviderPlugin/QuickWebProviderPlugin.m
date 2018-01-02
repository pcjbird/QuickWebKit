//
//  QuickWebProviderPlugin.m
//  QuickWebKit
//
//  Created by pcjbird on 2017/12/23.
//  Copyright © 2017年 Zero Status. All rights reserved.
//

#import "QuickWebProviderPlugin.h"
#import "QuickWebProvider.h"
#import "UIScrollView+QuickWebProviderPlugin.h"
#import "UIColor+QuickWeb.h"
#import "UIView+QuickWeb.h"
#import "QuickWebKitDefines.h"

@interface QuickWebProviderPlugin()

@end

@implementation QuickWebProviderPlugin

-(NSString *)name
{
    return @"QuickWebProviderPlugin";
}

-(void)setName:(NSString *)name
{
    
}

-(void)webViewControllerDidWebViewCreated:(QuickWebViewController *)webViewController
{
    UIColor *scrollBackColor = webViewController.webView.scrollView.backgroundColor;
    QuickWebProvider *provider = [QuickWebProvider new];
    provider.backgroundColor = [UIColor clearColor];
    provider.font = [UIFont systemFontOfSize:11.0f];
    provider.textColor = [scrollBackColor isKindOfClass:[UIColor class]] ? [[scrollBackColor quickweb_inversecolor] colorWithAlphaComponent:0.7f] : [UIColor colorWithRed:99/255.0 green:98/255.0 blue:98/255.0 alpha:0.7f];
    webViewController.webView.scrollView.quickweb_provider = provider;
}

-(void)webViewControllerDidLayoutSubviews:(QuickWebViewController *)webViewController
{
    CGFloat top = 0.0f;
    top += [webViewController.webView.scrollView quickweb_safeAreaInsets].top;
    if (!IsiOS11Later)
    {
        if(!webViewController.navbarTransparent)
        {
            top += [[UIApplication sharedApplication] statusBarFrame].size.height;
            top += 44.0f;
        }
    }
    webViewController.webView.scrollView.quickweb_provider.marginTop = top + 20.0f;
    [webViewController.webView.scrollView.quickweb_provider setNeedsLayout];
}


-(void)webViewControllerDidStartLoad:(QuickWebViewController *)webViewController
{
    NSURL *url = webViewController.webView.url;
    if([url isKindOfClass:[url class]])
    {
        [webViewController.webView.scrollView.quickweb_provider setProviderHost:url.host];
    }
}

-(void)webViewControllerDidFinishLoad:(QuickWebViewController *)webViewController
{
    NSURL *url = webViewController.webView.url;
    if([url isKindOfClass:[url class]])
    {
        [webViewController.webView.scrollView.quickweb_provider setProviderHost:url.host];
    }
}

@end
