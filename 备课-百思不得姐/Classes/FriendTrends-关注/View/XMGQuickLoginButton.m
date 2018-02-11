//
//  XMGQuickLoginButton.m
//  3期-百思不得姐
//
//  Created by xiaomage on 15/9/2.
//  Copyright (c) 2015年 xiaomage. All rights reserved.
//

#import "XMGQuickLoginButton.h"

@implementation XMGQuickLoginButton

- (void)awakeFromNib
{
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 调整图片的位置和尺寸
    self.imageView.y = 0;
    self.imageView.centerX = self.width * 0.5;
    
    // 调整文字的位置和尺寸
    self.titleLabel.x = 0;
    self.titleLabel.y = self.imageView.height;
    self.titleLabel.width = self.width;
    self.titleLabel.height = self.height - self.titleLabel.y;
}
@end
