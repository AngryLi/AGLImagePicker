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

- (void)setAlAsset:(ALAsset *)alAsset;
- (UIImage *)getThumbnail;
@end
