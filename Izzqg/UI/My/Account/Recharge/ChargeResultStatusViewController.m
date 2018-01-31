//
//  ChargeResultStatusViewController.m
//  Ixyb
//
//  Created by wang on 16/3/31.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import "ChargeResultStatusViewController.h"

#import "MoreProductViewController.h"
#import "RequestURL.h"
#import "Utility.h"
#import "WebviewViewController.h"

@interface ChargeResultStatusViewController ()

@end

@implementation ChargeResultStatusViewController

- (void)setNav {
    self.navItem.title = XYBString(@"string_charge_sucess", @"充值成功");

    self.navItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(clickBackBtn:)];
}

- (void)clickBackBtn:(id)sender {
    NSArray *arr = self.navigationController.viewControllers;
    [self.navigationController popToViewController:[arr objectAtIndex:arr.count - 4] animated:YES];
}

- (void)clickTheRightBtn {
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", [RequestURL getNodeJsH5URL:App_Bank_Limit_URL withIsSign:NO], App_Bank_Tab_Nav1_URL];
    NSString *titleStr = XYBString(@"str_bank_limit", @"充值提现说明");
    WebviewViewController *webView = [[WebviewViewController alloc] initWithTitle:titleStr webUrlString:urlStr];
    [self.navigationController pushViewController:webView animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setNav];
    [self creatTheResultView];
}

- (void)creatTheResultView {

    UIView *contentView = [[UIView alloc] initWithFrame:CGRectZero];
    contentView.backgroundColor = COLOR_COMMON_WHITE;
    [self.view addSubview:contentView];

    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navBar.mas_bottom);
        make.left.right.equalTo(self.view);
    }];

    UIImageView *clueImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    clueImageView.image = [UIImage imageNamed:@"green_success"];
    [contentView addSubview:clueImageView];

    [clueImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(AlertImage_Margin_Length));
        make.centerX.equalTo(contentView.mas_centerX);
    }];

    NSArray *attrArray = @[
        @{
            @"kStr" : XYBString(@"string_charge_sucess_point", @"充值成功, "),
            @"kColor" : COLOR_MAIN_GREY,
            @"kFont" : TEXT_FONT_16,
        },
        @{
            @"kStr" : @"获得",
            @"kColor" : COLOR_MAIN_GREY,
            @"kFont" : TEXT_FONT_16,
        },
        @{
            @"kStr" : @"2016元",
            @"kColor" : COLOR_ORANGE,
            @"kFont" : TEXT_FONT_16,
        },
        @{
            @"kStr" : @"红包",
            @"kColor" : COLOR_MAIN_GREY,
            @"kFont" : TEXT_FONT_16,
        }
    ];
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectZero];
    titleLab.font = TEXT_FONT_16;
    titleLab.textColor = COLOR_MAIN_GREY;
    if (self.firstSleepReward == 0) {
        titleLab.text = XYBString(@"string_charge_sucess", @"充值成功");
    } else {
        titleLab.attributedText = [Utility multAttributedString:attrArray];
    }
    titleLab.textAlignment = NSTextAlignmentCenter;
    [contentView addSubview:titleLab];

    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(clueImageView.mas_bottom).offset(Margin_Length);
        make.centerX.equalTo(contentView.mas_centerX);
        make.bottom.equalTo(contentView.mas_bottom).offset(-AlertImage_Margin_Length);

    }];

    ColorButton *financingBtn = [[ColorButton alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth - 30, Button_Height) Title:XYBString(@"string_financing_rewardamount", @"出借获得礼金") ByGradientType:leftToRight];
    [financingBtn addTarget:self action:@selector(clickTheFinancingBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:financingBtn];

    [financingBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView.mas_bottom).offset(Margin_Length);
        make.left.equalTo(@(Margin_Length));
        make.right.equalTo(@(-Margin_Length));
        make.height.equalTo(@(Button_Height));
    }];

    UIImageView *viewImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    viewImageView.image = [UIImage imageNamed:@"icon_info_bule"];
    [self.view addSubview:viewImageView];

    [viewImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(financingBtn.mas_bottom).offset(Text_Margin_Length);
        make.left.equalTo(@(Margin_Length));
    }];

    UILabel *note1Lab = [[UILabel alloc] initWithFrame:CGRectZero];
    note1Lab.font = TEXT_FONT_12;
    note1Lab.textColor = COLOR_AUXILIARY_GREY;
    note1Lab.text = XYBString(@"string_first_financing_send_rewardamount", @"APP首投送10元礼金(仅限首投1000元以上)");
    [self.view addSubview:note1Lab];

    [note1Lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(viewImageView.mas_right).offset(Text_Margin_Middle);
        make.centerY.equalTo(viewImageView.mas_centerY);
    }];
}

- (void)clickTheFinancingBtn:(id)sender {
    MoreProductViewController *moreProductVC = [[MoreProductViewController alloc] init];
    moreProductVC.hidesBottomBarWhenPushed = YES;
    moreProductVC.type = ClickTheDQB;
    [self.navigationController pushViewController:moreProductVC animated:YES];
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
