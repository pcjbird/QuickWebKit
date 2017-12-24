//
//  QuickWebProvider.m
//  QuickWebKit
//
//  Created by pcjbird on 2017/12/23.
//  Copyright © 2017年 Zero Status. All rights reserved.
//

#import "QuickWebProvider.h"
#import "UIScrollView+QuickWebProviderPlugin.h"

#define PLUGIN_BUNDLE [NSBundle bundleWithPath:[[NSBundle bundleForClass:[QuickWebProvider class]] pathForResource:@"QuickWebProviderPlugin" ofType:@"bundle"]]

@interface QuickWebProvider()
{
}
@property(nonatomic, weak) UIScrollView* scrollView;

@end

@implementation QuickWebProvider

-(instancetype)init
{
    if(self = [super init])
    {
        _marginTop = 20.0f;
    }
    return self;
}

-(void) setProviderHost:(NSString *) hostname
{
    self.text = [NSString stringWithFormat:NSLocalizedStringFromTableInBundle(@"WebProviderFormat", @"Localizable", PLUGIN_BUNDLE, nil), hostname];
    [self sizeToFit];
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    
    // 如果不是UIScrollView，不做任何事情
    if (newSuperview && ![newSuperview isKindOfClass:[UIScrollView class]]) return;
    
    // 旧的父控件移除监听
    [self removeObservers];
    
    if (newSuperview) { // 新的父控件
        // 记录UIScrollView
        _scrollView = (UIScrollView *)newSuperview;
        // 设置永远支持垂直弹簧效果
        _scrollView.alwaysBounceVertical = YES;
        // 添加监听
        [self addObservers];
    }
}

-(void)layoutSubviews
{
    if([self.scrollView isKindOfClass:[UIScrollView class]])
    {
        self.center = CGPointMake(CGRectGetWidth(self.scrollView.bounds)/2.0f, self.scrollView.contentOffset.y + _marginTop);
        [self.superview sendSubviewToBack:self];
    }
    [super layoutSubviews];
}

- (void)addObservers
{
    NSKeyValueObservingOptions options = NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld;
    [self.scrollView addObserver:self forKeyPath:@"contentOffset" options:options context:nil];
}

- (void)removeObservers
{
    [self.superview removeObserver:self forKeyPath:@"contentOffset"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (self.hidden) return;
    if ([keyPath isEqualToString:@"contentOffset"]) {
        [self scrollViewContentOffsetDidChange:change];
    }
}

- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change
{
    [self layoutSubviews];
}

@end
