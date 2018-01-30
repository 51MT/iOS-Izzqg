//
//  CustomAlertView.m
//  Ixyb
//
//  Created by wang on 15/5/28.
//  Copyright (c) 2015年 xyb. All rights reserved.
//

#import "CustomAlertView.h"

#import "Utility.h"

@implementation CustomAlertView
- (id)initWithStatus:(alertStatus)status {

    if (self = [super init]) {
        self.backgroundColor = [UIColor colorWithRed:153 / 255.f green:153 / 255.f blue:153 / 255.f alpha:0.8];
        self.status = status;
        [self setUI];
    }
    [self setNeedsUpdateConstraints];
    return self;
}
- (void)setUI {

    UIView *backView = [[UIView alloc] init];
    backView.backgroundColor = COLOR_COMMON_WHITE;
    backView.layer.masksToBounds = YES;
    backView.layer.cornerRadius = Corner_Radius_BombBox;

    [self addSubview:backView];

    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@20);
        make.right.equalTo(@(-20));
        make.centerX.equalTo(self.mas_centerX);
        make.centerY.equalTo(self.mas_centerY);
        make.height.equalTo(@200);
    }];

    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = [UIImage imageNamed:@"alert_warning"];
    [backView addSubview:imageView];

    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@20);
        make.centerX.equalTo(backView.mas_centerX);
    }];

    UILabel *contentLab = [[UILabel alloc] init];
    contentLab.font = [UIFont systemFontOfSize:14.0f];
    contentLab.text = @"项目已经满标，请选择其他未满标项目！";
    contentLab.textAlignment = NSTextAlignmentCenter;
    contentLab.textColor = COLOR_MAIN_GREY;
    [backView addSubview:contentLab];

    [contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(backView);
        make.top.equalTo(imageView.mas_bottom).offset(10);

    }];

    switch (self.status) {
        case alertSuccess:
            imageView.image = [UIImage imageNamed:@"alert_success"];
            contentLab.text = @"实名认证成功，需要设置交易密码";
            break;
        case alertFailure:
            imageView.image = [UIImage imageNamed:@"alert_failure"];
            contentLab.text = @"实名认证失败，请验证填写信息";

            break;
        case alertWarning:
            imageView.image = [UIImage imageNamed:@"alert_warning"];
            contentLab.text = @"项目已经满标，请选择其他未满标项目！";
            break;

        default:
            break;
    }

    UILabel *lineLab = [[UILabel alloc] init];
    lineLab.backgroundColor = [UIColor colorWithRed:245 / 255.f green:245 / 255.f blue:245 / 255.f alpha:1.0f];
    [backView addSubview:lineLab];

    [lineLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(backView);
        make.top.equalTo(contentLab.mas_bottom).offset(20);
        make.height.equalTo(@1);
    }];

    UIButton *sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [sureButton setTitle:@"确定" forState:UIControlStateNormal];
    [sureButton setTitleColor:[UIColor colorWithRed:0 / 255.f green:123 / 255.f blue:208 / 255.f alpha:1.0f] forState:UIControlStateNormal];
    [sureButton addTarget:self action:@selector(clickTheButton) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:sureButton];

    [sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(backView);
        make.height.equalTo(@55);
    }];
}

- (void)clickTheButton {
    if (self.clickButton) {
        self.clickButton();
    }
    [self removeFromSuperview];
}

@end
