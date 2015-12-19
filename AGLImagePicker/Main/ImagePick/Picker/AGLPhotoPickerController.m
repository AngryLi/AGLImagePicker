//
//  AGLPhotoPickerView.m
//  AGLImagePicker
//
//  Created by 李亚洲 on 15/12/12.
//  Copyright © 2015年 angryli. All rights reserved.
//

#import "AGLPhotoPickerController.h"

#import "AGLAlbumListController.h"

#import "AGLALAssetModel.h"

@interface AGLPhotoPickerController () <AGLAlbumListControllerDelegate>

@end

@implementation AGLPhotoPickerController
- (instancetype)init
{
    AGLAlbumListController *albumListVc = [[AGLAlbumListController alloc]init];
    albumListVc.delegate = self;
    self = [super initWithRootViewController:albumListVc];
    if (self) {
        self.navigationBar.translucent = YES;
    }
    return self;
}

- (void)albumListController:(AGLAlbumListController *)controller cancel:(BOOL)cancel
{
    if (self.aGLDelegate && [self.aGLDelegate respondsToSelector:@selector(photoPickerController:cancelSelect:)]) {
        [self.aGLDelegate photoPickerController:self cancelSelect:cancel];
    }
}
- (void)albumListController:(AGLAlbumListController *)controller didSelectPhotos:(NSArray<AGLALAssetModel *> *)photos
{
    if (self.aGLDelegate && [self.aGLDelegate respondsToSelector:@selector(photoPickerController:didSelectPhoto:)]) {
        NSMutableArray *images = [@[] mutableCopy];
        [photos enumerateObjectsUsingBlock:^(AGLALAssetModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [images addObject:[obj getDefault]];
        }];
        [self.aGLDelegate photoPickerController:self didSelectPhoto:[images copy]];
    }
}
@end
