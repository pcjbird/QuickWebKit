//
//  NSString+QuickWeb.m
//  QuickWebKit
//
//  Created by pcjbird on 2017/12/27.
//  Copyright © 2017年 Zero Status. All rights reserved.
//

#import "NSString+QuickWeb.h"

@implementation NSString (QuickWeb)

- (NSString *)quickweb_URLEncode {
    return [self quickweb_URLEncodeUsingEncoding:NSUTF8StringEncoding];
}

- (NSString *)quickweb_URLEncodeUsingEncoding:(NSStringEncoding)encoding {
    return (__bridge_transfer NSString *)CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                                 (__bridge CFStringRef)self,
                                                                                 NULL,
                                                                                 (CFStringRef)@"!*'\"();:@&=+$,/?%#[]% ",
                                                                                 CFStringConvertNSStringEncodingToEncoding(encoding));
}

- (NSString *)quickweb_URLDecode {
    return [self quickweb_URLDecodeUsingEncoding:NSUTF8StringEncoding];
}

- (NSString *)quickweb_URLDecodeUsingEncoding:(NSStringEncoding)encoding {
    return (__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL,
                                                                                                 (__bridge CFStringRef)self,
                                                                                                 CFSTR(""),
                                                                                                 CFStringConvertNSStringEncodingToEncoding(encoding));
}

@end
