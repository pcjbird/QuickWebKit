//
//  UIView+QuickWeb.m
//  QuickWebKit
//
//  Created by pcjbird on 2017/12/23.
//  Copyright © 2017年 Zero Status. All rights reserved.
//

#import "UIView+QuickWeb.h"

@implementation UIView (QuickWeb)

- (UIEdgeInsets)quickweb_safeAreaInsets
{
    if (@available(iOS 11.0, *)) {
        return self.safeAreaInsets;
    }
    return UIEdgeInsetsZero;
}

- (UIViewController *) quickweb_FindViewController
{
    id target = self;
    while (target) {
        target = ((UIResponder *)target).nextResponder;
        if ([target isKindOfClass:[UIViewController class]]) {
            break;
        }
    }
    if(!target)
    {
        target = [[UIApplication sharedApplication] keyWindow].rootViewController;
    }
    return target;
}
@end
