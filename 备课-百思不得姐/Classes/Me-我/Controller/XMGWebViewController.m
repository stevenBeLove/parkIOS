//
//  XMGWebViewController.m
//  3期-百思不得姐
//
//  Created by xiaomage on 15/9/7.
//  Copyright (c) 2015年 xiaomage. All rights reserved.
//

#import "XMGWebViewController.h"
#import "XMGSquare.h"

@interface XMGWebViewController () <UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *backItem;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *forwardItem;
@end

@implementation XMGWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = self.square.name;
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.square.url]]];
    
    self.webView.backgroundColor = XMGCommonBgColor;
    self.webView.scrollView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
}

- (IBAction)back {
    [self.webView goBack];
}

- (IBAction)forward {
    [self.webView goForward];
}

- (IBAction)refresh {
    [self.webView reload];
}

#pragma mark - <UIWebViewDelegate>
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    self.backItem.enabled = webView.canGoBack;
    self.forwardItem.enabled = webView.canGoForward;
}
@end
