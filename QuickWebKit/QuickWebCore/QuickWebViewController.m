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
#import "UIColor+QuickWeb.h"
#import "QuickWebKitDefines.h"
#import "QuickWebJSInvokeProviderProtocol.h"
#import <YYWebImage/YYWebImage.h>
#import <FTPopOverMenu/FTPopOverMenu.h>

#define ShowNetworkActivityIndicator()      [UIApplication sharedApplication].networkActivityIndicatorVisible = YES
#define HideNetworkActivityIndicator()      [UIApplication sharedApplication].networkActivityIndicatorVisible = NO
#define SDK_BUNDLE [NSBundle bundleWithPath:[[NSBundle bundleForClass:[QuickWebViewController class]] pathForResource:@"QuickWebKit" ofType:@"bundle"]]
#define DEFAULT_TINTCOLOR [UIColor darkGrayColor]
// 状态栏高度(来电等情况下，状态栏高度会发生变化，所以应该实时计算)
#define StatusBarHeight ([[UIApplication sharedApplication] statusBarFrame].size.height)
// navigationBar相关frame
#define NavigationBarHeight (44)

#pragma mark - QuickWebPauseResumeEventObject
/*
 * @brief 页面"离开/重新进入"事件定义
 */
typedef enum
{
    QuickWebPauseResumeEvent_Pause = 0,  //离开
    QuickWebPauseResumeEvent_Resume = 1, //重新进入
}QuickWebPauseResumeEvent;

/*
 * @brief 页面"离开/重新进入"事件
 */
@interface QuickWebPauseResumeEventObject: NSObject

@property(nonatomic, strong) NSString* callbackId;
@property(nonatomic, weak) id<QuickWebJSInvokeResultHandlerProtocol> resultHandler;

-(QuickWebJSInvokeResult*) toResultWithSecretId:(NSString*)secretId event:(QuickWebPauseResumeEvent)event;

@end

@implementation QuickWebPauseResumeEventObject

-(QuickWebJSInvokeResult*) toResultWithSecretId:(NSString*)secretId event:(QuickWebPauseResumeEvent)event
{
    NSString* result = (event == QuickWebPauseResumeEvent_Pause) ?  @"pause" : @"resume";
    return [QuickWebJSInvokeResult resultWithStatus:YES secretId:secretId callbackId:_callbackId resultWithString:[NSString stringWithFormat:@"%@", result]];
}

@end

#pragma mark - QuickWebJSButtonActionObject
/*
 * @brief JS按钮行为对象
 */
@interface QuickWebJSButtonActionObject: NSObject

@property(nonatomic, strong)NSString* callbackId;
@property(nonatomic, strong)NSString* action;
@property(nonatomic, strong)NSString* title;
@property(nonatomic, strong)NSString* icon;
@property(nonatomic, weak) id<QuickWebJSInvokeResultHandlerProtocol> resultHandler;
+(QuickWebJSButtonActionObject*) itemWithCallbackId:(NSString*)callbackId action:(NSString*)action title:(NSString*)title icon:(NSString*)icon;

-(QuickWebJSInvokeResult*) toResultWithSecretId:(NSString*)secretId;

@end

@implementation QuickWebJSButtonActionObject

-(id) initWithCallbackId:(NSString*)callbackId action:(NSString*)action title:(NSString*)title icon:(NSString*)icon
{
    if(self = [super init])
    {
        _callbackId = callbackId;
        _action = action;
        _title = title;
        _icon = icon;
    }
    return self;
}

-(QuickWebJSInvokeResult*) toResultWithSecretId:(NSString*)secretId
{
    return [QuickWebJSInvokeResult resultWithStatus:YES secretId:secretId callbackId:_callbackId resultWithString:[NSString stringWithFormat:@"%@", _action]];
}

+(QuickWebJSButtonActionObject*) itemWithCallbackId:(NSString*)callbackId action:(NSString*)action title:(NSString*)title icon:(NSString*)icon
{
    return [[QuickWebJSButtonActionObject alloc] initWithCallbackId:callbackId action:action title:title icon:icon];
}

