//
//  XMGClearCacheCell.m
//  3期-百思不得姐
//
//  Created by xiaomage on 15/9/7.
//  Copyright (c) 2015年 xiaomage. All rights reserved.
//

#import "XMGClearCacheCell.h"
#import <SVProgressHUD.h>

/** 缓存路径 */
#define XMGCacheFile [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"default"]

//#define XMGMyCachesFile ((NSString *)[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject])

static NSString * const XMGDefaultText = @"清除缓存";

@implementation XMGClearCacheCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
//        XMGLog(@"%zd", XMGMyCachesFile.length);
//        XMGLog(@"%zd", XMGCacheFile.length);
        
        self.textLabel.text = XMGDefaultText;
        
        // 禁止点击事件
        self.userInteractionEnabled = NO;
        
        // 右边显示圈圈
        UIActivityIndicatorView *loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [loadingView startAnimating];
        self.accessoryView = loadingView;
        
        // 计算大小
        [[[NSOperationQueue alloc] init] addOperationWithBlock:^{
            // 计算缓存大小
            NSInteger size = XMGCacheFile.fileSize;
            CGFloat unit = 1000.0;
            NSString *sizeText = nil;
            if (size >= unit * unit * unit) { // >= 1GB
                sizeText = [NSString stringWithFormat:@"%.1fGB", size / unit / unit / unit];
            } else if (size >= unit * unit) { // >= 1MB
                sizeText = [NSString stringWithFormat:@"%.1fMB", size / unit / unit];
            } else if (size >= unit) { // >= 1KB
                sizeText = [NSString stringWithFormat:@"%.1fKB", size / unit];
            } else { // >= 0B
                sizeText = [NSString stringWithFormat:@"%zdB", size];
            }
            NSString *text = [NSString stringWithFormat:@"%@(%@)", XMGDefaultText, sizeText];
            
            // 回到主线程
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                self.textLabel.text = text;
                self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                self.accessoryView = nil;
                // 允许点击事件
                self.userInteractionEnabled = YES;
            }];
        }];
    }
    return self;
}

- (void)updateStatus
{
    if (self.accessoryView == nil) return;
    
    // 让圈圈继续旋转
    UIActivityIndicatorView *loadingView = (UIActivityIndicatorView *)self.accessoryView;
    [loadingView startAnimating];
}

- (void)clearCache
{
    [SVProgressHUD showWithStatus:@"正在清除缓存" maskType:SVProgressHUDMaskTypeBlack];
    
    [[[NSOperationQueue alloc] init] addOperationWithBlock:^{
        [[NSFileManager defaultManager] removeItemAtPath:XMGCacheFile error:nil];
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [SVProgressHUD showSuccessWithStatus:@"清除成功"];
            
            self.textLabel.text = XMGDefaultText;
            
            // 禁止点击事件
            self.userInteractionEnabled = NO;
        }];
    }];
}

@end
