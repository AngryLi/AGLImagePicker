//
//  AGLBrowserCell.m
//  AGLImagePicker
//
//  Created by 李亚洲 on 15/12/19.
//  Copyright © 2015年 angryli. All rights reserved.
//

#import "AGLBrowserCell.h"

#import "AGLALAssetModel.h"

#import "AGLTapImageView.h"

@interface AGLBrowserCell () <UIScrollViewDelegate, AGLTapImageViewDelegate>
{
    UIScrollView *_scrollView;
    AGLTapImageView *_photoImageView;
}
@end

@implementation AGLBrowserCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(10, 0, self.bounds.size.width-20, self.bounds.size.height)];
        _scrollView.contentSize = _scrollView.frame.size;
        _scrollView.delegate = self;
        _scrollView.maximumZoomScale = 3;
        _scrollView.minimumZoomScale = 1;
        _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleWidth;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.decelerationRate = UIScrollViewDecelerationRateFast;
        [self.contentView addSubview:_scrollView];
        _photoImageView = [[AGLTapImageView alloc] initWithFrame:_scrollView.bounds];
        _photoImageView.delegate = self;
        _photoImageView.contentMode = UIViewContentModeScaleAspectFit;
        [_scrollView addSubview:_photoImageView];
    }
    return self;
}

- (void)layoutSubviews {
    // Super
    [super layoutSubviews];
    
    // Center the image as it becomes smaller than the size of the screen
    CGSize boundsSize = _scrollView.bounds.size;
    CGRect frameToCenter = _photoImageView.frame;
    
    // Horizontally
    if (frameToCenter.size.width < boundsSize.width) {
        frameToCenter.origin.x = floorf((boundsSize.width - frameToCenter.size.width) / 2.0);
    } else {
        frameToCenter.origin.x = 0;
    }
    
    // Vertically
    if (frameToCenter.size.height < boundsSize.height) {
        frameToCenter.origin.y = floorf((boundsSize.height - frameToCenter.size.height) / 2.0);
    } else {
        frameToCenter.origin.y = 0;
    }
    
    // Center
    if (!CGRectEqualToRect(_photoImageView.frame, frameToCenter))
        _photoImageView.frame = frameToCenter;
    
}
- (void)setAssetModel:(AGLALAssetModel *)assetModel
{
    _assetModel = assetModel;
    _photoImageView.image = [assetModel getDefault];
    _scrollView.zoomScale = 1;
    [self setNeedsLayout];
}
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return _photoImageView;
}
- (void)imageView:(UIImageView *)imageView doubleTapDetected:(UITouch *)touch {
    CGPoint touchPoint = [touch locationInView:touch.view];
    // Zoom
    if (_scrollView.zoomScale != _scrollView.minimumZoomScale) {
        // Zoom out
        [_scrollView setZoomScale:_scrollView.minimumZoomScale animated:YES];
    } else {
        // Zoom in to twice the size
        CGFloat newZoomScale = ((_scrollView.maximumZoomScale + _scrollView.minimumZoomScale) / 2);
        CGFloat xsize = _scrollView.bounds.size.width / newZoomScale;
        CGFloat ysize = _scrollView.bounds.size.height / newZoomScale;
        [_scrollView zoomToRect:CGRectMake(touchPoint.x - xsize / 2, touchPoint.y - ysize / 2, xsize, ysize) animated:YES];
        
    }
}
- (void)imageView:(UIImageView *)imageView singleTapDetected:(UITouch *)touch {
    if (self.delegate && [self.delegate respondsToSelector:@selector(browserCell:singleTap:)]) {
        [self.delegate browserCell:self singleTap:YES];
    }
}
- (void)imageView:(UIImageView *)imageView tripleTapDetected:(UITouch *)touch {
    
}
@end
