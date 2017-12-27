//
//  UIColor+QuickWeb.m
//  QuickWebKit
//
//  Created by pcjbird on 2017/12/27.
//  Copyright © 2017年 Zero Status. All rights reserved.
//

#import "UIColor+QuickWeb.h"

@implementation UIColor (QuickWeb)

+ (UIColor *) quickweb_ColorWithHexString: (NSString *) hexString
{
    return [self quickweb_ColorWithHexString:hexString alpha:1];
}

+ (UIColor *) quickweb_ColorWithHexString: (NSString *) hexString alpha:(CGFloat)alpha{
    NSString *colorString = [[hexString stringByReplacingOccurrencesOfString: @"#" withString: @""] uppercaseString];
    CGFloat  red = 0.0f, blue = 0.0f, green = 0.0f;
    BOOL bResult = TRUE;
    switch ([colorString length]) {
        case 3: // #RGB
            red   = [self quickweb_ColorComponentFrom: colorString start: 0 length: 1];
            green = [self quickweb_ColorComponentFrom: colorString start: 1 length: 1];
            blue  = [self quickweb_ColorComponentFrom: colorString start: 2 length: 1];
            break;
        case 4: // #RGBA
            red   = [self quickweb_ColorComponentFrom: colorString start: 0 length: 1];
            green = [self quickweb_ColorComponentFrom: colorString start: 1 length: 1];
            blue  = [self quickweb_ColorComponentFrom: colorString start: 2 length: 1];
            break;
        case 6: // #RRGGBB
            red   = [self quickweb_ColorComponentFrom: colorString start: 0 length: 2];
            green = [self quickweb_ColorComponentFrom: colorString start: 2 length: 2];
            blue  = [self quickweb_ColorComponentFrom: colorString start: 4 length: 2];
            break;
        case 8: // #RRGGBBAA
            red   = [self quickweb_ColorComponentFrom: colorString start: 0 length: 2];
            green = [self quickweb_ColorComponentFrom: colorString start: 2 length: 2];
            blue  = [self quickweb_ColorComponentFrom: colorString start: 4 length: 2];
            break;
        default:
            bResult = FALSE;
            break;
    }
    return (bResult ? [UIColor colorWithRed: red green: green blue: blue alpha: alpha] : nil);
}

+ (CGFloat) quickweb_ColorComponentFrom: (NSString *) string start: (NSUInteger) start length: (NSUInteger) length
{
    NSString *substring = [string substringWithRange: NSMakeRange(start, length)];
    NSString *fullHex = length == 2 ? substring : [NSString stringWithFormat: @"%@%@", substring, substring];
    unsigned hexComponent;
    [[NSScanner scannerWithString: fullHex] scanHexInt: &hexComponent];
    return hexComponent / 255.0;
}


- (CGFloat) quickweb_alpha
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

-(BOOL)quickweb_isdarkcolor
{
    if ([self quickweb_alpha]<10e-5)
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

-(UIColor*) quickweb_inversecolor
{
    CGFloat r,g,b,a;
    [self getRed:&r green:&g blue:&b alpha:&a];
    return [UIColor colorWithRed:1.-r green:1.-g blue:1.-b alpha:a];
}

@end
