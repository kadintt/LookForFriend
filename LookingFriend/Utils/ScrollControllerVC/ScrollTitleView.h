//
//  ScrollTitleView.h
//  DaoyitongCode
//
//  Created by chenjg on 2019/9/16.
//  Copyright © 2019 爱康国宾. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ScrollTitleView : UIView

/// 点击回调
@property (nonatomic, copy) void(^clickBlock)(NSInteger index);
/// 选中字体, 默认24
@property (nonatomic, assign) CGFloat maxFontSize;
/// 非选中字体, 默认14
@property (nonatomic, assign) CGFloat minFontSize;

- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titles;

- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titles titleWidth:(CGFloat)titleWidth;
/// 主动滚动到某个元素
- (void)scrollToIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
