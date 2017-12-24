//
//  QuickWebViewController.m
//  QuickWebViewController
//
//  Created by pcjbird on 2017/12/18.
//  Copyright © 2017年 Zero Status. All rights reserved.
//

#import "QuickWebViewController.h"
#import "QuickWebStringUtil.h"
#import "QuickWebNavigationButton.h"
#import "UIView+QuickWeb.h"
#import "QuickWebKitDefines.h"

#define ShowNetworkActivityIndicator()      [UIApplication sharedApplication].networkActivityIndicatorVisible = YES
#define HideNetworkActivityIndicator()      [UIApplication sharedApplication].networkActivityIndicatorVisible = NO
#define SDK_BUNDLE [NSBundle bundleWithPath:[[NSBundle bundleForClass:[QuickWebViewController class]] pathForResource:@"QuickWebKit" ofType:@"bundle"]]
#define DEFAULT_TINTCOLOR [UIColor darkGrayColor]
// 状态栏高度(来电等情况下，状态栏高度会发生变化，所以应该实时计算)
#define StatusBarHeight ([[UIApplication sharedApplication] statusBarFrame].size.height)
// navigationBar相关frame
#define NavigationBarHeight (44)

@interface QuickWebViewController ()<UIWebViewDelegate, WKNavigationDelegate, WKUIDelegate>
{
    NSString * _initUrl;
    SmartJSWebView*   _contentWebView;
    SmartJSWebProgressView* _progressView;
    NSMutableDictionary<NSString*, id<QuickWebPluginProtocol>> * _pluginMap;
}

//返回按钮
@property (nonatomic, strong) UIBarButtonItem *backItem;
//关闭按钮
@property (nonatomic, strong) UIBarButtonItem *closeItem;

@end

@implementation QuickWebViewController

-(instancetype)init
{
    if(self = [super init])
    {
        _initUrl = nil;
        _progressHidden = NO;
        _navbarTransparent = NO;
        _pluginMap = [NSMutableDictionary dictionary];
    }
    return self;
}

/*
 * @brief 初始化
 * @param url 页面地址
 */
-(instancetype)initWithUrlString:(NSString *)url
{
    if(self = [super init])
    {
        _initUrl = url;
        _progressHidden = NO;
        _navbarTransparent = NO;
        _pluginMap = [NSMutableDictionary dictionary];
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
    
    if(![QuickWebStringUtil isStringBlank:_initUrl])[self loadPage:_initUrl];
    
    [self updateLeftBarButtonItems];
}

-(void)loadPage:(NSString *)url
{
    if (![_contentWebView isKindOfClass:[SmartJSWebView class]] || [QuickWebStringUtil isStringBlank:url]) return;
    [_contentWebView loadPage:url];
    //bReload = FALSE;
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
    if (@available(iOS 11.0, *)) {
        _contentWebView.scrollView.contentInsetAdjustmentBehavior =YES;
    }
    _contentWebView.delegate = self;
    [self.view addSubview:_contentWebView];
    
    UISwipeGestureRecognizer*leftSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipes:)];
    leftSwipe.direction = UISwipeGestureRecognizerDirectionLeft;
    [_contentWebView addGestureRecognizer:leftSwipe];
    UISwipeGestureRecognizer*rightSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipes:)];
    rightSwipe.direction = UISwipeGestureRecognizerDirectionRight;
    [_contentWebView addGestureRecognizer:rightSwipe];
    
    weak(weakSelf);
    [_pluginMap enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, id<QuickWebPluginProtocol>  _Nonnull obj, BOOL * _Nonnull stop) {
        if([obj respondsToSelector:@selector(webViewControllerDidWebViewCreated:)])
        {
            [obj webViewControllerDidWebViewCreated:weakSelf];
        }
    }];
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

#pragma mark - 调整布局
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    CGFloat top = 0.0f;
    top += [_contentWebView.scrollView quickweb_safeAreaInsets].top;
    if (!IsiOS11Later)
    {
        if(!_navbarTransparent)
        {
            top += StatusBarHeight;
            top += NavigationBarHeight;
        }
    }
    _progressView.translatesAutoresizingMaskIntoConstraints = NO;
    CGRect frame = _progressView.frame;
    frame.origin.y = top;
    _progressView.frame = frame;
    _progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleBottomMargin;
    weak(weakSelf);
    [_pluginMap enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, id<QuickWebPluginProtocol>  _Nonnull obj, BOOL * _Nonnull stop) {
        if([obj respondsToSelector:@selector(webViewControllerDidLayoutSubviews:)])
        {
            [obj webViewControllerDidLayoutSubviews:weakSelf];
        }
    }];
}

#pragma mark - webview
-(SmartJSWebView *)webView
{
    return _contentWebView;
}

