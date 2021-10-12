//
//  RefreshTool.h
//  YH-IOS
//
//  Created by cjg on 2017/7/24.
//  Copyright © 2017年 com.intfocus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RefreshToolDownPullHeader.h"
#import "RefreshToolUpPullFooter.h"

NS_ASSUME_NONNULL_BEGIN

@class RefreshTool;

@protocol RefreshToolDelegate <NSObject>

@optional
/**
 * 下拉刷新回调
 * @param scrollView 刷新的视图
 * @param tool 刷新的工具类
 */
- (void)refreshToolBeginDownRefreshWithScrollView:(UIScrollView *)scrollView
                                             tool:(RefreshTool *)tool;
/**
 * 上拉加载回调
 * @param scrollView 刷新的视图
 * @param tool 刷新的工具类
 */
- (void)refreshToolBeginUpRefreshWithScrollView:(UIScrollView *)scrollView
                                           tool:(RefreshTool *)tool;
@end

@protocol RefreshToolDataSource

/// 是否有下一页
- (BOOL)isNextPages;

/// 这次刷新是否成功, 判断页码使用
- (BOOL)isRefreshSuccess;

@end

@interface RefreshTool : NSObject

@property(nonatomic, weak) id <RefreshToolDelegate> __nullable delegate;
@property(nonatomic, weak) UIScrollView *scrollView;
@property(nonatomic, weak) MJRefreshStateHeader *downPullHeader;
@property(nonatomic, weak) MJRefreshAutoStateFooter *upPullFooter;

@property(nonatomic, assign) NSInteger page;
/// 是否自动管理分页, 默认Yes
@property(nonatomic, assign) BOOL isAutoPage;

/**
 * 初始化方法
 * @param scrollView scrollView
 * @param delegate delegate
 * @param down 是否下拉
 * @param top 是否上拉
 * @return RefreshTool class
 */
- (instancetype)initWithScrollView:(UIScrollView *)scrollView
                          delegate:(id <RefreshToolDelegate> __nullable)delegate
                              down:(BOOL)down
                               top:(BOOL)top;

/** 开始下拉 */
- (void)beginDownPull;

/** 封装页码, 网络结束后直接传model */
- (void)endRefreshWithModel:(id <RefreshToolDataSource> __nullable)model;

/** 回滚page操作, 当网络调用失败的时候调用 */
- (void)revertPage;

/** 结束刷新 */
- (void)endRefresh;

/**
 * 结束下拉刷新
 * @param reload 是否需要刷新数据
 */
- (void)endDownPullWithReload:(BOOL)reload;

/**
 * 结束上拉加载
 * @param reload 是否需要刷新数据
 * @param noMore 是否还有下一页
 */
- (void)endTopPullWithReload:(BOOL)reload
                      noMore:(BOOL)noMore;

/**
 * 结束刷新基础方法
 * @param downPullEnd end
 * @param topPullEnd end
 * @param reload reload
 * @param noMore noMore
 */
- (void)endRefreshDownPullEnd:(BOOL)downPullEnd
                   topPullEnd:(BOOL)topPullEnd
                       reload:(BOOL)reload
                       noMore:(BOOL)noMore;


@end

NS_ASSUME_NONNULL_END
