//
//  AGLALAssetModel.m
//  AGLImagePicker
//
//  Created by 李亚洲 on 15/12/12.
//  Copyright © 2015年 angryli. All rights reserved.
//

#import "AGLALAssetModel.h"

#import <AssetsLibrary/AssetsLibrary.h>

@interface AGLALAssetModel ()
@property (nonatomic, strong) ALAsset *alAsset;
@property (nonatomic, strong) UIImage *image;
@end

@implementation AGLALAssetModel

- (void)setAlAsset:(ALAsset *)alAsset
{
    _alAsset = alAsset;
    self.image = [UIImage imageWithCGImage:alAsset.thumbnail];
}
- (void)setAssetId:(NSNumber *)assetId
{
    _assetId = assetId;
}
- (void)setSelected:(BOOL)selected
{
    _selected = selected;
}
- (UIImage *)getThumbnail
{
    return self.image;
}
- (UIImage *)image
{
    if (!_image) {
        _image = [UIImage imageWithCGImage:_alAsset.thumbnail];
    }
    return _image;
}
@end
