//
//  AGLBrowerViewController.h
//  AGLImagePicker
//
//  Created by 李亚洲 on 15/12/19.
//  Copyright © 2015年 angryli. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AGLALAssetModel, AGLBrowerViewController;
@protocol AGLBrowerViewControllerDelegate <NSObject>
- (void)browerViewController:(AGLBrowerViewController *)controller didSelectAsset:(BOOL)select withItem:(NSInteger)item;
- (void)browerViewController:(AGLBrowerViewController *)controller didSelectFullImage:(BOOL)fullImage;
- (void)browerViewController:(AGLBrowerViewController *)controller didSelectSend:(NSArray *)doneAssets;
@end

@interface AGLBrowerViewController : UIViewController
@property (nonatomic, weak) id<AGLBrowerViewControllerDelegate> delegate;

- (instancetype)initWithPhotoList:(NSArray<AGLALAssetModel *> *)photos withDonesAssets:(NSArray *)dones withCurrentPage:(NSInteger)page;
@end
