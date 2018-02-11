//
//  XMGTopWindow.m
//  备课-百思不得姐
//
//  Created by MJ Lee on 15/9/22.
//  Copyright © 2015年 小码哥. All rights reserved.
//

#import "XMGTopWindow.h"
#import "XMGTopWindowViewController.h"

@implementation XMGTopWindow

static UIWindow *window_;

+ (void)initialize
{
    window_ = [[self alloc] init];
}

+ (void)show
{
    window_.hidden = NO;
    window_.backgroundColor = [UIColor clearColor];
}

+ (void)hide
{
    window_.hidden = YES;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.windowLevel = UIWindowLevelAlert;
        self.rootViewController = [[XMGTopWindowViewController alloc] init];
    }
    return self;
}

- (void)setFrame:(CGRect)frame
{
    frame = [UIApplication sharedApplication].statusBarFrame;
    [super setFrame:frame];
}

@end
