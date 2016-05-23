//
//  AGLBrowerViewController.m
//  AGLImagePicker
//
//  Created by 李亚洲 on 15/12/19.
//  Copyright © 2015年 angryli. All rights reserved.
//

#import "AGLBrowerViewController.h"

#import "AGLALAssetModel.h"

#import "AGLBrowserCell.h"

#import "AGLSendButton.h"

@interface AGLBrowerViewController () <UICollectionViewDataSource, UICollectionViewDelegate, AGLBrowserCellDelagete>
{
    struct {
        unsigned int selectAsset    :1;
        unsigned int selectFullImage:1;
        unsigned int selectSend     :1;
    }_delefateFlags;
    UIToolbar *_bottomToolBar;
    BOOL _selfStatusHidden;
}
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIButton *checkButton;
@property (nonatomic, strong) UIButton *fullImageButton;
@property (nonatomic, strong) AGLSendButton *sendButton;
// 展示的图片 MLSelectAssets
@property (strong,nonatomic) NSArray *photos;
@property (strong,nonatomic) NSMutableArray *doneAssets;
// 当前提供的分页数
@property (nonatomic , assign) NSInteger currentPage;
@end
static NSInteger ZLPickerColletionViewPadding = 20;
@implementation AGLBrowerViewController
- (id)initWithPhotoList:(NSArray<AGLALAssetModel *> *)photos withDonesAssets:(NSArray *)dones withCurrentPage:(NSInteger)page
{
    if (self = [super init]) {
        _photos = photos;
        _doneAssets = [dones mutableCopy];
        _currentPage = page;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.extendedLayoutIncludesOpaqueBars = YES;
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.minimumLineSpacing = 0;
    flowLayout.itemSize = CGSizeMake(self.view.frame.size.width + ZLPickerColletionViewPadding, self.view.frame.size.height);
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(-ZLPickerColletionViewPadding * 0.5, 0, self.view.frame.size.width + ZLPickerColletionViewPadding,self.view.frame.size.height) collectionViewLayout:flowLayout];
    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.showsVerticalScrollIndicator = NO;
    collectionView.pagingEnabled = YES;
    collectionView.dataSource = self;
    collectionView.delegate = self;
    collectionView.backgroundColor = [UIColor clearColor];
    collectionView.bounces = YES;
    [collectionView registerClass:[AGLBrowserCell class] forCellWithReuseIdentifier:@"AGLBrowserCell"];
    [self.view addSubview:collectionView];
    self.collectionView = collectionView;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.checkButton];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    [self p_buildToolBar];
    [self p_updateSendButton];
    [self p_updateCheckButton];
    [self p_updateCollection];
}
- (void)p_updateCollection
{
    [self.collectionView setContentOffset:CGPointMake(self.currentPage * self.collectionView.frame.size.width, 0) animated:NO];
    [self p_updateTitleWithCurrenPage:self.currentPage + 1 withAllPageCnt:self.photos.count];
}
- (void)p_updateTitleWithCurrenPage:(NSInteger)page withAllPageCnt:(NSInteger)allPage
{
    self.title = [NSString stringWithFormat:@"%@ / %@",@(page), @(allPage)];
}
- (void)p_updateCheckButton
{
    AGLALAssetModel *model = self.photos[self.currentPage];
    self.checkButton.selected = model.selected;
}
- (void)p_updateSendButton
{
    if (self.doneAssets.count > 0) {
        self.sendButton.enable = YES;
    } else {
        self.sendButton.enable = NO;
    }
    [self.sendButton setBadge:@(self.doneAssets.count)];
}
- (void)p_buildToolBar
{
    UIToolbar *toolbar= [[UIToolbar alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.frame) - 40, CGRectGetWidth(self.view.frame), 40)];
    toolbar.backgroundColor = [UIColor redColor];
    [toolbar setBackgroundImage:[UIImage new] forToolbarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    toolbar.translucent = NO;
    
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithCustomView:self.fullImageButton];
    UIBarButtonItem *item2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *item3 = [[UIBarButtonItem alloc] initWithCustomView:self.sendButton];
    [toolbar setItems:@[item1, item2, item3] animated:NO];
    self->_bottomToolBar = toolbar;
    [self.view addSubview:toolbar];
}
#pragma mark - <UICollectionViewDataSource>
- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.photos.count;
}

