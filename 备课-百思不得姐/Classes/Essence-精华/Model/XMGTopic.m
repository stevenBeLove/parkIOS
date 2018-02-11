//
//  XMGTopic.m
//  3期-百思不得姐
//
//  Created by xiaomage on 15/9/14.
//  Copyright (c) 2015年 xiaomage. All rights reserved.
//

#import "XMGTopic.h"
#import "XMGComment.h"
#import "XMGUser.h"
//#import <MJExtension.h>

@implementation XMGTopic
// 实现所有属性的归档和解档
//MJExtensionCodingImplementation

#pragma mark - getter
- (NSString *)created_at
{
    // 日期格式化类
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    
    // NSString -> NSDate
    NSDate *createdAtDate = [fmt dateFromString:_created_at];
    
    // 比较【发帖时间】和【手机当前时间】的差值
    NSDateComponents *cmps = [createdAtDate intervalToNow];
    
    if (createdAtDate.isThisYear) {
        if (createdAtDate.isToday) { // 今天
            if (cmps.hour >= 1) { // 时间差距 >= 1小时
                return [NSString stringWithFormat:@"%zd小时前", cmps.hour];
            } else if (cmps.minute >= 1) { // 1分钟 =< 时间差距 <= 59分钟
                return [NSString stringWithFormat:@"%zd分钟前", cmps.minute];
            } else {
                return @"刚刚";
            }
        } else if (createdAtDate.isYesterday) { // 昨天
            fmt.dateFormat = @"昨天 HH:mm:ss";
            return [fmt stringFromDate:createdAtDate];
        } else { // 今年的其他时间
            fmt.dateFormat = @"MM-dd HH:mm:ss";
            return [fmt stringFromDate:createdAtDate];
        }
    } else { // 非今年
        return _created_at;
    }
}

- (CGFloat)cellHeight
{
    if (_cellHeight == 0) {
        // cell的高度
        _cellHeight = XMGTopicTextY;
        
        // 计算文字的高度
        CGFloat textW = XMGScreenW - 2 * XMGCommonMargin;
        CGFloat textH = [self.text boundingRectWithSize:CGSizeMake(textW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15]} context:nil].size.height;
        _cellHeight += textH + XMGCommonMargin;
        
        // 中间内容的高度
        if (self.type != XMGTopicTypeWord) {
            CGFloat contentW = textW;
            // 图片的高度 * 内容的宽度 / 图片的宽度
            CGFloat contentH = self.height * contentW / self.width;
            if (contentH >= XMGScreenH) { // 一旦图片的显示高度超过一个屏幕，就让图片高度为200
                contentH = 200;
                self.bigPicture = YES;
            }
            
            CGFloat contentX = XMGCommonMargin;
            CGFloat contentY = _cellHeight;
            self.contentFrame = CGRectMake(contentX, contentY, contentW, contentH);
            
            _cellHeight += contentH + XMGCommonMargin;
        }
        
        // 最热评论
        if (self.topComment) {
            NSString *username = self.topComment.user.username;
            NSString *content = self.topComment.content;
            NSString *cmtText = [NSString stringWithFormat:@"%@ : %@", username, content];
            // 评论内容的高度
            CGFloat cmtTextH = [cmtText boundingRectWithSize:CGSizeMake(textW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14]} context:nil].size.height;
            
            _cellHeight += XMGTopicTopCmtTopH + cmtTextH + XMGCommonMargin;
        }
        
        // 工具条的高度
        _cellHeight += XMGTopicToolbarH + XMGCommonMargin;
    }
    
    return _cellHeight;
}
@end