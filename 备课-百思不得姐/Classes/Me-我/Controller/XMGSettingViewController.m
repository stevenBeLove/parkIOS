//
//  XMGSettingViewController.m
//  3期-百思不得姐
//
//  Created by xiaomage on 15/9/1.
//  Copyright (c) 2015年 xiaomage. All rights reserved.
//

#import "XMGSettingViewController.h"
#import <SDImageCache.h>
#import "XMGClearCacheCell.h"
#import "XMGThirdCell.h"

@interface XMGSettingViewController ()

@end

@implementation XMGSettingViewController

static NSString * const XMGClearCacheCellId = @"clearCache";
static NSString * const XMGOtherCellId = @"other";
static NSString * const XMGThirdCellId = @"third";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"设置";
    self.view.backgroundColor = XMGCommonBgColor;
    
    [self.tableView registerClass:[XMGClearCacheCell class] forCellReuseIdentifier:XMGClearCacheCellId];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:XMGOtherCellId];
    [self.tableView registerClass:[XMGThirdCell class] forCellReuseIdentifier:XMGThirdCellId];
    
    // 设置内边距(-25代表：所有内容往上移动25)
    self.tableView.contentInset = UIEdgeInsetsMake(XMGCommonMargin - 35, 0, 0, 0);
}

#pragma mark - <数据源>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0) { // 清除缓存的cell
        XMGClearCacheCell *cell = [tableView dequeueReusableCellWithIdentifier:XMGClearCacheCellId];
        [cell updateStatus];
        return cell;
    } else if (indexPath.section == 1 && indexPath.row == 2) {
        return [tableView dequeueReusableCellWithIdentifier:XMGThirdCellId];
    } else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:XMGOtherCellId];
        cell.textLabel.text = [NSString stringWithFormat:@"%zd - %zd", indexPath.section, indexPath.row];
        return cell;
    }
}

#pragma mark - <代理>
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 取消选中
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // 清除缓存
    XMGClearCacheCell *cell = (XMGClearCacheCell *)[tableView cellForRowAtIndexPath:indexPath];
    [cell clearCache];
}
@end
