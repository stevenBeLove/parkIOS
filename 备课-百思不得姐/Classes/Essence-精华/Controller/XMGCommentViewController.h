//
//  XMGCommentViewController.h
//  3期-百思不得姐
//
//  Created by xiaomage on 15/9/17.
//  Copyright (c) 2015年 xiaomage. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XMGTopic;

@interface XMGCommentViewController : UIViewController
/** 帖子模型 */
@property (nonatomic, strong) XMGTopic *topic;
@end