#pragma mark - 插件列表
-(NSArray<id<QuickWebPluginProtocol>> *)plugins
{
    return _pluginMap.allValues;
}

#pragma mark - webview背景颜色
-(UIColor *)backgroundColor
{
    return [UIColor colorWithRed:(0xf2/255.0f) green:(0xf2/255.0f) blue:(0xf2/255.0f) alpha:1.0f];
}

#pragma mark - webview进度条颜色
-(UIColor *)progressColor
{
    return [UIColor colorWithRed:(0xe6/255.0f) green:(0x00/255.0f) blue:(0x1b/255.0f) alpha:1.0f];
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

#pragma mark - webview返回按钮图标
-(UIImage *)backIndicatorImage
{
    return [UIImage imageNamed:@"navbar_return" inBundle:SDK_BUNDLE compatibleWithTraitCollection:nil];
}

-(UIImage *)resolvedBackIndicatorImage
{
    UIImage *image = [self backIndicatorImage];
    if([image isKindOfClass:[UIImage class]])
    {
        return [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    }
    UINavigationBar *appearance = [UINavigationBar appearance];
    UIImage * backIndicator = appearance.backIndicatorImage;
    if([backIndicator isKindOfClass:[UIImage class]])
    {
        return backIndicator;
    }
    return [[UIImage imageNamed:@"navbar_return" inBundle:SDK_BUNDLE compatibleWithTraitCollection:nil] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
}

#pragma mark - webview关闭按钮图标
-(UIImage *)closeIndicatorImage
{
    return [UIImage imageNamed:@"navbar_close" inBundle:SDK_BUNDLE compatibleWithTraitCollection:nil];
}

-(UIImage *)resolvedCloseIndicatorImage
{
    UIImage *image = [self closeIndicatorImage];
    if([image isKindOfClass:[UIImage class]])
    {
        return [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    }
    return [[UIImage imageNamed:@"navbar_close" inBundle:SDK_BUNDLE compatibleWithTraitCollection:nil] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
}

#pragma mark - webview导航按钮前景色
-(UIColor *)resolvedBtnTintColor
{
    UIBarButtonItem *appearance = [UIBarButtonItem appearance];
    UIColor * tintColor = appearance.tintColor;
    if([tintColor isKindOfClass:[UIColor class]])
    {
        return tintColor;
    }
    return DEFAULT_TINTCOLOR;
}

#pragma mark - webview导航按钮前景色(highlighted)
-(UIColor *)resolvedBtnHighlightColor
{
    UIBarButtonItem *appearance = [UIBarButtonItem appearance];
    NSDictionary<NSString *,id> * highlightTextAttrs = [appearance titleTextAttributesForState:UIControlStateHighlighted];
    if([highlightTextAttrs isKindOfClass:[NSDictionary class]])
    {
        UIColor * color = [highlightTextAttrs objectForKey:NSForegroundColorAttributeName];
        if([color isKindOfClass:[UIColor class]])
        {
            return color;
        }
    }
    UIColor * tintColor = appearance.tintColor;
    if([tintColor isKindOfClass:[UIColor class]])
    {
        return tintColor;
    }
    return DEFAULT_TINTCOLOR;
}

#pragma mark - webview导航按钮前景色(disabled)
-(UIColor *)resolvedBtnDisabledColor
{
    UIBarButtonItem *appearance = [UIBarButtonItem appearance];
    NSDictionary<NSString *,id> * disableTextAttrs = [appearance titleTextAttributesForState:UIControlStateDisabled];
    if([disableTextAttrs isKindOfClass:[NSDictionary class]])
    {
        UIColor * color = [disableTextAttrs objectForKey:NSForegroundColorAttributeName];
        if([color isKindOfClass:[UIColor class]])
        {
            return color;
        }
    }
    UIColor * tintColor = appearance.tintColor;
    if([tintColor isKindOfClass:[UIColor class]])
    {
        return tintColor;
    }
    return DEFAULT_TINTCOLOR;
}

#pragma mark - webview导航按钮字体
-(UIFont *)resolvedBtnFont
{
    UIBarButtonItem *appearance = [UIBarButtonItem appearance];
    NSDictionary<NSString *,id> * normalTextAttrs = [appearance titleTextAttributesForState:UIControlStateNormal];
    if([normalTextAttrs isKindOfClass:[NSDictionary class]])
    {
        UIFont * font = [normalTextAttrs objectForKey:NSFontAttributeName];
        if([font isKindOfClass:[UIFont class]])
        {
            return font;
        }
    }
    return [UIFont systemFontOfSize:17];
}

#pragma mark - webview返回按钮
- (UIBarButtonItem *)backItem
{
    if (!_backItem)
    {
        if([self useTextWithBackOrCloseButton])
        {
            _backItem = [[UIBarButtonItem alloc] init];
             QuickWebNavigationButton *btn = [[QuickWebNavigationButton alloc] initWithIcon:[self resolvedBackIndicatorImage] title:NSLocalizedStringFromTableInBundle(@"Back", @"Localizable", SDK_BUNDLE, nil)];
            [btn setFont:[self resolvedBtnFont]];
            btn.tintColor = [self resolvedBtnTintColor];
            [btn setHighlightColor:[self resolvedBtnHighlightColor]];
            [btn addTarget:self action:@selector(goBack:) forControlEvents:UIControlEventTouchUpInside];
            _backItem.customView = btn;
        }
        else
        {
            _backItem = [[UIBarButtonItem alloc] initWithImage:[self resolvedBackIndicatorImage] style:UIBarButtonItemStylePlain target:self action:@selector(goBack:)];
        }
        _backItem.tintColor = [self resolvedBtnTintColor];
    }
    return _backItem;
}
#pragma mark - webview关闭按钮
- (UIBarButtonItem *)closeItem
{
    if (!_closeItem)
    {
        if([self useTextWithBackOrCloseButton])
        {
            _closeItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedStringFromTableInBundle(@"Close", @"Localizable", SDK_BUNDLE, nil) style:UIBarButtonItemStylePlain target:self action:@selector(close:)];
        }
        else
        {
            _closeItem = [[UIBarButtonItem alloc] initWithImage:[self resolvedCloseIndicatorImage] style:UIBarButtonItemStylePlain target:self action:@selector(close:)];
        }
        _closeItem.tintColor = [self resolvedBtnTintColor];
    }
    return _closeItem;
}

#pragma mark - 更新导航左侧按钮
-(void) updateLeftBarButtonItems
{
    if(_contentWebView && [_contentWebView canGoBack])
    {
        self.navigationItem.leftBarButtonItems = @[self.backItem, self.closeItem];
    }
    else
    {
        UINavigationController *naviContoller = self.navigationController;
        if([naviContoller isKindOfClass:[UINavigationController class]])
        {
            UIViewController * rootViewController = [naviContoller.viewControllers firstObject];
            if(rootViewController != self)
            {
                self.navigationItem.leftBarButtonItems = @[self.backItem];
                return;
            }
        }
        self.navigationItem.leftBarButtonItems = @[];
    }
}

#pragma mark - 是否在返回或关闭按钮上使用文字  默认YES
-(BOOL)useTextWithBackOrCloseButton
{
    return YES;
}

#pragma mark - 注册插件
- (void)registerPlugin:(id<QuickWebPluginProtocol>)plugin
{
    if(![plugin conformsToProtocol:@protocol(QuickWebPluginProtocol)])
    {
        SDK_LOG(@"注册插件失败，请确保您的插件实现了QuickWebPluginProtocol协议。");
        return;
    }
    if([QuickWebStringUtil isStringBlank:plugin.name])
    {
        SDK_LOG(@"注册插件失败，插件名不能为空。");
        return;
    }
    if([_pluginMap objectForKey:plugin.name])
    {
        SDK_LOG(@"注册插件失败，插件'%@'已经存在。", plugin.name);
        return;
    }
    [_pluginMap setObject:plugin forKey:plugin.name];
}

#pragma mark - UIWebViewDelegate
-(void)webViewDidStartLoad:(UIWebView *)webView
{
    ShowNetworkActivityIndicator();
    weak(weakSelf);
    [_pluginMap enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, id<QuickWebPluginProtocol>  _Nonnull obj, BOOL * _Nonnull stop) {
       if([obj respondsToSelector:@selector(webViewControllerDidStartLoad:)])
       {
           [obj webViewControllerDidStartLoad:weakSelf];
       }
    }];
}


-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    HideNetworkActivityIndicator();
    [self updateLeftBarButtonItems];
    self.navigationItem.title = _contentWebView.title;
    weak(weakSelf);
    [_pluginMap enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, id<QuickWebPluginProtocol>  _Nonnull obj, BOOL * _Nonnull stop) {
        if([obj respondsToSelector:@selector(webViewControllerDidFinishLoad:)])
        {
            [obj webViewControllerDidFinishLoad:weakSelf];
        }
    }];
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    HideNetworkActivityIndicator();
    weak(weakSelf);
    [_pluginMap enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, id<QuickWebPluginProtocol>  _Nonnull obj, BOOL * _Nonnull stop) {
        if([obj respondsToSelector:@selector(webViewController:didFailLoadWithError:)])
        {
            [obj webViewController:weakSelf didFailLoadWithError:error];
        }
    }];
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