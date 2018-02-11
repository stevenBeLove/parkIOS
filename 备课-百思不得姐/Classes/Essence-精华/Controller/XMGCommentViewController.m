//
//  XMGCommentViewController.m
//  3期-百思不得姐
//
//  Created by xiaomage on 15/9/17.
//  Copyright (c) 2015年 xiaomage. All rights reserved.
//

#import "XMGCommentViewController.h"
#import "XMGTopicCell.h"
#import "XMGCommentCell.h"
#import "XMGTopic.h"
#import <MJRefresh.h>
#import <AFNetworking.h>
#import "XMGComment.h"
#import <MJExtension.h>
#import "XMGCommentHeaderView.h"
#import "XMGUser.h"

@interface XMGCommentViewController () <UITableViewDelegate, UITableViewDataSource>
/** 请求管理者 */
@property (nonatomic, weak) AFHTTPSessionManager *manager;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomSpace;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/** 暂时存储：最热评论 */
@property (nonatomic, strong) XMGComment *topComment;

/** 最热评论 */
@property (nonatomic, strong) NSArray *hotComments;
/** 最新评论（所有的评论数据） */
@property (nonatomic, strong) NSMutableArray *latestComments;

// 属性名最好不要以new开头
//@property (nonatomic, strong) NSMutableArray *newComments;

/** 写方法声明的目的是为了使用点语法提示 */
- (XMGComment *)selectedComment;
@end

@implementation XMGCommentViewController

#pragma mark - 懒加载
- (AFHTTPSessionManager *)manager
{
    if (!_manager) {
        _manager = [AFHTTPSessionManager manager];
    }
    return _manager;
}

#pragma mark - 初始化
static NSString * const XMGCommentCellId = @"comment";
static NSString * const XMGHeaderId = @"header";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"评论";
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImage:@"comment_nav_item_share_icon" highImage:@"comment_nav_item_share_icon_click" target:nil action:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    [self setupTable];
    
    [self setupRefresh];
}

- (void)setupTable
{
    self.tableView.backgroundColor = XMGCommonBgColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([XMGCommentCell class]) bundle:nil] forCellReuseIdentifier:XMGCommentCellId];
    [self.tableView registerClass:[XMGCommentHeaderView class] forHeaderFooterViewReuseIdentifier:XMGHeaderId];
    
    self.tableView.estimatedRowHeight = 100;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    // 处理模型数据
    if (self.topic.topComment) {
        self.topComment = self.topic.topComment;
        self.topic.topComment = nil;
        self.topic.cellHeight = 0;
    }
    
    // celll
    XMGTopicCell *cell = [XMGTopicCell viewFromXib];
    cell.topic = self.topic;
    cell.frame = CGRectMake(0, 0, XMGScreenW, self.topic.cellHeight);
    
    // 设置header
    UIView *header = [[UIView alloc] init];
    header.height = cell.height + 2 * XMGCommonMargin;
    [header addSubview:cell];
    
    self.tableView.tableHeaderView = header;
}

- (void)setupRefresh
{
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewComments)];
    [self.tableView.header beginRefreshing];
    
    self.tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreComments)];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    // 恢复帖子的最热评论数据
    if (self.topComment) {
        self.topic.topComment = self.topComment;
        self.topic.cellHeight = 0;
    }
}

#pragma mark - 加载评论数据
- (void)loadNewComments
{
    // 取消之前的所有请求
    [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];
    
    // 请求参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = @"dataList";
    params[@"c"] = @"comment";
    params[@"data_id"] = self.topic.ID;
    params[@"hot"] = @1;
    
    // 发送请求
    XMGWeakSelf;
    [self.manager GET:XMGRequestURL parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([responseObject isKindOfClass:[NSArray class]]) {
            // 意味着没有评论数据
            
            // 结束刷新
            [weakSelf.tableView.header endRefreshing];
            
            // 返回
            return;
        }
        
        // 最热评论
        weakSelf.hotComments = [XMGComment objectArrayWithKeyValuesArray:responseObject[@"hot"]];
        
        // 最新评论
        weakSelf.latestComments = [XMGComment objectArrayWithKeyValuesArray:responseObject[@"data"]];
        
        // 刷新表格
        [weakSelf.tableView reloadData];
        
        // 结束刷新
        [weakSelf.tableView.header endRefreshing];
        
        // 判断评论数据是否已经加载完全
        if (self.latestComments.count >= [responseObject[@"total"] intValue]) {
            // 已经完全加载完毕
//            [weakSelf.tableView.footer noticeNoMoreData];
            weakSelf.tableView.footer.hidden = YES;
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        // 结束刷新
        [weakSelf.tableView.header endRefreshing];
    }];
}

