//
//  AGLAlbumListController.m
//  AGLImagePicker
//
//  Created by 李亚洲 on 15/12/12.
//  Copyright © 2015年 angryli. All rights reserved.
//

#import "AGLAlbumListController.h"

#import "AGLPhotoCollectionController.h"

#import "AGLPhotoPickerConstants.h"

#import <AssetsLibrary/AssetsLibrary.h>

static ALAssetsLibrary *assetLibrary;

@interface AGLAlbumListController ()
@property (nonatomic, strong) NSArray *photoGoupList;

@property (nonatomic, strong) NSArray<NSNumber *> *groupTypes;
@end

@implementation AGLAlbumListController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.rowHeight = 60;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(e_cancelOnClick)];
    
    [self p_reloadPhotoGroups];
}

#pragma mark - private
- (void)showUnAuthorizedTipsView
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"未授权" message:@"请在设置里为该应用打开权限" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil];
    [alert show];
}
- (NSAttributedString *)albumTitle:(ALAssetsGroup *)assetsGroup
{
    NSString *albumTitle = [assetsGroup valueForProperty:ALAssetsGroupPropertyName];
    NSString *numberString = [NSString stringWithFormat:@"  (%@)",@(assetsGroup.numberOfAssets)];
    NSString *cellTitleString = [NSString stringWithFormat:@"%@%@",albumTitle,numberString];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:cellTitleString];
    [attributedString setAttributes: @{
                                       NSFontAttributeName : [UIFont systemFontOfSize:16.0f],
                                       NSForegroundColorAttributeName : [UIColor blackColor],
                                       }
                              range:NSMakeRange(0, albumTitle.length)];
    [attributedString setAttributes:@{
                                      NSFontAttributeName : [UIFont systemFontOfSize:16.0f],
                                      NSForegroundColorAttributeName : [UIColor grayColor],
                                      } range:NSMakeRange(albumTitle.length, numberString.length)];
    return attributedString;
    
}
- (void)p_reloadPhotoGroups
{
    [self p_fetchGroupWithGroupTypeList:self.groupTypes sucess:^(NSArray *groupList) {
        self.photoGoupList = [groupList sortedArrayUsingComparator:^NSComparisonResult(ALAssetsGroup *  _Nonnull obj1, ALAssetsGroup *  _Nonnull obj2) {
            return [[obj2 valueForProperty:ALAssetsGroupPropertyType] compare:[obj1 valueForProperty:ALAssetsGroupPropertyType]];
        }];
        [self.tableView reloadData];
    } withFailture:^(NSError *error) {
        if ([ALAssetsLibrary authorizationStatus] != ALAuthorizationStatusAuthorized){
            [self showUnAuthorizedTipsView];
        }
    }];
}
- (void)p_fetchGroupWithGroupTypeList:(NSArray<NSNumber *> *)groups sucess:(void(^)(NSArray *groupList))sucessBlock withFailture:(void(^)(NSError *error))failtureBlock
{
    if (assetLibrary == nil) {
        assetLibrary = [[ALAssetsLibrary alloc]init];
    }
    NSMutableArray<ALAssetsGroup *> *groupList = [@[] mutableCopy];
    [assetLibrary enumerateGroupsWithTypes:ALAssetsGroupAll | ALAssetsGroupLibrary usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        if (group) {
            [group setAssetsFilter:[ALAssetsFilter allPhotos]];
            if (group.numberOfAssets > 0) {
                [groupList addObject:group];
            }
        } else {
            if (sucessBlock) {
                sucessBlock(groupList);
            }
        }
    } failureBlock:^(NSError *error) {
        if (failtureBlock) {
            failtureBlock(error);
        }
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)e_cancelOnClick
{
    [[NSNotificationCenter defaultCenter] postNotificationName:AGLPhotoPickerCancelNotification object:nil];
}
- (void)e_doneOnClick
{
    [[NSNotificationCenter defaultCenter] postNotificationName:AGLPhotoPickerDoneNotification object:@[]];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.photoGoupList == nil? 0 : self.photoGoupList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    // Configure the cell...
    ALAssetsGroup *group = self.photoGoupList[indexPath.row];
    cell.textLabel.attributedText = [self albumTitle:group];
    [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
        if (result) {
            cell.imageView.image = [UIImage imageWithCGImage:result.thumbnail];
            *stop = YES;
        }
    }];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    AGLPhotoCollectionController *photoListVc = [[AGLPhotoCollectionController alloc]initWithALAssetsGroup:self.photoGoupList[indexPath.item]];
    [self.navigationController pushViewController:photoListVc animated:YES];
}

#pragma mark - get
- (NSArray<NSNumber *> *)groupTypes
{
    if (!_groupTypes) {
        _groupTypes = @[@(ALAssetsGroupAll)];
    }
    return _groupTypes;
}
#pragma mark - AGLPhotoCollectionControllerDelegate
- (void)photoCollectionController:(AGLPhotoCollectionController *)controller cancel:(BOOL)cancel
{
    [[NSNotificationCenter defaultCenter] postNotificationName:AGLPhotoPickerCancelNotification object:nil];
}
- (void)photoCollectionController:(AGLPhotoCollectionController *)controller didSelectPhoto:(NSArray<AGLALAssetModel *> *)photos
{
    [[NSNotificationCenter defaultCenter] postNotificationName:AGLPhotoPickerDoneNotification object:photos];
}
@end
