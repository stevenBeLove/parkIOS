//
//  XMGTagViewController.m
//  3期-百思不得姐
//
//  Created by xiaomage on 15/9/1.
//  Copyright (c) 2015年 xiaomage. All rights reserved.
//

#import "XMGTagViewController.h"
#import "XMGTagCell.h"
#import <AFNetworking.h>
#import <MJExtension.h>
#import "XMGTag.h"
#import <SVProgressHUD.h>

@interface XMGTagViewController ()
/** 所有的标签数据（里面存放的都是XMGTag模型） */
@property (nonatomic, strong) NSArray *tags;
/** 请求管理者 */
@property (nonatomic, weak) AFHTTPSessionManager *manager;
@end

@implementation XMGTagViewController

/** cell的循环利用标识 */
static NSString * const XMGTagCellId = @"tag";

- (AFHTTPSessionManager *)manager
{
    if (!_manager) {
        _manager = [AFHTTPSessionManager manager];
    }
    return _manager;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"推荐标签";
    
    [self setupTable];
    
    [self loadTags];
}

- (void)setupTable
{
    self.tableView.backgroundColor = XMGCommonBgColor;
    // 设置行高
    self.tableView.rowHeight = 70;
    
    // 去掉系统自带的分割线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([XMGTagCell class]) bundle:nil] forCellReuseIdentifier:XMGTagCellId];
}

- (void)loadTags
{
    // 弹框
    [SVProgressHUD show];
    
    // 加载标签数据
    // 请求参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = @"tag_recommend";
    params[@"action"] = @"sub";
    params[@"c"] = @"topic";
    
    // 发送请求
    XMGWeakSelf;
    [self.manager GET:XMGRequestURL parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        if (responseObject == nil) {
            // 关闭弹框
            [SVProgressHUD showErrorWithStatus:@"加载标签数据失败"];
            return;
        }
        
        // responseObject：字典数组
        // weakSelf.tags：模型数组
        // responseObject -> weakSelf.tags
        weakSelf.tags = [XMGTag objectArrayWithKeyValuesArray:responseObject];
        
        // 刷新表格
        [weakSelf.tableView reloadData];
        
        // 关闭弹框
        [SVProgressHUD dismiss];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        // 如果是取消了任务，就不算请求失败，就直接返回
        if (error.code == NSURLErrorCancelled) return;
        
        if (error.code == NSURLErrorTimedOut) {
            // 关闭弹框
            [SVProgressHUD showErrorWithStatus:@"加载标签数据超时，请稍后再试！"];
        } else {
            // 关闭弹框
            [SVProgressHUD showErrorWithStatus:@"加载标签数据失败"];
        }
    }];
}

- (void)dealloc
{
    // 停止请求
    [self.manager invalidateSessionCancelingTasks:YES];
    
    [SVProgressHUD dismiss];
}

#pragma mark - <UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tags.count;
}

/**
 * 返回indexPath位置对应的cell
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XMGTagCell *cell = [tableView dequeueReusableCellWithIdentifier:XMGTagCellId];
    
    cell.tagModel = self.tags[indexPath.row];
    
    return cell;
}
@end
