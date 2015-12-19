//
//  AGLSendButton.m
//  AGLImagePicker
//
//  Created by 李亚洲 on 15/12/19.
//  Copyright © 2015年 angryli. All rights reserved.
//

#import "AGLSendButton.h"

@interface AGLSendButton()
@property (nonatomic, strong) UIButton *btnSend;
@property (nonatomic, strong) UILabel *badgeLabel;
@end

@implementation AGLSendButton
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self p_buildUI];
    }
    return self;
}
- (void)p_buildUI
{
    CGFloat btnHeight = 30;
    CGFloat marginX = 10;
    [self addSubview:self.badgeLabel];
    [self addSubview:self.btnSend];
    
    self.badgeLabel.frame = CGRectMake(0, (self.bounds.size.height - btnHeight) * 0.5, btnHeight, btnHeight);
    self.badgeLabel.layer.cornerRadius = btnHeight * 0.5;
    self.badgeLabel.layer.masksToBounds = YES;
    self.badgeLabel.hidden = YES;
    self.btnSend.frame = CGRectMake(CGRectGetMaxX(self.badgeLabel.frame) + marginX, self.badgeLabel.frame.origin.y, self.bounds.size.width - btnHeight - marginX, btnHeight);
}
#pragma public
- (void)setEnable:(BOOL)enable
{
    if (enable) {
        self.btnSend.enabled = YES;
    } else {
        self.btnSend.enabled = NO;
    }
}
- (void)setBadge:(NSNumber *)badge
{
    if (badge.integerValue <= 0) {
        self.badgeLabel.hidden = YES;
    } else {
        self.badgeLabel.text = [NSString stringWithFormat:@"%@",badge];
        self.badgeLabel.hidden = NO;
    }
}
- (void)addTarget:(id)target action:(SEL)action
{
    [self.btnSend addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}
#pragma mark - get
- (UIButton *)btnSend
{
    if (!_btnSend) {
        _btnSend = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btnSend setTitle:@"发送" forState:UIControlStateNormal];
        [_btnSend setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_btnSend setTitleColor:[UIColor redColor] forState:UIControlStateDisabled];
    }
    return _btnSend;
}
- (UILabel *)badgeLabel
{
    if (!_badgeLabel) {
        _badgeLabel = [[UILabel alloc]init];
        _badgeLabel.font = [UIFont systemFontOfSize:12];
        _badgeLabel.textAlignment = NSTextAlignmentCenter;
        _badgeLabel.backgroundColor = [UIColor greenColor];
        _badgeLabel.textColor = [UIColor blackColor];
    }
    return _badgeLabel;
}
@end
