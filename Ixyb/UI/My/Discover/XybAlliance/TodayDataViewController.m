//
//  TodayDataViewController.m
//  Ixyb
//
//  Created by wang on 16/8/25.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import "AllianceDataView.h"
#import "TodayDataViewController.h"
#import "Utility.h"

@interface TodayDataViewController ()

@end

@implementation TodayDataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNav];
    [self creatTheRankView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)setNav {
    self.navItem.title = XYBString(@"str_today_data", @"今日数据");

    self.navItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(clickBackBtn:)];
}

- (void)clickBackBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)creatTheRankView {
    NSString *today = @"TODAY";
    AllianceDataView *unionDataView = [[AllianceDataView alloc] initWithFrame:CGRectZero dateQueryStr:today];
    [self.view addSubview:unionDataView];
    [unionDataView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navBar.mas_bottom);
        make.left.bottom.right.equalTo(self.view);
    }];
}
@end
