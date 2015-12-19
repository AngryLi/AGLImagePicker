//
//  AGLPhotoCollectionController.h
//  AGLImagePicker
//
//  Created by 李亚洲 on 15/12/12.
//  Copyright © 2015年 angryli. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ALAssetsGroup, AGLALAssetModel, AGLPhotoCollectionController;
@protocol AGLPhotoCollectionControllerDelegate <NSObject>
- (void)photoCollectionController:(AGLPhotoCollectionController *)controller didSelectPhoto:(NSArray<AGLALAssetModel *> *)photos;
- (void)photoCollectionController:(AGLPhotoCollectionController *)controller cancel:(BOOL)cancel;
@end
@interface AGLPhotoCollectionController : UIViewController
@property (nonatomic, weak) id<AGLPhotoCollectionControllerDelegate> delegate;

- (instancetype)initWithALAssetsGroup:(ALAssetsGroup *)group;
@end
