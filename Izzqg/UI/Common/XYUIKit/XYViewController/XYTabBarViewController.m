//
//  TabBarViewController.m
//  Ixyb
//
//  Created by wangjianimac on 15/8/14.
//  Copyright (c) 2015年 xyb. All rights reserved.
//

#import "XYNavigationController.h"
#import "XYTabBarViewController.h"

#import "MoneyBoxViewController.h"
#import "MyViewController.h"
#import "BenefitsViewController.h"

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

    MoneyBoxViewController *moneyBoxVC = [[MoneyBoxViewController alloc] init];
    moneyBoxVC.tabBarItem.title = XYBString(@"str_moneyBox", @"钱罐"); //本地化，注释
    moneyBoxVC.tabBarItem.image = [[UIImage imageNamed:@"moneyBox_icon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    moneyBoxVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"moneyBox_icon_select"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    moneyBoxVC.tabBarItem.tag = 600;
    XYNavigationController *moneyBoxNC = [[XYNavigationController alloc] initWithRootViewController:moneyBoxVC];


    BenefitsViewController *benefitsVC = [[BenefitsViewController alloc] init];
    benefitsVC.tabBarItem.title = XYBString(@"str_benefits", @"福利");
    benefitsVC.tabBarItem.image = [[UIImage imageNamed:@"benefit_icon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    benefitsVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"benefit_icon_select"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    benefitsVC.tabBarItem.tag = 602;
    XYNavigationController *benefitsNC = [[XYNavigationController alloc] initWithRootViewController:benefitsVC];
    

    MyViewController *myVC = [[MyViewController alloc] init];
    myVC.tabBarItem.title = XYBString(@"str_my", @"我的");
    myVC.tabBarItem.image = [[UIImage imageNamed:@"my_icon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    myVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"my_icon_select"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    myVC.tabBarItem.tag = 603;
    XYNavigationController *myNC = [[XYNavigationController alloc] initWithRootViewController:myVC];

    self.viewControllers = @[ moneyBoxNC, benefitsNC, myNC ];

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
