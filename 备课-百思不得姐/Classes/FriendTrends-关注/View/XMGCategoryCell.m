//
//  XMGCategoryCell.m
//  3期-百思不得姐
//
//  Created by xiaomage on 15/9/20.
//  Copyright (c) 2015年 xiaomage. All rights reserved.
//

#import "XMGCategoryCell.h"
#import "XMGFollowCategory.h"

@interface XMGCategoryCell()
/** 左边的选中指示器 */
@property (weak, nonatomic) IBOutlet UIView *selectedIndicator;
@end

@implementation XMGCategoryCell

- (void)awakeFromNib
{
    // 清除文字背景色（这样就不会挡住分割线）
    self.textLabel.backgroundColor = [UIColor clearColor];
}

/**
 * 这个方法可以用来监听cell的选中和取消选中
 */
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    self.textLabel.textColor = selected ? [UIColor redColor] : [UIColor darkGrayColor];
    self.selectedIndicator.hidden = !selected;
}

- (void)setCategory:(XMGFollowCategory *)category
{
    _category = category;
    
    // 设置文字
    self.textLabel.text = category.name;
}

@end
