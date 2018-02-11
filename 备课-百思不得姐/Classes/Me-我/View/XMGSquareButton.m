//
//  XMGSquareButton.m
//  3期-百思不得姐
//
//  Created by xiaomage on 15/9/7.
//  Copyright (c) 2015年 xiaomage. All rights reserved.
//

#import "XMGSquareButton.h"
#import "XMGSquare.h"
#import <UIButton+WebCache.h>

@implementation XMGSquareButton

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.font = [UIFont systemFontOfSize:14];
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self setBackgroundImage:[UIImage imageNamed:@"mainCellBackground"] forState:UIControlStateNormal];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.imageView.width = self.width * 0.5;
    self.imageView.height = self.imageView.width;
    self.imageView.y = self.height * 0.1;
    self.imageView.centerX = self.width * 0.5;
    
    self.titleLabel.width = self.width;
    self.titleLabel.y = CGRectGetMaxY(self.imageView.frame);
    self.titleLabel.x = 0;
    self.titleLabel.height = self.height - self.titleLabel.y;
}

- (void)setSquare:(XMGSquare *)square
{
    _square = square;
    
    // 数据
    [self setTitle:square.name forState:UIControlStateNormal];
    // 设置按钮的image
    [self sd_setImageWithURL:[NSURL URLWithString:square.icon] forState:UIControlStateNormal];
}
@end
