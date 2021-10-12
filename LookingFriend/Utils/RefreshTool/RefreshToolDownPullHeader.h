//
//  RefreshToolDownPullHeader.h
//  YH-IOS
//
//  Created by cjg on 2017/7/24.
//  Copyright © 2017年 com.intfocus. All rights reserved.
//

#import <MJRefresh/MJRefresh.h>

@interface RefreshToolDownPullHeader : MJRefreshNormalHeader


/// 设置刷新头部忽略高度偏移(主要适配X用)
/// @param inset 偏移数值
- (void)setTopInset:(CGFloat)inset;
- (void)setJsonName:(NSString *)jsonName;

@end

