//
//  XMGMeViewController.m
//  3期-百思不得姐
//
//  Created by xiaomage on 15/9/1.
//  Copyright (c) 2015年 xiaomage. All rights reserved.
//

#import "XMGMeViewController.h"
#import "XMGSettingViewController.h"
#import "XMGMeCell.h"
#import "XMGMeFooter.h"

@interface XMGMeViewController ()

@end

@implementation XMGMeViewController

static NSString * const XMGMeCellId = @"me";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNav];
    
    [self setupTable];
}

- (void)setupTable
{
    self.tableView.backgroundColor = XMGCommonBgColor;
    [self.tableView registerClass:[XMGMeCell class] forCellReuseIdentifier:XMGMeCellId];
    self.tableView.sectionHeaderHeight = 0;
    self.tableView.sectionFooterHeight = XMGCommonMargin;
    // 设置内边距(-25代表：所有内容往上移动25)
    self.tableView.contentInset = UIEdgeInsetsMake(XMGCommonMargin - 35, 0, -20, 0);
    // 设置footer
    self.tableView.tableFooterView = [[XMGMeFooter alloc] init];
}

- (void)setupNav
{
    self.navigationItem.title = @"我的";
    
    // 导航栏右边的内容
   
    UIBarButtonItem *moonItem = [UIBarButtonItem itemWithImage:[UIImage imageNamed:@"mine-moon-icon"] selImage:[UIImage imageNamed:@"mine-moon-icon-click"] targer:self action:@selector(moonClick:)];
    
    UIBarButtonItem *settingItem = [UIBarButtonItem itemWithImage:@"mine-setting-icon" highImage:@"mine-setting-icon-click" target:self action:@selector(settingClick)];
    
    self.navigationItem.rightBarButtonItems = @[settingItem, moonItem]; 
}

- (void)moonClick:(UIButton *)btn
{
    btn.selected = !btn.selected;
    XMGLogFunc;
}

- (void)settingClick
{
    XMGSettingViewController *setting = [[XMGSettingViewController alloc] initWithStyle:UITableViewStyleGrouped];
    [self.navigationController pushViewController:setting animated:YES];
}

#pragma mark - <数据源>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XMGMeCell *cell = [tableView dequeueReusableCellWithIdentifier:XMGMeCellId];
    
    if (indexPath.section == 0) {
        cell.textLabel.text = @"登录/注册";
        cell.imageView.image = [UIImage imageNamed:@"setup-head-default"];
    } else {
        cell.textLabel.text = @"离线下载";
    }
    
    return cell;
}

@end
