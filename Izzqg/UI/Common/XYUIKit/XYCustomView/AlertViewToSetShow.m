//
//  AlertViewToSetShow.m
//  Ixyb
//
//  Created by wang on 16/7/1.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import "AlertViewToSetShow.h"
#import "Utility.h"
#import "WebService.h"
#import "WithdrawalsCounterFeeModel.h"
#import "XYButton.h"

@implementation AlertViewToSetShow

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
        //        make.left.equalTo(@(Margin_Left));
        make.width.equalTo(@270);
    }];

#pragma mark - 弹出框画线1

    UIView *lineTopView = [[UIView alloc] initWithFrame:CGRectZero];
    lineTopView.backgroundColor = COLOR_LINE;
    [backGroundview addSubview:lineTopView];
    [lineTopView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@24);
        make.right.equalTo(@-24);
        make.height.equalTo(@(Line_Height));
        make.top.equalTo(backGroundview.mas_top).offset(45);
    }];

    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectZero];
    titleLab.text = @"确认提现";
    titleLab.font = TEXT_FONT_16;
    titleLab.textColor = COLOR_MAIN_GREY;
    titleLab.textAlignment = NSTextAlignmentCenter;
    [backGroundview addSubview:titleLab];
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(backGroundview.mas_centerX);
        make.top.equalTo(backGroundview.mas_top).offset(10);
        make.bottom.equalTo(lineTopView.mas_bottom).offset(-10);
    }];

    UIView *backView = [[UIView alloc] initWithFrame:CGRectZero];
    [self addSubview:backView];

#pragma mark 弹出框中间的内容(提现金额、手续费、预计到账金额)

    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectZero];
    label1.text = @"提现金额";
    label1.textColor = COLOR_AUXILIARY_GREY;
    label1.font = TEXT_FONT_12;
    [backView addSubview:label1];
    [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lineTopView.mas_left);
        make.top.equalTo(backView.mas_top).offset(24);
        make.bottom.equalTo(backView.mas_bottom).offset(0);
    }];

    self.moneyLab = [[UILabel alloc] initWithFrame:CGRectZero]; //中间红色字体部分
    self.moneyLab.text = @"0.00";
    self.moneyLab.textColor = COLOR_AUXILIARY_GREY;
    self.moneyLab.font = TEXT_FONT_12;
    [backView addSubview:self.moneyLab];
    [self.moneyLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(lineTopView.mas_right);
        make.centerY.equalTo(label1.mas_centerY);
    }];

    //    UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectZero];
    //    label3.text = @"元";
    //    label3.textColor = COLOR_AUXILIARY_GREY;
    //    label3.font = TEXT_FONT_12;
    //    [backView addSubview:label3];
    //    [label3 mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.left.equalTo(self.moneyLab.mas_right).offset(1);
    //        make.centerY.equalTo(self.moneyLab.mas_centerY);
    //        make.right.equalTo(lineTopView.mas_right).offset(0);
    //    }];

    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectZero];
    label2.text = @"手续费";
    label2.textColor = COLOR_AUXILIARY_GREY;
    label2.font = TEXT_FONT_12;
    label2.textAlignment = NSTextAlignmentLeft;
    [backView addSubview:label2];
    [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.moneyLab.mas_bottom).offset(10);
        make.left.equalTo(label1.mas_left);
        make.width.equalTo(label1);
    }];

    self.counterFeeLab = [[UILabel alloc] initWithFrame:CGRectZero];
    self.counterFeeLab.text = @"0.00元";
    self.counterFeeLab.textColor = COLOR_AUXILIARY_GREY;
    self.counterFeeLab.font = TEXT_FONT_12;
    [backView addSubview:self.counterFeeLab];
    [self.counterFeeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.moneyLab.mas_bottom).offset(10);
        make.right.equalTo(self.moneyLab.mas_right);
    }];

    UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectZero];
    label3.text = @"预计到账金额";
    label3.textColor = COLOR_AUXILIARY_GREY;
    label3.font = TEXT_FONT_12;
    label3.textAlignment = NSTextAlignmentLeft;
    [backView addSubview:label3];
    [label3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label2.mas_bottom).offset(10);
        make.left.equalTo(label2.mas_left);
        make.width.equalTo(label2);
    }];

    self.expectedArrivalLab = [[UILabel alloc] initWithFrame:CGRectZero];
    self.expectedArrivalLab.text = @"0.00元";
    self.expectedArrivalLab.textColor = COLOR_AUXILIARY_GREY;
    self.expectedArrivalLab.font = TEXT_FONT_12;
    [backView addSubview:self.expectedArrivalLab];
    [self.expectedArrivalLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.counterFeeLab.mas_bottom).offset(10);
        make.right.equalTo(self.counterFeeLab.mas_right);
    }];

    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(backGroundview.mas_centerX);
        make.top.equalTo(titleLab.mas_bottom).offset(0);
    }];

