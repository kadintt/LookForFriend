//
//  RefreshToolDownPullHeader.m
//  YH-IOS
//
//  Created by cjg on 2017/7/24.
//  Copyright © 2017年 com.intfocus. All rights reserved.
//

#import "RefreshToolDownPullHeader.h"
//#import <Lottie/Lottie.h>
#import <Lottie/Lottie.h>

@interface RefreshToolDownPullHeader ()

@property (nonatomic, strong) LOTAnimationView *animateView;
@property (nonatomic, strong) NSString *jsonString;

@end

@implementation RefreshToolDownPullHeader

- (instancetype)init {
    if (self = [super init]) {
        self.lastUpdatedTimeLabel.hidden = YES;
        self.stateLabel.hidden = YES;
        self.arrowView.image = [UIImage new];
        [self setValue:UIColor.clearColor forKeyPath:@"loadingView.color"];
    }
    return self;
}

- (void)setJsonName:(NSString *)jsonName {
    self.jsonString = jsonName;
    [self addSubview:self.animateView];
}

- (void)setTopInset:(CGFloat)inset {
    self.ignoredScrollViewContentInsetTop = inset;
    self.mj_h = self.mj_h - self.ignoredScrollViewContentInsetTop;
}

- (void)setState:(MJRefreshState)state {
//    [super setState:state];

    MJRefreshCheckState;
    if (self.jsonString.length > 0) {
        switch (state) {
            case MJRefreshStateIdle: {  //普通闲置状态
                [self.animateView setAnimation:self.jsonString];

                [self.animateView stop];
                break;
            }
            case MJRefreshStatePulling: {  //松开就可以进行刷新的状态
                break;
            }
            case MJRefreshStateRefreshing: {  //正在刷新中的状态
                [self.animateView setAnimation:@"roundloadingpart2"];
                [self.animateView play];
                break;
            }
            default:
                break;
        }
    }
}

#pragma mark - 实时监听控件 scrollViewContentOffset

- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change {
    [super scrollViewContentOffsetDidChange:change];
    if (self.jsonString.length > 0) {
        CGPoint point;
        id newVelue = [change valueForKey:NSKeyValueChangeNewKey];
        [(NSValue *)newVelue getValue:&point];

//        self.animateView.hidden = !(self.pullingPercent);
        CGFloat progress = point.y / ([UIScreen mainScreen].bounds.size.height / 3.0);
        if (self.state != MJRefreshStateRefreshing) {
            self.animateView.animationProgress = -progress;
        }
    }
}

- (void)prepare {
    [super prepare];
}

- (void)placeSubviews {
    [super placeSubviews];
}

- (void)endRefreshing {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [super endRefreshing];
    });
}

- (void)beginRefreshing {
    [super beginRefreshing];
}

#pragma mark - lazy init
- (LOTAnimationView *)animateView {
    if (_animateView == nil) {
        _animateView = [LOTAnimationView animationNamed:self.jsonString];
        _animateView.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width / 2.0) - 16, 0, 32, 32);
        _animateView.loopAnimation = YES;
        _animateView.contentMode = UIViewContentModeScaleAspectFill;
        _animateView.animationSpeed = 1.0;
    }
    return _animateView;
}

@end