@end

#pragma mark - QuickWebViewController
/*
 * @brief QuickWebViewController 一款基于插件的 WebView 视图控制器，您可以基于它设计您的浏览器插件，然后像积木一样来组装它们。
 */
@interface QuickWebViewController ()<UIWebViewDelegate, WKNavigationDelegate, WKUIDelegate, QuickWebJSInvokeProviderProtocol>
{
    BOOL       _preferWKWebView;
    NSString * _initUrl;
    SmartJSWebView*   _contentWebView;
    SmartJSWebProgressView* _progressView;
    NSMutableDictionary<NSString*, id<QuickWebPluginProtocol>> * _pluginMap;
}

//返回按钮
@property (nonatomic, strong) UIBarButtonItem *backItem;
//关闭按钮
@property (nonatomic, strong) UIBarButtonItem *closeItem;
//页面"离开/重新进入"事件监听对象
@property(nonatomic, strong) QuickWebPauseResumeEventObject * pauseResumeEventListenObject;
//导航栏右侧主要按钮（JSButton）
@property(nonatomic, strong) QuickWebJSButtonActionObject* primaryButton;
//点击弹出的菜单项（JSButton）列表
@property(nonatomic, strong) NSMutableArray* popItems;

//导航栏相关样式
@property(nonatomic, strong) UIColor *navBarBackColor;
@property(nonatomic, strong) UIColor *navBarTitleColor;
@property(nonatomic, strong) NSString *navBarTitleImageUrl;
@end

@implementation QuickWebViewController

-(instancetype)init
{
    if(self = [super init])
    {
        [self initVariables];
    }
    return self;
}

-(instancetype)initWithPreferWKWebView:(BOOL)preferWKWebView
{
    if(self = [super init])
    {
        [self initVariables];
        _preferWKWebView = preferWKWebView;
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
        [self initVariables];
        _initUrl = url;
    }
    return self;
}

-(instancetype)initWithUrlString:(NSString *)url preferWKWebView:(BOOL)preferWKWebView
{
    if(self = [super init])
    {
        [self initVariables];
        _initUrl = url;
        _preferWKWebView = preferWKWebView;
    }
    return self;
}

-(void) initVariables
{
    _initUrl = nil;
    _preferWKWebView = NO;
    _progressHidden = NO;
    _navbarTransparent = NO;
    _pluginMap = [NSMutableDictionary dictionary];
    _popItems = [NSMutableArray array];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:_navbarTransparent animated:animated];
    if([self.pauseResumeEventListenObject isKindOfClass:[QuickWebPauseResumeEventObject class]] && self.pauseResumeEventListenObject.resultHandler)
    {
        [self.pauseResumeEventListenObject.resultHandler handleQuickWebJSInvokeResult:[self.pauseResumeEventListenObject toResultWithSecretId:_contentWebView.secretId event:QuickWebPauseResumeEvent_Resume]];
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if([self.pauseResumeEventListenObject isKindOfClass:[QuickWebPauseResumeEventObject class]] && self.pauseResumeEventListenObject.resultHandler)
    {
        [self.pauseResumeEventListenObject.resultHandler handleQuickWebJSInvokeResult:[self.pauseResumeEventListenObject toResultWithSecretId:_contentWebView.secretId event:QuickWebPauseResumeEvent_Pause]];
    }
    if(self.navigationController && [self.navigationController.viewControllers isKindOfClass:[NSArray class]])
    {
        NSArray *viewControllers = self.navigationController.viewControllers;
        if (viewControllers.count > 1 && [viewControllers objectAtIndex:(viewControllers.count - 2)] == self)
        {
            [self didPushedToNextVC:animated];
        }
        else if ([viewControllers indexOfObject:self] == NSNotFound)
        {
            [self willPopToPrevVC:animated];
        }
    }
}

-(void)willPopToPrevVC:(BOOL)animated
{
    self.pauseResumeEventListenObject = nil;
}

