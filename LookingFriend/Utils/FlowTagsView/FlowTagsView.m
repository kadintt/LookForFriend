//
//  FlowTagsView.m
//  DaoyitongCode
//
//  Created by cjg on 2018/8/17.
//  Copyright © 2018年 爱康国宾. All rights reserved.
//

#import "FlowTagsView.h"
#import "NSArray+Category.h"
#import "UIColor+Category.h"
#import <SDAutoLayout/SDAutoLayout.h>

#define beginTag 1000

@implementation FlowTagsView

- (instancetype)init {
    if (self = [super init]) {
        self.clipsToBounds = true;
        self.padding = 10;
        self.tagHeight = 30;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame dataList:(NSArray<NSString *> *)dataList {
    self = [self initWithFrame:frame];
    [self reloadWithDataList:dataList];
    return self;
}

/** 刷新数据源方法 */
- (void)reloadWithDataList:(NSArray<NSString *> *)dataList {
    self.dataList = dataList;
    [self.subviews forEach:^(UIView *_Nonnull objc, NSInteger index) {
        [objc removeFromSuperviewAndClearAutoLayoutSettings];
    }];
    [self updateLayout];
    //拿到屏幕的宽
    CGFloat kScreenW = self.width_sd;

    //间距
    CGFloat padding = self.padding;

    CGFloat titBtnX = 0;
    CGFloat titBtnY = 0;

    CGFloat titBtnH = self.tagHeight;

    for (int i = 0; i < dataList.count; i++) {
        UIButton *titBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        //设置按钮的样式
        titBtn.backgroundColor = self.button.backgroundColor;
        [titBtn setTitleColor:[self.button titleColorForState:UIControlStateNormal] forState:UIControlStateNormal];
        [titBtn setTitleColor:[self.button titleColorForState:UIControlStateSelected] forState:UIControlStateSelected];
        titBtn.titleLabel.font = self.button.titleLabel.font;
        [titBtn setTitle:dataList[i] forState:UIControlStateNormal];
        if (_isImage) {
            [titBtn setImage:[self.button imageForState:UIControlStateNormal] forState:UIControlStateNormal];
            [titBtn setImage:[self.button imageForState:UIControlStateSelected] forState:UIControlStateSelected];
        }
        titBtn.tag = beginTag + i;
        titBtn.layer.cornerRadius = self.button.layer.cornerRadius;
        titBtn.layer.masksToBounds = true;
        [titBtn addTarget:self action:@selector(titBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        //计算文字大小
        CGSize titleSize = [dataList[i] boundingRectWithSize:CGSizeMake(MAXFLOAT, titBtnH) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: titBtn.titleLabel.font} context:nil].size;
        CGFloat textMargin = _titleMargin > 0 ? _titleMargin : 0.0f;
        CGFloat imageWidth = _isImage ? 6 : 0;
        ///  按钮文字长度太小的话 左右加4
        CGFloat titBtnW = (titleSize.width < 18 ? 26 : titleSize.width) + 2 * textMargin + imageWidth + self.edgeInsets;
//        CGFloat titBtnW = titleSize.width + 2 * padding
        if (self.tagWidth) {
            titBtnW = self.tagWidth;
        }
        //判断按钮是否超过屏幕的宽
        if ((titBtnX + titBtnW) > kScreenW) {
            titBtnX = 0;
            titBtnY += titBtnH + padding;
        }
        //设置按钮的位置
//        titBtn.frame = CGRectMake(titBtnX, titBtnY, titBtnW, titBtnH);
        [self addSubview:titBtn];

        titBtn.sd_layout.topSpaceToView(self, titBtnY).leftSpaceToView(self, titBtnX).heightIs(titBtnH).widthIs(titBtnW);
        [self updateLayoutSubViews:titBtn];
        if (_isImage) {
            [titBtn layoutButtonWithEdgeInsetsStyle:self.edgeInsetsStyle imageTitleSpace:self.edgeInsets];
//            [titBtn setLayout:self.edgeInsetsStyle aSpacing:self.edgeInsets];
        }
        titBtnX += titBtnW + padding;

    }
    NSLog(@"---titBtnY--->%lf",titBtnY);
    if (self.superview) {
        if (dataList.count) {
            [self.subviews.lastObject updateLayout];
            self.sd_layout.heightIs(self.subviews.lastObject.bottom_sd + self.bottomMargin);
        } else {
            self.sd_layout.heightIs(0);
        }
        [self updateLayout];
    } else {
        [self.subviews.lastObject updateLayout];
        self.sd_layout.heightIs(self.subviews.lastObject.bottom_sd + self.bottomMargin);
    }
}

/// 刷新所有子视图的布局
- (void)updateLayoutSubViews:(UIView *)view {
    [view updateLayout];
    [view.subviews forEach:^(UIView *_Nonnull objc, NSInteger index) {
        [self updateLayoutSubViews:objc];
    }];
    [view updateLayout];
}


/** 按钮点击事件 */
- (void)titBtnClick:(UIButton *)btn {
    if (self.touchBlock) {
        self.touchBlock(btn.tag - beginTag, btn);
    }
}

- (NSArray <UIButton *> *)buttonsArray {
    return [self.subviews map:^id(id element, NSInteger index) {
        if ([element isKindOfClass:[UIButton class]]) {
            return element;
        }
        return nil;
    }];
}

- (UIButton *)buttonWithIndex:(NSInteger)index {
    return [self viewWithTag:beginTag + index];
}

- (void)updateButtonsLayoutStyle {
    [self.buttonsArray forEach:^(UIButton *objc, NSInteger index) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [objc layoutButtonWithEdgeInsetsStyle:self.edgeInsetsStyle imageTitleSpace:self.edgeInsets];
//            [titBtn setLayout:self.edgeInsetsStyle aSpacing:self.edgeInsets];

        });
    }];
}

#pragma mark - get && set

- (UIButton *)button {
    if (!_button) {
        UIButton *titBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        //设置按钮的样式
        titBtn.backgroundColor = [UIColor colorWithString:@"F0F0F0"];
        [titBtn setTitleColor:[UIColor colorWithString:@"7B7F83"] forState:UIControlStateNormal];
        titBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        titBtn.layer.cornerRadius = 2;
        titBtn.layer.masksToBounds = true;
        _button = titBtn;
    }
    return _button;
}


@end
