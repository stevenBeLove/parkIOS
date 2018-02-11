//
//  BSAdItem.h
//  01-BuDeJie
//
//  Created by yz on 15/12/16.
//  Copyright © 2015年 yz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BSAdItem : NSObject

// 广告图片
@property (nonatomic, strong) NSString *w_picurl;

// 广告图片尺寸
@property (nonatomic, assign) CGFloat w;

// 广告图片尺寸
@property (nonatomic, assign) CGFloat h;

// 点击广告跳转的界面
@property (nonatomic, strong) NSString *ori_curl;

@end
