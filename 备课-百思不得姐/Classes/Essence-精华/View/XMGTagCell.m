//
//  XMGTagCell.m
//  3期-百思不得姐
//
//  Created by xiaomage on 15/9/6.
//  Copyright (c) 2015年 xiaomage. All rights reserved.
//

#import "XMGTagCell.h"
#import "XMGTag.h"
#import <UIImageView+WebCache.h>

@interface XMGTagCell()
@property (weak, nonatomic) IBOutlet UIImageView *imageListView;
@property (weak, nonatomic) IBOutlet UILabel *themeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *subNumberLabel;
@end

@implementation XMGTagCell

/**
 * 重写这个方法的目的：拦截cell的frame设置
 */
- (void)setFrame:(CGRect)frame
{
    frame.size.height -= 1;
    
    [super setFrame:frame];
}

- (void)setTagModel:(XMGTag *)tagModel
{
    _tagModel = tagModel;
    
    // 设置头像
    [self.imageListView setHeader:tagModel.image_list];
    
    self.themeNameLabel.text = tagModel.theme_name;
    
    // 订阅数
    if (tagModel.sub_number >= 10000) {
        self.subNumberLabel.text = [NSString stringWithFormat:@"%.1f万人订阅", tagModel.sub_number / 10000.0];
    } else {
        self.subNumberLabel.text = [NSString stringWithFormat:@"%zd人订阅", tagModel.sub_number];
    }
}

@end
