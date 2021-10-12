//
//  UITableViewCell+Category.h
//  DaoyitongCode
//
//  Created by cjg on 2018/8/6.
//  Copyright © 2018年 爱康国宾. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

static NSString *indexPathKey = @"indexPath";

static NSInteger backViewTag = 564631231;

@interface UITableViewCell (CCAdd)

@property(nonatomic, strong) NSIndexPath *indexPath;

/**
 * 初始化cell方法
 * @param tableView cell注册的tableView
 * @param xib 是否是xib, xib的名字必须和类名相同
 * @return cell实例
 */
+ (instancetype)cellWithTableView:(UITableView *)tableView
                              xib:(BOOL)xib;

@end

@interface UICollectionViewCell (CCAdd)

@property(nonatomic, strong) NSIndexPath *indexPath;

+ (instancetype)cellWithCollectionView:(UICollectionView *)collectionView
                             indexPath:(NSIndexPath *)indexPath
                                   xib:(BOOL)xib;

@end

@interface UITableViewCell (RoundShadow)

// 导医通设置阴影圆角 cornerRadius = 8; edgeInsets = UIEdgeInsetsMake(4, 16, 4, 16)
- (void)setCellRoundShadowDefault;
// 导医通设置阴影圆角
- (void)setCellRoundShadow:(CGFloat)cornerRadius;
// 导医通设置阴影圆角 边距
- (void)setCellRoundShadow:(CGFloat)cornerRadius edgeInsets:(UIEdgeInsets)edgeInsets;
// 导医通设置阴影圆角 边距 阴影颜色
- (void)setCellRoundShadow:(CGFloat)cornerRadius edgeInsets:(UIEdgeInsets)edgeInsets shadowColor:(UIColor *)shadowColor;
/// 缩进tableviewCell contentView
- (void)setCellRetractDYT;

@end

@interface UICollectionViewCell (RoundShadow)

// 导医通设置阴影圆角 cornerRadius = 8; edgeInsets = UIEdgeInsetsMake(4, 16, 4, 16)
- (void)setCellRoundShadowDefault;
// 导医通设置阴影圆角
- (void)setCellRoundShadow:(CGFloat)cornerRadius;

- (void)setCellRoundShadow:(CGFloat)cornerRadius edgeInsets:(UIEdgeInsets)edgeInsets;
/// 缩进tableviewCell contentView
- (void)setCellRetractDYT;

@end
