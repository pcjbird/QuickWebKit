//
//  QuickWebNavigationButton.m
//  QuickWebKit
//
//  Created by pcjbird on 2017/12/23.
//  Copyright © 2017年 Zero Status. All rights reserved.
//

#import "QuickWebNavigationButton.h"
#import "UIImage+QuickWeb.h"
#import "QuickWebKitDefines.h"

@implementation QuickWebNavigationButton
{
    UIImage * _icon;
    NSString * _title;
    UIColor *  _hightlightColor;
}

- (instancetype)initWithIcon:(UIImage *)icon title:(NSString *)title
{
    if(self = [super init])
    {
        _icon = icon;
        _title = title;
        _hightlightColor = nil;
        [self adjustButton];
    }
    return self;
}


-(void) adjustButton
{
    [self setTitle:_title forState:UIControlStateNormal];
    [self setImage:_icon forState:UIControlStateNormal];
    if([_icon respondsToSelector:@selector(quickweb_imageWithAlpha:)])
    {
        [self setImage:[_icon quickweb_imageWithAlpha:0.5f] forState:UIControlStateHighlighted];
        [self setImage:[_icon quickweb_imageWithAlpha:0.5f] forState:UIControlStateDisabled];
    }
    else
    {
        SDK_LOG(@"部分功能无法正常工作，请检查您的项目配置，在 'Other Linker Flags' 中添加设置 '-ObjC'。");
    }
    self.titleLabel.backgroundColor = [UIColor clearColor];
    self.adjustsImageWhenHighlighted = NO;
    self.adjustsImageWhenDisabled = NO;
    [self adjustContentInsets];
}

- (void) setFont:(UIFont *)font
{
    [self.titleLabel setFont:font];
    [self adjustContentInsets];
}

- (void) setHighlightColor:(UIColor *) color
{
    _hightlightColor = color;
    if([_hightlightColor isKindOfClass:[UIColor class]])
    {
        [self setTitleColor:[_hightlightColor colorWithAlphaComponent:0.5f] forState:UIControlStateHighlighted];
    }
}

-(void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
    self.imageView.tintColor = highlighted ? _hightlightColor : [self tintColor];
}

-(void) adjustContentInsets
{
    CGSize fitSize = [self sizeThatFits:CGSizeMake(HUGE, 40.0f)];
    self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.contentEdgeInsets = UIEdgeInsetsMake(0, -15, 0, 0);
    self.frame = CGRectMake(0, 0, fitSize.width, fitSize.height);
}

- (void)setImage:(UIImage *)image forState:(UIControlState)state
{
    if (image && [image respondsToSelector:@selector(imageWithRenderingMode:)])
    {
        image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    }
    [super setImage:image forState:state];
}

- (void)tintColorDidChange
{
    [super tintColorDidChange];
    [self setTitleColor:self.tintColor forState:UIControlStateNormal];
    [self setTitleColor:[_hightlightColor isKindOfClass:[UIColor class]] ? [_hightlightColor colorWithAlphaComponent:0.5f] : [self.tintColor colorWithAlphaComponent:0.5f] forState:UIControlStateHighlighted];
    [self setTitleColor:[self.tintColor colorWithAlphaComponent:0.5f] forState:UIControlStateDisabled];
}
@end