- (UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    AGLBrowserCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"AGLBrowserCell" forIndexPath:indexPath];
    cell.delegate = self;
    [cell setAssetModel:self.photos[indexPath.item]];
    return cell;
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger page = scrollView.contentOffset.x / scrollView.frame.size.width;
    self.currentPage = page;
    [self p_updateTitleWithCurrenPage:page + 1 withAllPageCnt:self.photos.count];
    [self p_updateCheckButton];
}
#pragma mark - get
- (UIButton *)checkButton
{
    if (nil == _checkButton) {
        _checkButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _checkButton.frame = CGRectMake(0, 0, 25, 25);
        [_checkButton setBackgroundImage:[UIImage imageNamed:@"photo_check_selected"] forState:UIControlStateSelected];
        [_checkButton setBackgroundImage:[UIImage imageNamed:@"photo_check_default"] forState:UIControlStateNormal];
        [_checkButton addTarget:self action:@selector(e_checkButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _checkButton;
}
- (UIButton *)fullImageButton
{
    if (nil == _fullImageButton) {
        _fullImageButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _fullImageButton.frame = CGRectMake(0, 0, 25, 25);
        [_fullImageButton setBackgroundImage:[UIImage imageNamed:@"photo_check_selected"] forState:UIControlStateSelected];
        [_fullImageButton setBackgroundImage:[UIImage imageNamed:@"photo_check_default"] forState:UIControlStateNormal];
        [_fullImageButton addTarget:self action:@selector(e_fullImageOnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _fullImageButton;
}
- (AGLSendButton *)sendButton
{
    if (!_sendButton) {
        _sendButton = [[AGLSendButton alloc]initWithFrame:CGRectMake(0, 0, 80, 40)];
        [_sendButton addTarget:self action:@selector(e_sendOnClick)];
    }
    return _sendButton;
}
// set
- (void)setDelegate:(id<AGLBrowerViewControllerDelegate>)delegate
{
    _delegate = delegate;
    _delefateFlags.selectAsset = [delegate respondsToSelector:@selector(browerViewController:didSelectAsset:withItem:)];
    _delefateFlags.selectFullImage = [delegate respondsToSelector:@selector(browerViewController:didSelectFullImage:)];
    _delefateFlags.selectSend = [delegate respondsToSelector:@selector(browerViewController:didSelectSend:)];
}
#pragma mark - AGLBrowserCellDelagete
- (void)browserCell:(AGLBrowserCell *)cell singleTap:(BOOL)tap
{
    if (tap) {
        [self p_updateNavigationAndBottomToolBar];
    }
}
#pragma mark - event
- (void)p_updateNavigationAndBottomToolBar
{
    // Force visible
    BOOL hidden = !(self->_bottomToolBar.alpha == 0);
    // Animations & positions
    CGFloat animatonOffset = 20;
    CGFloat animationDuration = 0.35;
//    [self.navigationController setNavigationBarHidden:NO animated:YES];
        CGRect frame = self->_bottomToolBar.frame;
    /// 原作者巧妙的将toolbar移动20个位置（然而我是根据别人的代码改的）。当好和statusbar移动相同的位置
    /// 这样在相同时间内toolbar和statusbar移动相同的位置，并且同时隐藏(包括alpha = 0)，同步效果会更完美。
    /// 但是总感觉哪里不对劲的样子。
    /// 是不是使用([self.navigationController setNavigationBarHidden:YES animated:YES];)会更好呢
    frame.origin.y = hidden? frame.origin.y + animatonOffset : frame.origin.y - animatonOffset;
    _selfStatusHidden = hidden;
    [UIView animateWithDuration:animationDuration animations:^{
        [self setNeedsStatusBarAppearanceUpdate];
            CGFloat alpha = hidden? 0 : 1;
            [self.navigationController.navigationBar setAlpha:alpha];
            self->_bottomToolBar.frame = frame;
            self->_bottomToolBar.alpha = alpha;
//            [self.navigationController.navigationBar setAlpha:alpha];
        }];
}
- (void)e_checkButtonAction
{
    AGLALAssetModel *model = self.photos[self.currentPage];
    model.selected = !model.selected;
    self.checkButton.selected = model.selected;
    if (model.selected) {
        [self.doneAssets addObject:model];
    } else {
        [self.doneAssets removeObject:model];
    }
    [self p_updateSendButton];
    if (_delefateFlags.selectAsset) {
        [_delegate browerViewController:self didSelectAsset:model.selected withItem:self.currentPage];
    }
}
- (void)e_fullImageOnClick
{
    self.fullImageButton.selected = !self.fullImageButton.selected;
    if (_delefateFlags.selectFullImage) {
        [_delegate browerViewController:self didSelectFullImage:self.fullImageButton.selected];
    }
}
- (void)e_sendOnClick
{
    if (_delefateFlags.selectSend) {
        [_delegate browerViewController:self didSelectSend:[self.doneAssets copy]];
    }
}
- (BOOL)prefersStatusBarHidden
{
    return _selfStatusHidden;
}
- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation
{
    return UIStatusBarAnimationSlide;
}
@end