-(void)didPushedToNextVC:(BOOL)animated
{
    
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

-(void) registerNotificationObserver
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(OnPluginRequestUpdateUINotification:) name:QUICKWEBPLUGINREQUESTUPDATEUINOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(OnJSInvokeNotification:) name:QUICKWEBJSINVOKENOTIFICATION object:nil];
    weak(weakSelf);
    [_pluginMap enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, id<QuickWebPluginProtocol>  _Nonnull obj, BOOL * _Nonnull stop) {
        if([obj respondsToSelector:@selector(webViewControllerDidRegisterNotificationObserver:)])
        {
            [obj webViewControllerDidRegisterNotificationObserver:weakSelf];
        }
    }];
    [self didRegisterNotificationObserver];
}

-(void) didRegisterNotificationObserver{}

-(void)removeNotificationObserver
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    for (id<QuickWebPluginProtocol> plugin in _pluginMap.allValues) {
        if([plugin respondsToSelector:@selector(webViewControllerDidRemoveNotificationObserver:)])
        {
            [plugin webViewControllerDidRemoveNotificationObserver:self];
        }
    }
    [self didRemoveNotificationObserver];
}

-(void) didRemoveNotificationObserver{}

-(void)dealloc
{
    [self removeNotificationObserver];
}

#pragma mark - 插件请求更新UI
-(void) OnPluginRequestUpdateUINotification:(NSNotification *)notification
{
    weak(weakSelf);
    NSString* secretId = notification.object;
    if([QuickWebStringUtil isStringBlank:secretId] || ![QuickWebStringUtil isString:secretId EqualTo:_contentWebView.secretId]) return;
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf updateRightBarButtonItems];
    });
}

#pragma mark - 处理JS调用
-(void) OnJSInvokeNotification:(NSNotification *)notification
{
    QuickWebJSInvokeCommand *command = notification.object;
    if(![command isKindOfClass:[QuickWebJSInvokeCommand class]])
    {
        return;
    }
    if(![_contentWebView.secretId isEqualToString:command.secretId])
    {
        return;
    }
    if([QuickWebStringUtil isStringBlank:command.provider])
    {
        SDK_LOG(@"JS调用失败，提供者(provider)不能为空。");
        return;
    }
    if([command.provider isEqualToString:self.jsProviderName])
    {
        [self callAction:command.actionId command:command callback:^(QuickWebJSInvokeResult *result) {
            if(command.resultHandler && [command.resultHandler conformsToProtocol:@protocol(QuickWebJSInvokeResultHandlerProtocol)])
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [command.resultHandler handleQuickWebJSInvokeResult:result];
                });
            }
            
        }];
    }
    else
    {
        [_pluginMap enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, id<QuickWebPluginProtocol>  _Nonnull obj, BOOL * _Nonnull stop) {
           if([obj conformsToProtocol:@protocol(QuickWebJSInvokeProviderProtocol)])
           {
               id<QuickWebJSInvokeProviderProtocol> provider = (id<QuickWebJSInvokeProviderProtocol>)obj;
               if([provider.jsProviderName isEqualToString:command.provider])
               {
                   [provider callAction:command.actionId command:command callback:^(QuickWebJSInvokeResult *result) {
                       if(command.resultHandler && [command.resultHandler conformsToProtocol:@protocol(QuickWebJSInvokeResultHandlerProtocol)])
                       {
                           dispatch_async(dispatch_get_main_queue(), ^{
                               [command.resultHandler handleQuickWebJSInvokeResult:result];
                           });
                       }
                   }];
               }
           }
        }];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 加载页面
