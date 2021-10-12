//
//  ViewController.m
//
//
//  Created by CJG on 16/7/25.
//  Copyright © 2016年 CJG. All rights reserved.
//

#import "ScrollControllersVc.h"
#import "CategoryHeader.h"
#import "ScrollTitleView.h"
#import <SDAutoLayout/SDAutoLayout.h>
#import "UIView+Catetory.h"

@interface ScrollControllersVc () <UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *controllersScrollView;
@end

@implementation ScrollControllersVc

- (instancetype)init {
    self = [super init];
    if (self) {
        _curIndex = 0;
    }
    return self;
}

- (instancetype)initWithControllers:(NSArray *)controllers titles:(NSArray *)titles {
    return [self initWithControllers:controllers titles:titles titleWidth:0];
}

- (instancetype)initWithControllers:(NSArray*)controllers
                             titles:(NSArray*)titles
                         titleWidth:(CGFloat)titleWidth {
    self = [self init];
    if (self) {
        self.controllers = controllers;
        self.titles = titles;
        ScrollTitleView* header = [[ScrollTitleView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 62) titles:titles titleWidth:titleWidth];
        __weak typeof(self) weakSelf = self;
        header.clickBlock = ^(NSInteger index) {
            [weakSelf scrollWithIndex:index];
        };
        self.scrollHeaderDataSource = (id<ScrollHeaderDataSource>)header;
        
    }
    return self;
}

- (instancetype)initWithControllers:(NSArray *)controllers {
    self = [self init];
    if (self) {
        self.controllers = controllers;
        NSMutableArray *titles = [NSMutableArray new];
        for (int i = 0; i < controllers.count; i++) {
            [titles addObject:@" "];
        }
        [self.scrollHeaderDataSource scrollContent].hidden = YES;
        self.titles = titles;
    }
    return self;
}

- (void)setScrollHeaderDataSource:(id<ScrollHeaderDataSource>)scrollHeaderDataSource{
    _scrollHeaderDataSource = scrollHeaderDataSource;
//    [self.topView removeFromSuperview];
    self.topView = [scrollHeaderDataSource scrollContent];
}

- (UIScrollView *)controllersScrollView {
    if (!_controllersScrollView) {
        _controllersScrollView = [[UIScrollView alloc] init];
        _controllersScrollView.bounces = NO;
        _controllersScrollView.showsHorizontalScrollIndicator = NO;
        _controllersScrollView.delegate = self;
    }
    return _controllersScrollView;
}

- (UIViewController *)curController {
    return self.controllers[_curIndex];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self addScrollView];
    [self addControllers];
    [self scrollWithIndex:_curIndex];
    [self scrollViewDidScroll:self.controllersScrollView];
}

- (void)updateTitles:(NSArray *)titles {
    _titles = titles;
    [self scrollWithScrollView:_controllersScrollView];
}

- (void)updateControllers:(NSArray *)controllers titles:(NSArray *)titles {
    for (UIView *view in self.view.subviews) {
        [view removeFromSuperview];
    }
    for (UIViewController *vc in self.childViewControllers) {
        [vc removeFromParentViewController];
    }
    // todo更新操作
    [[self.scrollHeaderDataSource scrollContent] removeAllSubviews];
    [self.controllersScrollView removeAllSubviews];
    [self addScrollView];
    self.controllers = controllers;
    [self addControllers];
    _curIndex = 0;
    self.titles = titles;
    [self scrollWithIndex:_curIndex];
    [self scrollViewDidScroll:self.controllersScrollView];
}

- (void)addScrollView {
    [self.view addSubview:self.controllersScrollView];
    [self.view addSubview:[self.scrollHeaderDataSource scrollContent]];
    self.controllersScrollView.sd_layout
    .topSpaceToView([self.scrollHeaderDataSource scrollContent], 0)
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .bottomSpaceToView(self.view, 0);
}

