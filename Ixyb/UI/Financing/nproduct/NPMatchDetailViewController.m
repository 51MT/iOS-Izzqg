//
//  NPMatchDetailViewController.m
//  Ixyb
//
//  Created by wang on 2017/12/13.
//  Copyright © 2017年 xyb. All rights reserved.
//

#import "NPMatchDetailViewController.h"
#import "Utility.h"

@interface NPMatchDetailViewController ()

@end

@implementation NPMatchDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNav];
}

#pragma mark -- 初始化 UI
- (void)setNav {
    self.navItem.title = XYBString(@"str_common_yjcj", @"标的组成详情");
    self.navItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(clickBackBtn:)];
    self.view.backgroundColor = COLOR_BG;
}

#pragma mark -- 点击v事件
-(void)clickBackBtn:(id)sender
{
    
}


#pragma mark -- 数据处理

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
  
}



@end