-(void)loadPage:(NSString *)url
{
    if (![_contentWebView isKindOfClass:[SmartJSWebView class]] || [QuickWebStringUtil isStringBlank:url]) return;
    [_contentWebView loadPage:url];
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
    if(_preferWKWebView)_contentWebView.preferWKWebView = YES;
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
        if(!_navbarTransparent&&self.navigationController.navigationBar.translucent)
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

#pragma mark - 更新导航右侧按钮

-(void) updateRightBarButtonItems
{
    NSMutableArray *rightBtns = [NSMutableArray array];
    if([self.primaryButton isKindOfClass:[QuickWebJSButtonActionObject class]])
    {
        if(![QuickWebStringUtil isStringBlank:self.primaryButton.icon])
        {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            if(![QuickWebStringUtil isStringBlank:self.primaryButton.title])
            {
                [button setTitle:self.primaryButton.title forState:UIControlStateNormal];
                [button.titleLabel setFont:[self resolvedBtnFont]];
                button.tintColor = [self resolvedBtnTintColor];
            }
            [button.imageView yy_setImageWithURL:[NSURL URLWithString:self.primaryButton.icon] placeholder:nil options:YYWebImageOptionProgressiveBlur completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
                CGSize size = [button sizeThatFits:CGSizeMake(HUGE, 40)];
                button.frame = CGRectMake(0, 0, size.width, size.height);
            }];
            
            [button addTarget:self action:@selector(OnPrimaryBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            UIBarButtonItem *primaryBtn = [[UIBarButtonItem alloc] initWithCustomView:button];
            [rightBtns addObject:primaryBtn];
        }
        else
        {
            UIBarButtonItem *primaryBtn = [[UIBarButtonItem alloc] initWithTitle:self.primaryButton.title style:UIBarButtonItemStylePlain target:self action:@selector(OnPrimaryBtnClick:)];
            [rightBtns addObject:primaryBtn];
        }
        
    }
    if([self.popItems isKindOfClass:[NSArray class]] && [self.popItems count] > 0)
    {
        UIBarButtonItem *moreBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navbar_more" inBundle:SDK_BUNDLE compatibleWithTraitCollection:nil] style:UIBarButtonItemStylePlain target:self action:@selector(popView:event:)];
        [rightBtns addObject:moreBtn];
    }
    else
    {
        weak(weakSelf);
        [_pluginMap enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, id<QuickWebPluginProtocol>  _Nonnull obj, BOOL * _Nonnull stop) {
            if([obj respondsToSelector:@selector(webViewControllerRequestRightBarButtonItems:)])
            {
                NSArray<UIBarButtonItem *>* buttons = [obj webViewControllerRequestRightBarButtonItems:weakSelf];
                if([buttons isKindOfClass:[NSArray<UIBarButtonItem *> class]])
                {
                    [rightBtns addObjectsFromArray:buttons];
                }
            }
        }];
    }
    self.navigationItem.rightBarButtonItems = rightBtns;
}

-(void) applyNavBar
{
    if([self.navBarBackColor isKindOfClass:[UIColor class]])
    {
        [self.navigationController.navigationBar setBarTintColor:self.navBarBackColor];
        
    }
    else
    {
        UINavigationBar *apperance = [UINavigationBar appearance];
        if([apperance.barTintColor isKindOfClass:[UIColor class]])
        {
            [self.navigationController.navigationBar setBarTintColor:apperance.barTintColor];
        }
    }
    //trigger reload statusbar style
    self.navigationController.navigationBarHidden = NO;
    
    if([self.navBarTitleColor isKindOfClass:[UIColor class]])
    {
        [self.navigationController.navigationBar setTitleTextAttributes: @{NSForegroundColorAttributeName:self.navBarTitleColor}];
    }
    else
    {
        UINavigationBar *apperance = [UINavigationBar appearance];
        NSDictionary<NSAttributedStringKey, id> *titleTextAttributes = [apperance titleTextAttributes];
        if([titleTextAttributes isKindOfClass:[NSDictionary class]])
        {
            UIColor *titleColor = [titleTextAttributes objectForKey:NSForegroundColorAttributeName];
            if([titleColor isKindOfClass:[UIColor class]])
            {
                [self.navigationController.navigationBar setTitleTextAttributes: @{NSForegroundColorAttributeName:titleColor}];
            }
        }
    }
    
    if(![QuickWebStringUtil isStringBlank:self.navBarTitleImageUrl])
    {
        __weak typeof(self) weakSelf = self;
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        __block UIImageView *weakImageView = imageView;
        [imageView yy_setImageWithURL:[NSURL URLWithString:self.navBarTitleImageUrl] placeholder:nil options:YYWebImageOptionProgressiveBlur|YYWebImageOptionSetImageWithFadeAnimation completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
            if([error isKindOfClass:[NSError class]]) return;
            CGSize size = [weakImageView sizeThatFits:CGSizeMake([[UIScreen mainScreen] bounds].size.width, 40)];
            weakImageView.frame = CGRectMake(0, 0, size.width, size.height);
            weakImageView.contentMode = UIViewContentModeScaleAspectFit;
            weakSelf.navigationItem.titleView = weakImageView;
        }];
    }
    else
    {
        self.navigationItem.titleView = nil;
    }
}

