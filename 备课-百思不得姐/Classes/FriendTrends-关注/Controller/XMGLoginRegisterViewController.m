//
//  XMGLoginRegisterViewController.m
//  3期-百思不得姐
//
//  Created by xiaomage on 15/9/2.
//  Copyright (c) 2015年 xiaomage. All rights reserved.
//

#import "XMGLoginRegisterViewController.h"
#import "XMGLoginRegisterTextField.h"
#import "XMGTopWindow.h"

@interface XMGLoginRegisterViewController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftSpace;
@end

@implementation XMGLoginRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [XMGTopWindow hide];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [XMGTopWindow show];
}

- (IBAction)close {
    [self dismissViewControllerAnimated:YES completion:nil];
}

/**
 * 让状态栏样式为白色
 */
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (IBAction)loginOrRegister:(UIButton *)button {
    // 修改约束
    if (self.leftSpace.constant == 0) {
        self.leftSpace.constant = - self.view.width;
        button.selected = YES;
//        [button setTitle:@"已有帐号？" forState:UIControlStateNormal];
    } else {
        self.leftSpace.constant = 0;
        button.selected = NO;
//        [button setTitle:@"注册帐号" forState:UIControlStateNormal];
    }
    
    [UIView animateWithDuration:0.25 animations:^{
        [self.view layoutIfNeeded];
    }];
}
@end
