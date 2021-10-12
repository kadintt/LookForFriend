//
//  FlowTagsView.h
//  DaoyitongCode
//
//  Created by cjg on 2018/8/17.
//  Copyright © 2018年 爱康国宾. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIButton+ImageTitleSpacing.h"

typedef void(^TouchBlock)(NSInteger index, UIButton *button);

@interface FlowTagsView : UIView

@property (nonatomic, strong) TouchBlock touchBlock;

@property (nonatomic, strong) NSArray<NSString *> *dataList;

/** 最后一个标签和自身底部的间隙, 默认0px */
@property (nonatomic, assign) CGFloat bottomMargin;

/** 每个标签的水平间距, 默认10px */
@property (nonatomic, assign) CGFloat padding;

/** 每个标签的高度, 默认30px */
@property (nonatomic, assign) CGFloat tagHeight;

/** 默认0, 当大于0的时候流式布局取消 */
@property (nonatomic, assign) CGFloat tagWidth;

/** 示例按钮, 所有样式bgColor, font, textColor等都取这个按钮的样式 */
@property (nonatomic, strong) UIButton *button;

/** 是否显示图片, 默认false */
@property (nonatomic, assign) BOOL isImage;

/** button的图文间距 */
@property (nonatomic, assign) CGFloat edgeInsets;

/** button图文摆放位置 */
@property (nonatomic, assign) MKButtonEdgeInsetsStyle edgeInsetsStyle;

/** button与文字间距 */
@property (nonatomic, assign) CGFloat titleMargin;


//- (instancetype)initWithFrame:(CGRect)frame dataList:(NSArray<NSString*>*)dataList;

- (void)reloadWithDataList:(NSArray<NSString *> *)dataList;

- (NSArray <UIButton *> *)buttonsArray;

- (UIButton *)buttonWithIndex:(NSInteger)index;

/// 更新所有buton的图文间距
- (void)updateButtonsLayoutStyle;


@end