-(void) OnPrimaryBtnClick:(id)sender
{
    if([self.primaryButton isKindOfClass:[QuickWebJSButtonActionObject class]])
    {
        if([self.primaryButton.resultHandler conformsToProtocol:@protocol(QuickWebJSInvokeResultHandlerProtocol)])
        {
            [self.primaryButton.resultHandler handleQuickWebJSInvokeResult:[self.primaryButton toResultWithSecretId:_contentWebView.secretId]];
        }
    }
}

-(void)popView:(id)sender event:(UIEvent *)event
{
    FTPopOverMenuConfiguration *configuration = [FTPopOverMenuConfiguration defaultConfiguration];
    configuration.menuRowHeight = 40;
    configuration.menuWidth = 127;
    configuration.textColor = [UIColor quickweb_ColorWithHexString:@"#faa208"];
    configuration.textFont = [UIFont systemFontOfSize:13.0f];
    configuration.tintColor = [UIColor whiteColor];
    configuration.borderColor = [UIColor whiteColor];
    configuration.borderWidth = 0.5;
    
    __weak typeof(self) weakSelf = self;
    if (self.popItems && self.popItems.count > 0)
    {
        NSMutableArray *menuItems = [NSMutableArray array];
        NSMutableArray *iconItems = [NSMutableArray array];
        BOOL isIconEmpty = YES;
        for (QuickWebJSButtonActionObject*item in self.popItems) {
            [menuItems addObject:item.title];
            [iconItems addObject:[QuickWebStringUtil isStringBlank:item.icon] ? @"" : item.icon];
            if(![QuickWebStringUtil isStringBlank:item.icon])
            {
                isIconEmpty = NO;
            }
        }
        [FTPopOverMenu showFromEvent:event withMenuArray:menuItems imageArray:isIconEmpty ? nil : iconItems doneBlock:^(NSInteger selectedIndex) {
            QuickWebJSButtonActionObject* item = [weakSelf.popItems objectAtIndex:selectedIndex];
            if([item isKindOfClass:[QuickWebJSButtonActionObject class]])
            {
                if([item.resultHandler conformsToProtocol:@protocol(QuickWebJSInvokeResultHandlerProtocol)])
                {
                    [item.resultHandler handleQuickWebJSInvokeResult:[item toResultWithSecretId:_contentWebView.secretId]];
                }
            }
        } dismissBlock:^{
            
        }];
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

#pragma mark - QuickWebJSInvokeProviderProtocol

-(NSString *)jsProviderName
{
    return @"MasterProvider";
}

-(void)setJsProviderName:(NSString *)jsProviderName
{
    
}

-(void)callAction:(NSString *)actionId command:(QuickWebJSInvokeCommand *)command callback:(QuickWebJSCallBack)callback
{
    if([actionId isEqualToString:@"100"])
    {
        [self webViewGoBack:command callback:callback];
    }
    else if([actionId isEqualToString:@"101"])
    {
        [self webViewClose:command callback:callback];
    }
    else if([actionId isEqualToString:@"102"])
    {
        [self listenWebViewPauseResumeEvent:command callback:callback];
    }
    else if([actionId isEqualToString:@"103"])
    {
        [self applyNavBar:command callback:callback];
    }
}

-(void)webViewGoBack:(QuickWebJSInvokeCommand*)command callback:(QuickWebJSCallBack)callback
{
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf goBack:nil];
    });
}

