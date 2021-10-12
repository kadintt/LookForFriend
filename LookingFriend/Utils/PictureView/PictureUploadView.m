//
//  PictureUploadView.m
//  DaoyitongCode
//
//  Created by maoge on 2018/12/7.
//  Copyright © 2018 爱康国宾. All rights reserved.
//

#import "PictureUploadView.h"
#import "PictureUploadHandler.h"
#import "TZImagePickerController.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "UIView+Layout.h"
#import "UIButton+ImageTitleSpacing.h"

static NSInteger const kIPUploadImageViewMaxLineCount = 5;
static CGFloat const kIPUploadImageViewMinimumInteritemSpacing = 8.f;
static CGFloat const kIPUploadImageViewMinimumLineSpacing = 8.f;

@implementation UploadRemoveButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIButton *removeButton = [UIButton buttonWithType: UIButtonTypeCustom];
        [removeButton setImage: [UIImage imageNamed: @"internet_icon_delete_nor"] forState: UIControlStateNormal];
        [self addSubview:removeButton];
        removeButton.layer.cornerRadius = 4.f;
        removeButton.layer.masksToBounds = YES;
        [removeButton setEnlargeEdgeWithTop:8 right:8 bottom:12 left:12];
        self.removeButton = removeButton;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat removeW = 18;
    CGFloat removeH = removeW;
    CGFloat removeX = self.frame.size.width - removeW + 4;
    CGFloat removeY = - 4;
    self.removeButton.frame = CGRectMake(removeX, removeY, removeW, removeH);
}


@end

@interface PictureUploadView ()<TZImagePickerControllerDelegate>

@property (nonatomic, strong) UIButton *addButton;

@property (nonatomic, strong) NSMutableArray<UploadRemoveButton *> *items;
@property (nonatomic, strong) NSMutableArray<UploadRemoveButton *> *reuseItems;

@property (nonatomic, assign) CGFloat itemWidth;
@property (nonatomic, assign) CGFloat viewHeight;

@property (nonatomic) CGFloat minimumLineSpacing;
@property (nonatomic) CGFloat minimumInteritemSpacing;

@property (nonatomic, strong) PictureUploadHandler *handler;


- (void)addImage:(UIImage *)image;
- (void)deleteImageAtIndex:(NSInteger )index;


@end

@implementation PictureUploadView

#pragma mark - Life
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setUpUI];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self setUpUI];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    NSInteger count = self.subviews.count;
    for (int i = 0; i < count; i ++) {
        UIButton *button = self.subviews[i];
        CGFloat itemX = (i % self.maxLineCount) * (self.itemWidth + self.minimumInteritemSpacing);
        CGFloat itemY = (i / self.maxLineCount) * (self.itemWidth + self.minimumInteritemSpacing) + 10;
        [button setFrame: CGRectMake( itemX, itemY, self.itemWidth, self.itemWidth)];

        if (i == count - 1) {
            self.viewHeight = button.tz_bottom;
            
        }
    }
}

#pragma mark - Public
- (void)addImage:(UIImage *)image {
    [self.images addObject: image];
    [self reloadData];
}

- (void)loadImages:(NSArray *)images {
    if (images.count == 0 && (self.images.count == 0)) {
        [self tz_removeAllSubviews];
        [self addSubview: self.addButton];
        return;
    }

    [self.images removeAllObjects];
    [self.images addObjectsFromArray: images];
    [self reloadData];
    
    // 将hanlder中的选中图片数组传递出去
    if (self.selectImageArrayBlock) {
        self.selectImageArrayBlock(self.handler.selectedImageIds);
    }
}

- (void)deleteImageAtIndex:(NSInteger )index {
    [self.images removeObjectAtIndex: index];
    [self reloadData];
}


- (CGFloat)heightOfUploadImageView {
    return self.viewHeight;
}

- (void)setAddButtonImage:(UIImage *)image {
    [self.addButton setImage: image forState: UIControlStateNormal];
}

#pragma mark TZImagePickerControllerDelegate
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto infos:(NSArray<NSDictionary *> *)infos {

    [[PHImageManager defaultManager] requestImageForAsset:[assets lastObject] targetSize:PHImageManagerMaximumSize contentMode:PHImageContentModeAspectFill options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        if (![[info objectForKey:PHImageResultIsDegradedKey] boolValue]) {
            //这样只会走一次获取到高清图时
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.handler requestUploadFileSingleImage:result sourceAsset:[assets lastObject] pickingPhoto:[photos lastObject] view:self.window];
            });
        }
    }];
}

#pragma mark - Private
- (void)addImageButtonAction:(UIButton *)button {
    TZImagePickerController *imagePickerVC = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];

    imagePickerVC.isSelectOriginalPhoto = YES;
    // 1.设置目前已经选中的图片数组
    [imagePickerVC setUiImagePickerControllerSettingBlock:^(UIImagePickerController *imagePickerController) {
        imagePickerController.videoQuality = UIImagePickerControllerQualityTypeHigh;
    }];

    imagePickerVC.iconThemeColor = [UIColor colorWithRed:31 / 255.0 green:185 / 255.0 blue:34 / 255.0 alpha:1.0];
    imagePickerVC.showPhotoCannotSelectLayer = YES;
    imagePickerVC.cannotSelectLayerColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8];
    [imagePickerVC setPhotoPickerPageUIConfigBlock:^(UICollectionView *collectionView, UIView *bottomToolBar, UIButton *previewButton, UIButton *originalPhotoButton, UILabel *originalPhotoLabel, UIButton *doneButton, UIImageView *numberImageView, UILabel *numberLabel, UIView *divideLine) {
        [doneButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    }];

    imagePickerVC.allowPickingVideo = NO;
    imagePickerVC.sortAscendingByModificationDate = NO;
    imagePickerVC.allowCrop = NO;
    imagePickerVC.needCircleCrop = NO;
    imagePickerVC.showSelectedIndex = YES;

    if (self.delegate && [self.delegate respondsToSelector:@selector(addPicture:controller:)]) {
        [self.delegate addPicture:self controller:imagePickerVC];
    }
}