- (void)loadMoreComments
{
    // 取消之前的所有请求
    [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];
    
    // 请求参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = @"dataList";
    params[@"c"] = @"comment";
    params[@"data_id"] = self.topic.ID;
    params[@"lastcid"] = [self.latestComments.lastObject ID];
    
    // 发送请求
    XMGWeakSelf;
    [self.manager GET:XMGRequestURL parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        XMGWriteToPlist(responseObject, @"comment_more");
        // 最新评论
        NSArray *newComments = [XMGComment objectArrayWithKeyValuesArray:responseObject[@"data"]];
        [self.latestComments addObjectsFromArray:newComments];
        
        // 刷新表格
        [weakSelf.tableView reloadData];
        
        // 判断评论数据是否已经加载完全
        if (self.latestComments.count >= [responseObject[@"total"] intValue]) {
            // 已经完全加载完毕
//            [weakSelf.tableView.footer noticeNoMoreData];
            weakSelf.tableView.footer.hidden = YES;
        } else { // 应该还会有下一页数据
            // 结束刷新(恢复到普通状态，仍旧可以继续刷新)
            [weakSelf.tableView.footer endRefreshing];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        // 结束刷新
        [weakSelf.tableView.footer endRefreshing];
    }];
}

#pragma mark - 监听
- (void)keyboardWillChangeFrame:(NSNotification *)note
{
    // 工具条平移的距离 == 屏幕高度 - 键盘最终的Y值
    self.bottomSpace.constant = XMGScreenH - [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].origin.y;
    
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration:duration animations:^{
        [self.view layoutIfNeeded];
    }];
}

#pragma mark - <UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.hotComments.count) return 2;
    if (self.latestComments.count) return 1;
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0 && self.hotComments.count) {
        return self.hotComments.count;
    }
    
    return self.latestComments.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XMGCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:XMGCommentCellId];
    
    // 获得对应的评论数据
    NSArray *comments = self.latestComments;
    if (indexPath.section == 0 && self.hotComments.count) {
        comments = self.hotComments;
    }
    
    // 传递模型给cell
    cell.comment = comments[indexPath.row];
    
    return cell;
}

#pragma mark - <UITableViewDelegate>
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    XMGCommentHeaderView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:XMGHeaderId
                                           ];
    // 覆盖文字
    if (section == 0 && self.hotComments.count) {
        header.text = @"最热评论";
    } else {
        header.text = @"最新评论";
    }

    return header;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 取出cell
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    UIMenuController *menu = [UIMenuController sharedMenuController];
    
    // 设置菜单内容
    menu.menuItems = @[
                       [[UIMenuItem alloc] initWithTitle:@"顶" action:@selector(ding:)],
                       [[UIMenuItem alloc] initWithTitle:@"回复" action:@selector(reply:)],
                       [[UIMenuItem alloc] initWithTitle:@"举报" action:@selector(warn:)]
                       ];
    
    // 显示位置
    CGRect rect = CGRectMake(0, cell.height * 0.5, cell.width, 1);
    [menu setTargetRect:rect inView:cell];
    
    // 显示出来
    [menu setMenuVisible:YES animated:YES];
}

#pragma mark - 获得当前选中的评论
- (XMGComment *)selectedComment
{
    // 获得被选中的cell的行号
    NSIndexPath *indexPath = self.tableView.indexPathForSelectedRow;
    NSInteger row = indexPath.row;
    
    // 获得评论数据
    NSArray *comments = self.latestComments;
    if (indexPath.section == 0 && self.hotComments.count) {
        comments = self.hotComments;
    }
    
    return comments[row];
}

#pragma mark - UIMenuController处理
- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    if (!self.isFirstResponder) { // 文本框弹出键盘, 文本框才是第一响应者
        if (action == @selector(ding:)
            || action == @selector(reply:)
            || action == @selector(warn:)) return NO;
    }
    
    return [super canPerformAction:action withSender:sender];
}

- (void)ding:(UIMenuController *)menu
{
    XMGLog(@"ding - %@ %@",
           self.selectedComment.user.username,
           self.selectedComment.content);
}

- (void)reply:(UIMenuController *)menu
{
    XMGLog(@"reply - %@ %@",
           self.selectedComment.user.username,
           self.selectedComment.content);
}

- (void)warn:(UIMenuController *)menu
{
    XMGLog(@"warn - %@ %@",
           self.selectedComment.user.username,
           self.selectedComment.content);
}
@end
