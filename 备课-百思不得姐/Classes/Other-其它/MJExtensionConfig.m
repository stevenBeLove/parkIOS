//
//  MJExtensionConfig.m
//  3期-百思不得姐
//
//  Created by xiaomage on 15/9/17.
//  Copyright (c) 2015年 xiaomage. All rights reserved.
//

#import "MJExtensionConfig.h"
#import <MJExtension.h>
#import "XMGTopic.h"

#import "XMGUser.h"
#import "XMGComment.h"

#import "XMGFollowCategory.h"

@implementation MJExtensionConfig
+ (void)load
{
    [XMGTopic setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{
                 @"ID" : @"id",
                 @"small_image" : @"image0",
                 @"middle_image" : @"image2",
                 @"large_image" : @"image1",
                 @"topComment" : @"top_cmt[0]"
                 };
    }];
    
    [XMGComment setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{@"ID" : @"id"};
    }];
    
    [XMGFollowCategory setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{@"ID" : @"id"};
    }];
}
@end
