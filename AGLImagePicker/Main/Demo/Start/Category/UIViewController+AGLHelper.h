//
//  UIViewController+AGLHelper.h
//  AGLImagePicker
//
//  Created by 李亚洲 on 15/12/12.
//  Copyright © 2015年 angryli. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (AGLHelper)
- (void)showSelecPhotoAlertWithCompleteHander:(void(^)(UIImage *image))completeHander;
@end
