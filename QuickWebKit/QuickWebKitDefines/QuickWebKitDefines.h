//
//  QuickWebKitDefines.h
//  QuickWebKit
//
//  Created by pcjbird on 2017/12/23.
//  Copyright © 2017年 Zero Status. All rights reserved.
//

#ifndef QuickWebKitDefines_h
#define QuickWebKitDefines_h

#define QUICKWEB_APP_NAME ([[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"CFBundleDisplayName"] ? [[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"CFBundleDisplayName"]:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"])
#define QUICKWEB_APP_BUNDLEID ([[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"CFBundleIdentifier"])
#define QUICKWEB_APP_VERSION ([[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"])

#ifdef DEBUG
#   define SDK_LOG(fmt, ...) NSLog((@"[🦉QuickWebKit] %s (line %d) " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#   define SDK_LOG(fmt, ...) (nil)
#endif

//系统版本
#define IOSVersion                          [[[UIDevice currentDevice] systemVersion] floatValue]
#define IsiOS7Later                         !(IOSVersion < 7.0)
#define IsiOS8Later                         !(IOSVersion < 8.0)
#define IsiOS9Later                         !(IOSVersion < 9.0)
#define IsiOS10Later                         !(IOSVersion < 10.0)
#define IsiOS11Later                         !(IOSVersion < 11.0)

//weak
#define weak(v) __weak typeof(self) v = self

#endif /* QuickWebKitDefines_h */
