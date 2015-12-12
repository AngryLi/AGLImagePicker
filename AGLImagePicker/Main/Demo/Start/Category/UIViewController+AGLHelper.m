//
//  UIViewController+AGLHelper.m
//  AGLImagePicker
//
//  Created by 李亚洲 on 15/12/12.
//  Copyright © 2015年 angryli. All rights reserved.
//

#import "UIViewController+AGLHelper.h"

#import "AGLPhotoPickerController.h"

@interface UIViewController () <UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@end

@implementation UIViewController (AGLHelper)
- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message
{
    if ([UIDevice currentDevice].systemVersion.floatValue < 8.0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
        [alert show];
    } else {
        UIAlertController *alertVc = [[UIAlertController alloc]init];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        alertVc.title = title;
        alertVc.message = message;
        [alertVc addAction:cancelAction];
        [self showViewController:alertVc sender:nil];
    }
}
- (void)showSelecPhotoAlert
{
    if ([UIDevice currentDevice].systemVersion.floatValue < 8.0) {
        // 按钮的index从上到下0开始数(与位置有关,与类型无关)
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"选择方式" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"相机", @"从相册选取", nil];
        [sheet showInView:self.view];
    } else {
        UIAlertController *alertVc = [[UIAlertController alloc]init];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self takePhoto];
        }];
        UIAlertAction *albumAction = [UIAlertAction actionWithTitle:@"从相册选取" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self localPhoto];
        }];
        [alertVc addAction:cancelAction];
        [alertVc addAction:cameraAction];
        [alertVc addAction:albumAction];
        [self showViewController:alertVc sender:nil];
    }
}
#pragma mark - 使用系统相机
- (void)takePhoto
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc]init];
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        picker.delegate = self;
        picker.allowsEditing = YES;
        [self presentViewController:picker animated:YES completion:nil];
    } else {
        [self showAlertWithTitle:@"警告" message:@"搞设备不支持相机"];
    }
}
- (void)localPhoto
{
    AGLPhotoPickerController *picker = [[AGLPhotoPickerController alloc]init];
    [self presentViewController:picker animated:YES completion:nil];
//    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
//        UIImagePickerController *picker = [[UIImagePickerController alloc]init];
//        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//        picker.delegate = self;
//        picker.allowsEditing = YES;
//        [self presentViewController:picker animated:YES completion:nil];
//    } else {
//        [self showAlertWithTitle:@"警告" message:@"搞设备不支持相机"];
//    }
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{
//        UIImage *oroginalImage = info[@"UIImagePickerControllerOriginalImage"];
//        UIImage *editedImage = info[@"UIImagePickerControllerEditedImage"];
    }];
}
#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0: {
            [self takePhoto];
            break;
        }
        case 1:{
            [self localPhoto];
            break;
        }
        default:
            break;
    }
}
@end
