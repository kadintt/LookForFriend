//
//  UIView+IHOSPEmptyView.h
//  pavohospital
//
//  Created by maoge on 2019/6/24.
//  Copyright © 2019 daoyitong. All rights reserved.
//

#import <UIKit/UIKit.h>
/** UIView的占位图类型 */
typedef NS_ENUM(NSInteger, EmptyViewType) {
    /** 没网 */
    EmptyViewTypeNoNetwork,
    /** 没检查申请 */
    EmptyViewTypeNoCheckAppointment,
    /** 没记录 */
    EmptyViewTypeNoRecord,
    /// 没订单
    EmptyViewTypeNoOrders,
    /// 没评价
    EmptyViewTypeNoComments,
    /// 没分组
    EmptyViewTypeNoGroup,
    /// 没个人回复
    EmptyViewTypeNoReply,
    /// 没聊天搜索结果
    EmptyViewTypeNoChatSearch,
    /// 没群组搜索结果
    EmptyViewTypeNoGroupSearch,
    /// 没干预计划
    EmptyViewTypeNoPlan,
    /// 没今日任务
    EmptyViewTypeNoTask,
    /// 没有群组
    EmptyViewTypeNoGroupList,
    /// 没有单聊
    EmptyViewTypeNoC2CList,
    /// 没有优惠券
    EmptyViewTypeNoCoupon,
    /// 没有推荐模板
    EmptyViewTypeNoRecommend,
};


@interface UIView (EmptyView)

/** 占位图 */
@property (nonatomic, strong, readonly) UIView *dyt_emptyView;

#pragma mark - 展示占位图
/**
 展示UIView及其子类的占位图
 
 @param type 占位图类型
 @param reloadBlock 重新加载回调的block
 */
- (void)dyt_showEmptyViewWithType:(EmptyViewType)type reloadBlock:(void(^)(void))reloadBlock;

/**
 展示UIView及其子类的占位图, 不带重新加载按钮
 
 @param type 占位图类型
 */
- (void)dyt_showEmptyViewWithType:(EmptyViewType)type show:(BOOL)show;

/**
 展示UIView及其子类的占位图, 不带重新加载按钮 带frame宽高
 
 @param type 占位图类型
 */
- (void)dyt_showEmptyViewWithType:(EmptyViewType)type clear:(BOOL)clear show:(BOOL)show;

#pragma mark - 主动移除占位图
/**
 主动移除占位图
 */
- (void)dyt_removeEmptyView;

@end

