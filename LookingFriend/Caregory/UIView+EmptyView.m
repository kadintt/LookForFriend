//
//  UIView+IHOSPEmptyView.m
//  pavohospital
//
//  Created by maoge on 2019/6/24.
//  Copyright © 2019 daoyitong. All rights reserved.
//

#import "UIView+EmptyView.h"
#import <objc/runtime.h>
#import <Masonry/Masonry.h>
#import "UIColor+Category.h"

static void *emptyViewKey = &emptyViewKey;
static void *reloadBlcokKey = &reloadBlcokKey;
static void *reloadButtonKey = &reloadButtonKey;
@interface UIView ()

/** 用来记录重新加载按钮 */
@property (nonatomic, strong) UIButton *reloadButton;

@end

@implementation UIView (EmptyView)

- (void)setReloadButton:(UIButton *)reloadButton {
    objc_setAssociatedObject(self, &reloadButtonKey, reloadButton, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIButton *)reloadButton {
    return objc_getAssociatedObject(self, &reloadButtonKey);
}

- (void)setReloadBlock:(void (^)(void))reloadBlock {
    objc_setAssociatedObject(self, &reloadBlcokKey, reloadBlock, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void (^)(void))reloadBlock {
    return objc_getAssociatedObject(self, &reloadBlcokKey);
}

- (UIView *)dyt_emptyView {
    return objc_getAssociatedObject(self, &emptyViewKey);
}

- (void)setDyt_emptyView:(UIView *)dyt_emptyView {
    objc_setAssociatedObject(self, &emptyViewKey, dyt_emptyView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - 展示UIView或其子类的占位图
/**
 展示UIView或其子类的占位图

 @param type 占位图类型
 @param reloadBlock 重新加载回调的block
 */
- (void)dyt_showEmptyViewWithType:(EmptyViewType)type reloadBlock:(void (^)(void))reloadBlock {
    self.reloadBlock = reloadBlock;

    // 如果是UIScrollView及其子类，占位图展示期间禁止scroll
    if ([self isKindOfClass:[UIScrollView class]]) {
        UIScrollView *scrollView = (UIScrollView *)self;
        // 将scrollEnabled设为NO
        scrollView.scrollEnabled = TRUE;
    }

    //------- 占位图 -------//
    if (self.dyt_emptyView) {
        [self.dyt_emptyView removeFromSuperview];
        self.dyt_emptyView = nil;
    }
    self.dyt_emptyView = [[UIView alloc] init];
    [self addSubview:self.dyt_emptyView];
    self.dyt_emptyView.backgroundColor = [UIColor colorWithHex:0xfafafa];
    [self.dyt_emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self);
        make.size.mas_equalTo(self);
    }];
    
    NSLog(@"%@", self.dyt_emptyView);
    //------- 图标 -------//
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.dyt_emptyView addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(imageView.superview);
        make.centerY.mas_equalTo(imageView.superview).mas_offset(-80);
        make.size.mas_equalTo(CGSizeMake(120, 120));
    }];

    //------- 描述 -------//
    UILabel *descLabel = [[UILabel alloc] init];
    [self.dyt_emptyView addSubview:descLabel];
    descLabel.textColor = [UIColor colorWithHex:0x686868];
    [descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(descLabel.superview);
        make.top.mas_equalTo(imageView.mas_bottom).mas_offset(20);
        make.height.mas_equalTo(15);
    }];

    //------- 重新加载button -------//
    self.reloadButton = [[UIButton alloc] init];
    [self.dyt_emptyView addSubview:self.reloadButton];
    [self.reloadButton setTitleColor:[UIColor colorWithHex:0x494847] forState:UIControlStateNormal];
    [self.reloadButton setTitle:@"重新加载" forState:UIControlStateNormal];
    self.reloadButton.layer.borderWidth = 1;
    self.reloadButton.layer.borderColor = [UIColor colorWithHex:0xC4C2C0].CGColor;
    self.reloadButton.layer.cornerRadius = 18;
    self.reloadButton.layer.masksToBounds = YES;
    self.reloadButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.reloadButton addTarget:self action:@selector(reloadAction:) forControlEvents:UIControlEventTouchUpInside];

    [self.reloadButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.reloadButton.superview);
        make.top.mas_equalTo(descLabel.mas_bottom).mas_offset(20);
        make.size.mas_equalTo(CGSizeMake(110, 36));
    }];

    //------- 根据type设置不同UI -------//
    switch (type) {
        case EmptyViewTypeNoNetwork: // 网络不好
        {
            imageView.image = [UIImage imageNamed:@"network_no_service"];
            descLabel.text = @"服务开小差了，请耐心等待";
            self.reloadButton.hidden = false;
        }
        break;

        case EmptyViewTypeNoCheckAppointment: // 没检查申请
        {
            imageView.image = [UIImage imageNamed:@"network_no_check_appointment"];
            descLabel.text = @"暂无检查申请";
        }
        break;

        case EmptyViewTypeNoRecord: // 没记录
        {
            imageView.image = [UIImage imageNamed:@"network_no_record"];
            descLabel.text = @"暂无记录";
        }
        break;
        case EmptyViewTypeNoOrders: // 没订单
        {
            imageView.image = [UIImage imageNamed:@"network_no_orders"];
            descLabel.text = @"暂无相关订单";
        }

        break;
        case EmptyViewTypeNoComments: // 没评价
        {
            imageView.image = [UIImage imageNamed:@"network_no_evaluate"];
            descLabel.text = @"暂无用户评价";
        }
        break;
        case EmptyViewTypeNoChatSearch: // 没搜索结果
        {
            imageView.image = [UIImage imageNamed:@"network_no_searchResult"];
            descLabel.text = @"没有找到相关聊天记录~";
        }
        break;
        case EmptyViewTypeNoGroupSearch: // 没搜索结果
        {
            imageView.image = [UIImage imageNamed:@"network_no_searchResult"];
            descLabel.text = @"没有找到你要的结果哦～";
        }
        break;
        case EmptyViewTypeNoTask: // 没任务
        {
            imageView.image = [UIImage imageNamed:@"network_no_task_or_plan"];
            descLabel.text = @"今日没有任何任务~";
        }
        break;
        case EmptyViewTypeNoGroupList:
        {
            imageView.image = [UIImage imageNamed:@"network_no_searchResult"];
            descLabel.text = @"还没有群组";
        }
        break;
        case EmptyViewTypeNoC2CList:
        {
            imageView.image = [UIImage imageNamed:@"network_no_searchResult"];
            descLabel.text = @"暂无数据";
        }
        break;
        case EmptyViewTypeNoPlan: // 没计划
        {
            imageView.image = [UIImage imageNamed:@"network_no_task_or_plan"];
            descLabel.text = @"还没有可选的干预计划～";
        }
        break;
        case EmptyViewTypeNoCoupon: // 没优惠券
        {
            imageView.image = [UIImage imageNamed:@"no_coupon"];
            descLabel.text = @"暂无优惠券";
        }
        break;
        case EmptyViewTypeNoRecommend: // 没推荐模板
        {
            imageView.image = [UIImage imageNamed:@"no_recommend"];
            descLabel.text = @"暂无推荐商品模版";
        }
        break;
        case EmptyViewTypeNoGroup: // 没分组
        {
            imageView.image = [UIImage imageNamed:@"network_no_group"];
            descLabel.text = @"暂无回复分组";
            self.reloadButton.hidden = false;
            [self.reloadButton setTitleColor:[UIColor colorWithHex:0xFFFFFF] forState:UIControlStateNormal];
            [self.reloadButton setTitle:@"添加分组" forState:UIControlStateNormal];
            self.reloadButton.layer.borderColor = [UIColor colorWithHex:0x2AD5D5].CGColor;
            self.reloadButton.backgroundColor = [UIColor colorWithHex:0x2AD5D5];
            [imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerX.mas_equalTo(imageView.superview);
                make.top.mas_equalTo(imageView.superview.mas_top).mas_offset(148);
                make.size.mas_equalTo(CGSizeMake(115, 115));
            }];
            [self.reloadButton mas_updateConstraints:^(MASConstraintMaker *make) {
                make.centerX.mas_equalTo(self.reloadButton.superview);
                make.top.mas_equalTo(descLabel.mas_bottom).mas_offset(50);
                make.size.mas_equalTo(CGSizeMake(110, 36));
            }];
        }
            
        break;
        case EmptyViewTypeNoReply: // 没回复
        {
            imageView.image = [UIImage imageNamed:@"network_no_reply"];
            descLabel.text = @"暂无回复内容";
            self.reloadButton.hidden = false;
            [self.reloadButton setTitleColor:[UIColor colorWithHex:0xFFFFFF] forState:UIControlStateNormal];
            [self.reloadButton setTitle:@"添加回复" forState:UIControlStateNormal];
            self.reloadButton.layer.borderColor = [UIColor colorWithHex:0x2AD5D5].CGColor;
            self.reloadButton.backgroundColor = [UIColor colorWithHex:0x2AD5D5];
            [imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerX.mas_equalTo(imageView.superview);
                make.top.mas_equalTo(imageView.superview.mas_top).mas_offset(150);
                make.size.mas_equalTo(CGSizeMake(115, 115));
            }];
            [self.reloadButton mas_updateConstraints:^(MASConstraintMaker *make) {
                make.centerX.mas_equalTo(self.reloadButton.superview);
                make.top.mas_equalTo(descLabel.mas_bottom).mas_offset(50);
                make.size.mas_equalTo(CGSizeMake(110, 36));
            }];
        }
            
        break;
            
        default:
            break;
    }
}

