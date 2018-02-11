//
//  XMGFriendTrendsViewController.m
//  3期-百思不得姐
//
//  Created by xiaomage on 15/9/1.
//  Copyright (c) 2015年 xiaomage. All rights reserved.
//

#import "XMGFriendTrendsViewController.h"
#import "XMGLoginRegisterViewController.h"
#import "XMGRecommendFollowViewController.h"

@interface XMGFriendTrendsViewController ()

@end

@implementation XMGFriendTrendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = XMGCommonBgColor;
    
    self.navigationItem.title = @"我的关注";
    
    // 导航栏左边的内容
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"friendsRecommentIcon" highImage:@"friendsRecommentIcon-click" target:self action:@selector(friendsRecommendClick)];
}

- (void)friendsRecommendClick
{
    XMGRecommendFollowViewController *follow = [[XMGRecommendFollowViewController alloc] init];
    [self.navigationController pushViewController:follow animated:YES];
}

- (IBAction)loginRegister {
    XMGLoginRegisterViewController *loginRegister = [[XMGLoginRegisterViewController alloc] init];
    [self presentViewController:loginRegister animated:YES completion:nil];
}
@end
