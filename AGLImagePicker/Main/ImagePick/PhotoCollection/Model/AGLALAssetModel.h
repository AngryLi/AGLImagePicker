//
//  AGLALAssetModel.h
//  AGLImagePicker
//
//  Created by 李亚洲 on 15/12/12.
//  Copyright © 2015年 angryli. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ALAsset;
@interface AGLALAssetModel : NSObject
@property (nonatomic, strong, readonly) ALAsset *alAsset;
@property (nonatomic, strong, readonly) NSNumber *assetId;
@property (nonatomic, assign, readonly, getter=isSelected) BOOL selected;
- (void)setSelected:(BOOL)selected;
- (void)setAssetId:(NSNumber *)assetId;
- (void)setAlAsset:(ALAsset *)alAsset;
- (UIImage *)getThumbnail;
@end