- (void)addControllers {
    for (int i = 0; i < _controllers.count; i++) {
        [self addChildViewController:_controllers[i]];
    }
    _controllersScrollView.contentSize = CGSizeMake(self.view.width_sd * self.childViewControllers.count, 0);
}

- (void)lableOnclic:(UITapGestureRecognizer *)tap {
    NSInteger index = tap.view.tag;
    [self scrollWithIndex:index - 1];
}

- (void)scrollWithIndex:(NSInteger)index {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (index >= self.controllers.count) {
            return;
        }
        self.curIndex = index;
        UIViewController *vc = self.childViewControllers[index];
        [self.controllersScrollView setContentOffset:CGPointMake((index) * self.view.width_sd, 0) animated:true];
        if (![vc isViewLoaded] || vc.view.superview != self.controllersScrollView) {
            [self.controllersScrollView addSubview:vc.view];
            [self.controllersScrollView updateLayout];
            vc.view.sd_layout
            .topEqualToView(self.controllersScrollView)
            .bottomEqualToView(self.controllersScrollView)
            .widthRatioToView(self.controllersScrollView, 1)
            .leftSpaceToView(self.controllersScrollView, self.controllersScrollView.width_sd * index);
        }
        if ([self.scrollHeaderDataSource respondsToSelector:@selector(scrollDidIndex:controller:)]) {
            [self.scrollHeaderDataSource scrollDidIndex:index controller:self];
        }
        if (self.selectBack) {
            self.selectBack(@(index));
        }
    });
}

#pragma mark - scrollView代理

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat scale = scrollView.contentOffset.x / scrollView.width;
    if (scrollView.contentOffset.x == 0) {
        scale = 0;
    }
    if ([self.scrollHeaderDataSource respondsToSelector:@selector(scrollDidProgress:controller:)]) {
        [self.scrollHeaderDataSource scrollDidProgress:scale controller:self];
    }
    if (scale >= 0 && scale <= self.controllers.count - 1) {
        if (self.scaleBack) {
            self.scaleBack(@(scale));
        }
    }
//    if (scale<0) {
//        scale = 0.0; // 处理边缘
//    }
//    if (scale>self.controllers.count) {
//        scale = self.controllers.count;
//    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        [self scrollWithScrollView:scrollView];
    }
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    CGFloat offx = scrollView.contentOffset.x;
    CGFloat width = self.view.frame.size.width;
    NSInteger index = -1;
    if (offx < 0) {
        index = 0;
    } else if (offx > self.childViewControllers.count * width - width) {
        index = self.childViewControllers.count - 1;
    } else {
        if (offx - _curIndex * width < 0 && _curIndex > 0) {
            index = _curIndex - 1;
        } else {
            if (_curIndex < self.controllers.count - 1 && offx != 0) {
                index = _curIndex + 1;
            }
        }
    }
    if (index > -1) {
        [self scrollWithIndex:index];
    }
}

- (void)scrollWithScrollView:(UIScrollView *)scrollView {
    NSInteger index;
    CGPoint offset = scrollView.contentOffset;
    if (offset.x <= 0) {
        index = 0;
    } else if (offset.x >= (scrollView.contentSize.width)) {
        index = self.childViewControllers.count - 1;
    } else {
        index = (int)offset.x / self.view.width_sd;
        CGFloat x = offset.x - index * self.view.width_sd;
        if (x > self.view.width_sd * 0.5) {
            index++;
        }
    }
    [self scrollWithIndex:index];
}

- (void)dealloc {
    NSLog(@"循环滚动控制器 ====== 销毁了");
}

- (void)isDisableSpan:(BOOL)disable {
    self.controllersScrollView.scrollEnabled = !disable;
}

- (void)titleItemActionDisable:(BOOL)disable {
    ScrollTitleView *titleView = (ScrollTitleView *)self.scrollHeaderDataSource;
    titleView.userInteractionEnabled = !disable;
}

@end
