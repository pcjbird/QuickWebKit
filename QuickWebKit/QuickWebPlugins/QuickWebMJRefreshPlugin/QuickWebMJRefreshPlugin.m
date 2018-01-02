//
//  QuickWebMJRefreshPlugin.m
//  QuickWebKit
//
//  Created by pcjbird on 2018/1/2.
//  Copyright © 2018年 Zero Status. All rights reserved.
//

#import "QuickWebMJRefreshPlugin.h"

@implementation QuickWebMJRefreshPlugin

-(NSString *)name
{
    return @"QuickWebMJRefreshPlugin";
}

-(void)setName:(NSString *)name
{
    
}

-(void)webViewControllerDidWebViewCreated:(QuickWebViewController *)webViewController
{
    webViewController.webView.scrollView.mj_header = [MJRefreshStateHeader headerWithRefreshingBlock:^{
        [webViewController.webView reload];
    }];
}

-(void)webViewControllerDidFinishLoad:(QuickWebViewController *)webViewController
{
    [webViewController.webView.scrollView.mj_header endRefreshing];
}

-(void)webViewController:(QuickWebViewController *)webViewController didFailLoadWithError:(NSError *)error
{
    [webViewController.webView.scrollView.mj_header endRefreshing];
}

@end
