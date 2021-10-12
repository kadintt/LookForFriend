//
//  RefreshTool.m
//  YH-IOS
//
//  Created by cjg on 2017/7/24.
//  Copyright © 2017年 com.intfocus. All rights reserved.
//

#import "RefreshTool.h"
#import <SDAutoLayout/SDAutoLayout.h>
#import "RefreshToolDownPullHeader.h"

#define DefaultPage 1
#define NoMoreMessage @"没有更多了"

@interface RefreshTool ()

@property(nonatomic, weak) UITableView *tableView;
@property(nonatomic, weak) UICollectionView *collectionView;
/// 记录上一次的页码, 给网络失败的时候回滚用
@property(nonatomic, assign) NSInteger lastPage;

@end

@implementation RefreshTool

- (instancetype)init {
    self = [super init];
    if (self) {
        self.page = DefaultPage;
        self.lastPage = DefaultPage;
        self.isAutoPage = true;
    }
    return self;
}


- (instancetype)initWithScrollView:(UIScrollView *)scrollView delegate:(id <RefreshToolDelegate>)delegate down:(BOOL)down top:(BOOL)top {
    if (self = [self init]) {
        if (down) {
            [self addDownPullHeaderWithScrollView:scrollView delegate:delegate];
        }
        if (top) {
            [self addTopPullHeaderWithScrollView:scrollView delegate:delegate];
        }
    }
    return self;
}

- (void)addDownPullHeaderWithScrollView:(UIScrollView *)scrollView delegate:(id <RefreshToolDelegate>)delegate {
    _delegate = delegate;
    self.scrollView = scrollView;
    __weak typeof(self) weakSelf = self;;
    
    
    RefreshToolDownPullHeader *head = [RefreshToolDownPullHeader headerWithRefreshingBlock:^{
        if (weakSelf.isAutoPage) {
            weakSelf.page = 1;
        }
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(refreshToolBeginDownRefreshWithScrollView:tool:)]) {
            [weakSelf.delegate refreshToolBeginDownRefreshWithScrollView:weakSelf.scrollView tool:weakSelf];
        }
    }];
    
      [head setJsonName:@"roundloadingpart1"];
    _scrollView.mj_header = head;
}

- (void)addTopPullHeaderWithScrollView:(UIScrollView *)scrollView delegate:(id <RefreshToolDelegate>)delegate {
    _delegate = delegate;
    self.scrollView = scrollView;
    __weak typeof(self) weakSelf = self;;
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        if (weakSelf.isAutoPage) {
            weakSelf.page += 1;
        }
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(refreshToolBeginUpRefreshWithScrollView:tool:)]) {
            [weakSelf.delegate refreshToolBeginUpRefreshWithScrollView:weakSelf.scrollView tool:weakSelf];
        }
    }];
    footer.triggerAutomaticallyRefreshPercent = -1;
    [footer setTitle:@"" forState:MJRefreshStateNoMoreData];
    _scrollView.mj_footer = footer;
    _scrollView.mj_footer.hidden = YES;

    
}

- (void)beginDownPull {
    if (_scrollView.mj_footer) {
        _scrollView.mj_footer.hidden = true;
    }
    if (_scrollView.mj_header) {
        [_downPullHeader beginRefreshing];
    }
}

- (void)endRefreshWithModel:(id <RefreshToolDataSource>)model {
    if (model.isRefreshSuccess) {
        self.lastPage = self.page;
        [self endRefreshDownPullEnd:true topPullEnd:true reload:false noMore:!model.isNextPages];
    } else{
        [self revertPage];
        [self endRefreshDownPullEnd:true topPullEnd:true reload:false noMore:self.upPullFooter.state == MJRefreshStateNoMoreData];
    }
}

/** 回滚page操作, 当网络调用失败的时候调用 */
- (void)revertPage{
    self.page = self.lastPage;
}

- (void)endRefresh {
    [self endRefreshDownPullEnd:YES topPullEnd:YES reload:NO noMore:NO];
}

- (void)endRefreshDownPullEnd:(BOOL)downPullEnd topPullEnd:(BOOL)topPullEnd reload:(BOOL)reload noMore:(BOOL)noMore {
    if (downPullEnd) {
        [_scrollView.mj_header endRefreshing];
    }
    if (topPullEnd) {
        if (noMore) {
            [_scrollView.mj_footer endRefreshingWithNoMoreData];
            UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"no_more_data"]];
            imageView.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width - 122) * 0.5, (44 - 12 ) * 0.5, 122, 12);
            [_scrollView.mj_footer addSubview:imageView];
            NSLog(@"_scrollView.mj_footer.subviews-->%@",_scrollView.mj_footer.subviews);
        } else {
            [_scrollView.mj_footer endRefreshing];
        }
    }
    if (reload) {
        [self reloadScrollView];
    }
    if (_scrollView.mj_footer) { //防止刚出来的时候footer显示
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t) (0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self->_scrollView.mj_footer.hidden = self->_scrollView.mj_contentH < self->_scrollView.height;
//            if (_tableView) {
//
//                _upPullFooter.hidden = !(_tableView.numberOfSections > 0 && [_tableView numberOfRowsInSection:0] > 5);
//            }
//            if (_collectionView) {
//                _upPullFooter.hidden = _collectionView.visibleCells.count < 5;
//            }
        });
    }
}

- (void)endDownPullWithReload:(BOOL)reload {
    [self endRefreshDownPullEnd:YES topPullEnd:NO reload:reload noMore:NO];
}

- (void)endTopPullWithReload:(BOOL)reload noMore:(BOOL)noMore {
    [self endRefreshDownPullEnd:NO topPullEnd:YES reload:reload noMore:noMore];

}

- (void)reloadScrollView {
    [_tableView reloadData];
    [_collectionView reloadData];
}


#pragma mark - lazy init and set

- (void)setScrollView:(UIScrollView *)scrollView {
    _scrollView = scrollView;
    if ([scrollView isKindOfClass:[UITableView class]]) {
        _tableView = (UITableView *) scrollView;
    }
    if ([scrollView isKindOfClass:[UICollectionView class]]) {
        _collectionView = (UICollectionView *) scrollView;
    }
}

//- (MJRefreshNormalHeader *)downPullHeader {
//    if (!_downPullHeader) {
//        __weak typeof(self) weakSelf = self;;
//        _downPullHeader = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//            if (weakSelf.isAutoPage) {
//                weakSelf.page = 1;
//            }
//            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(refreshToolBeginDownRefreshWithScrollView:tool:)]) {
//                [weakSelf.delegate refreshToolBeginDownRefreshWithScrollView:weakSelf.scrollView tool:weakSelf];
//            }
//        }];
//        _downPullHeader.lastUpdatedTimeLabel.hidden = YES;
//
//    }
//    return _downPullHeader;
//}

//- (MJRefreshAutoNormalFooter *)upPullFooter {
//    if (!_upPullFooter) {
//        __weak typeof(self) weakSelf = self;;
//        _upPullFooter = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
//            if (weakSelf.isAutoPage) {
//                weakSelf.page += 1;
//            }
//            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(refreshToolBeginUpRefreshWithScrollView:tool:)]) {
//                [weakSelf.delegate refreshToolBeginUpRefreshWithScrollView:weakSelf.scrollView tool:weakSelf];
//            }
//        }];
//        _upPullFooter.triggerAutomaticallyRefreshPercent = -1;
//        [_upPullFooter setTitle:@"" forState:MJRefreshStateNoMoreData];
//        _upPullFooter.hidden = YES;
//    }
//    return _upPullFooter;
//}

@end
