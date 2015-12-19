//
//  AGLPhotoCollectionViewCell.h
//  AGLImagePicker
//
//  Created by 李亚洲 on 15/12/12.
//  Copyright © 2015年 angryli. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AGLALAssetModel;
typedef void(^UpdateSelectBlock)(AGLALAssetModel *alassetModel);
@interface AGLPhotoCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong, readonly) AGLALAssetModel *alassetModel;
@property (nonatomic, copy) UpdateSelectBlock _updateSelectBlock;

- (void)setAlassetModel:(AGLALAssetModel *)alassetModel;

- (void)setAssetSelect:(BOOL)select;

@end