- (void)dyt_showEmptyViewWithType:(EmptyViewType)type show:(BOOL)show;
{
    [self dyt_showEmptyViewWithType:type reloadBlock:nil];

    self.reloadButton.hidden = YES;

    if (!show) {
        [self dyt_removeEmptyView];
    }
}

- (void)dyt_showEmptyViewWithType:(EmptyViewType)type clear:(BOOL)clear show:(BOOL)show {
    
    [self dyt_showEmptyViewWithType:type show:show];
    
    self.dyt_emptyView.backgroundColor = UIColor.clearColor;
}

#pragma mark - 按钮响应回调
/**
 按钮响应回调
 */
- (void)reloadAction:(UIButton *)sender {
    if (self.reloadBlock) {
        self.reloadBlock();
    }
    // 从父视图移除
    [self.dyt_emptyView removeFromSuperview];
    self.dyt_emptyView = nil;
    // 复原UIScrollView的scrollEnabled
    if ([self isKindOfClass:[UIScrollView class]]) {
        UIScrollView *scrollView = (UIScrollView *)self;
        scrollView.scrollEnabled = YES;
    }
}

#pragma mark - 主动移除占位图
/**
 主动移除占位图
 */
- (void)dyt_removeEmptyView {
    if (self.dyt_emptyView) {
        [self.dyt_emptyView removeFromSuperview];
        self.dyt_emptyView = nil;
    }
    // 复原UIScrollView的scrollEnabled
    if ([self isKindOfClass:[UIScrollView class]]) {
        UIScrollView *scrollView = (UIScrollView *)self;
        scrollView.scrollEnabled = YES;
    }
}

@end
