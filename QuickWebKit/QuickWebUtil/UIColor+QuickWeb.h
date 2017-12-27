//
//  UIColor+QuickWeb.h
//  QuickWebKit
//
//  Created by pcjbird on 2017/12/27.
//  Copyright © 2017年 Zero Status. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (QuickWeb)

+ (UIColor *) quickweb_ColorWithHexString: (NSString *) hexString;
+ (UIColor *) quickweb_ColorWithHexString: (NSString *) hexString alpha:(CGFloat)alpha;

- (CGFloat) quickweb_alpha;
-(BOOL)quickweb_isdarkcolor;
-(UIColor*) quickweb_inversecolor;
@end
