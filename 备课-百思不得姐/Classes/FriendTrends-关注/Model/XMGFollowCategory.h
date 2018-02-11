//
//  XMGFollowCategory.h
//  3期-百思不得姐
//
//  Created by xiaomage on 15/9/20.
//  Copyright (c) 2015年 xiaomage. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XMGFollowCategory : NSObject
/** id */
@property (nonatomic, copy) NSString *ID;
/** 名字 */
@property (nonatomic, copy) NSString *name;

/** 这组的用户总数 */
@property (nonatomic, assign) NSInteger total;
/** 当前的页码 */
@property (nonatomic, assign) NSInteger page;
/** 这个类别对应的用户数据 */
@property (nonatomic, strong) NSMutableArray *users;
@end
