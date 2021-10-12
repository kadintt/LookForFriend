//
//  UITableViewCell+Category.m
//  DaoyitongCode
//
//  Created by cjg on 2018/8/6.
//  Copyright © 2018年 爱康国宾. All rights reserved.
//

#import "UITableViewCell+Category.h"
#import "YCShadowView.h"
#import <SDAutoLayout/SDAutoLayout.h>
#import <objc/runtime.h>
#import "LookingFriend-Swift.h"

@implementation UITableViewCell (CCAdd)

- (NSIndexPath *)indexPath {
    return objc_getAssociatedObject(self, &indexPathKey);
}

- (void)setIndexPath:(NSIndexPath *)indexPath {
    objc_setAssociatedObject(self, &indexPathKey, indexPath, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (instancetype)cellWithTableView:(UITableView *)tableView xib:(BOOL)xib {
    NSString *identifier = [NSStringFromClass(self) componentsSeparatedByString:@"."].lastObject;
    if (xib) {
        static NSString *tableViewNib = @"tableViewNib";
        BOOL isNib = [objc_getAssociatedObject(tableView, &tableViewNib) boolValue];
        if (!isNib) {
            UINib *nib = [UINib nibWithNibName:identifier bundle:nil];
            [tableView registerNib:nib forCellReuseIdentifier:identifier];
            objc_setAssociatedObject(tableView, &tableView, @(YES), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
    }
    id cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        if (!xib) {
            cell = [[self alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
    }
    return cell;
}

@end

@implementation UICollectionViewCell (CCAdd)

+ (instancetype)cellWithCollectionView:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath xib:(BOOL)xib {
    NSString *identifier = [NSStringFromClass(self) componentsSeparatedByString:@"."].lastObject;
    if (!xib) {
        [collectionView registerClass:self forCellWithReuseIdentifier:identifier];
    } else {
        [collectionView registerNib:[UINib nibWithNibName:identifier bundle:nil] forCellWithReuseIdentifier:identifier];
    }
    return [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
}

- (NSIndexPath *)indexPath {
    return objc_getAssociatedObject(self, &indexPathKey);
}

- (void)setIndexPath:(NSIndexPath *)indexPath {
    objc_setAssociatedObject(self, &indexPathKey, indexPath, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end

@implementation UITableViewCell (RoundShadow)

- (void)setCellRoundShadowDefault {
    [self setCellRoundShadow:4 edgeInsets:UIEdgeInsetsMake(4, 16, 4, 16)];
}

- (void)setCellRoundShadow:(CGFloat)cornerRadius {
    [self setCellRoundShadow:cornerRadius edgeInsets:UIEdgeInsetsMake(4, 16, 4, 16)];
}



- (void)setCellRoundShadow:(CGFloat)cornerRadius edgeInsets:(UIEdgeInsets)edgeInsets {
    [self setCellRoundShadow:cornerRadius edgeInsets:UIEdgeInsetsMake(4, 16, 4, 16) shadowColor:[UIColor colorWithWhite:0 alpha:0.05]];

}

- (void)setCellRoundShadow:(CGFloat)cornerRadius edgeInsets:(UIEdgeInsets)edgeInsets shadowColor:(UIColor *)shadowColor {
    // 缩进
    self.contentView.sd_layout.spaceToSuperView(edgeInsets);
    self.contentView.layer.cornerRadius = cornerRadius;
    self.contentView.layer.masksToBounds = YES;
    self.backgroundColor = UIColor.dyt_background;
    self.contentView.backgroundColor = UIColor.whiteColor;

    // 阴影
    YCShadowView *backView = [self viewWithTag:backViewTag];
    if (backView == nil) {
        backView = [[YCShadowView alloc] initWithFrame:self.contentView.bounds];
        [self insertSubview:backView atIndex:0];
        [backView yc_shaodwRadius:cornerRadius shadowColor:shadowColor shadowOffset:CGSizeMake(0, 0) byShadowSide:YCShadowSideAllSides];
        [backView yc_cornerRadius:cornerRadius];
    }
    [self sendSubviewToBack:backView];
    backView.sd_layout.spaceToSuperView(edgeInsets);
    [backView updateLayout];
}

/// 缩进tableviewCell contentView
- (void)setCellRetractDYT {
    self.contentView.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 16, 0, 16));
    self.backgroundColor = UIColor.dyt_background;
    self.contentView.backgroundColor = UIColor.whiteColor;
}

@end

@implementation UICollectionViewCell (RoundShadow)

- (void)setCellRoundShadowDefault {
    [self setCellRoundShadow:8 edgeInsets:UIEdgeInsetsMake(4, 16, 4, 16)];
}

- (void)setCellRoundShadow:(CGFloat)cornerRadius {
    [self setCellRoundShadow:cornerRadius edgeInsets:UIEdgeInsetsMake(4, 16, 4, 16)];
}

- (void)setCellRoundShadow:(CGFloat)cornerRadius edgeInsets:(UIEdgeInsets)edgeInsets {
    // 缩进
    self.contentView.sd_layout.spaceToSuperView(edgeInsets);
    self.contentView.layer.cornerRadius = cornerRadius;
    self.contentView.layer.masksToBounds = YES;
    self.backgroundColor = UIColor.dyt_background;
    self.contentView.backgroundColor = UIColor.whiteColor;

//    // 阴影
    YCShadowView *backView = [self viewWithTag:backViewTag];
    if (backView == nil) {
        backView = [[YCShadowView alloc] initWithFrame:self.contentView.bounds];
        [self insertSubview:backView atIndex:0];
        [backView yc_shaodwRadius:cornerRadius shadowColor:UIColor.dyt_shadow shadowOffset:CGSizeMake(0, 0) byShadowSide:YCShadowSideAllSides];
        [backView yc_cornerRadius:cornerRadius];
    }
    [self sendSubviewToBack:backView];
    backView.sd_layout.spaceToSuperView(edgeInsets);
    [backView updateLayout];
}

/// 缩进tableviewCell contentView
- (void)setCellRetractDYT {
    self.contentView.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 16, 0, 16));
    self.backgroundColor = UIColor.dyt_background;
    self.contentView.backgroundColor = UIColor.whiteColor;
}

@end
