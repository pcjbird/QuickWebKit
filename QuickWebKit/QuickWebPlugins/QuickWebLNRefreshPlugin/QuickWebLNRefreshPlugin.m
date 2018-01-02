//
//  QuickWebLNRefreshPlugin.m
//  QuickWebKit
//
//  Created by pcjbird on 2018/1/2.
//  Copyright © 2018年 Zero Status. All rights reserved.
//

#import "QuickWebLNRefreshPlugin.h"

@implementation QuickWebLNRefreshPlugin

-(NSString *)name
{
    return @"QuickWebLNRefreshPlugin";
}

-(void)setName:(NSString *)name
{
    
}

-(void)webViewControllerDidWebViewCreated:(QuickWebViewController *)webViewController
{
    if(![self.headAnimator isKindOfClass:[LNHeaderAnimator class]])
    {
        [webViewController.webView.scrollView addPullToRefresh:^{
            [webViewController.webView reload];
        }];
    }
    else
    {
        __weak typeof(LNHeaderAnimator*) weakHeadAnimator = self.headAnimator;
        [webViewController.webView.scrollView addPullToRefresh:weakHeadAnimator block:^{
            [webViewController.webView reload];
        }];
    }
}

-(void)webViewControllerDidFinishLoad:(QuickWebViewController *)webViewController
{
    [webViewController.webView.scrollView endRefreshing];
}

-(void)webViewController:(QuickWebViewController *)webViewController didFailLoadWithError:(NSError *)error
{
    [webViewController.webView.scrollView endRefreshing];
}

@end
