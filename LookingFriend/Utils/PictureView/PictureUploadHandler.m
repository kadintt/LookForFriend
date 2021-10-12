//
//  PictureUploadHandler.m
//  DaoyitongCode
//
//  Created by maoge on 2018/12/7.
//  Copyright © 2018 爱康国宾. All rights reserved.
//

#import "PictureUploadHandler.h"
#import "MRIconView.h"
#import "PictureUploadView.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "UIImage+Extension.h"
#import "LookingFriend-Swift.h"

@implementation PictureUploadHandler

- (NSArray *)deletePictureAtIndex:(NSInteger)index {
    [self.selectedImages removeObjectAtIndex:index];
    [self.selectedAssets removeObjectAtIndex:index];
    [self.selectedImageIds removeObjectAtIndex:index];

    return [NSArray arrayWithArray:self.selectedImages];
}

//- (void)requestUploadFileSingleImage:(UIImage *)originalImage sourceAsset:(id)asset pickingPhoto:(UIImage *)pickingPhoto view:(UIView *)view {
//    NSData *imageData;
//    if (originalImage) {
//        UIImage *myfile = [originalImage imageCompressForTargetSize:originalImage.size];
//        imageData = UIImageJPEGRepresentation(myfile, 0.7);
//    }
//
//    UploadModel *uploadModel = [[UploadModel alloc] initWithData:imageData key:@"file" fileName:[NSString stringWithFormat:@"ios图片%zd.png", (NSInteger)[NSDate date].timeIntervalSince1970] mineType:UploadMimeTypePng];
//
//    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
//    hud.mode = MBProgressHUDModeDeterminateHorizontalBar;
//    hud.label.text = @"图片上传中...";
//
//    [NetApi uploadFileSinglePictureWithModel:@[uploadModel] upProgress:^(NSInteger upProgress) {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [hud setProgress:upProgress];
//        });
//        
//    } finish:^(RequestTool *tool, NSError *error, DCNetWorkFinishType finishType) {
//        if (finishType == DCNetWorkFinishTypeSuccess) {
//            UIImage *thumbImage = [pickingPhoto imageCompressForTargetSize:CGSizeMake(130, 130)];
//            [self.selectedImages addObject:thumbImage];
//            [self.selectedAssets addObject:asset];
//            if (tool.responseObject[@"fileId"]) {
//                [self.selectedImageIds addObject:tool.responseObject[@"fileId"]];
//            }
//
//            if (self.loadImagesBlock) {
//                self.loadImagesBlock(self.selectedImages.copy);
//            }
//
//            [self showUpLoadMessage:@"图片上传成功" addedToView:view progressView:hud];
//        } else {
//            [self showUpLoadMessage:@"图片上传失败,请重新上传" addedToView:view progressView:hud];
//        }
//    }];
//}

- (void)showUpLoadMessage:(NSString *)message addedToView:(UIView *)view progressView:(MBProgressHUD *)progressView  {
    [progressView hideAnimated:YES];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.customView = [MRCrossIconView new];
    hud.mode = MBProgressHUDModeCustomView;
    hud.label.text = message;
    [hud hideAnimated:YES afterDelay:1];
}

#pragma mark - Getter & Setter

- (NSMutableArray *)selectedImages {
    if (!_selectedImages) {
        _selectedImages = [[NSMutableArray alloc] init];
    }
    return _selectedImages;
}

- (NSMutableArray *)selectedAssets {
    if (!_selectedAssets) {
        _selectedAssets = [[NSMutableArray alloc] init];
    }
    return _selectedAssets;
}

- (NSMutableArray *)selectedImageIds {
    if (!_selectedImageIds) {
        _selectedImageIds = [[NSMutableArray alloc] init];
    }
    return _selectedImageIds;
}

@end
