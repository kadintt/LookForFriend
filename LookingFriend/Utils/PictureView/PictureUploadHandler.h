//
//  PictureUploadHandler.h
//  DaoyitongCode
//
//  Created by maoge on 2018/12/7.
//  Copyright © 2018 爱康国宾. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MBProgressHUD;

NS_ASSUME_NONNULL_BEGIN

@interface PictureUploadHandler : NSObject
@property (nonatomic, strong) NSMutableArray *selectedImages;
@property (nonatomic, strong) NSMutableArray *selectedAssets;
@property (nonatomic, strong) NSMutableArray *selectedImageIds;

// 加载图片回调Block
@property (nonatomic, copy) void (^loadImagesBlock)(NSArray *array);

- (NSArray *)deletePictureAtIndex:(NSInteger)index;

- (void)requestUploadFileSingleImage:(UIImage *)originalImage sourceAsset:(id)asset pickingPhoto:(UIImage *)pickingPhoto view:(UIView *)view;
@end

NS_ASSUME_NONNULL_END
