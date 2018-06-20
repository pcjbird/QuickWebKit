//
//  QuickWebJSBridgeVideoPlayProxy.m
//  QuickWebKit
//
//  Created by pcjbird on 2017/12/27.
//  Copyright © 2017年 Zero Status. All rights reserved.
//

#import "QuickWebJSBridgeVideoPlayProxy.h"
#import "QuickWebStringUtil.h"
#import "QuickWebDataParseUtil.h"
#import "NSString+QuickWeb.h"
#import "UIView+QuickWeb.h"
#import <ZFPlayer/ZFPlayer.h>
#import <ZFPlayer/ZFAVPlayerManager.h>
#import <ZFPlayer/ZFPlayerControlView.h>

@interface QuickWebJSBridgeVideoPlayProxy()
{
    NSString * _name;
}

@property(nonatomic, weak) id<QuickWebJSInvokeResultHandlerProtocol, SmartJSBridgeProtocol> resultHandler;
@property (nonatomic, weak) ZFPlayerController *player;
@property (nonatomic, weak) ZFPlayerControlView *controlView;
@end

@implementation QuickWebJSBridgeVideoPlayProxy
-(NSString *)name
{
    return [QuickWebStringUtil isStringBlank:_name] ? @"videoplay" : _name;
}

-(void)setName:(NSString *)name
{
    _name = name;
}

-(id)initWithResultHandler:(id<QuickWebJSInvokeResultHandlerProtocol, SmartJSBridgeProtocol>)handler
{
    if(self = [super init])
    {
        _resultHandler = handler;
    }
    return self;
}

-(NSString*)callAction:(NSString*)actionId command:(QuickWebJSBridgeInvokeCommand*)command callback:(QuickWebJSCallBack)callback
{
    if([actionId isEqualToString:@"100"])
    {
        return [self playVideo:command callback:callback];
    }
    else
    {
        if([command.webView isKindOfClass:[SmartJSWebView class]])
        {
            NSString *warning = [NSString stringWithFormat:@"无效的JS调用(service=\"%@\", action=\"%@\")。", [self name], actionId];
            [command.webView tracewarning:warning];
        }
    }
    return NSStringFromBOOL(FALSE);
}

-(NSString*)playVideo:(QuickWebJSBridgeInvokeCommand *)command callback:(QuickWebJSCallBack)callback
{
    if(![command isKindOfClass:[QuickWebJSBridgeInvokeCommand class]])
    {
        return NSStringFromBOOL(FALSE);
    }
    NSDictionary* args = command.arguments;
    if(![args isKindOfClass:[NSDictionary class]])
    {
        return NSStringFromBOOL(FALSE);
    }
    
    BOOL bPlayHD = [QuickWebDataParseUtil getDataAsBool:[args objectForKey:@"playHD"]]; //是否播放高清， 0： 普清  1：高清 ,默认普清
    NSString *videoUrl = ![QuickWebStringUtil isStringBlank:[args objectForKey:@"url"]] ? [[args objectForKey:@"url"] quickweb_URLDecode] : @"";   //普清url
    NSString *hdVideoUrl = ![QuickWebStringUtil isStringBlank:[args objectForKey:@"highUrl"]] ? [[args objectForKey:@"highUrl" ] quickweb_URLDecode] : @""; //高清url
    if(!bPlayHD && [QuickWebStringUtil isStringBlank:videoUrl])
    {
        return NSStringFromBOOL(FALSE);
    }
    
    if(bPlayHD && [QuickWebStringUtil isStringBlank:hdVideoUrl])
    {
        if(![QuickWebStringUtil isStringBlank:videoUrl])
        {
            hdVideoUrl = videoUrl;
        }
        else
        {
            return NSStringFromBOOL(FALSE);
        }
    }
    
    if(bPlayHD)
    {
        [self playVideoWithUrl:hdVideoUrl webViewSecretId:command.secretId];
    }
    
    else
    {
        [self playVideoWithUrl:videoUrl webViewSecretId:command.secretId];
    }
    
    return NSStringFromBOOL(TRUE);
}

