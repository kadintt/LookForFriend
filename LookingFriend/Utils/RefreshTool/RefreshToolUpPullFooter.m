//
//  RefreshToolUpPullFooter.m
//  DaoyitongCode
//
//  Created by maoge on 2018/9/13.
//  Copyright © 2018年 爱康国宾. All rights reserved.
//

#import "RefreshToolUpPullFooter.h"
#import <SDAutoLayout/SDAutoLayout.h>
@interface RefreshToolUpPullFooter ()
@property (nonatomic, strong) UIImageView *imageView;

@end
@implementation RefreshToolUpPullFooter

- (void)setState:(MJRefreshState)state {
    [super setState:state];
    
    switch (state) {
        case MJRefreshStateNoMoreData:
//            self.alpha = 1;
            self.imageView.hidden = false;
            break;

        default:
//            self.alpha = 0;
            self.imageView.hidden = true;
            break;
    }
}

- (void)prepare {
    [super prepare];

    self.imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"no_more_data"]];
    self.imageView.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width - 122) * 0.5, (44 - 12) * 0.5, 122, 12);
    [self addSubview:self.imageView];
    self.imageView.hidden = true;
}

- (void)placeSubviews {
    [super placeSubviews];
}

- (void)endRefreshing {
    [super endRefreshing];
}

@end
