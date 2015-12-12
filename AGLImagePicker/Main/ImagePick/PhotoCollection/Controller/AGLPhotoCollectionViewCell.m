//
//  AGLPhotoCollectionViewCell.m
//  AGLImagePicker
//
//  Created by 李亚洲 on 15/12/12.
//  Copyright © 2015年 angryli. All rights reserved.
//

#import "AGLPhotoCollectionViewCell.h"

#import "AGLALAssetModel.h"
#import <AssetsLibrary/AssetsLibrary.h>

#import "UIImageView+WebCache.h"

@interface AGLPhotoCollectionViewCell ()
@property (nonatomic, strong) UIImageView *imageView;
@end

@implementation AGLPhotoCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = YES;
        [self.contentView addSubview:_imageView];
    }
    return self;
}
- (void)setAlassetModel:(AGLALAssetModel *)alassetModel
{
    _alassetModel = alassetModel;
    _imageView.image = [alassetModel getThumbnail];
}
@end
