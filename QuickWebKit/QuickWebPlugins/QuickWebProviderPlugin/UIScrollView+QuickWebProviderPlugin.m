//
//  UIScrollView+QuickWebProviderPlugin.m
//  QuickWebKit
//
//  Created by pcjbird on 2017/12/23.
//  Copyright © 2017年 Zero Status. All rights reserved.
//

#import "UIScrollView+QuickWebProviderPlugin.h"
#import "QuickWebProvider.h"
#import <objc/runtime.h>

@implementation UIScrollView (QuickWebProviderPlugin)

static const NSString* QuickWebProviderKey = @"QuickWebProviderKey";

-(void)setQuickweb_provider:(QuickWebProvider *)quickweb_provider
{
    if(quickweb_provider != self.quickweb_provider)
    {
        [self.quickweb_provider removeFromSuperview];
        [self insertSubview:quickweb_provider atIndex:0];
        
        [self willChangeValueForKey:@"quickweb_provider"];
        objc_setAssociatedObject(self, &QuickWebProviderKey, quickweb_provider, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [self didChangeValueForKey:@"quickweb_provider"];
    }
}

-(QuickWebProvider *)quickweb_provider
{
    return objc_getAssociatedObject(self, &QuickWebProviderKey);
}


- (UIEdgeInsets)quickwebprovider_inset
{
    if (@available(iOS 11.0, *)) {
        return self.adjustedContentInset;
    }
    return self.contentInset;
}

@end
