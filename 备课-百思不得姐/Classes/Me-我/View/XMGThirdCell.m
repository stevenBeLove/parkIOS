//
//  XMGThirdCell.m
//  3期-百思不得姐
//
//  Created by xiaomage on 15/9/7.
//  Copyright (c) 2015年 xiaomage. All rights reserved.
//

#import "XMGThirdCell.h"

@implementation XMGThirdCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.textLabel.text = @"第三种cell";
        self.backgroundColor = [UIColor redColor];
        [self.contentView addSubview:[[UISwitch alloc] init]];
    }
    return self;
}
@end