- (void)viewLargerImageButtonAction:(UIButton *)button {
    if (self.delegate && [self.delegate respondsToSelector:@selector(viewLargerPicture:index:)]) {
        [self.delegate viewLargerPicture:self index:button.superview.tag];
    }
}

#pragma mark  - privateMethod
- (void)deleteImageButtonAction:(UIButton *)button {

   NSArray *images = [self.handler deletePictureAtIndex:button.superview.tag];
    
    [self loadImages:images];
}


#pragma mark  - method

- (void)reloadData {
    if (self.items.count + self.reuseItems.count <= self.images.count) {
        if (self.images.count > self.maxImagesCount) {
            return;
        }

        if (self.reuseItems.count > 0) {

            [self.items addObjectsFromArray: self.reuseItems];
            [self.reuseItems removeAllObjects];
        }

        NSInteger count = self.images.count - self.items.count;
        if (count > 0) {
            for (int i = 0; i < count; i ++) {
                UploadRemoveButton *button = [[UploadRemoveButton alloc] init];
                [button addTarget: self action: @selector(viewLargerImageButtonAction:) forControlEvents: UIControlEventTouchUpInside];
                [button.removeButton addTarget: self action: @selector(deleteImageButtonAction:) forControlEvents: UIControlEventTouchUpInside];
                [self.items addObject: button];
            }
        }
    } else {
        if (self.items.count > self.images.count) {
            NSInteger count = self.items.count - self.images.count;
            for (int i = 0; i < count; i++) {
                [self.reuseItems addObject: [self.items lastObject]];
                [self.items removeLastObject];
            }
        } else if (self.items.count < self.images.count) {
            NSInteger count = self.images.count - self.items.count;
            for (int i = 0; i < count; i++) {
                [self.items addObject: [self.reuseItems lastObject]];
                [self.reuseItems removeLastObject];
            }
        }
    }

    [self tz_removeAllSubviews];
    for (int i = 0; i < self.items.count; i ++) {
        UploadRemoveButton *button = self.items[i];
        button.tag = i;
        [button setImage: self.images[i] forState: UIControlStateNormal];
        button.imageView.layer.cornerRadius = 4;
        [self addSubview: button];
    }

    if (self.items.count < self.maxImagesCount) {
        [self addSubview: self.addButton];
    }
}

- (void)setUpUI {
    self.backgroundColor = [UIColor whiteColor];

    [self addSubview: self.addButton];
    [self.addButton setFrame: CGRectMake( 0, 10, self.itemWidth, self.itemWidth)];
    self.viewHeight = self.addButton.tz_bottom;

}

- (UIButton *)addButton {
    if (!_addButton) {
        _addButton = [[UIButton alloc] init];
        [_addButton setBackgroundImage:[UIImage imageNamed: @"interrogation_icon_upload_nor"] forState: UIControlStateNormal];
//        [_addButton setImage: [UIImage imageNamed: @"inquiry_upload_btn"] forState: UIControlStateNormal];
        [_addButton addTarget:self action:@selector(addImageButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addButton;
}

- (NSMutableArray *)items {
    if (!_items) {
        _items = [[NSMutableArray alloc] init];
    }
    return _items;
}

- (NSMutableArray *)reuseItems {
    if (!_reuseItems) {
        _reuseItems = [[NSMutableArray alloc] init];
    }
    return _reuseItems;
}

- (NSMutableArray *)images {
    if (!_images) {
        _images = [[NSMutableArray alloc] init];
    }
    return _images;
}

- (NSInteger)maxLineCount {
    if (!_maxLineCount) {
        _maxLineCount = kIPUploadImageViewMaxLineCount;
    }
    return _maxLineCount;
}

- (CGFloat)minimumInteritemSpacing {
    if (!_minimumInteritemSpacing) {
        _minimumInteritemSpacing = kIPUploadImageViewMinimumInteritemSpacing;
    }
    return _minimumInteritemSpacing;
}

- (CGFloat)minimumLineSpacing {
    if (!_minimumLineSpacing) {
        _minimumLineSpacing = kIPUploadImageViewMinimumLineSpacing;
    }
    return _minimumLineSpacing;
}

- (CGFloat)itemWidth {
    if (!_itemWidth) {
        _itemWidth = (([UIScreen mainScreen].bounds.size.width - 32 - (self.maxLineCount - 1) * self.minimumInteritemSpacing) * 1.0 / self.maxLineCount);
    }
    return _itemWidth;
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];

    if (frame.size.width != 0 && frame.size.width != 0) {
        self.itemWidth = ((frame.size.width - (self.maxLineCount - 1) * self.minimumInteritemSpacing) * 1.0 / self.maxLineCount);
    }
}

#pragma mark  - lazyLoad
#pragma mark - Getter & Setter

- (PictureUploadHandler *)handler {
    if (!_handler) {
        _handler = [[PictureUploadHandler alloc] init];
        __weak __typeof(self)weakSelf = self;
        _handler.loadImagesBlock = ^(NSArray * _Nonnull array) {
            [weakSelf loadImages:array];
        };
    }
    return _handler;
}

@end
