//
// Created by cjg on 2018/6/8.
// Copyright (c) 2018 cjg. All rights reserved.
//


#import "BaseTableViewController.h"
#import "UITableViewCell+Category.h"
#import "UIColor+Category.h"
#import <SDAutoLayout/SDAutoLayout.h>

@interface BaseTableViewController ()

@property (nonatomic, copy) CellHeightBlock cellHeightBlock;

@property (nonatomic, copy) CellBlock cellBlock;

@property (nonatomic, copy) CellBlock cellSelectBlock;

@end


@implementation BaseTableViewController

- (instancetype)initWithNibName:(nullable NSString *)nibNameOrNil bundle:(nullable NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    self.cellHeight = -1;
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    _tableView.sd_layout.topSpaceToView(self.view, 0).leftSpaceToView(self.view, 0).rightSpaceToView(self.view, 0).bottomSpaceToView(self.view, 0);
    [self refreshTool];
}

- (void)reloadWithDataList:(NSArray *)dataList {
    if ([dataList isKindOfClass:[NSMutableArray class]]) {
        self.dataList = (NSMutableArray *) dataList;
    } else if ([dataList isKindOfClass:[NSArray class]]) {
        self.dataList = dataList.mutableCopy;
    } else {
        self.dataList = nil;
    }
    [self.tableView reloadData];
}

- (instancetype)addHeightBlock:(CellHeightBlock)heightBlock {
    _cellHeightBlock = heightBlock;
    return self;
}

- (instancetype)addCellBlock:(CellBlock)cellBlock {
    _cellBlock = cellBlock;
    return self;
}

- (instancetype)addSelectBlock:(CellBlock)selectBlock {
    _cellSelectBlock = selectBlock;
    return self;
}

#pragma mark - 刷新代理

- (void)refreshToolBeginDownRefreshWithScrollView:(UIScrollView *)scrollView tool:(RefreshTool *)tool {

}

- (void)refreshToolBeginUpRefreshWithScrollView:(UIScrollView *)scrollView tool:(RefreshTool *)tool {

}

#pragma mark - 表格代理

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self.cellClass cellWithTableView:tableView xib:_isXib];
    if (_cellBlock) {
        _cellBlock(tableView, indexPath, cell);
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_cellHeight < 0) {
        return [self cellHeightForIndexPath:indexPath cellContentViewWidth:tableView.bounds.size.width tableView:tableView];
    } else {
        if (_cellHeightBlock) {
            return _cellHeightBlock(tableView, indexPath);
        } else {
            return _cellHeight;
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (_cellSelectBlock) {
        _cellSelectBlock(tableView, indexPath, [tableView cellForRowAtIndexPath:indexPath]);
    }
}

#pragma mark - layz

- (void)setIsEnableTopPullRefresh:(BOOL)isEnableTopPullRefresh{
    _isEnableTopPullRefresh = isEnableTopPullRefresh;
    _refreshTool = nil;
    [self refreshTool];
}

- (void)setIsEnableDownPullRefresh:(BOOL)isEnableDownPullRefresh{
    _isEnableDownPullRefresh = isEnableDownPullRefresh;
    _refreshTool = nil;
    [self refreshTool];
}

- (UITableView *)tableView {
    if (!_tableView) {
        if (!self.cellClass) {
            self.cellClass = UITableViewCell.class;
        }
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor colorWithHex:0xFAFAFA];
        _tableView.tableFooterView = [UIView new];
        _tableView.showsVerticalScrollIndicator = false;
//        if (@available(iOS 15.0, *)) {
//            _tableView.sectionHeaderTopPadding = 0;
//        }
    }
    return _tableView;
}

- (NSMutableArray *)dataList {
    if (!_dataList) {
        _dataList = [NSMutableArray array];
    }
    return _dataList;
}

- (RefreshTool *)refreshTool {
    if (!_refreshTool) {
        _refreshTool = [[RefreshTool alloc] initWithScrollView:self.tableView delegate:self down:self.isEnableDownPullRefresh top:self.isEnableTopPullRefresh];
    }
    return _refreshTool;
}

@end
