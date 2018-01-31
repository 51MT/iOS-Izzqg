//
//  RegisterProblemViewController.m
//  Ixyb
//
//  Created by dengjian on 16/4/29.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import "RegisterProblemViewController.h"

#import "Utility.h"
#import "UMengAnalyticsUtil.h"

@interface RegisterProblemViewController () <UIWebViewDelegate>

@end

@implementation RegisterProblemViewController

- (void)setNav {
    self.view.backgroundColor = COLOR_BG;
    self.navItem.title = XYBString(@"string_customer_service", @"客服");

    self.navItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(clickBackBtn:)];
}

- (void)clickBackBtn:(id)sender {

    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [UMengAnalyticsUtil beginLogPageView:NSStringFromClass([self class])];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [UMengAnalyticsUtil endLogPageView:NSStringFromClass([self class])];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setNav];
    [self createMainView];
}

- (void)createMainView {
    UILabel *remindLab = [[UILabel alloc] init];
    remindLab.font = TEXT_FONT_16;
    remindLab.text = @"如您在操作中遇到问题请联系客服";
    remindLab.textColor = COLOR_AUXILIARY_GREY;
    [self.view addSubview:remindLab];

    [remindLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.navBar.mas_bottom).offset(30);
    }];

    _callPhoneButton = [[ColorButton alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth - 30.f, Button_Height) Title:@"客服电话 400-070-7663"  ByGradientType:leftToRight];
    [_callPhoneButton setImage:[UIImage imageNamed:@"callphone"] forState:UIControlStateNormal];
    _callPhoneButton.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    [_callPhoneButton addTarget:self action:@selector(clickTheCellPhoneButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_callPhoneButton];
    
    [_callPhoneButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(remindLab.mas_bottom).offset(30);
        make.left.equalTo(self.view.mas_left).offset(Margin_Length);
        make.right.equalTo(self.view.mas_right).offset(-Margin_Length);
        make.height.equalTo(@45);
    }];
}

- (void)clickTheCellPhoneButton:(XYButton *)sender {
    UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:XYBString(@"string_xyb_tellphone", @"拨打电话") message:@"400-070-7663" delegate:self cancelButtonTitle:XYBString(@"string_cancel", @"取消") otherButtonTitles:XYBString(@"string_ok", @"确定"), nil];
    [alertview show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://4000707663"]];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
