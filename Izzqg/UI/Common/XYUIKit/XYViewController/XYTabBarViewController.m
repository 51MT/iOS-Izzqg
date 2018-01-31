//
//  TabBarViewController.m
//  Ixyb
//
//  Created by wangjianimac on 15/8/14.
//  Copyright (c) 2015年 xyb. All rights reserved.
//

#import "XYNavigationController.h"
#import "XYTabBarViewController.h"

#import "FinancingViewController.h"
#import "MyViewController.h"
#import "SafeViewController.h"
#import "XsdViewController.h"

#import "Utility.h"

@interface XYTabBarViewController ()

@end

@implementation XYTabBarViewController

- (void)viewDidLoad {

    [super viewDidLoad];

    //设置选项卡选中图像的颜色
    self.tabBar.barTintColor = RGBACOLOR(248.0f, 248.0f, 248.0f, 0.9f); //最前景色
    //self.tabBar.tintColor = COLOR_MAIN;//前景色
    //self.tabBar.selectedImageTintColor = RGBACOLOR(251.0f,110.0f,83.0f,1.0f);

    FinancingViewController *financingVC = [[FinancingViewController alloc] init];
    financingVC.tabBarItem.title = XYBString(@"str_financing", @"首页"); //本地化，注释
    financingVC.tabBarItem.image = [[UIImage imageNamed:@"financing"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    financingVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"financing_select"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    financingVC.tabBarItem.tag = 600;
    XYNavigationController *financingNavigationController = [[XYNavigationController alloc] initWithRootViewController:financingVC];

    //    XsdViewController *xsdVC = [[XsdViewController alloc] init];
    //    xsdVC.tabBarItem.title = XYBString(@"str_xsdborrow", @"借款");
    //    xsdVC.tabBarItem.image = [[UIImage imageNamed:@"xsd_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    //    xsdVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"xsd_select"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    //    xsdVC.tabBarItem.tag = 601;
    //    XYNavigationController *xsdNavigationController = [[XYNavigationController alloc] initWithRootViewController:xsdVC];

    SafeViewController *safeVC = [[SafeViewController alloc] init];
    safeVC.tabBarItem.title = XYBString(@"str_safe", @"安全");
    safeVC.tabBarItem.image = [[UIImage imageNamed:@"safe"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    safeVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"safe_select"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    safeVC.tabBarItem.tag = 602;
    XYNavigationController *safeNavigationController = [[XYNavigationController alloc] initWithRootViewController:safeVC];

    MyViewController *myVC = [[MyViewController alloc] init];
    myVC.tabBarItem.title = XYBString(@"str_my", @"我的");
    myVC.tabBarItem.image = [[UIImage imageNamed:@"account"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    myVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"account_select"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    myVC.tabBarItem.tag = 603;
    XYNavigationController *myNavigationController = [[XYNavigationController alloc] initWithRootViewController:myVC];

    self.viewControllers = @[ financingNavigationController, safeNavigationController, myNavigationController ];

    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:COLOR_MAIN, NSForegroundColorAttributeName, nil]
                                             forState:UIControlStateSelected];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (BOOL)prefersStatusBarHidden {
    return NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

@end
