//
//  QuickWebProvider.h
//  QuickWebKit
//
//  Created by pcjbird on 2017/12/23.
//  Copyright © 2017年 Zero Status. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QuickWebProvider : UILabel

@property(nonatomic, assign) CGFloat marginTop;
-(void) setProviderHost:(NSString *) hostname;

@end
