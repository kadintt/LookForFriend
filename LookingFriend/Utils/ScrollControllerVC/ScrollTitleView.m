//
//  ScrollTitleView.m
//  DaoyitongCode
//
//  Created by chenjg on 2019/9/16.
//  Copyright © 2019 爱康国宾. All rights reserved.
//

#import "ScrollTitleView.h"
#import "ScrollControllersVc.h"
#import "UIColor+Category.h"
#import "NSString+Category.h"
#import <SDAutoLayout/SDAutoLayout.h>
#import "UIView+Catetory.h"

@interface ScrollTitleView () <ScrollHeaderDataSource>
{
    CGFloat labelWidth;
    CGFloat labelHeight;
}
@property (nonatomic, strong) NSArray<NSString *> *titles;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *indicatorView;
@property (nonatomic, assign) CGFloat progress;
@property (nonatomic, assign) CGFloat maxOffsetX;
@end

@implementation ScrollTitleView

- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titles {
    return [self initWithFrame:frame titles:titles titleWidth:0];
}

- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titles titleWidth:(CGFloat)titleWidth {
    self = [self initWithFrame:frame];
    _maxFontSize = 24;
    _minFontSize = 14;
    self.titles = titles;

    if (titleWidth > 0) {
        labelWidth = titleWidth;
    } else {
        labelWidth = MAX(self.width / 5, self.width / @(titles.count).floatValue);
        for (NSString* str in titles) {
            labelWidth = MAX(labelWidth, [str sizeWithFont:[UIFont systemFontOfSize:_maxFontSize weight:UIFontWeightMedium] byHeight:40].width + 10);
        }
    }

    labelHeight = 30;
    [self setup];
    [self addLabels];
    [self scrollDidProgress:0 controller:nil];
    return self;
}

#pragma mark - API
/// 点击回调
- (void)labelClick:(UITapGestureRecognizer *)tap {
    if (self.clickBlock) {
        self.clickBlock(tap.view.tag - 1);
    }
}

- (void)scrollToIndex:(NSInteger)index {
    [UIView animateWithDuration:0.3 animations:^{
        [self scrollDidProgress:index controller:nil];
    }];
}

- (void)setMaxFontSize:(CGFloat)maxFontSize {
    _maxFontSize = maxFontSize;
    [self scrollDidProgress:self.progress controller:nil];
}

- (void)setMinFontSize:(CGFloat)minFontSize {
    _minFontSize = minFontSize;
    [self scrollDidProgress:self.progress controller:nil];
}

#pragma mark - ScrollHeaderDataSource

- (UIView *)scrollContent {
    return self;
}

- (void)scrollDidProgress:(CGFloat)progress controller:(ScrollControllersVc *)controller {
    _progress = progress;

    self.indicatorView.width = 15 + fabs(progress - round(progress)) / 0.5 * 45;
    self.indicatorView.centerX = progress * labelWidth + labelWidth * 0.5;

    [self resetLableStatus];

    UILabel *leftLabel = [self.scrollView viewWithTag:floor(progress) + 1];
    UILabel *rightLabel = [self.scrollView viewWithTag:ceil(progress) + 1];

    [self selectedLabelCenter:rightLabel];

    //计算值
    CGFloat (^ ComputedBlock)(CGFloat, CGFloat, BOOL) =  ^CGFloat (CGFloat max, CGFloat min, BOOL isLast) {
        CGFloat span = max - min;
        if (isLast) {
            return max - (progress - leftLabel.tag + 1) * span;
        } else {
            return min + (progress - rightLabel.tag + 2) * span;
        }
    };

    leftLabel.font = [UIFont systemFontOfSize:ComputedBlock(_maxFontSize, _minFontSize, true) weight:ComputedBlock(UIFontWeightMedium, UIFontWeightRegular, true)];
    leftLabel.textColor = [UIColor colorWithRed:ComputedBlock(34, 42, true) / 255.0 green:ComputedBlock(34, 40, true) / 255.0 blue:ComputedBlock(34, 39, true) / 255.0 alpha:1.0];

    rightLabel.font = [UIFont systemFontOfSize:ComputedBlock(_maxFontSize, _minFontSize, + -false) weight:ComputedBlock(UIFontWeightMedium, UIFontWeightMedium, false)];
    rightLabel.textColor = [UIColor colorWithRed:ComputedBlock(34, 42, false) / 255.0 green:ComputedBlock(34, 40, false) / 255.0 blue:ComputedBlock(34, 39, false) / 255.0 alpha:1.0];
}

#pragma mark - private

/// 滚动标题选中居中
- (void)selectedLabelCenter:(UILabel *)centerLabel {
    // 计算偏移量
    CGFloat offsetX = centerLabel.center.x - self.frame.size.width * 0.5;

    if (offsetX < 0) {
        offsetX = 0;
    }

    // 获取最大滚动范围
    if (offsetX > _maxOffsetX) {
        offsetX = _maxOffsetX;
    }
    // 滚动标题滚动条
    [self.scrollView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
}

/// 恢复默认最小状态
- (void)resetLableStatus {
    for (UILabel *label in self.scrollView.subviews) {
        if ([label isKindOfClass:[UILabel class]]) {
            label.font = [UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
        }
    }
}

/// 添加label
- (void)addLabels {
    for (UIView *label in self.scrollView.subviews) {
        if ([label isKindOfClass:[UILabel class]]) {
            [label removeFromSuperview];
        }
    }
    for (NSInteger i = 0; i < self.titles.count; i++) {
        UILabel *label = [[UILabel alloc] init];
        label.tag = i + 1;
        label.text = self.titles[i];
        label.frame = CGRectMake(labelWidth * i, 20, labelWidth, labelHeight);
        label.textColor = [UIColor colorWithRed:42 / 255.0 green:40 / 255.0 blue:39 / 255.0 alpha:1.0];
        label.textAlignment = NSTextAlignmentCenter;
        [label addTapTarget:self selector:@selector(labelClick:)];
        [self.scrollView addSubview:label];
    }
    [self.scrollView bringSubviewToFront:self.indicatorView];

    [self.scrollView setContentSize:CGSizeMake(_titles.count * labelWidth, 20)];
    self.maxOffsetX = self.scrollView.contentSize.width - self.frame.size.width;
}

#pragma mark - setup
- (void)setup {
    [self addSubview:self.scrollView];
    [self.scrollView addSubview:self.indicatorView];
    self.clipsToBounds = true;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollView.showsHorizontalScrollIndicator = NO;
    }
    return _scrollView;
}

- (UIView *)indicatorView {
    if (!_indicatorView) {
        _indicatorView = [[UIView alloc] initWithFrame:CGRectMake(labelWidth / 2.0, self.bottom - 3, 15, 3)];
        _indicatorView.layer.cornerRadius = 2;
        _indicatorView.layer.masksToBounds = YES;
        _indicatorView.centerX = labelWidth * 0.5;
        _indicatorView.backgroundColor = [UIColor colorWithString:@"#2AD5D5"];
    }
    return _indicatorView;
}

@end
