//
//  UIScrollView+QuickWebProviderPlugin.h
//  QuickWebKit
//
//  Created by pcjbird on 2017/12/23.
//  Copyright © 2017年 Zero Status. All rights reserved.
//

#import <UIKit/UIKit.h>

@class QuickWebProvider;
@interface UIScrollView (QuickWebProviderPlugin)

@property (strong, nonatomic) QuickWebProvider *quickweb_provider;

- (UIEdgeInsets)quickwebprovider_inset;

@end
