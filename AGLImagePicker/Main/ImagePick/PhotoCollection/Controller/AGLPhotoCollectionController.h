//
//  AGLPhotoCollectionController.h
//  AGLImagePicker
//
//  Created by 李亚洲 on 15/12/12.
//  Copyright © 2015年 angryli. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ALAssetsGroup, AGLALAssetModel;
@interface AGLPhotoCollectionController : UIViewController
- (instancetype)initWithALAssetsGroup:(ALAssetsGroup *)group;
@end
