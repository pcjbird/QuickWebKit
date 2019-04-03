//
//  QuickWebJSBridgeImagePlayProxy.m
//  QuickWebKit
//
//  Created by pcjbird on 2017/12/27.
//  Copyright © 2017年 Zero Status. All rights reserved.
//

#import "QuickWebJSBridgeImagePlayProxy.h"
#import "QuickWebStringUtil.h"
#import "QuickWebDataParseUtil.h"
#import "QuickWebKit.h"

#if __has_include(<IDMPhotoBrowser/IDMPhotoBrowser.h>)
#import <IDMPhotoBrowser/IDMPhotoBrowser.h>
#else
#import "IDMPhotoBrowser.h"
#endif

#import "NSString+QuickWeb.h"
#import "UIView+QuickWeb.h"

@interface QuickWebJSBridgeImagePlayProxy()<IDMPhotoBrowserDelegate>
{
    NSString * _name;
}

@property(nonatomic, weak) id<QuickWebJSInvokeResultHandlerProtocol, SmartJSBridgeProtocol> resultHandler;
@end

@implementation QuickWebJSBridgeImagePlayProxy
-(NSString *)name
{
    return [QuickWebStringUtil isStringBlank:_name] ? @"imageplay" : _name;
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
        return [self browseArtwork:command callback:callback];
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

- (NSString*)browseArtwork:(QuickWebJSBridgeInvokeCommand *)command callback:(QuickWebJSCallBack)callback
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
    
    int fromIndex = [QuickWebDataParseUtil getDataAsInt:[args objectForKey:@"fromIndex"]];
    
    NSString *photoUrls = [args objectForKey:@"photoUrls"];
    if([QuickWebStringUtil isStringBlank:photoUrls])
    {
        return NSStringFromBOOL(FALSE);
    }
    
    if(![self browseArtwork:photoUrls fromIndex:[NSString stringWithFormat:@"%d",fromIndex] webViewSecretId:command.secretId])
    {
        return NSStringFromBOOL(FALSE);
    }
    
    return NSStringFromBOOL(TRUE);
}

- (BOOL)browseArtwork:(NSString *)photoUrls fromIndex:(NSString *)photoIndex webViewSecretId:(NSString *)secretId
{
    if([QuickWebStringUtil isStringBlank:photoUrls]) return FALSE;
    
    NSMutableArray *imageAttachArray = [[photoUrls componentsSeparatedByString:@","] mutableCopy];
    if (![imageAttachArray isKindOfClass:[NSArray class]] || [imageAttachArray count] == 0 || [photoIndex intValue] >= (int) [imageAttachArray count]) return FALSE;
    
    NSMutableArray *photos = [NSMutableArray array];
    for (NSString *previewUrl in imageAttachArray) {
        IDMPhoto* photo = [IDMPhoto photoWithURL:[NSURL URLWithString:[previewUrl quickweb_URLDecode]]];
        if([photo isKindOfClass:[IDMPhoto class]])
        {
            [photos addObject:photo];
        }
    }
    int fromIndex = [photoIndex intValue];
    if(fromIndex >= [photos count])
    {
        fromIndex = 0;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        // Create and setup browser
        IDMPhotoBrowser *browser = [[IDMPhotoBrowser alloc] initWithPhotos:photos];
        browser.delegate = self;
        browser.displayActionButton = NO;
        browser.displayArrowButton = NO;
        browser.displayCounterLabel = YES;
        browser.displayDoneButton = YES;
        browser.autoHideInterface = YES;
        browser.usePopAnimation = YES;
        browser.doneButtonImage = [UIImage imageNamed:@"light_btn_close" inBundle:QUICKWEB_BUNDLE compatibleWithTraitCollection:nil];
        [browser setInitialPageIndex:fromIndex];
        // Show
        UIViewController *viewController = [[UIApplication sharedApplication] keyWindow].rootViewController;
        if([self.resultHandler conformsToProtocol:@protocol(SmartJSBridgeProtocol)])
        {
            UIView * webView = [self.resultHandler getSmartJSWebViewBySecretId:secretId];
            if([webView isKindOfClass:[UIView class]])
            {
                viewController = [webView quickweb_FindViewController];
            }
        }
        [viewController presentViewController:browser animated:YES completion:nil];
    });
    return TRUE;
}

#pragma mark - IDMPhotoBrowser Delegate

- (void)photoBrowser:(IDMPhotoBrowser *)photoBrowser didShowPhotoAtIndex:(NSUInteger)pageIndex
{
    //id <IDMPhoto> photo = [photoBrowser photoAtIndex:pageIndex];
    //NSLog(@"Did show photoBrowser with photo index: %zu, photo caption: %@", pageIndex, photo.caption);
}

- (void)photoBrowser:(IDMPhotoBrowser *)photoBrowser willDismissAtPageIndex:(NSUInteger)pageIndex
{
    //id <IDMPhoto> photo = [photoBrowser photoAtIndex:pageIndex];
    //NSLog(@"Will dismiss photoBrowser with photo index: %zu, photo caption: %@", pageIndex, photo.caption);
}

- (void)photoBrowser:(IDMPhotoBrowser *)photoBrowser didDismissAtPageIndex:(NSUInteger)pageIndex
{
    //id <IDMPhoto> photo = [photoBrowser photoAtIndex:pageIndex];
    //NSLog(@"Did dismiss photoBrowser with photo index: %zu, photo caption: %@", pageIndex, photo.caption);
}

- (void)photoBrowser:(IDMPhotoBrowser *)photoBrowser didDismissActionSheetWithButtonIndex:(NSUInteger)buttonIndex photoIndex:(NSUInteger)photoIndex
{
    //id <IDMPhoto> photo = [photoBrowser photoAtIndex:photoIndex];
    //NSLog(@"Did dismiss actionSheet with photo index: %zu, photo caption: %@", photoIndex, photo.caption);
    
}
@end
