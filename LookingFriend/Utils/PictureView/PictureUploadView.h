//
//  PictureUploadView.h
//  DaoyitongCode
//
//  Created by maoge on 2018/12/7.
//  Copyright © 2018 爱康国宾. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UploadRemoveButton;

@interface UploadRemoveButton : UIButton
/** 删除按钮 */
@property (nonatomic, weak) UIButton *removeButton;

@end

@class PictureUploadView;

@protocol PictureUploadViewDelegate <NSObject>
/** 添加图片 */
- (void)addPicture:(PictureUploadView *)uploadImageView controller:(UIViewController *)controller;

@optional
/** 查看大图 */
- (void)viewLargerPicture:(PictureUploadView *)uploadImageView index:(NSInteger )index;
@end

@interface PictureUploadView : UIView

/** 选中图片ID数组 */
@property (nonatomic, copy) void (^selectImageArrayBlock)(NSArray *array);

@property (nonatomic, weak  ) id<PictureUploadViewDelegate> delegate;

// 上传最大图片数
@property (nonatomic, assign) NSInteger maxImagesCount;

/** 最大行数 */
@property (nonatomic, assign) NSInteger maxLineCount;

/** 图片数组 */
@property (nonatomic, strong) NSMutableArray<UIImage *> *images;

/** 返回高度 */
- (CGFloat)heightOfUploadImageView;

/** 设置添加按钮图片 */
- (void)setAddButtonImage:(UIImage *)image;

@end

