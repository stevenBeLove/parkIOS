//
//  XMGTag.h
//  3期-百思不得姐
//
//  Created by xiaomage on 15/9/6.
//  Copyright (c) 2015年 xiaomage. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XMGTag : NSObject
/** 图片 */
@property (nonatomic, copy) NSString *image_list;
/** 订阅数 */
@property (nonatomic, assign) NSInteger sub_number;
/** 名字 */
@property (nonatomic, copy) NSString *theme_name;
@end
