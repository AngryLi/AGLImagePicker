//
//  AGLPhotoCollectionController.m
//  AGLImagePicker
//
//  Created by 李亚洲 on 15/12/12.
//  Copyright © 2015年 angryli. All rights reserved.
//

#import "AGLPhotoCollectionController.h"
#import "AGLBrowerViewController.h"

#import "AGLPhotoPickerConstants.h"

#import "AGLPhotoCollectionViewCell.h"

#import "AGLSendButton.h"

#import "AGLALAssetModel.h"

#import <AssetsLibrary/AssetsLibrary.h>

@interface AGLPhotoCollectionController () <UICollectionViewDataSource, UICollectionViewDelegate, AGLBrowerViewControllerDelegate>
{
    UIBarButtonItem *preItem;
}
@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) ALAssetsGroup *currentGroup;
@property (nonatomic, strong) NSMutableArray *imageArray;

@property (nonatomic, strong) NSMutableArray<AGLALAssetModel *> *selectAssetList;

@property (nonatomic, strong) AGLSendButton *sendButton;
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
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(e_cancelOnClick)];
    [self p_buildToolBar];
    
    [self p_reloadDatas];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.toolbarHidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated
{
    self.navigationController.toolbarHidden = YES;
}
#pragma mark - private
- (void)p_buildToolBar
{
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithTitle:@"预览" style:UIBarButtonItemStylePlain target:self action:@selector(e_preOnClick)];
    [item1 setTintColor:[UIColor blackColor]];
    item1.enabled = NO;
    UIBarButtonItem *item2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    UIBarButtonItem *item3 = [[UIBarButtonItem alloc] initWithCustomView:self.sendButton];
    
    [self setToolbarItems:@[item1,item2,item3] animated:NO];
    self->preItem = item1;
    
    self->preItem.enabled = NO;
    self.sendButton.enable = NO;
}
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
-(void)showPhotoBrowerWithIndex:(NSInteger)currentIndex{
    
    AGLBrowerViewController *browserVc = [[AGLBrowerViewController alloc] initWithPhotoList:self.imageArray withDonesAssets:self.selectAssetList withCurrentPage:currentIndex];
    browserVc.delegate = self;
    [self.navigationController pushViewController:browserVc animated:YES];
}
- (void)p_photoDisSelect:(AGLALAssetModel *)model
{
    if (model.isSelected) {
        [self.selectAssetList addObject:model];
    } else {
        [self.selectAssetList removeObject:model];
    }
    if (_selectAssetList.count > 0) {
        self.sendButton.enable = YES;
        self->preItem.enabled = YES;
    } else {
        self.sendButton.enable = NO;
        self->preItem.enabled = NO;
    }
    [self.sendButton setBadge:@(_selectAssetList.count)];
}
#pragma mark - event
- (void)e_onClickConfirm
{
    [[NSNotificationCenter defaultCenter] postNotificationName:AGLPhotoPickerDoneNotification object:[_selectAssetList copy]];
}
- (void)e_preOnClick
{
    [self showPhotoBrowerWithIndex:0];
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
            [self p_photoDisSelect:alssetModel];
        };
    }
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    [self showPhotoBrowerWithIndex:indexPath.row];
}
#pragma mark - get
- (AGLSendButton *)sendButton
{
    if (!_sendButton) {
        _sendButton = [[AGLSendButton alloc]initWithFrame:CGRectMake(0, 0, 80, 40)];
        [_sendButton addTarget:self action:@selector(e_onClickConfirm)];
    }
    return _sendButton;
}
#pragma mark - AGLBrowerViewControllerDelegate
- (void)browerViewController:(AGLBrowerViewController *)controller didSelectAsset:(BOOL)select withItem:(NSInteger)item
{
//    AGLALAssetModel *model = self.imageArray[item];
//    model.selected = select;
    AGLPhotoCollectionViewCell *cell = (AGLPhotoCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:item inSection:0]];
    [cell setAssetSelect:select];
}
- (void)browerViewController:(AGLBrowerViewController *)controller didSelectFullImage:(BOOL)fullImage
{
    
}
- (void)browerViewController:(AGLBrowerViewController *)controller didSelectSend:(NSArray *)doneAssets
{
    [[NSNotificationCenter defaultCenter] postNotificationName:AGLPhotoPickerDoneNotification object:doneAssets];
}
#pragma mark - event
- (void)e_cancelOnClick
{
    [[NSNotificationCenter defaultCenter] postNotificationName:AGLPhotoPickerCancelNotification object:nil];
}
@end
