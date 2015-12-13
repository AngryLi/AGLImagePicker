//
//  AGLStartViewController.m
//  AGLImagePicker
//
//  Created by 李亚洲 on 15/12/12.
//  Copyright © 2015年 angryli. All rights reserved.
//

#import "AGLStartViewController.h"

#import "UIViewController+AGLHelper.h"

@interface AGLStartViewController ()

@end

@implementation AGLStartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self p_buildView];
}
#pragma mark - private,UI
- (void)p_buildView
{
    UIButton *btnAdd = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnAdd setTitle:@"选择照片" forState:UIControlStateNormal];
    [btnAdd setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btnAdd.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [btnAdd setBackgroundColor:[UIColor brownColor]];
    btnAdd.layer.cornerRadius = 10;
//    btnAdd.layer.
    btnAdd.frame = CGRectMake(0, 0, 100, 40);
    btnAdd.center = self.view.center;
    [btnAdd addTarget:self action:@selector(e_onclickSelectImage:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnAdd];
}
#pragma mark - private,Event
- (void)e_onclickSelectImage:(UIButton *)sender
{
    [self showSelecPhotoAlertWithCompleteHander:^(UIImage *image) {
        
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
