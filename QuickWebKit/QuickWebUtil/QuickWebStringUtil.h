//
//  QuickWebStringUtil.h
//  QuickWebKit
//
//  Created by pcjbird on 2017/12/23.
//  Copyright © 2017年 Zero Status. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QuickWebStringUtil : NSObject

/**
 *@brief 判断字符串是否为空
 *@param val 目标字符串
 *@return 是否为空
 */
+(BOOL) isStringBlank:(NSString*)val;


/**
 *@brief 判断字符串是否包含中文
 *@param val 目标字符串
 *@return 是否包含中文
 */
+(BOOL) isStringHasChineseCharacter:(NSString*)val;


/**
 *@brief 判断字符串是否相等
 *@param val1 目标字符串1
 *@param val2 目标字符串2
 *@return 是否相等
 */
+(BOOL) isString:(NSString*)val1 EqualTo:(NSString*)val2;

@end
