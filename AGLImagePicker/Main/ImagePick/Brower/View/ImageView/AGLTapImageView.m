//
//  UIImageViewTap.m
//  Momento
//
//  Created by Michael Waterfall on 04/11/2009.
//  Copyright 2009 d3i. All rights reserved.
//

#import "AGLTapImageView.h"

@implementation AGLTapImageView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
        singleTap.numberOfTapsRequired = 1;
        singleTap.numberOfTouchesRequired = 1;
        [self addGestureRecognizer:singleTap];
        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
        doubleTap.numberOfTapsRequired = 2;
        doubleTap.numberOfTouchesRequired = 1;
        [self addGestureRecognizer:doubleTap];
        
        [singleTap requireGestureRecognizerToFail:doubleTap];
    }
    return self;
}

//- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
//	UITouch *touch = [touches anyObject];
//	NSUInteger tapCount = touch.tapCount;
//	switch (tapCount) {
//		case 1:
//			[self handleSingleTap:touch];
//			break;
//		case 2:
//			[self handleDoubleTap:touch];
//			break;
//		case 3:
//			[self handleTripleTap:touch];
//			break;
//		default:
//			break;
//	}
//	[[self nextResponder] touchesEnded:touches withEvent:event];
//}

- (void)handleSingleTap:(UITapGestureRecognizer *)touch {
	if ([_delegate respondsToSelector:@selector(imageView:singleTapDetected:)])
		[_delegate imageView:self singleTapDetected:touch];
}

- (void)handleDoubleTap:(UITapGestureRecognizer *)touch {
	if ([_delegate respondsToSelector:@selector(imageView:doubleTapDetected:)])
		[_delegate imageView:self doubleTapDetected:touch];
}

@end
