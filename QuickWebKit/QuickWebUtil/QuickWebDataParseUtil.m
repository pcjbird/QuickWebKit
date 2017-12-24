//
//  QuickWebDataParseUtil.m
//  QuickWebKit
//
//  Created by pcjbird on 2017/12/24.
//  Copyright © 2017年 Zero Status. All rights reserved.
//

#import "QuickWebDataParseUtil.h"

@implementation QuickWebDataParseUtil

+ (NSString*)getDataAsString:(id)data
{
    if ([data isKindOfClass:[NSString class]]) {
        return data;
    }
    else if([data isKindOfClass:[NSNumber class]]){
        return [NSString stringWithFormat:@"%@", data];
    }
    return nil;
}

+ (BOOL) getDataAsBool:(id)data
{
    if ([data isKindOfClass:[NSNumber class]] ||[data isKindOfClass:[NSString class]]) {
        return [data boolValue];
    }
    return FALSE;
}

+ (int) getDataAsInt:(id)data
{
    if ([data isKindOfClass:[NSNumber class]] ||[data isKindOfClass:[NSString class]]) {
        return [data intValue];
    }
    return 0;
}

+ (long) getDataAsLong:(id)data
{
    if ([data isKindOfClass:[NSNumber class]] ||[data isKindOfClass:[NSString class]]) {
        return (long)[data longLongValue];
    }
    return 0;
}

+ (float) getDataAsFloat:(id)data
{
    if ([data isKindOfClass:[NSNumber class]] ||[data isKindOfClass:[NSString class]]) {
        return [data floatValue];
    }
    return 0.0f;
}
+ (double) getDataAsDouble:(id)data
{
    if ([data isKindOfClass:[NSNumber class]] ||[data isKindOfClass:[NSString class]]) {
        return [data doubleValue];
    }
    return 0.0f;
}

+ (NSDate*) getDataAsDate:(id)data
{
    if ([data isKindOfClass:[NSDate class]]) {
        return [data date];
    }
    else if([data isKindOfClass:[NSString class]]){
        NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate* res = [formatter dateFromString:[data stringByReplacingOccurrencesOfString:@"T" withString:@" "]];
        if(![res isKindOfClass:[NSDate class]])
        {
            [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss zzz"];
            res = [formatter dateFromString:[data stringByReplacingOccurrencesOfString:@"T" withString:@" "]];
        }
        if(![res isKindOfClass:[NSDate class]])
        {
            [formatter setDateFormat:@"yyyy-MM-dd"];
            res = [formatter dateFromString:[data stringByReplacingOccurrencesOfString:@"T" withString:@" "]];
        }
        return res;
    }
    else if([data isKindOfClass:[NSNumber class]]){
        return [[NSDate alloc] initWithTimeIntervalSince1970:(double)[data doubleValue]/1000];
    }
    return nil;
}

+ (NSData*) toJSONData:(id)data
{
    if ([data isKindOfClass:[NSArray class]] || [data isKindOfClass:[NSDictionary class]]) {
        NSError *error = nil;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:data options:NSJSONWritingPrettyPrinted error:&error];
        if ([jsonData length] > 0 && !error)
        {
            return jsonData;
        }
    }
    return nil;
}

+ (id) toJsonObject:(id)data
{
    if ([data isKindOfClass:[NSData class]]) {
        NSError *error = nil;
        id jsonObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
        if ([NSJSONSerialization isValidJSONObject:jsonObject] && !error)
        {
            return jsonObject;
        }
    }
    return nil;
}


+ (NSString*) toJSONString:(id)data
{
    if ([data isKindOfClass:[NSArray class]] || [data isKindOfClass:[NSDictionary class]]) {
        NSError *error = nil;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:data options:NSJSONWritingPrettyPrinted error:&error];
        if ([jsonData length] > 0 && !error)
        {
            return [[[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding] stringByReplacingOccurrencesOfString:@"\n " withString:@""]stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        }
    }
    return nil;
}

+ (int) getDateAsAge:(NSDate*)date
{
    if (![date isKindOfClass:[NSDate class]]) {
        return 0;
    }
    // 出生日期转换 年月日
    NSDateComponents *components1 = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:date];
    NSInteger brithDateYear  = [components1 year];
    NSInteger brithDateDay   = [components1 day];
    NSInteger brithDateMonth = [components1 month];
    
    // 获取系统当前 年月日
    NSDateComponents *components2 = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
    NSInteger currentDateYear  = [components2 year];
    NSInteger currentDateDay   = [components2 day];
    NSInteger currentDateMonth = [components2 month];
    
    // 计算年龄
    NSInteger iAge = currentDateYear - brithDateYear - 1;
    if ((currentDateMonth > brithDateMonth) || (currentDateMonth == brithDateMonth && currentDateDay >= brithDateDay)) {
        iAge++;
    }
    
    return (int)iAge;
}

+ (NSString*)formatFloatValue:(CGFloat)val
{
    if (fmodf(val, 1)==0)
    {
        return [NSString stringWithFormat:@"%.0f",val];
        
    }
    else if (fmodf(val*10, 1)==0)
    {
        return [NSString stringWithFormat:@"%.1f",val];
    }
    else
    {
        return [NSString stringWithFormat:@"%.2f",val];
    }
}

@end
