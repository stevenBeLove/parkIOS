//
//  XMGEssenceViewController.m
//  3期-百思不得姐
//
//  Created by xiaomage on 15/9/1.
//  Copyright (c) 2015年 xiaomage. All rights reserved.
//

#import "XMGEssenceViewController.h"

#import "XMGTitleButton.h"
#import "XMGAllViewController.h"
#import "XMGVideoViewController.h"
#import "XMGVoiceViewController.h"
#import "XMGPictureViewController.h"
#import "XMGWordViewController.h"

@interface XMGEssenceViewController () <UIScrollViewDelegate>
/** 这个scrollView的作用：存放所有子控制器的view */
@property (nonatomic, weak) UIScrollView *scrollView;
/** 标题栏 */
@property (nonatomic, weak) UIView *titlesView;
/** 当前被选中的按钮 */
@property (nonatomic, weak) XMGTitleButton *selectedTitleButton;
/** 标题栏底部的指示器 */
@property (nonatomic, weak) UIView *titleBottomView;
/** 存放所有的标签按钮 */
@property (nonatomic, strong) NSMutableArray *titleButtons;
@end

@implementation XMGEssenceViewController

#pragma mark - lazy
- (NSMutableArray *)titleButtons
{
    if (!_titleButtons) {
        _titleButtons = [NSMutableArray array];
    }
    return _titleButtons;
}

#pragma mark - 初始化
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNav];
    
    [self setupChildVcs];
    
    [self setupScrollView];
    
    [self setupTitlesView];
}

- (void)setupChildVcs
{
    XMGAllViewController *all = [[XMGAllViewController alloc] init];
    all.title = @"全部";
    [self addChildViewController:all];
    
    XMGVideoViewController *video = [[XMGVideoViewController alloc] init];
    video.title = @"视频";
    [self addChildViewController:video];
    
    XMGVoiceViewController *voice = [[XMGVoiceViewController alloc] init];
    voice.title = @"声音";
    [self addChildViewController:voice];
    
    XMGPictureViewController *picture = [[XMGPictureViewController alloc] init];
    picture.title = @"图片";
    [self addChildViewController:picture];
    
    XMGWordViewController *word = [[XMGWordViewController alloc] init];
    word.title = @"段子";
    [self addChildViewController:word];
}

- (void)setupTitlesView
{
    // 标签栏整体
    UIView *titlesView = [[UIView alloc] init];
    titlesView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.7];
    titlesView.frame = CGRectMake(0, XMGNavBarMaxY, self.view.width, XMGTitlesViewH);
    [self.view addSubview:titlesView];
    self.titlesView = titlesView;
    
    // 标签栏内部的标签按钮
    NSUInteger count = self.childViewControllers.count;
    CGFloat titleButtonH = titlesView.height;
    CGFloat titleButtonW = titlesView.width / count;
    for (int i = 0; i < count; i++) {
        // 创建
        XMGTitleButton *titleButton = [XMGTitleButton buttonWithType:UIButtonTypeCustom];
        [titleButton addTarget:self action:@selector(titleClick:) forControlEvents:UIControlEventTouchUpInside];
        [titlesView addSubview:titleButton];
        [self.titleButtons addObject:titleButton];
        
        // 文字
        NSString *title = [self.childViewControllers[i] title];
        [titleButton setTitle:title forState:UIControlStateNormal];
        
        // frame
        titleButton.y = 0;
        titleButton.height = titleButtonH;
        titleButton.width = titleButtonW;
        titleButton.x = i * titleButton.width;
    }
    
    // 标签栏底部的指示器控件
    UIView *titleBottomView = [[UIView alloc] init];
    titleBottomView.backgroundColor = [self.titleButtons.lastObject titleColorForState:UIControlStateSelected];
    titleBottomView.height = 1;
    titleBottomView.y = titlesView.height - titleBottomView.height;
    [titlesView addSubview:titleBottomView];
    self.titleBottomView = titleBottomView;
    
    // 默认点击最前面的按钮
    XMGTitleButton *firstTitleButton = self.titleButtons.firstObject;
    [firstTitleButton.titleLabel sizeToFit];
    titleBottomView.width = firstTitleButton.titleLabel.width;
    titleBottomView.centerX = firstTitleButton.centerX;
    [self titleClick:firstTitleButton];
}

- (void)setupScrollView
{
    // 不要自动调整scrollView的contentInset
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.frame = self.view.bounds;
    scrollView.backgroundColor = XMGCommonBgColor;
    scrollView.delegate = self;
    scrollView.pagingEnabled = YES;
    scrollView.contentSize = CGSizeMake(self.childViewControllers.count * self.view.width, 0);
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
    
    // 默认显示第0个控制器
    [self scrollViewDidEndScrollingAnimation:scrollView];
}

- (void)setupNav
{
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MainTitle"]];
    
    // 导航栏左边的内容
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"nav_item_game_icon" highImage:@"nav_item_game_click_icon" target:self action:@selector(game)];
    
    // 导航栏右边内容
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImage:@"navigationButtonRandom" highImage:@"navigationButtonRandomClick" target:nil action:nil];
}

- (void)game
{
    
}

#pragma mark - 监听
- (void)titleClick:(XMGTitleButton *)titleButton
{
    // 控制按钮状态
    self.selectedTitleButton.selected = NO;
    titleButton.selected = YES;
    self.selectedTitleButton = titleButton;
    
    // 底部控件的位置和尺寸
    [UIView animateWithDuration:0.25 animations:^{
        self.titleBottomView.width = titleButton.titleLabel.width;
        self.titleBottomView.centerX = titleButton.centerX;
    }];
    
    // 让scrollView滚动到对应的位置
    CGPoint offset = self.scrollView.contentOffset;
    offset.x = self.view.width * [self.titleButtons indexOfObject:titleButton];
    [self.scrollView setContentOffset:offset animated:YES];
}


#pragma mark - <UIScrollViewDelegate>
/**
 * 当滚动动画完毕的时候调用（通过代码setContentOffset:animated:让scrollView滚动完毕后，就会调用这个方法）
 * 如果执行完setContentOffset:animated:后，scrollView的偏移量并没有发生改变的话，就不会调用scrollViewDidEndScrollingAnimation:方法
 */
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    // 取出对应的子控制器
    int index = scrollView.contentOffset.x / scrollView.width;
    UIViewController *willShowChildVc = self.childViewControllers[index];
    
    // 如果控制器的view已经被创建过，就直接返回
    if (willShowChildVc.isViewLoaded) return;
    
    // 添加子控制器的view到scrollView身上
    willShowChildVc.view.frame = scrollView.bounds;
    [scrollView addSubview:willShowChildVc.view];
}

/**
 * 当减速完毕的时候调用（人为拖拽scrollView，手松开后scrollView慢慢减速完毕到静止）
 */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self scrollViewDidEndScrollingAnimation:scrollView];
    
    // 点击按钮
    int index = scrollView.contentOffset.x / scrollView.width;
    [self titleClick:self.titleButtons[index]];
}

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//
//}
@end
