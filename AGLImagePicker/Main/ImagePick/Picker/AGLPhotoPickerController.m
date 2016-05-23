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

#import "AGLPhotoPickerConstants.h"

@interface AGLPhotoPickerController ()

@end

@implementation AGLPhotoPickerController
- (instancetype)init
{
    AGLAlbumListController *albumListVc = [[AGLAlbumListController alloc]init];
    self = [super initWithRootViewController:albumListVc];
    if (self) {
        self.navigationBar.translucent = YES;
        
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(noti_cancel) name:AGLPhotoPickerCancelNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(noti_done:) name:AGLPhotoPickerDoneNotification object:nil];
    }
    return self;
}


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)noti_cancel {
    if (_aGLDelegate) {
        [_aGLDelegate photoPickerControllerDidCancel:self];
    }
}

- (void)noti_done:(NSNotification *)noti {
    
    NSArray<AGLALAssetModel *> *photos = noti.object;
    
    if (self.aGLDelegate) {
        NSMutableArray *images = [@[] mutableCopy];
        [photos enumerateObjectsUsingBlock:^(AGLALAssetModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [images addObject:[obj getDefault]];
        }];
        [self.aGLDelegate photoPickerController:self didSelectPhoto:[images copy]];
    }
}
@end