-(void)webViewClose:(QuickWebJSInvokeCommand*)command callback:(QuickWebJSCallBack)callback
{
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf close:nil];
    });
}

-(void)listenWebViewPauseResumeEvent:(QuickWebJSInvokeCommand*)command callback:(QuickWebJSCallBack)callback
{
    self.pauseResumeEventListenObject = [QuickWebPauseResumeEventObject new];
    self.pauseResumeEventListenObject.callbackId = command.callbackId;
    self.pauseResumeEventListenObject.resultHandler = command.resultHandler;
}

-(void)applyNavBar:(QuickWebJSInvokeCommand *)command callback:(QuickWebJSCallBack)callback
{
    NSDictionary*params = command.param;
    if([params isKindOfClass:[NSDictionary class]])
    {
        NSDictionary *primaryAction = [params objectForKey:@"primaryAction"];
        if([primaryAction isKindOfClass:[NSDictionary class]])
        {
            self.primaryButton = [QuickWebJSButtonActionObject itemWithCallbackId:command.callbackId action:[primaryAction objectForKey:@"action"] title:[primaryAction objectForKey:@"des"] icon:[primaryAction objectForKey:@"iconUrl"]];
        }
        else
        {
            self.primaryButton = nil;
        }
        NSArray *moreAction = [params objectForKey:@"moreAction"];
        if([moreAction isKindOfClass:[NSArray class]] && [moreAction count] > 0)
        {
            [self.popItems removeAllObjects];
            for (NSDictionary* dict in moreAction) {
                QuickWebJSButtonActionObject* buttonObject = [QuickWebJSButtonActionObject itemWithCallbackId:command.callbackId action:[dict objectForKey:@"action"] title:[dict objectForKey:@"des"] icon:[dict objectForKey:@"iconUrl"]];
                [self.popItems addObject:buttonObject];
            }
        }
        NSString* headerColor = [params objectForKey:@"headerColor"];
        if(![QuickWebStringUtil isStringBlank:headerColor])
        {
            self.navBarBackColor = [UIColor quickweb_ColorWithHexString:headerColor];
        }
        else
        {
            self.navBarBackColor = nil;
        }
        
        NSString* titleColor = [params objectForKey:@"titleColor"];
        if(![QuickWebStringUtil isStringBlank:titleColor])
        {
            self.navBarTitleColor = [UIColor quickweb_ColorWithHexString:titleColor];
        }
        else
        {
            self.navBarTitleColor = nil;
        }
        NSString* titleLogo = [params objectForKey:@"logoUrl"];
        if(![QuickWebStringUtil isStringBlank:titleLogo])
        {
            self.navBarTitleImageUrl = titleLogo;
        }
        else
        {
            self.navBarTitleImageUrl = nil;
        }
        __weak typeof(self) weakSelf = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf applyNavBar];
            [weakSelf updateRightBarButtonItems];
        });
    }
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

#pragma mark - Status Bar

-(BOOL)prefersStatusBarHidden
{
    return NO;
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    UIColor * navBarTintColor = [UIColor whiteColor];
    if([self.navBarBackColor isKindOfClass:[UIColor class]])
    {
        navBarTintColor = self.navBarBackColor;
    }
    else
    {
        UINavigationBar *apperance = [UINavigationBar appearance];
        if([apperance.barTintColor isKindOfClass:[UIColor class]])
        {
            navBarTintColor = apperance.barTintColor;
        }
    }
    BOOL isDark = [navBarTintColor quickweb_isdarkcolor];
    return isDark ? UIStatusBarStyleLightContent : UIStatusBarStyleDefault;
}
@end
