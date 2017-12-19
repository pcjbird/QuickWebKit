//
//  QuickWebViewController.m
//  QuickWebViewController
//
//  Created by pcjbird on 2017/12/18.
//  Copyright © 2017年 Zero Status. All rights reserved.
//

#import "QuickWebViewController.h"
#import <SmartJSWebView/SmartJSWebView.h>

#define ShowNetworkActivityIndicator()      [UIApplication sharedApplication].networkActivityIndicatorVisible = YES
#define HideNetworkActivityIndicator()      [UIApplication sharedApplication].networkActivityIndicatorVisible = NO

@interface QuickWebViewController ()<UIWebViewDelegate, WKNavigationDelegate, WKUIDelegate>
{
    SmartJSWebView*   _contentWebView;
    SmartJSWebProgressView* _progressView;
}
@end

@implementation QuickWebViewController

-(instancetype)init
{
    if(self = [super init])
    {
        _progressHidden = NO;
        _navbarTransparent = NO;
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:_navbarTransparent animated:animated];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.hidesBottomBarWhenPushed = YES;
    self.edgesForExtendedLayout = UIRectEdgeAll;
    self.extendedLayoutIncludesOpaqueBars = NO;
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0 && [[[UIDevice currentDevice] systemVersion] floatValue] < 11.0)
    {
        self.automaticallyAdjustsScrollViewInsets = YES;
    }
    [self createWebView];
    [self createProgressView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 手势处理
-(void)handleSwipes:(UISwipeGestureRecognizer*)sender
{
    if (sender.direction == UISwipeGestureRecognizerDirectionLeft)
    {
        if([_contentWebView isKindOfClass:[SmartJSWebView class]] && [_contentWebView canGoForward])
        {
            [_contentWebView goForward];
        }
    }
    else if(sender.direction == UISwipeGestureRecognizerDirectionRight)
    {
        [self goBack:nil];
    }
}

-(void) goBack:(id)sender
{
    if([_contentWebView isKindOfClass:[SmartJSWebView class]] && [_contentWebView canGoBack])
    {
        [_contentWebView goBack];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void) close:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 创建WebView
-(void)createWebView
{
    if ([_contentWebView isKindOfClass:[UIView class]]) [_contentWebView removeFromSuperview];
    CGRect frame = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds));
    _contentWebView = [[SmartJSWebView alloc] initWithFrame:frame];
    _contentWebView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [_contentWebView setBackgroundColor:[self backgroundColor]];
    _contentWebView.opaque = NO;
   if([[[UIDevice currentDevice] systemVersion] floatValue] >= 11.0)
   {
       _contentWebView.scrollView.contentInsetAdjustmentBehavior =YES;
   }
    _contentWebView.delegate = self;
    [self.view addSubview:_contentWebView];
    
    UISwipeGestureRecognizer*leftSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipes:)];
    leftSwipe.direction = UISwipeGestureRecognizerDirectionLeft;
    [contentWebView addGestureRecognizer:leftSwipe];
    UISwipeGestureRecognizer*rightSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipes:)];
    rightSwipe.direction = UISwipeGestureRecognizerDirectionRight;
    [contentWebView addGestureRecognizer:rightSwipe];
}

#pragma mark - 创建WebView 进度条
-(void)createProgressView
{
    _progressView = [[SmartJSWebProgressView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 2)];
    _progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleBottomMargin;
    _progressView.progressBarColor = [self progressColor];
    _contentWebView.progressDelegate = _progressView;
    _progressView.hidden = _progressHidden;
    [self.view addSubview:_progressView];
}

#pragma mark - webview背景颜色
-(UIColor *)backgroundColor
{
    return [UIColor colorWithRed:(0xf2/0xff) green:(0xf2/0xff) blue:(0xf2/0xff) alpha:1.0f];
}

#pragma mark - webview进度条颜色
-(UIColor *)progressColor
{
    return [UIColor colorWithRed:(0xe6/0xff) green:(0x00/0xff) blue:(0x1b/0xff) alpha:1.0f];
}

#pragma mark - 设置webview进度条是否显示
-(void)setProgressHidden:(BOOL)progressHidden
{
    if(_progressHidden != progressHidden)
    {
        _progressHidden = progressHidden;
        if([_progressView isKindOfClass:[SmartJSWebProgressView class]])
        {
            _progressView.hidden = _progressHidden;
        }
    }
}

#pragma mark - UIWebViewDelegate
-(void)webViewDidStartLoad:(UIWebView *)webView
{
    ShowNetworkActivityIndicator();
}


-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    HideNetworkActivityIndicator();
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    HideNetworkActivityIndicator();
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    return TRUE;
}


#pragma mark - WKNavigationDelegate, WKUIDelegate

-(void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation
{
    ShowNetworkActivityIndicator();
}

-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    HideNetworkActivityIndicator();
}

-(void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error
{
    HideNetworkActivityIndicator();
}
@end
