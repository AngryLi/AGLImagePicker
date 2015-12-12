//
//  AGLPhotoCollectionController.m
//  AGLImagePicker
//
//  Created by 李亚洲 on 15/12/12.
//  Copyright © 2015年 angryli. All rights reserved.
//

#import "AGLPhotoCollectionController.h"

#import "AGLPhotoCollectionViewCell.h"

#import "AGLALAssetModel.h"

#import <AssetsLibrary/AssetsLibrary.h>

@interface AGLPhotoCollectionController () <UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) ALAssetsGroup *currentGroup;
@property (nonatomic, strong) NSMutableArray *imageArray;

@property (nonatomic, strong) NSMutableArray *selectAssetList;
@end

@implementation AGLPhotoCollectionController
- (instancetype)initWithALAssetsGroup:(ALAssetsGroup *)group
{
    if (self = [super init]) {
        _currentGroup = group;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    dispatch_async(dispatch_get_main_queue(), ^{
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(e_onClickConfirm)];
        self.navigationItem.rightBarButtonItem = rightItem;
    });
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    CGFloat row = 4;
    CGFloat margin = 3;
    flowLayout.minimumInteritemSpacing = margin;
    flowLayout.minimumLineSpacing = margin;
    CGFloat itemWidth = ([UIScreen mainScreen].bounds.size.width - (row - 1) * margin) / row;
    flowLayout.itemSize = CGSizeMake(itemWidth, itemWidth);
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
    [self.collectionView registerClass:[AGLPhotoCollectionViewCell class] forCellWithReuseIdentifier:@"AGLPhotoCollectionViewCell"];
    self.collectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.collectionView.scrollIndicatorInsets = self.collectionView.contentInset;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.collectionView];
    [self p_reloadDatas];
}

#pragma mark - private
- (void)p_reloadDatas
{
    self.selectAssetList = [@[] mutableCopy];
    self.imageArray = [@[] mutableCopy];
    if (self.currentGroup == nil) {
        
    } else {
        [self.currentGroup enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
            if (result) {
                if ([[result valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypePhoto]) {
                    AGLALAssetModel *asset = [AGLALAssetModel new];
                    [asset setAssetId:@(index)];
                    [asset setAlAsset:result];
                    [self.imageArray insertObject:asset atIndex:0];
                }
            } else {
                [self.collectionView reloadData];
            }
        }];
    }
}
#pragma mark - event
- (void)e_onClickConfirm
{
    [self dismissViewControllerAnimated:YES completion:nil];
    NSLog(@"选取了%@张照片",@(_selectAssetList.count));
}
#pragma mark - UICollectionView
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSInteger rowCnt = self.imageArray.count;
    return rowCnt;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    AGLPhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"AGLPhotoCollectionViewCell" forIndexPath:indexPath];
    [cell setAlassetModel:self.imageArray[indexPath.item]];
    if (cell._updateSelectBlock == nil) {
        cell._updateSelectBlock = ^(AGLALAssetModel *alssetModel) {
            if (alssetModel.isSelected) {
                [self.selectAssetList addObject:alssetModel.assetId];
            } else {
                [self.selectAssetList removeObject:alssetModel.assetId];
            }
        };
    }
    return cell;
}
@end
