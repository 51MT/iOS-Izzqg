//
//  HiddenNavBarBaseViewController.m
//  Ixyb
//
//  Created by wangjianimac on 2017/9/21.
//  Copyright © 2017年 xyb. All rights reserved.
//

#import "HiddenNavBarBaseViewController.h"
#import "WRNavigationBar.h"

@implementation HiddenNavBarBaseViewController

#pragma mark - ViewController内置方法，自动执行
- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupNavBar];
}

- (void)setupNavBar {

    self.navigationController.navigationBar.hidden = YES;
    self.automaticallyAdjustsScrollViewInsets = YES;
    
    
    // 自定义导航栏必须设置这个属性!!!!!!!
    [self wr_setCustomNavBar:self.navBar];

    [self.view addSubview:self.navBar];
    self.navBar.items = @[self.navItem];

    _navMaxY = CGRectGetMaxY(self.navBar.frame);
    
    // 设置自定义导航栏默认背景颜色
    [self wr_setNavBarBarTintColor:COLOR_MAIN];

    // 设置自定义导航栏背景图片
    //[self wr_setNavBarBackgroundImage:[UIImage imageNamed:@"millcolorGrad"]];

    // 设置自定义导航栏透明度
    [self wr_setNavBarBackgroundAlpha:1.0f];

    // 设置自定义导航栏标题颜色
    [self wr_setNavBarTitleColor:[UIColor whiteColor]];

    // 设置自定义导航栏左右按钮字体颜色
    [self wr_setNavBarTintColor:[UIColor whiteColor]];

    // 设置状态栏是 default 还是 lightContent
    [self wr_setStatusBarStyle:UIStatusBarStyleLightContent];

    // 设置自定义导航栏底部分割线是否隐藏
    [self wr_setNavBarShadowImageHidden:YES];
}


- (XYNavigationBar *)navBar {
    if (_navBar == nil) {
        _navBar =  [XYNavigationBar defaultBar];
    }
    return _navBar;
}


- (UINavigationItem *)navItem {
    if (_navItem == nil) {
        _navItem = [UINavigationItem new];
    }
    return _navItem;
}

@end
