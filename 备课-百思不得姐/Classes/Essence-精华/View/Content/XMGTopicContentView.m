//
//  XMGTopicContentView.m
//  3期-百思不得姐
//
//  Created by xiaomage on 15/9/20.
//  Copyright (c) 2015年 xiaomage. All rights reserved.
//

#import "XMGTopicContentView.h"
#import "XMGSeeBigPictureViewController.h"

@interface XMGTopicContentView()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@end

@implementation XMGTopicContentView

- (void)awakeFromNib
{
    // 清空自动伸缩属性
    self.autoresizingMask = UIViewAutoresizingNone;
    
    self.imageView.userInteractionEnabled = YES;
    [self.imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageClick)]];
}

- (void)imageClick
{
    if (self.imageView.image == nil) return;
    
    XMGSeeBigPictureViewController *seeBig = [[XMGSeeBigPictureViewController alloc] init];
    seeBig.topic = self.topic;
    [self.window.rootViewController presentViewController:seeBig animated:YES completion:nil];
}

@end
