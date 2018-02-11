//
//  XMGTopicCell.m
//  3期-百思不得姐
//
//  Created by xiaomage on 15/9/14.
//  Copyright (c) 2015年 xiaomage. All rights reserved.
//

#import "XMGTopicCell.h"
#import "XMGTopic.h"
#import "XMGTopicPictureView.h"
#import "XMGTopicVideoView.h"
#import "XMGTopicVoiceView.h"
#import "XMGComment.h"
#import "XMGUser.h"

@interface XMGTopicCell()
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *createdAtLabel;
@property (weak, nonatomic) IBOutlet UILabel *text_label;
@property (weak, nonatomic) IBOutlet UIButton *dingButton;
@property (weak, nonatomic) IBOutlet UIButton *caiButton;
@property (weak, nonatomic) IBOutlet UIButton *repostButton;
@property (weak, nonatomic) IBOutlet UIButton *commentButton;
/** 图片 */
@property (nonatomic, weak) XMGTopicPictureView *pictureView;
/** 视频 */
@property (nonatomic, weak) XMGTopicVideoView *videoView;
/** 声音 */
@property (nonatomic, weak) XMGTopicVoiceView *voiceView;

/** 最热评论-整体 */
@property (weak, nonatomic) IBOutlet UIView *topCmtView;
/** 最热评论-文字内容 */
@property (weak, nonatomic) IBOutlet UILabel *topCmtLabel;
@end

@implementation XMGTopicCell

- (XMGTopicPictureView *)pictureView
{
    if (!_pictureView) {
        XMGTopicPictureView *pictureView = [XMGTopicPictureView viewFromXib];
        [self.contentView addSubview:pictureView];
        _pictureView = pictureView;
    }
    return _pictureView;
}

- (XMGTopicVideoView *)videoView
{
    if (!_videoView) {
        XMGTopicVideoView *videoView = [XMGTopicVideoView viewFromXib];
        [self.contentView addSubview:videoView];
        _videoView = videoView;
    }
    return _videoView;
}

- (XMGTopicVoiceView *)voiceView
{
    if (!_voiceView) {
        XMGTopicVoiceView *voiceView = [XMGTopicVoiceView viewFromXib];
        [self.contentView addSubview:voiceView];
        _voiceView = voiceView;
    }
    return _voiceView;
}

- (void)awakeFromNib
{
    // 设置cell的背景图片
    self.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mainCellBackground"]];
}

/**
 * 调用比较频繁
 */
- (void)setTopic:(XMGTopic *)topic
{
    _topic = topic;
    
    [self.profileImageView setHeader:topic.profile_image];
    self.nameLabel.text = topic.name;
    self.createdAtLabel.text = topic.created_at;
    self.text_label.text = topic.text;
    
    // 设置底部工具条的数字
    [self setupButtonTitle:self.dingButton number:topic.ding placeholder:@"顶"];
    [self setupButtonTitle:self.caiButton number:topic.cai placeholder:@"踩"];
    [self setupButtonTitle:self.repostButton number:topic.repost placeholder:@"分享"];
    [self setupButtonTitle:self.commentButton number:topic.comment placeholder:@"评论"];
    
    // 根据帖子的类型决定中间的内容
    if (topic.type == XMGTopicTypePicture) { // 图片
        
        self.videoView.hidden = YES;
        self.voiceView.hidden = YES;
        self.pictureView.hidden = NO;
        self.pictureView.frame = topic.contentFrame;
        self.pictureView.topic = topic;
        
    } else if (topic.type == XMGTopicTypeVoice) { // 声音
        
        self.pictureView.hidden = YES;
        self.videoView.hidden = YES;
        self.voiceView.hidden = NO;
        self.voiceView.frame = topic.contentFrame;
        self.voiceView.topic = topic;
        
    } else if (topic.type == XMGTopicTypeVideo) { // 视频
        
        self.pictureView.hidden = YES;
        self.voiceView.hidden = YES;
        self.videoView.hidden = NO;
        self.videoView.frame = topic.contentFrame;
        self.videoView.topic = topic;
        
    } else if (topic.type == XMGTopicTypeWord) { // 文字
        
        self.pictureView.hidden = YES;
        self.videoView.hidden = YES;
        self.voiceView.hidden = YES;
        
    }
    
    // 最热评论
    if (topic.topComment) {
        self.topCmtView.hidden = NO;
        NSString *username = topic.topComment.user.username;
        NSString *content = topic.topComment.content;
        self.topCmtLabel.text = [NSString stringWithFormat:@"%@ : %@", username, content];
    } else {
        self.topCmtView.hidden = YES;
    }
}

/**
 * 设置工具条按钮的文字
 */
- (void)setupButtonTitle:(UIButton *)button number:(NSInteger)number placeholder:(NSString *)placeholder
{
    if (number >= 10000) {
        [button setTitle:[NSString stringWithFormat:@"%.1f万", number / 10000.0] forState:UIControlStateNormal];
    } else if (number > 0) {
        [button setTitle:[NSString stringWithFormat:@"%zd", number] forState:UIControlStateNormal];
    } else {
        [button setTitle:placeholder forState:UIControlStateNormal];
    }
}

- (void)setFrame:(CGRect)frame
{
    frame.origin.y += XMGCommonMargin;
    frame.size.height -= XMGCommonMargin;
    
    [super setFrame:frame];
}

- (IBAction)moreClick {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"收藏" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        XMGLog(@"收藏");
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"举报" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        XMGLog(@"举报");
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        XMGLog(@"取消");
    }]];
    
    [self.window.rootViewController presentViewController:alert animated:YES completion:nil];
}

/**
 1.cell的高度
 2.图片控件的frame
 3.图片控件的内容
 */

@end
