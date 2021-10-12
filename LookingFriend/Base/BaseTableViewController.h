//
// Created by cjg on 2018/6/8.
// Copyright (c) 2018 cjg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RefreshTool.h"
#import "DCViewController.h"

typedef CGFloat (^CellHeightBlock)(UITableView *tableView, NSIndexPath *indexPath);

typedef void (^CellBlock)(UITableView *tableView, NSIndexPath *indexPath, id cell);

@interface BaseTableViewController : DCViewController <UITableViewDataSource, UITableViewDelegate, RefreshToolDelegate>

@property (nonatomic, strong) UITableView *tableView;
/** 数据源 */
@property (nonatomic, strong) NSMutableArray *dataList;
/** 刷新基类 */
@property (nonatomic, strong) RefreshTool *refreshTool;
/** cell类 */
@property (nonatomic, assign) Class cellClass;
/** cell是否xib */
@property (nonatomic, assign) BOOL isXib;
/** 默认-1, 自动计算 */
@property (nonatomic, assign) CGFloat cellHeight;
/// 是否开启下拉刷新
@property (nonatomic, assign) BOOL isEnableDownPullRefresh;
/// 是否开启上拉加载
@property (nonatomic, assign) BOOL isEnableTopPullRefresh;

- (void)reloadWithDataList:(NSArray *)dataList;

#pragma mark - 不是初始化方法

/** 优先级比cellHeight高, 时时回调 */
- (instancetype)addHeightBlock:(CellHeightBlock)heightBlock;

- (instancetype)addCellBlock:(CellBlock)cellBlock;

- (instancetype)addSelectBlock:(CellBlock)selectBlock;

@end
