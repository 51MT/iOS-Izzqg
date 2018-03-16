//
//  NavigationController.m
//  Ixyb
//
//  Created by wangjianimac on 15/5/14.
//  Copyright (c) 2015年 xyb. All rights reserved.
//

#import "XYNavigationController.h"
#import "MyViewController.h"
#import "Utility.h"


@interface XYNavigationController ()

@end

@implementation XYNavigationController

#pragma mark 一个类只会调用一次
+ (void)initialize {

    // 1.取出设置主题的对象
    UINavigationBar *navBar = [UINavigationBar appearance];

    // 2.设置导航栏的背景图片和颜色
    navBar.barTintColor = COLOR_GRAY_MAIN;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    navBar.barStyle = UIBarStyleBlack;
    navBar.translucent = NO; //这是由于半透明模糊引起的

    // 3.标题
    [navBar setTitleTextAttributes:@{NSForegroundColorAttributeName : COLOR_COMMON_WHITE}];


    // 设置导航栏默认的背景颜色
    [UIColor wr_setDefaultNavBarBarTintColor:COLOR_GRAY_MAIN];
    
    // 设置导航栏所有按钮的默认颜色
    [UIColor wr_setDefaultNavBarTintColor:[UIColor whiteColor]];
    
    // 设置导航栏标题默认颜色
    [UIColor wr_setDefaultNavBarTitleColor:[UIColor whiteColor]];
    
    // 统一设置状态栏样式
    [UIColor wr_setDefaultStatusBarStyle:UIStatusBarStyleLightContent];
    
    // 如果需要设置导航栏底部分割线隐藏，可以在这里统一设置
    [UIColor wr_setDefaultNavBarShadowImageHidden:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    //方案一:开启使用系统自带的侧滑返回 和键盘发生冲突，不可用
//    self.interactivePopGestureRecognizer.delegate = (id) self;

    //方案二:实现UINavigationViewController的代理方法，自定义动画对象和交互对象。（即自定义转场动画）较复杂


    /** 方案三:极其简单取巧的方法 1.自定义侧滑返回 **/

    //    // 获取系统自带滑动手势的target对象
    //    id target = self.interactivePopGestureRecognizer.delegate;
    //    // 创建全屏滑动手势，调用系统自带滑动手势的target的action方法
    //    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:target action:@selector(handleNavigationTransition:)]; //私有API,审核可能会被拒
    //    // 设置手势代理，拦截手势触发
    //    pan.delegate = self;
    //    // 给导航控制器的view添加全屏滑动手势
    //    [self.view addGestureRecognizer:pan];
    //    // 禁止使用系统自带的滑动手势
    //    self.interactivePopGestureRecognizer.enabled = NO;
}



/** 方案三:极其简单取巧的方法 2.自定义侧滑返回 **/

// 什么时候调用：每次触发手势之前都会询问下代理，是否触发。作用：拦截手势触发
//- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
//
//    // 注意：只有非根控制器才有滑动返回功能，根控制器没有。
//    // 判断导航控制器是否只有一个子控制器，如果只有一个子控制器，肯定是根控制器
//    if (self.childViewControllers.count == 1) {
//        // 表示用户在根控制器界面，就不需要触发滑动手势，
//        return NO;
//    }
//    return YES;
//}


#pragma mark 控制状态栏的样式
- (BOOL)prefersStatusBarHidden {
    return NO;
}


- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}


/** 自定义导航栏控制器 start 20170919**/
//push隐藏BottomBar／TabBar
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.childViewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
}
/** 自定义导航栏控制器 start 20170919**/

@end
