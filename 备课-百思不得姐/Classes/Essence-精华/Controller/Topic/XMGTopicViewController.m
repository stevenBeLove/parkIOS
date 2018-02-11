//
//  XMGTopicViewController.m
//  3期-百思不得姐
//
//  Created by xiaomage on 15/9/13.
//  Copyright (c) 2015年 xiaomage. All rights reserved.
//

#import "XMGTopicViewController.h"
#import <AFNetworking.h>
#import "XMGTopic.h"
#import <MJExtension.h>
#import <MJRefresh.h>
#import "XMGMyFooter.h"
#import "XMGTopicCell.h"
#import "XMGCommentViewController.h"
#import "XMGNewViewController.h"

@interface XMGTopicViewController ()
/** 请求管理者 */
@property (nonatomic, weak) AFHTTPSessionManager *manager;
/** 所有的帖子数据 */
@property (nonatomic, strong) NSMutableArray *topics;
/** 用来加载下一页数据 */
@property (nonatomic, copy) NSString *maxtime;
@end

@implementation XMGTopicViewController

/**
 * 实现这个方法仅仅是为了消除警告（因为子类的type方法最终会覆盖父类的这个方法）
 */
- (XMGTopicType)type { return 0; }

static NSString * const XMGTopicCellId = @"topic";

#pragma mark - 懒加载
- (AFHTTPSessionManager *)manager
{
    if (!_manager) {
        _manager = [AFHTTPSessionManager manager];
    }
    return _manager;
}

#pragma mark - 初始化
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupTable];
    
    [self setupRefresh];
}

- (void)setupTable
{
    self.tableView.backgroundColor = XMGCommonBgColor;
    self.tableView.contentInset = UIEdgeInsetsMake(XMGNavBarMaxY + XMGTitlesViewH, 0, XMGTabBarH, 0);
    self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
    // 去掉分割线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    // 注册
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([XMGTopicCell class]) bundle:nil] forCellReuseIdentifier:XMGTopicCellId];
}

- (void)setupRefresh
{
    // 下拉刷新
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewTopics)];
    // 自动改变透明度
    self.tableView.header.automaticallyChangeAlpha = YES;
    // 马上进入刷新状态
    [self.tableView.header beginRefreshing];
    
    // 上拉刷新
    self.tableView.footer = [XMGMyFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreTopics)];
}

- (NSString *)aParam
{
    // [a isKindOfClass:c] 判断a是否为c类型或者c的子类类型
    if ([self.parentViewController isKindOfClass:[XMGNewViewController class]]) {
        return @"newlist";
    }
    
    return @"list";
}

/**
 * 加载最新的帖子数据
 */
- (void)loadNewTopics
{
    // 取消之前的所有请求
    [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];
    
    // 请求参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = self.aParam;
    params[@"c"] = @"data";
    params[@"type"] = @(self.type);
    
    // 发送请求
    XMGWeakSelf;
    [self.manager GET:XMGRequestURL parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        // 字典数组 -> 模型数组
        weakSelf.topics = [XMGTopic objectArrayWithKeyValuesArray:responseObject[@"list"]];
        
        // 存储maxtime
        weakSelf.maxtime = responseObject[@"info"][@"maxtime"];
        
        // 刷新表格
        [weakSelf.tableView reloadData];
        
        // 结束刷新
        [weakSelf.tableView.header endRefreshing];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        // 结束刷新
        [weakSelf.tableView.header endRefreshing];
    }];
}

/**
 * 加载更多的帖子数据
 */
- (void)loadMoreTopics
{
    // 取消之前的所有请求
    [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];
    
    // 请求参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = self.aParam;
    params[@"c"] = @"data";
    params[@"type"] = @(self.type);
    params[@"maxtime"] = self.maxtime;
    
    // 发送请求
    XMGWeakSelf;
    [self.manager GET:XMGRequestURL parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        // 字典数组 -> 模型数组
        NSArray *moreTopics = [XMGTopic objectArrayWithKeyValuesArray:responseObject[@"list"]];
        [weakSelf.topics addObjectsFromArray:moreTopics];
        
        // 存储maxtime
        weakSelf.maxtime = responseObject[@"info"][@"maxtime"];
        
        // 刷新表格
        [weakSelf.tableView reloadData];
        
        // 结束刷新
        [weakSelf.tableView.footer endRefreshing];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        // 结束刷新
        [weakSelf.tableView.footer endRefreshing];
    }];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.topics.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XMGTopicCell *cell = [tableView dequeueReusableCellWithIdentifier:XMGTopicCellId];
    
    cell.topic = self.topics[indexPath.row];
    
    return cell;
}

#pragma mark - 代理方法
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 在这个方法中，已经将cell的高度 和 中间内容的frame 计算完毕
    XMGTopic *topic = self.topics[indexPath.row];
    return topic.cellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    XMGCommentViewController *comment = [[XMGCommentViewController alloc] init];
    comment.topic = self.topics[indexPath.row];
    [self.navigationController pushViewController:comment animated:YES];
}
@end
