//
//  UIImageViewTap.h
//  Momento
//
//  Created by Michael Waterfall on 04/11/2009.
//  Copyright 2009 d3i. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AGLTapImageViewDelegate;

@interface AGLTapImageView : UIImageView {}
@property (nonatomic, weak) id <AGLTapImageViewDelegate> delegate;
@end
@protocol AGLTapImageViewDelegate <NSObject>
@optional
- (void)imageView:(UIImageView *)imageView singleTapDetected:(UITapGestureRecognizer *)touch;
- (void)imageView:(UIImageView *)imageView doubleTapDetected:(UITapGestureRecognizer *)touch;
@end