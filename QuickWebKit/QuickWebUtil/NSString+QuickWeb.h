//
//  NSString+QuickWeb.h
//  QuickWebKit
//
//  Created by pcjbird on 2017/12/27.
//  Copyright © 2017年 Zero Status. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (QuickWeb)

- (NSString *)quickweb_URLEncode;
- (NSString *)quickweb_URLEncodeUsingEncoding:(NSStringEncoding)encoding;

- (NSString *)quickweb_URLDecode;
- (NSString *)quickweb_URLDecodeUsingEncoding:(NSStringEncoding)encoding;

@end
