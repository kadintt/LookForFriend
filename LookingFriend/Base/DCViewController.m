//
// Created by maoge on 2020/3/27.
// Copyright (c) 2020 导医通. All rights reserved.
//

#import "DCViewController.h"
#import "LookingFriend-Swift.h"

@implementation DCViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [DCDataManager shared].topBaseViewController = self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isPopGestureEnable = true;
    self.isHiddenNavigationBar = false;
    self.view.backgroundColor = [UIColor whiteColor];
    [self.navigationBar setTitleColor:UIColor.dyt_nav_title];
    self.automaticallyAdjustsScrollViewInsets = false;
    self.edgesForExtendedLayout = UIRectEdgeTop;
    [self addNavigationItem:nil selTitle:nil titleColor:nil titleFont:nil image:[UIImage imageNamed:@"nav_back"] sel:@selector(onBack) isLeft:true];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        self.navigationBar.backgroundColor = UIColor.dyt_background;
        [self.navigationBar setTitleColor:UIColor.dyt_nav_title];
    });
    [DCDataManager shared].topBaseViewController = self;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event {
    [self.view endEditing:true];
}

- (Class)rt_navigationBarClass {
    return [DCNavigationBar class];
}

- (void)dealloc {
    NSLog(@"\n\n控制器: %@ \n标题: %@ \n----------------销毁了--------------\n", [self.class.description componentsSeparatedByString:@"."].lastObject, self.title ? self.title : self.navigationItem.title);
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    if (@available(iOS 13.0, *)) {
        return UIStatusBarStyleDarkContent;
    } else {
        return UIStatusBarStyleDefault;
    }
}

@end
