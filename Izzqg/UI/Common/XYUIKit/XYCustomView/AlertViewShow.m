//
//  AlertViewShow.m
//  Ixyb
//
//  Created by dengjian on 16/5/4.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import "AlertViewShow.h"
#import "Utility.h"
#import "XYButton.h"

@implementation AlertViewShow

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        [self creatMainView];
    }
    return self;
}

- (void)creatMainView {
    self.backgroundColor = COLOR_COMMON_BLACK_TRANS;

    UIView *backGroundview = [[UIView alloc] initWithFrame:CGRectZero];
    backGroundview.backgroundColor = [COLOR_COMMON_WHITE colorWithAlphaComponent:0.95f];
    backGroundview.layer.masksToBounds = YES;
    backGroundview.layer.cornerRadius = Corner_Radius_BombBox;
    [self addSubview:backGroundview];

    [backGroundview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.width.equalTo(@(270));
    }];

    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectZero];
    titleLab.text = @"余额不足";
    titleLab.font = TEXT_FONT_18;
    titleLab.textColor = COLOR_MAIN_GREY;
    titleLab.textAlignment = NSTextAlignmentCenter;
    [backGroundview addSubview:titleLab];
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(backGroundview.mas_centerX);
        make.top.equalTo(backGroundview.mas_top).offset(30);
    }];

    UIView *backView = [[UIView alloc] initWithFrame:CGRectZero];
    [self addSubview:backView];

#pragma mark 弹出框中间的内容

    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectZero];
    label1.text = @"此次出借还差";
    label1.textColor = COLOR_AUXILIARY_GREY;
    label1.font = TEXT_FONT_14;
    [backView addSubview:label1];
    [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backView.mas_left).offset(0);
        make.top.equalTo(backView.mas_top).offset(0);
        make.bottom.equalTo(backView.mas_bottom).offset(0);
    }];

    self.moneyLab = [[UILabel alloc] initWithFrame:CGRectZero]; //中间红色字体部分
    self.moneyLab.text = @"0.00";
    self.moneyLab.textColor = COLOR_RED_VERTICALLINE;
    self.moneyLab.font = TEXT_FONT_14;
    [backView addSubview:self.moneyLab];
    [self.moneyLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(label1.mas_right).offset(3);
        make.centerY.equalTo(label1.mas_centerY);
    }];

    UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectZero];
    label3.text = @"元，立即充值";
    label3.textColor = COLOR_AUXILIARY_GREY;
    label3.font = TEXT_FONT_14;
    [backView addSubview:label3];
    [label3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.moneyLab.mas_right).offset(1);
        make.centerY.equalTo(self.moneyLab.mas_centerY);
        make.right.equalTo(backView.mas_right).offset(0);
    }];

    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(backGroundview.mas_centerX);
        make.top.equalTo(titleLab.mas_bottom).offset(12);
    }];
#pragma mark 弹出框画线

    UIView *lineView = [[UIView alloc] initWithFrame:CGRectZero];
    lineView.backgroundColor = COLOR_LINE;
    [backGroundview addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(backGroundview);
        make.height.equalTo(@(Line_Height));
        make.top.equalTo(backView.mas_bottom).offset(30);
    }];

#pragma mark 弹出框按钮部分

    XYButton *cancelBtn = [[XYButton alloc] initWithSubordinationButtonTitle:@"取消" isUserInteractionEnabled:YES];
    [cancelBtn addTarget:self action:@selector(clickCancelBtn:) forControlEvents:UIControlEventTouchUpInside];
    [backGroundview addSubview:cancelBtn];
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backGroundview.mas_left).offset(0);
        make.width.equalTo(@(270 / 2 - Line_Height));
        make.top.equalTo(lineView.mas_bottom).offset(0);
        make.height.equalTo(@(45));
        make.bottom.equalTo(backGroundview.mas_bottom).offset(0);
    }];

    UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectZero];
    lineView2.backgroundColor = COLOR_LINE;
    [backGroundview addSubview:lineView2];
    [lineView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cancelBtn.mas_right).offset(0);
        make.top.equalTo(lineView.mas_bottom).offset(0);
        make.width.equalTo(@(Line_Height));
        make.bottom.equalTo(backGroundview.mas_bottom).offset(0);
    }];

    XYButton *chargeBtn = [[XYButton alloc] initWithSubordinationButtonTitle:@"去充值" isUserInteractionEnabled:YES];
    [chargeBtn addTarget:self action:@selector(clickChargeBtn:) forControlEvents:UIControlEventTouchUpInside];
    [backGroundview addSubview:chargeBtn];
    [chargeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(cancelBtn.mas_centerY);
        make.left.equalTo(lineView2.mas_right).offset(0);
        make.right.equalTo(backGroundview.mas_right).offset(0);
    }];
}

- (void)clickCancelBtn:(UIButton *)button {
    [self removeFromSuperview];
}

- (void)clickChargeBtn:(UIButton *)button {
//    ChargeViewController *chargeViewController = [[ChargeViewController alloc] initWithIdetifer:NO];
//    self.chargeBlock(chargeViewController);
}

@end
