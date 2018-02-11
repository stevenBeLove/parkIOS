//
//  XMGUserCell.h
//  3期-百思不得姐
//
//  Created by xiaomage on 15/9/20.
//  Copyright (c) 2015年 xiaomage. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XMGFollowUser;

@interface XMGUserCell : UITableViewCell
/** 用户模型 */
@property (nonatomic, strong) XMGFollowUser *user;
@end
