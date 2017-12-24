//
//  QuickWebToastPlugin.m
//  QuickWebKit
//
//  Created by pcjbird on 2017/12/23.
//  Copyright © 2017年 Zero Status. All rights reserved.
//

#import "QuickWebToastPlugin.h"
#import <Toast/Toast.h>

@implementation QuickWebToastPlugin

-(NSString *)name
{
    return @"QuickWebToastPlugin";
}

-(void)setName:(NSString *)name
{
    
}

-(void)webViewController:(QuickWebViewController *)webViewController didFailLoadWithError:(NSError *)error
{
    if ([error isKindOfClass:[NSError class]])
    {
        if(error.code!= NSURLErrorCancelled)
        {
            [webViewController.view makeToast:error.localizedDescription];
        }
    }
}
@end
