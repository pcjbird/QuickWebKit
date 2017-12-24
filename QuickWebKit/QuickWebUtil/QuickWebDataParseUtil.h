//
//  QuickWebDataParseUtil.h
//  QuickWebKit
//
//  Created by pcjbird on 2017/12/24.
//  Copyright © 2017年 Zero Status. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

@interface QuickWebDataParseUtil : NSObject

+ (NSString*)getDataAsString:(id)data;
+ (BOOL) getDataAsBool:(id)data;
+ (int) getDataAsInt:(id)data;
+ (long) getDataAsLong:(id)data;
+ (float) getDataAsFloat:(id)data;
+ (double) getDataAsDouble:(id)data;
+ (NSDate*) getDataAsDate:(id)data;
+ (NSData*) toJSONData:(id)data;
+ (id) toJsonObject:(id)data;
+ (NSString*) toJSONString:(id)data;
+ (int) getDateAsAge:(NSDate*)date;
+ (NSString*)formatFloatValue:(CGFloat)val;

@end
