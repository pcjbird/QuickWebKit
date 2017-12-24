//
//  QuickWebNavigationButton.h
//  QuickWebKit
//
//  Created by pcjbird on 2017/12/23.
//  Copyright © 2017年 Zero Status. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QuickWebNavigationButton : UIButton

- (instancetype)initWithIcon:(UIImage *)icon title:(NSString *)title;

- (void) setFont:(UIFont *)font;

- (void) setHighlightColor:(UIColor *) color;
@end
