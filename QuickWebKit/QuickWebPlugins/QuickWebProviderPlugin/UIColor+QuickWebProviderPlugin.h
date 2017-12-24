//
//  UIColor+QuickWebProviderPlugin.h
//  QuickWebKit
//
//  Created by pcjbird on 2017/12/24.
//  Copyright © 2017年 Zero Status. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (QuickWebProviderPlugin)

- (CGFloat) quickwebprovider_alpha;
-(BOOL)quickwebprovider_isdarkcolor;
-(UIColor*) quickwebprovider_inversecolor;

@end