#pragma mark 弹出框画线2

    UIView *lineView = [[UIView alloc] initWithFrame:CGRectZero];
    lineView.backgroundColor = COLOR_LINE;
    [backGroundview addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(backGroundview);
        make.height.equalTo(@(Line_Height));
        make.top.equalTo(self.expectedArrivalLab.mas_bottom).offset(12);
    }];

#pragma mark 弹出框-确认/取消按钮

    XYButton *cancelBtn = [[XYButton alloc] initWithSubordinationButtonTitle:@"取消" isUserInteractionEnabled:YES];
    [cancelBtn addTarget:self action:@selector(clickCancelBtn:) forControlEvents:UIControlEventTouchUpInside];
    [backGroundview addSubview:cancelBtn];
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backGroundview.mas_left).offset(0);
        make.width.equalTo(@(135 - Line_Height));
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

    XYButton *chargeBtn = [[XYButton alloc] initWithSubordinationButtonTitle:@"确认" isUserInteractionEnabled:YES];
    [chargeBtn addTarget:self action:@selector(clickChargeBtn:) forControlEvents:UIControlEventTouchUpInside];
    [backGroundview addSubview:chargeBtn];
    [chargeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(cancelBtn.mas_centerY);
        make.left.equalTo(lineView2.mas_right).offset(0);
        make.right.equalTo(backGroundview.mas_right).offset(0);
    }];
}

#pragma mark - 请求数据获取提现手续费

- (void)updateFee {
    NSDictionary *param = @{ @"userId" : [UserDefaultsUtil getUser].userId,
                             @"amount" : self.amount };
    NSString *urlPath = [RequestURL getRequestURL:@"" param:param];
    [WebService postRequest:urlPath param:param JSONModelClass:[WithdrawalsCounterFeeModel class]

        Success:^(AFHTTPRequestOperation *operation, id responseObject) {
            WithdrawalsCounterFeeModel *withdrawalsCounterFee = responseObject;
            if (withdrawalsCounterFee.resultCode == 1) {
                double fee = [withdrawalsCounterFee.drawMoneyFee doubleValue];
                if (fee == 0) {
                    self.counterFeeLab.text = XYBString(@"str_fee_zero", @" 0.00元");
                } else {
                    self.counterFeeLab.text = [NSString stringWithFormat:@" %@元", [Utility replaceTheNumberForNSNumberFormatter:[NSString stringWithFormat:@"%.2f", fee]]];
                }
                AppDelegate *app = (AppDelegate *) [UIApplication sharedApplication].delegate;
                for (UIView *view in app.window.subviews) {
                    if (![view isKindOfClass:[AlertViewToSetShow class]]) {
                        [app.window addSubview:self];
                        [self mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.edges.equalTo(app.window);
                        }];
                    } else {
                        [self removeFromSuperview];
                    }
                }
                if ([self.amount doubleValue] == 0) {
                    self.moneyLab.text = XYBString(@"str_fee_zero", @"0.00元");
                } else {
                    self.moneyLab.text = [NSString stringWithFormat:@"%@元", [Utility replaceTheNumberForNSNumberFormatter:[NSString stringWithFormat:@"%.2f", [self.amount doubleValue]]]];
                }
                // 预计到账金额
                double expectedArrival = [withdrawalsCounterFee.actualAmount doubleValue];
                if (expectedArrival == 0) {
                    self.expectedArrivalLab.text = XYBString(@"str_fee_zero", @"0.00元");
                } else {
                    self.expectedArrivalLab.text = [NSString stringWithFormat:@"%@元", [Utility replaceTheNumberForNSNumberFormatter:[NSString stringWithFormat:@"%.2f", expectedArrival]]];
                }
            }
        }

        fail:^(AFHTTPRequestOperation *operation, NSString *errorMessage) {
            [self showPromptTip:errorMessage];
        }

    ];
}

- (void)show:(TropismTradeViewCompletion)completion {
    //手续费
    [self updateFee];
}

- (void)clickCancelBtn:(UIButton *)button {
    [self removeFromSuperview];
}

- (void)clickChargeBtn:(UIButton *)button {
    self.chargeBlock(); //block回调
}

@end