-(void) playVideoWithUrl:(NSString*)videoUrl webViewSecretId:(NSString *)secretId
{
    if([QuickWebStringUtil isStringBlank:videoUrl]) return;
    __weak typeof(self) weakSelf = self;
    BOOL bAlert = [self whetherRemindUseDataToPlayVideoUnderCelluarNetworks];
    void(^playBlock)(void) = ^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC * 0.1f),dispatch_get_main_queue(), ^{
            if(![weakSelf.player isKindOfClass:[ZFPlayerController class]])
            {
                UIView *playerParentView = [[UIApplication sharedApplication] keyWindow].rootViewController.view;
                
                if([weakSelf.resultHandler conformsToProtocol:@protocol(SmartJSBridgeProtocol)])
                {
                    UIView * webView = [weakSelf.resultHandler getSmartJSWebViewBySecretId:secretId];
                    if([webView isKindOfClass:[UIView class]])
                    {
                        playerParentView = webView;
                    }
                }
                ZFAVPlayerManager *playerManager = [[ZFAVPlayerManager alloc] init];
                weakSelf.player = [ZFPlayerController playerWithPlayerManager:playerManager containerView:playerParentView];
                ZFPlayerControlView* controlView = [ZFPlayerControlView new];
                weakSelf.player.controlView = controlView;
                weakSelf.controlView = controlView;
                [playerParentView bringSubviewToFront:weakSelf.player.currentPlayerManager.view];
                weakSelf.player.assetURL = [NSURL URLWithString:videoUrl];
                [weakSelf.player enterLandscapeFullScreen:UIInterfaceOrientationLandscapeRight animated:NO];
                [weakSelf.controlView.landScapeControlView.backBtn addTarget:weakSelf action:@selector(stop:) forControlEvents:UIControlEventTouchUpInside];
                
            }
            else
            {
                UIView *playerParentView = [[UIApplication sharedApplication] keyWindow].rootViewController.view;
                if([self.resultHandler conformsToProtocol:@protocol(SmartJSBridgeProtocol)])
                {
                    UIView * webView = [weakSelf.resultHandler getSmartJSWebViewBySecretId:secretId];
                    if([webView isKindOfClass:[UIView class]])
                    {
                        playerParentView = webView;
                    }
                }
                [playerParentView addSubview:weakSelf.player.currentPlayerManager.view];
                [playerParentView bringSubviewToFront:weakSelf.player.currentPlayerManager.view];
                weakSelf.player.assetURL = [NSURL URLWithString:videoUrl];
                [weakSelf.player enterLandscapeFullScreen:UIInterfaceOrientationLandscapeRight animated:NO];
                [weakSelf.controlView.landScapeControlView.backBtn addTarget:weakSelf action:@selector(stop:) forControlEvents:UIControlEventTouchUpInside];
            }
            
        });
    };
    void(^alertBlock)(NSString*title, NSString* message) = ^(NSString* title, NSString *message){
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedStringFromTableInBundle(@"Confirm", @"Localizable", QUICKWEB_BUNDLE, nil) style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:cancelAction];
        UIColor * tintColor = [weakSelf alertTintColor];
        alertController.view.tintColor  = tintColor ? tintColor : [UIColor colorWithRed:(0x49)/255.f green:(0x49)/255.f blue:(0x4a)/255.f alpha:1.f];
        UIViewController *viewController = [[UIApplication sharedApplication] keyWindow].rootViewController;
        if([weakSelf.resultHandler conformsToProtocol:@protocol(SmartJSBridgeProtocol)])
        {
            UIView * webView = [weakSelf.resultHandler getSmartJSWebViewBySecretId:secretId];
            if([webView isKindOfClass:[UIView class]])
            {
                viewController = [webView quickweb_FindViewController];
            }
        }
        [viewController presentViewController:alertController animated:YES completion:nil];
    };
    
    if(![self isNetworkAvailable])
    {
        alertBlock(nil, NSLocalizedStringFromTableInBundle(@"Network Not Available", @"Localizable", QUICKWEB_BUNDLE, nil));
        return;
    }
    if(bAlert && [self isUnderCelluarNetworks] && !(weakSelf.player && weakSelf.player.currentPlayerManager.isPlaying))
    {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:NSLocalizedStringFromTableInBundle(@"CellularNetworksVideoPlayTip", @"Localizable", QUICKWEB_BUNDLE, nil) preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedStringFromTableInBundle(@"Cancel", @"Localizable", QUICKWEB_BUNDLE, nil) style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedStringFromTableInBundle(@"Continue Play", @"Localizable", QUICKWEB_BUNDLE, nil) style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC * 0.3f),dispatch_get_main_queue(), ^{
                playBlock();
            });
        }];
        [alertController addAction:cancelAction];
        [alertController addAction:okAction];
        UIColor * tintColor = [self alertTintColor];
        alertController.view.tintColor  = tintColor ? tintColor : [UIColor colorWithRed:(0x49)/255.f green:(0x49)/255.f blue:(0x4a)/255.f alpha:1.f];
        UIViewController *viewController = [[UIApplication sharedApplication] keyWindow].rootViewController;
        if([self.resultHandler conformsToProtocol:@protocol(SmartJSBridgeProtocol)])
        {
            UIView * webView = [self.resultHandler getSmartJSWebViewBySecretId:secretId];
            if([webView isKindOfClass:[UIView class]])
            {
                viewController = [webView quickweb_FindViewController];
            }
        }
        [viewController presentViewController:alertController animated:YES completion:nil];
    }
    else
    {
        playBlock();
    }
}

-(void)stop:(id)sender
{
    if(self.player)
    {
        [self.player stop];
    }
}

-(BOOL) whetherRemindUseDataToPlayVideoUnderCelluarNetworks
{
    return YES;
}

-(BOOL) isNetworkAvailable
{
    return YES;
}

-(BOOL)isUnderCelluarNetworks
{
    return YES;
}

-(UIColor *) alertTintColor
{
    return [UIColor colorWithRed:(0x49)/255.f green:(0x49)/255.f blue:(0x4a)/255.f alpha:1.f];
}
@end
