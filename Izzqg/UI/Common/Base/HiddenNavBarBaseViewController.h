//
//  HiddenNavBarBaseViewController.h
//  Ixyb
//
//  Created by wangjianimac on 2017/9/21.
//  Copyright © 2017年 xyb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XYNavigationBar.h"
#import "BaseViewController.h"

@interface HiddenNavBarBaseViewController : BaseViewController

@property (nonatomic, strong) XYNavigationBar *navBar;   //自定义导航栏navBar
@property (nonatomic, strong) UINavigationItem *navItem; //自定义导航栏navItem
@property (nonatomic, assign, readonly) CGFloat navMaxY;

@end
