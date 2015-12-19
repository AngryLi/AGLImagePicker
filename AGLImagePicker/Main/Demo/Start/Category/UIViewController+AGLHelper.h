//
//  UIViewController+AGLHelper.h
//  AGLImagePicker
//
//  Created by 李亚洲 on 15/12/12.
//  Copyright © 2015年 angryli. All rights reserved.
//
#import "AGLPhotoPickerController.h"

@interface UIViewController (AGLHelper) <UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, AGLPhotoPickerControllerDelegate>

- (void)showSelecPhotoAlertWithCompleteHander:(void(^)(UIImage *image))completeHander;
@end
