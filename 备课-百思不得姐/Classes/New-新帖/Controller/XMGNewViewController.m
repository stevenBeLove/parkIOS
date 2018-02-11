//
//  XMGNewViewController.m
//  3期-百思不得姐
//
//  Created by xiaomage on 15/9/1.
//  Copyright (c) 2015年 xiaomage. All rights reserved.
//

#import "XMGNewViewController.h"

#import "XMGTagViewController.h"

@interface XMGNewViewController ()

@end

@implementation XMGNewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MainTitle"]];
    
    
    // 导航栏左边的内容
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"MainTagSubIcon" highImage:@"MainTagSubIconClick" target:self action:@selector(tagClick)];
    
    self.navigationItem.rightBarButtonItem = nil;
}

/**
 * 左上角按钮点击
 */
- (void)tagClick
{
    XMGTagViewController *tag = [[XMGTagViewController alloc] init];
    [self.navigationController pushViewController:tag animated:YES];
}


@end
