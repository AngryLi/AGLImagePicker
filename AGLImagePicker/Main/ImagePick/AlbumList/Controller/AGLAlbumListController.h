//
//  AGLAlbumListController.h
//  AGLImagePicker
//
//  Created by 李亚洲 on 15/12/12.
//  Copyright © 2015年 angryli. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AGLAlbumListController, AGLALAssetModel;
@protocol AGLAlbumListControllerDelegate <NSObject>
- (void)albumListController:(AGLAlbumListController *)controller didSelectPhotos:(NSArray<AGLALAssetModel *> *)photos;
- (void)albumListController:(AGLAlbumListController *)controller cancel:(BOOL)cancel;
@end
@interface AGLAlbumListController : UITableViewController
@property (nonatomic, weak) id<AGLAlbumListControllerDelegate> delegate;
@end
