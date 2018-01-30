//
//  OrderHaveSubmitViewController.m
//  Ixyb
//
//  Created by dengjian on 16/5/4.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import "OrderHaveSubmitViewController.h"

#import "Utility.h"

@interface OrderHaveSubmitViewController ()

@end

@implementation OrderHaveSubmitViewController

- (void)setNav {

    self.navItem.title = @"订单已提交";

    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    closeBtn.frame = CGRectMake(0, 0, 40, 40);
    [closeBtn setTitle:@"完成" forState:UIControlStateNormal];
    closeBtn.titleLabel.font = TEXT_FONT_14;
    [closeBtn addTarget:self action:@selector(clickCloseBtn:) forControlEvents:UIControlEventTouchUpInside];

    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:closeBtn];
    UIBarButtonItem *distance = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    distance.width = -12;
    self.navItem.rightBarButtonItems = @[ distance, rightBarButton ];
}

- (void)clickCloseBtn:(id)sender {
    NSInteger count = self.navigationController.viewControllers.count;
    [self.navigationController popToViewController:self.navigationController.viewControllers[count - 3] animated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationItem.hidesBackButton = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setNav];
    [self createMainView];
}

- (void)createMainView {
    UIView *backView = [[UIView alloc] initWithFrame:CGRectZero];
    backView.backgroundColor = COLOR_COMMON_WHITE;
    [self.view addSubview:backView];

    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navBar.mas_bottom);
        make.left.right.equalTo(self.view);
    }];

    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    imageView.image = [UIImage imageNamed:@"order_have_submit"];
    [backView addSubview:imageView];

    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(backView.mas_centerX);
        make.top.equalTo(backView.mas_top).offset(30);
    }];

    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectZero];
    titleLab.text = @"订单已提交，客服会尽快安排发货";
    titleLab.font = TEXT_FONT_18;
    titleLab.textColor = COLOR_MAIN_GREY;
    [backView addSubview:titleLab];

    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(backView.mas_centerX);
        make.height.equalTo(@17);
        make.top.equalTo(imageView.mas_bottom).offset(24);
        make.bottom.equalTo(backView.mas_bottom).offset(-30);
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
