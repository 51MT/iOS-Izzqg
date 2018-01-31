//
//  CommissionView.m
//  Ixyb
//
//  Created by wang on 15/11/9.
//  Copyright © 2015年 xyb. All rights reserved.
//

#import "CommissionView.h"

#import "Utility.h"

@implementation CommissionView

static CommissionView *_commissionView = nil;

+ (CommissionView *)shareInstanceCommissionView {

    if (_commissionView) {

        return _commissionView;

    } else {
        _commissionView = [[CommissionView alloc] init];

        [_commissionView setUI];
    }

    return _commissionView;
}

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithRed:0 / 255.f green:0 / 255.f blue:0 / 255.f alpha:0.4f];
        [self setUI];
    }
    return self;
}

- (void)setUI {

    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [cancelBtn addTarget:self action:@selector(cancelCommissionView) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:cancelBtn];

    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];

    UIView *backView = [[UIView alloc] initWithFrame:CGRectZero];
    backView.backgroundColor = COLOR_COMMON_WHITE;
    backView.layer.masksToBounds = YES;
    backView.layer.cornerRadius = Corner_Radius_BombBox;
    [self addSubview:backView];

    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@10);
        make.right.equalTo(@(-10));
        make.centerY.equalTo(self.mas_centerY);
        make.height.equalTo(@260);
    }];

    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectZero];
    titleLab.textColor = COLOR_MAIN_GREY;
    titleLab.font = TEXT_FONT_18;
    titleLab.text = XYBString(@"string_make_sure_charge_info", @"确认充值信息");
    [backView addSubview:titleLab];

    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(@20);
    }];

    UIImageView *pointsImage = [[UIImageView alloc] initWithFrame:CGRectZero];
    pointsImage.image = [UIImage imageNamed:@"onePoint"];
    [backView addSubview:pointsImage];

    [pointsImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@20);
        make.right.equalTo(@(-20));
        make.top.equalTo(backView.mas_top).offset(59);
        make.height.equalTo(@1);
    }];

    NSArray *arr = @[ XYBString(@"string_charge_amount", @"充值金额"), XYBString(@"string_fee", @"手续费用"), XYBString(@"string_acutal_pay_amount", @"实付金额") ];

    UILabel *contentLab = nil;
    for (int i = 0; i < arr.count; i++) {
        UILabel *leftLab = [[UILabel alloc] initWithFrame:CGRectZero];
        leftLab.font = TEXT_FONT_14;
        leftLab.text = [arr objectAtIndex:i];
        leftLab.textColor = COLOR_LIGHT_GREY;
        [backView addSubview:leftLab];
        [leftLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@20);
            if (contentLab) {
                make.top.equalTo(contentLab.mas_bottom).offset(18);
            } else {
                make.top.equalTo(pointsImage.mas_bottom).offset(18);
            }
        }];
        UILabel *rightLab = [[UILabel alloc] initWithFrame:CGRectZero];
        rightLab.font = TEXT_FONT_18;
        rightLab.text = XYBString(@"string_zero_yuan", @"0.00元");
        rightLab.textColor = COLOR_MAIN_GREY;
        rightLab.tag = 400 + i;
        [backView addSubview:rightLab];
        [rightLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(@(-20));
            make.centerY.equalTo(leftLab.mas_centerY);
        }];

        contentLab = leftLab;
    }

    UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [sureBtn setTitle:XYBString(@"string_ok", @"确定") forState:UIControlStateNormal];
    [sureBtn setTitleColor:COLOR_COMMON_WHITE forState:UIControlStateNormal];
    [sureBtn.layer setMasksToBounds:YES];
    [sureBtn.layer setCornerRadius:4.0];
    [sureBtn addTarget:self action:@selector(clickTheSureButton:) forControlEvents:UIControlEventTouchUpInside];
    sureBtn.backgroundColor = COLOR_MAIN;
    [sureBtn setBackgroundImage:[ColorUtil imageWithColor:COLOR_HIGHTBULE_BUTTON] forState:UIControlStateHighlighted];
    [backView addSubview:sureBtn];

    [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@Margin_Length);
        make.right.equalTo(@(-Margin_Length));
        make.height.equalTo(@44);
        make.top.equalTo(contentLab.mas_bottom).offset(20);
    }];

    UILabel *noteLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    noteLabel.textColor = COLOR_AUXILIARY_GREY;
    noteLabel.text = XYBString(@"financingWithAgree", @"我已阅读并同意");
    noteLabel.font = [UIFont systemFontOfSize:12.0f];
    [backView addSubview:noteLabel];

    [noteLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(sureBtn.mas_bottom).offset(10);
        make.left.equalTo(@Margin_Length);
    }];

    UIButton *agreementButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [agreementButton setTitle:XYBString(@"string_servie_protocol_pos_1", @"《刷卡器服务协议》") forState:UIControlStateNormal];
    agreementButton.titleLabel.font = [UIFont systemFontOfSize:12.f];
    [agreementButton setTitleColor:COLOR_MAIN forState:UIControlStateNormal];

    [agreementButton addTarget:self action:@selector(clickTheAgreementButton:) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:agreementButton];

    [agreementButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(noteLabel.mas_right).offset(2);
        make.centerY.equalTo(noteLabel.mas_centerY);
        make.height.equalTo(@20);
    }];
}

- (void)setModel:(MposModel *)model {

    UILabel *amountLab = (UILabel *) [self viewWithTag:400];
    UILabel *commissionLab = (UILabel *) [self viewWithTag:401];
    UILabel *totalLab = (UILabel *) [self viewWithTag:402];

    if (model.payFee == 0) {
        commissionLab.text = XYBString(@"string_zero_yuan", @"0.00元");
    } else {
        NSString *payFeeStr = [Utility replaceTheNumberForNSNumberFormatter:[NSString stringWithFormat:@"%.2f", model.payFee]];
        commissionLab.text = [NSString stringWithFormat:XYBString(@"string_some_yuan", @"%@元"), payFeeStr];
    }
    if (model.amount == 0) {
        amountLab.text = XYBString(@"string_zero_yuan", @"0.00元");
    } else {
        NSString *amountStr = [Utility replaceTheNumberForNSNumberFormatter:[NSString stringWithFormat:@"%.2f", model.amount]];
        amountLab.text = [NSString stringWithFormat:XYBString(@"string_some_yuan", @"%@元"), amountStr];
    }
    if (model.totalAmount == 0) {
        totalLab.text = XYBString(@"string_zero_yuan", @"0.00元");
    } else {
        NSString *totalStr = [Utility replaceTheNumberForNSNumberFormatter:[NSString stringWithFormat:@"%.2f", model.totalAmount]];
        totalLab.text = [NSString stringWithFormat:XYBString(@"string_some_yuan", @"%@元"), totalStr];
    }
}

- (void)clickTheSureButton:(id)sender {

    if (self.clicckSureButton) {
        self.clicckSureButton();
    }
}

- (void)clickTheAgreementButton:(UIButton *)btn {
    if (self.clicckAgreeButton) {
        self.clicckAgreeButton();
    }
}

- (void)cancelCommissionView {
    if (self) {
        [self removeFromSuperview];
    }
}

@end
