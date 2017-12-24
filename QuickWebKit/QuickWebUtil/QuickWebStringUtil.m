//
//  QuickWebStringUtil.m
//  QuickWebKit
//
//  Created by pcjbird on 2017/12/23.
//  Copyright © 2017年 Zero Status. All rights reserved.
//

#import "QuickWebStringUtil.h"

@implementation QuickWebStringUtil

+(BOOL) isStringBlank:(NSString*)val
{
    if(!val) return YES;
    if(![val isKindOfClass:[NSString class]]) return YES;
    val = [val stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if([val isEqualToString:@""]) return YES;
    if([val isEqualToString:@"(null)"]) return YES;
    if([val isEqualToString:@"<null>"]) return YES;
    return NO;
}


+(BOOL) isStringHasChineseCharacter:(NSString*)val
{
    if([[self class] isStringBlank:val]) return NO;
    for(int i=0; i< [val length];i++)
    {
        int a = [val characterAtIndex:i];
        if( a > 0x4e00 && a < 0x9fff)
        {
            return YES;
        }
    }
    return NO;
}

+(BOOL) isString:(NSString*)val1 EqualTo:(NSString*)val2
{
    if([[self class] isStringBlank:val1] && [[self class] isStringBlank:val2]) return YES;
    if([[self class] isStringBlank:val1] || [[self class] isStringBlank:val2]) return NO;
    return [val1 isEqualToString:val2];
}

@end
