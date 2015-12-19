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

@interface AGLPhotoCollectionViewCell ()
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIButton *btnSelect;
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
        
        _btnSelect = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnSelect.imageView.contentMode = UIViewContentModeScaleToFill;
        [_btnSelect setImage:[UIImage imageNamed:@"photo_check_default"] forState:UIControlStateNormal];
        [_btnSelect setImage:[UIImage imageNamed:@"photo_check_selected"] forState:UIControlStateSelected];
        _btnSelect.frame = CGRectMake(CGRectGetMaxX(self.bounds) - 5 - 25, 5, 25, 25);
        [_btnSelect addTarget:self action:@selector(e_onClickBtnSelect:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_btnSelect];
    }
    return self;
}
- (void)setAlassetModel:(AGLALAssetModel *)alassetModel
{
    _alassetModel = alassetModel;
    _imageView.image = [alassetModel getThumbnail];
    _btnSelect.selected = alassetModel.isSelected;
}
- (void)p_setBtnSelected:(BOOL)select
{
    [self.alassetModel setSelected:select];
    _btnSelect.selected = select;
    if (self._updateSelectBlock) {
        self._updateSelectBlock(self.alassetModel);
    }
    _btnSelect.layer.transform = CATransform3DMakeScale(0.5, 0.5, 1.0);
    [UIView animateWithDuration:0.5
                delay:0.0
                usingSpringWithDamping:0.3
                initialSpringVelocity:1.0
                options:UIViewAnimationOptionCurveEaseIn
                animations:^{
                _btnSelect.layer.transform = CATransform3DMakeScale(1.0, 1.0, 1.0);
            } completion:nil];
}
- (void)e_onClickBtnSelect:(UIButton *)sender
{
    if (sender.selected) {
        [self p_setBtnSelected:NO];
    } else {
        [self p_setBtnSelected:YES];
    }
}
#pragma mark - public
- (void)setAssetSelect:(BOOL)select
{
    [self p_setBtnSelected:select];
//    self.alassetModel.selected = select;
}
@end
