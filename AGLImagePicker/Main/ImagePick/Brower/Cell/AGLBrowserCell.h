//
//  AGLBrowserCell.h
//  AGLImagePicker
//
//  Created by 李亚洲 on 15/12/19.
//  Copyright © 2015年 angryli. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AGLALAssetModel;
@protocol AGLBrowserCellDelagete;
@interface AGLBrowserCell : UICollectionViewCell

@property (nonatomic, weak) id<AGLBrowserCellDelagete> delegate;
@property (nonatomic, strong) AGLALAssetModel *assetModel;
@end

@protocol AGLBrowserCellDelagete <NSObject>
- (void)browserCell:(AGLBrowserCell *)cell singleTap:(BOOL)tap;
@end
