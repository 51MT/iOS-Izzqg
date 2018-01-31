//
//  GETStatusViewController.m
//  Ixyb
//
//  Created by wang on 16/4/7.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import "GETStatusViewController.h"

#import "Utility.h"

@interface GETStatusViewController () <UIAlertViewDelegate>

@end

@implementation GETStatusViewController

- (void)setNav {

    self.navItem.title = XYBString(@"string_sure_pos_status", @"领取状态");
    self.navItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(clickBackBtn:)];
}

- (void)clickBackBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setNav];
    [self setUI];
}

- (void)setUI {

    DeliverInfoModel *model = _model.deliverInfo;

    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = COLOR_COMMON_WHITE;
    [self.view addSubview:headerView];

    [headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navBar.mas_bottom);
        make.left.right.equalTo(self.view);
        make.height.equalTo(@120);
    }];

    UIView *splitView = [[UIView alloc] init];
    splitView.backgroundColor = COLOR_LINE;
    [headerView addSubview:splitView];

    [splitView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headerView.mas_bottom);
        make.height.equalTo(@(Line_Height));
        make.left.equalTo(@0);
        make.right.equalTo(@0);
    }];

    UIImageView *lineImage = [[UIImageView alloc] init];
    lineImage.image = [UIImage imageNamed:@"pos_xuxian"];
    [headerView addSubview:lineImage];

    [lineImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@Margin_Length);
        make.centerY.equalTo(headerView.mas_centerY);
    }];

    UIImageView *applyImageView = [[UIImageView alloc] init];
    applyImageView.image = [UIImage imageNamed:@"pay_select"];
    [headerView addSubview:applyImageView];

    [applyImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(headerView.mas_centerX).offset(-(MainScreenWidth / 4));
        make.centerY.equalTo(headerView.mas_centerY);
    }];

    UILabel *applyLabel = [[UILabel alloc] init];
    applyLabel.textColor = COLOR_MAIN_GREY;
    applyLabel.text = @"已申请领取";
    applyLabel.font = TEXT_FONT_16;
    [headerView addSubview:applyLabel];

    [applyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(applyImageView.mas_centerX);
        make.bottom.equalTo(applyImageView.mas_top).offset(-19);
    }];

    UILabel *applyDateLabel = [[UILabel alloc] init];
    applyDateLabel.textColor = COLOR_AUXILIARY_GREY;
    applyDateLabel.text = [NSString stringWithFormat:@"%@", model.applyDate];
    applyDateLabel.font = TEXT_FONT_14;
    [headerView addSubview:applyDateLabel];

    [applyDateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(applyImageView.mas_centerX);
        make.top.equalTo(applyImageView.mas_bottom).offset(19);
    }];

    UIImageView *sendImageView = [[UIImageView alloc] init];

    sendImageView.backgroundColor = COLOR_COMMON_WHITE;
    [headerView addSubview:sendImageView];

    [sendImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(headerView.mas_centerX).offset((MainScreenWidth / 4));
        make.centerY.equalTo(headerView.mas_centerY);
    }];

    UILabel *sendLab = [[UILabel alloc] init];
    sendLab.textColor = COLOR_MAIN_GREY;
    sendLab.text = @"已发货";
    sendLab.font = TEXT_FONT_16;
    [headerView addSubview:sendLab];

    [sendLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(sendImageView.mas_centerX);
        make.bottom.equalTo(sendImageView.mas_top).offset(-19);
    }];

    UILabel *deliverDateLabel = [[UILabel alloc] init];
    deliverDateLabel.textColor = COLOR_AUXILIARY_GREY;
    deliverDateLabel.font = TEXT_FONT_14;
    [headerView addSubview:deliverDateLabel];

    [deliverDateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(sendImageView.mas_centerX);
        make.top.equalTo(sendImageView.mas_bottom).offset(19);
    }];

    if (model.state == 0) {
        sendImageView.image = [UIImage imageNamed:@"pay_unselect"];
    } else {
        sendImageView.image = [UIImage imageNamed:@"pay_select"];
        deliverDateLabel.text = [NSString stringWithFormat:@"%@", model.deliverDate];
    }

    UIView *addressInfoView = [[UIView alloc] init];
    addressInfoView.backgroundColor = COLOR_COMMON_WHITE;
    [self.view addSubview:addressInfoView];

    [addressInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(headerView.mas_bottom).offset(20);
        make.height.equalTo(@45);
    }];

    UIView *split11View = [[UIView alloc] init];
    split11View.backgroundColor = COLOR_LINE;
    [addressInfoView addSubview:split11View];

    [split11View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(addressInfoView.mas_top);
        make.height.equalTo(@(Line_Height));
        make.left.equalTo(@0);
        make.right.equalTo(@0);
    }];

    UIView *split22View = [[UIView alloc] init];
    split22View.backgroundColor = COLOR_LINE;
    [addressInfoView addSubview:split22View];

    [split22View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(addressInfoView.mas_bottom);
        make.height.equalTo(@(Line_Height));
        make.left.equalTo(@Margin_Length);
        make.right.equalTo(@0);
    }];

    UILabel *psStyleLab = [[UILabel alloc] init];
    psStyleLab.text = @"物流单号";
    psStyleLab.textColor = COLOR_MAIN_GREY;
    psStyleLab.font = TEXT_FONT_16;
    [addressInfoView addSubview:psStyleLab];

    [psStyleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(addressInfoView.mas_centerY);
        make.left.equalTo(@Margin_Length);
    }];

    UILabel *psResultLab = [[UILabel alloc] init];

    psResultLab.textColor = COLOR_AUXILIARY_GREY;
    psResultLab.font = TEXT_FONT_16;
    [addressInfoView addSubview:psResultLab];

    [psResultLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(addressInfoView.mas_centerY);
        make.right.equalTo(@-Margin_Length);
    }];

    if (model.expressNo) {
        psResultLab.text = [NSString stringWithFormat:@"%@%@", model.expressCompany, model.expressNo];
    } else {
        psResultLab.text = @"暂无";
    }

    UIView *addressView = [[UIView alloc] init];
    addressView.backgroundColor = COLOR_COMMON_WHITE;
    [self.view addSubview:addressView];

    [addressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(addressInfoView.mas_bottom);
    }];

    UILabel *selectAddressLab = [[UILabel alloc] init];
    selectAddressLab.textColor = COLOR_AUXILIARY_GREY;
    selectAddressLab.font = TEXT_FONT_14;
    selectAddressLab.numberOfLines = 0;
    [addressView addSubview:selectAddressLab];

    //    UserAddress *userAddress = [Utility getCurrentUserAddress];
    if (model) {
        NSString *textStr = [NSString stringWithFormat:@"收货人：%@  %@\n收货地址：%@", model.receiverName, model.receiverPhone, model.receiverAddress];
        // 调整行间距
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:textStr];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:6];
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [textStr length])];
        selectAddressLab.attributedText = attributedString;
    }

    [selectAddressLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(addressView.mas_centerY);
        make.left.equalTo(@Margin_Length);
        make.right.equalTo(@-Margin_Length);
        make.bottom.equalTo(addressView.mas_bottom).offset(-Margin_Length);
    }];

    UIView *split33View = [[UIView alloc] init];
    split33View.backgroundColor = COLOR_LINE;
    [addressView addSubview:split33View];

    [split33View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(addressView.mas_bottom);
        make.height.equalTo(@(Line_Height));
        make.left.equalTo(@0);
        make.right.equalTo(@0);
    }];

    UIView *serviceView = [[UIView alloc] init];
    serviceView.backgroundColor = COLOR_COMMON_WHITE;
    [self.view addSubview:serviceView];

    [serviceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(addressView.mas_bottom).offset(20);
    }];

    UIView *split44View = [[UIView alloc] init];
    split44View.backgroundColor = COLOR_LINE;
    [serviceView addSubview:split44View];

    [split44View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(serviceView.mas_top);
        make.height.equalTo(@(Line_Height));
        make.left.equalTo(@0);
        make.right.equalTo(@0);
    }];

    UIView *split55View = [[UIView alloc] init];
    split55View.backgroundColor = COLOR_LINE;
    [serviceView addSubview:split55View];

    [split55View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(serviceView.mas_bottom);
        make.height.equalTo(@(Line_Height));
        make.left.equalTo(@0);
        make.right.equalTo(@0);
    }];

    UILabel *serviceLab = [[UILabel alloc] init];
    serviceLab.text = @"客服电话";
    serviceLab.textColor = COLOR_MAIN_GREY;
    serviceLab.font = TEXT_FONT_16;
    [serviceView addSubview:serviceLab];

    [serviceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(serviceView.mas_centerY);
        make.left.equalTo(@Margin_Length);
        make.bottom.equalTo(serviceView.mas_bottom).offset(-Margin_Length);
    }];

    UILabel *phoneLab = [[UILabel alloc] init];
    phoneLab.text = @"400-070-7663";
    phoneLab.textColor = COLOR_MAIN;
    phoneLab.font = TEXT_FONT_16;
    [serviceView addSubview:phoneLab];

    [phoneLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(serviceView.mas_centerY);
        make.right.equalTo(@-Margin_Length);
    }];

    UIButton *callPhoneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [callPhoneBtn addTarget:self action:@selector(clickThePhoneBtn:) forControlEvents:UIControlEventTouchUpInside];
    [serviceView addSubview:callPhoneBtn];
    [callPhoneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(serviceView);
    }];
}

- (void)clickThePhoneBtn:(id)sender {
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
