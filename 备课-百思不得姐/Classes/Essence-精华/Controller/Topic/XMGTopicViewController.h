//
//  XMGTopicViewController.h
//  3期-百思不得姐
//
//  Created by xiaomage on 15/9/20.
//  Copyright (c) 2015年 xiaomage. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XMGTopic.h"

@interface XMGTopicViewController : UITableViewController
/** 帖子的类型 */
- (XMGTopicType)type;
//@property (nonatomic, assign) XMGTopicType type;
//@property (nonatomic, assign, readonly) XMGTopicType type;
@end

/**
 控制器Z
 - (void)test1;
 - (void)test2;
 - (void)test3;
 
 控制器A : 控制器Z
 - (void)aTest;
 
 控制器B : 控制器Z
 - (void)bTest;
 
 控制器C : 控制器Z
 - (void)cTest;
 
 控制器D : 控制器Z
 - (void)dTest;
 */

/**
 控制器Z : UIViewController
 - (void)test1;
 - (void)test2;
 - (void)test3;
 
 控制器A : 控制器Z
 - 创建一个tableView
 - (void)aTest;
 
 控制器B : 控制器Z
 - (void)bTest;
 
 控制器C : 控制器Z
 - 创建一个collectionView
 - (void)cTest;
 
 控制器D : 控制器Z
 - (void)dTest;
 
 XMGZZZView : UIView
 
 XMGAbcView  : XMGZZZView
 
 XMGDDDView  : XMGZZZView
 
 XMGEEEView  : XMGZZZView
 */
