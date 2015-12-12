
#import <UIKit/UIKit.h>

@class AGLALAssetModel;
@interface AGLPhotoBrowserController : UIViewController
// 展示的图片 MLSelectAssets
@property (strong,nonatomic) NSArray *photos;

@property (strong,nonatomic) NSMutableArray *doneAssets;
// 长按图片弹出的UIActionSheet
@property (strong,nonatomic) UIActionSheet *sheet;
// 当前提供的分页数
@property (nonatomic , assign) NSInteger currentPage;

@property (copy)void(^selectPhotoBlock)(NSArray *photoArray);
@property (copy)void(^selectAssetBlock)(AGLALAssetModel *assetModel);

@end
