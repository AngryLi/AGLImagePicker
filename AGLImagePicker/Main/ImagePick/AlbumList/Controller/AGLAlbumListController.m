//
//  AGLAlbumListController.m
//  AGLImagePicker
//
//  Created by 李亚洲 on 15/12/12.
//  Copyright © 2015年 angryli. All rights reserved.
//

#import "AGLAlbumListController.h"

#import "AGLPhotoCollectionController.h"

#import <AssetsLibrary/AssetsLibrary.h>

static ALAssetsLibrary *assetLibrary;

@interface AGLAlbumListController ()
@property (nonatomic, strong) NSMutableArray *photoGoupList;
@end

@implementation AGLAlbumListController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self p_buildNavigationBar];
    
    [self p_initData];
}

- (void)p_buildNavigationBar
{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(p_dismiss)];
}

- (void)p_initData
{
    if (assetLibrary == nil) {
        assetLibrary = [[ALAssetsLibrary alloc]init];
    }
    self.photoGoupList = [@[] mutableCopy];
    [assetLibrary enumerateGroupsWithTypes:ALAssetsGroupAll | ALAssetsGroupLibrary usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        if (group) {
            [self.photoGoupList addObject:group];
        } else {
            NSLog(@"去玩了%@",self.photoGoupList);
            [self.tableView reloadData];
        }
    } failureBlock:^(NSError *error) {
        
    }];
}

- (void)p_dismiss
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    cell.textLabel.text = [group valueForProperty:ALAssetsGroupPropertyName];
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
@end
