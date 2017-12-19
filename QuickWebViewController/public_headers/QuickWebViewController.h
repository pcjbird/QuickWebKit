//
//  QuickWebViewController.h
//  QuickWebViewController
//
//  Created by pcjbird on 2017/12/18.
//  Copyright © 2017年 Zero Status. All rights reserved.
//

#import <UIKit/UIKit.h>

//! Project version number for QuickWebViewController.
FOUNDATION_EXPORT double QuickWebViewControllerVersionNumber;

//! Project version string for QuickWebViewController.
FOUNDATION_EXPORT const unsigned char SuperWebViewControllerVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <QuickWebViewController/PublicHeader.h>



@interface QuickWebViewController : UIViewController

/*
 * @brief 导航栏是否透明
 */
@property(nonatomic, assign) BOOL navbarTransparent;

/*
 * @brief 是否显示进度条
 */
@property(nonatomic, assign) BOOL progressHidden;

/*
 * @brief webview背景颜色 默认值：#f2f2f2
 */
-(UIColor *)backgroundColor;

/*
 * @brief webview进度条颜色 默认值：#e6001b
 */
-(UIColor *)progressColor;

@end
