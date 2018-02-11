//
//  XMGMeFooter.m
//  3期-百思不得姐
//
//  Created by xiaomage on 15/9/7.
//  Copyright (c) 2015年 xiaomage. All rights reserved.
//

#import "XMGMeFooter.h"
#import <AFNetworking.h>
#import "XMGSquare.h"
#import <MJExtension.h>
#import "XMGSquareButton.h"
#import "XMGWebViewController.h"

@implementation XMGMeFooter

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        // 请求参数
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"a"] = @"square";
        params[@"c"] = @"topic";
        
        // 发送请求
        XMGWeakSelf;
        [[AFHTTPSessionManager manager] GET:XMGRequestURL parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
            [weakSelf createSquares:[XMGSquare objectArrayWithKeyValuesArray:responseObject[@"square_list"]]];
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            
        }];
    }
    return self;
}

/**
 * 创建方块
 */
- (void)createSquares:(NSArray *)squares
{
    // 每行的列数
    int colsCount = 4;
    
    // 按钮尺寸
    CGFloat buttonW = self.width / colsCount;
    CGFloat buttonH = buttonW;
    
    // 遍历所有的模型
    NSUInteger count = squares.count;
    for (NSUInteger i = 0; i < count; i++) {
        // 创建按钮
        XMGSquareButton *button = [XMGSquareButton buttonWithType:UIButtonTypeCustom];
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        
        // frame
        CGFloat buttonX = (i % colsCount) * buttonW;
        CGFloat buttonY = (i / colsCount) * buttonH;
        button.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
        
        // 设置模型数据
        button.square = squares[i];
        
        // 设置footer的高度
        self.height = CGRectGetMaxY(button.frame);
    }
    
    // 重新设置footerView
    UITableView *tableView = (UITableView *)self.superview;
    tableView.tableFooterView = self;
    //tableView.contentSize = CGSizeMake(0, CGRectGetMaxY(self.frame));
}

- (void)buttonClick:(XMGSquareButton *)button
{
    if ([button.square.url hasPrefix:@"http"] == NO) return;
    
    XMGWebViewController *webVc = [[XMGWebViewController alloc] init];
    webVc.square = button.square;
    
    // 取出当前选中的导航控制器
    UITabBarController *rootVc = (UITabBarController *)self.window.rootViewController;
    UINavigationController *nav = (UINavigationController *)rootVc.selectedViewController;
    [nav pushViewController:webVc animated:YES];
}

@end
