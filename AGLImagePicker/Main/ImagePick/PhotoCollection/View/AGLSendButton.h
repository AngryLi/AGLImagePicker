//
//  AGLSendButton.h
//  AGLImagePicker
//
//  Created by 李亚洲 on 15/12/19.
//  Copyright © 2015年 angryli. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AGLSendButton : UIView
@property (nonatomic, assign) BOOL enable;

- (void)setBadge:(NSNumber *)badge;
- (void)addTarget:(id)target action:(SEL)action;
@end
