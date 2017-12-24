//
//  UIColor+QuickWebProviderPlugin.m
//  QuickWebKit
//
//  Created by pcjbird on 2017/12/24.
//  Copyright © 2017年 Zero Status. All rights reserved.
//

#import "UIColor+QuickWebProviderPlugin.h"

@implementation UIColor (QuickWebProviderPlugin)

- (CGFloat) quickwebprovider_alpha
{
    CGFloat r, g, b, a, w, h, s, l;
    BOOL compatible = [self getWhite:&w alpha:&a];
    if (compatible)
    {
        return a;
    }
    else
    {
        compatible = [self getRed:&r green:&g blue:&b alpha:&a];
        if (compatible)
        {
            return a;
        }
        else
        {
            [self getHue:&h saturation:&s brightness:&l alpha:&a];
            return a;
        }
    }
}

-(BOOL)quickwebprovider_isdarkcolor
{
    if ([self quickwebprovider_alpha]<10e-5)
    {
        return YES;
    }
    const CGFloat *componentColors = CGColorGetComponents(self.CGColor);
    CGFloat colorBrightness = ((componentColors[0] * 299) + (componentColors[1] * 587) + (componentColors[2] * 114)) / 1000;
    if (colorBrightness < 0.5)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

-(UIColor*) quickwebprovider_inversecolor
{
    CGFloat r,g,b,a;
    [self getRed:&r green:&g blue:&b alpha:&a];
    return [UIColor colorWithRed:1.-r green:1.-g blue:1.-b alpha:a];
}

@end
