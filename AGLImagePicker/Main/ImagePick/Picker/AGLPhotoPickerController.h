//
//  AGLPhotoPickerView.h
//  AGLImagePicker
//
//  Created by 李亚洲 on 15/12/12.
//  Copyright © 2015年 angryli. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AGLPhotoPickerController;
@protocol AGLPhotoPickerControllerDelegate <NSObject>
- (void)photoPickerController:(AGLPhotoPickerController *)picker didSelectPhoto:(NSArray<UIImage *> *)photos;
- (void)photoPickerControllerDidCancel:(AGLPhotoPickerController *)picker;
@end
@interface AGLPhotoPickerController : UINavigationController
/// 因为重名了
@property (nonatomic, weak) id<AGLPhotoPickerControllerDelegate> aGLDelegate;
@end
