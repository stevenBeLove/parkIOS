//
//  XMGTopicPictureView.m
//  3期-百思不得姐
//
//  Created by xiaomage on 15/9/16.
//  Copyright (c) 2015年 xiaomage. All rights reserved.
//

#import "XMGTopicPictureView.h"
#import "XMGTopic.h"
#import <UIImageView+WebCache.h>
#import <DALabeledCircularProgressView.h>

@interface XMGTopicPictureView()
@property (weak, nonatomic) IBOutlet UIImageView *gifView;
@property (weak, nonatomic) IBOutlet UIButton *seeBigPictureButton;

@property (weak, nonatomic) IBOutlet DALabeledCircularProgressView *progressView;
@end

@implementation XMGTopicPictureView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.progressView.roundedCorners = 5;
    self.progressView.progressLabel.textColor = [UIColor whiteColor];
}

- (void)setTopic:(XMGTopic *)topic
{
    [super setTopic:topic];
    
    // 下载图片
    XMGWeakSelf;
    [_imageView sd_setImageWithURL:[NSURL URLWithString:topic.large_image] placeholderImage:nil options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        // 每下载一点图片数据，就会调用一次这个block
        weakSelf.progressView.hidden = NO;
        weakSelf.progressView.progress = 1.0 * receivedSize / expectedSize;
        weakSelf.progressView.progressLabel.text = [NSString stringWithFormat:@"%.0f%%", weakSelf.progressView.progress * 100];
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        // 当图片下载完毕后，就会调用这个block
        weakSelf.progressView.hidden = YES;
    }];
    
    // gif
    self.gifView.hidden = !topic.is_gif;
    
    // see big
    self.seeBigPictureButton.hidden = !topic.isBigPicture;
    if (topic.isBigPicture) {
        _imageView.contentMode = UIViewContentModeTop;
        _imageView.clipsToBounds = YES;
    } else {
        _imageView.contentMode = UIViewContentModeScaleToFill;
        _imageView.clipsToBounds = NO;
    }
}

@end
