//
//  AGLPhotoPickerView.m
//  AGLImagePicker
//
//  Created by 李亚洲 on 15/12/12.
//  Copyright © 2015年 angryli. All rights reserved.
//

#import "AGLPhotoPickerController.h"

#import "AGLAlbumListController.h"

@implementation AGLPhotoPickerController
- (instancetype)init
{
    AGLAlbumListController *albumListVc = [[AGLAlbumListController alloc]init];
    self = [super initWithRootViewController:albumListVc];
    if (self) {
    }
    return self;
}
@end
