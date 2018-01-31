//
//  XsdAuthorizedView.m
//  Ixyb
//
//  Created by wang on 16/1/26.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import "XsdAuthorizedView.h"

#import "Utility.h"

#import "MJExtension.h"

#define circleProgressWidth 210
#define MONEYLABTAG 1001
#define PROCESSVIEWTAG 1002
#define RETURNTAG 1003
#define AUTHORIZEDBTNTAG 1004

@implementation XsdAuthorizedView

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = COLOR_COMMON_CLEAR;
        borrowArr = [[NSMutableArray alloc] init];
        [self setUI];
    }
    return self;
}

- (void)setUI {

    UIScrollView *mainScroll = [[UIScrollView alloc] init];
    mainScroll.backgroundColor = COLOR_COMMON_CLEAR;
    mainScroll.showsVerticalScrollIndicator = NO;
    [self addSubview:mainScroll];

    [mainScroll mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
        make.width.equalTo(@(MainScreenWidth));
    }];

    UIView *authorizedView = [[UIView alloc] init];
    authorizedView.backgroundColor = COLOR_COMMON_WHITE;
    [mainScroll addSubview:authorizedView];

    [authorizedView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(mainScroll);
        make.width.equalTo(@(MainScreenWidth));
    }];

    UIView *topView = [[UIView alloc] init];
    topView.backgroundColor = COLOR_COMMON_CLEAR;
    [authorizedView addSubview:topView];

    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@10);
        make.centerX.equalTo(authorizedView.mas_centerX);
    }];

    UIImageView *circleImageView = [[UIImageView alloc] init];
    circleImageView.image = [UIImage imageNamed:@"xsd_circleImageview"];
    [topView addSubview:circleImageView];

    [circleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(topView.mas_centerX);
        make.centerY.equalTo(topView.mas_centerY);
        make.width.equalTo(topView.mas_width);
        make.height.equalTo(topView.mas_height);

    }];

    UILabel *borrowTitleLab = [[UILabel alloc] init];
    borrowTitleLab.text = XYBString(@"str_xsdborrow_INeedBorrow", @"我要借款");
    borrowTitleLab.textAlignment = NSTextAlignmentCenter;
    borrowTitleLab.textColor = COLOR_MAIN_GREY;
    borrowTitleLab.font = TEXT_FONT_16;
    [topView addSubview:borrowTitleLab];

    [borrowTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(topView.mas_centerX);
        make.top.equalTo(topView.mas_top).offset(60);
    }];

    moneyField = [[UITextField alloc] init];
    moneyField.textAlignment = NSTextAlignmentCenter;
    moneyField.font = BORROW_TEXT_FONT_40;
    moneyField.textColor = COLOR_MAIN_GREY;
    moneyField.text = XYBString(@"str_financing_zero", @"0.00");
    moneyField.tag = MONEYLABTAG;
    moneyField.delegate = self;
    moneyField.keyboardType = UIKeyboardTypeNumberPad;
    moneyField.adjustsFontSizeToFitWidth = YES;
    [topView addSubview:moneyField];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moneyTextFieldChange) name:UITextFieldTextDidChangeNotification object:moneyField];
    [moneyField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(borrowTitleLab.mas_bottom).offset(5);
        make.width.equalTo(@130);
        make.centerX.equalTo(topView.mas_centerX);
    }];

    UIImageView *writieImage = [[UIImageView alloc] init];
    writieImage.image = [UIImage imageNamed:@"xsd_writieImage"];
    [topView addSubview:writieImage];

    [writieImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(moneyField.mas_right).offset(10);
        make.bottom.equalTo(moneyField.mas_bottom).offset(-10);
    }];

    xsdAlert = [[XsdAlertView alloc] initWithFrame:CGRectMake(0, 0, 200, 20) contentStr:XYBString(@"str_xsdborrow_enterAmountXW100ZSB", @"输入金额必须为100的倍数")];
    xsdAlert.hidden = YES;
    [topView addSubview:xsdAlert];

    [xsdAlert mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(topView.mas_centerX);
        make.bottom.equalTo(moneyField.mas_top);
        make.height.equalTo(@30);
    }];

    UIImageView *verlineImage = [[UIImageView alloc] init];
    verlineImage.image = [UIImage imageNamed:@"onePoint"];
    [topView addSubview:verlineImage];

    [verlineImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(topView).offset(30);
        make.right.equalTo(topView).offset(-30);
        make.centerY.equalTo(topView.mas_centerY).offset(10);
        make.height.equalTo(@1);
    }];

    UILabel *_returnLab = [[UILabel alloc] init];
    _returnLab.text = XYBString(@"str_financing_zero", @"0.00");
    _returnLab.textAlignment = NSTextAlignmentCenter;
    _returnLab.textColor = COLOR_STRONG_RED;
    _returnLab.font = TEXT_FONT_18;
    _returnLab.tag = RETURNTAG;
    _returnLab.adjustsFontSizeToFitWidth = YES;
    [topView addSubview:_returnLab];

    [_returnLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(topView.mas_centerX);
        make.top.equalTo(verlineImage.mas_bottom).offset(Margin_Length);
    }];
    //
    UILabel *returnTitleLab = [[UILabel alloc] init];
    returnTitleLab.text = XYBString(@"str_xsdborrow_canBorrowAmount", @"可借总额度(元)");
    returnTitleLab.textAlignment = NSTextAlignmentCenter;
    returnTitleLab.textColor = COLOR_LIGHT_GREY;
    returnTitleLab.font = TEXT_FONT_12;
    [topView addSubview:returnTitleLab];

    [returnTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_returnLab);
        make.top.equalTo(_returnLab.mas_bottom).offset(5);
    }];

    // 2.创建 TXHRrettyRuler 对象 并设置代理对象
    ruler = [[TXHRrettyRuler alloc] initWithFrame:CGRectMake(0, 200, [UIScreen mainScreen].bounds.size.width, 120)];
    ruler.rulerDeletate = self;
    [authorizedView addSubview:ruler];
    [authorizedView sendSubviewToBack:ruler];

    [ruler mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topView.mas_bottom).offset(-20);
        make.centerX.equalTo(authorizedView.mas_centerX);
        make.width.equalTo(@(MainScreenWidth));
        make.height.equalTo(@120);
    }];

    processView = [[UIView alloc] init];
    processView.tag = PROCESSVIEWTAG;
    [authorizedView addSubview:processView];

    [processView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ruler.mas_bottom).offset(-10);
        make.left.right.equalTo(authorizedView);
        make.height.equalTo(@130);
        make.bottom.equalTo(authorizedView.mas_bottom);
    }];

    [self creatTheProcessView:YES];

    UIButton *telescopicBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [telescopicBtn setImage:[UIImage imageNamed:@"telescopic"] forState:UIControlStateNormal];
    [telescopicBtn addTarget:self action:@selector(clickTheTelescopicBtn:) forControlEvents:UIControlEventTouchUpInside];
    [processView addSubview:telescopicBtn];

    [telescopicBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(processView.mas_centerX);
        make.bottom.equalTo(processView.mas_bottom).offset(-10);

    }];

    UIImageView *verline = [[UIImageView alloc] init];
    verline.image = [UIImage imageNamed:@"onePoint"];
    [processView addSubview:verline];

    [verline mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(processView);
        make.top.equalTo(processView.mas_bottom).offset(0.5);
        make.height.equalTo(@1);
    }];

    UIView *authorizedBtnView = [[UIView alloc] init];
    authorizedBtnView.backgroundColor = COLOR_BG;
    [mainScroll addSubview:authorizedBtnView];

    [authorizedBtnView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(processView.mas_bottom).offset(20);
        make.left.right.equalTo(authorizedView);
        make.height.equalTo(@80);
    }];

    UIButton *authorizedBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    authorizedBtn.backgroundColor = COLOR_MAIN;
    authorizedBtn.layer.cornerRadius = Corner_Radius;
    authorizedBtn.layer.masksToBounds = YES;
    [authorizedBtn setTitle:XYBString(@"str_xsdborrow_borrow", @"借款") forState:UIControlStateNormal];
    [authorizedBtn setTitleColor:COLOR_COMMON_WHITE forState:UIControlStateNormal];
    [authorizedBtn addTarget:self action:@selector(clickTheAuthorizedBtn:) forControlEvents:UIControlEventTouchUpInside];
    authorizedBtn.tag = AUTHORIZEDBTNTAG;
    [authorizedBtnView addSubview:authorizedBtn];

    [authorizedBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(processView.mas_bottom).offset(20);
        make.left.equalTo(@10);
        make.right.equalTo(@(-10));
        make.height.equalTo(@50);
    }];

    UILabel *noteLabel = [[UILabel alloc] init];
    noteLabel.textColor = COLOR_XSD_AUTH;
    noteLabel.text = XYBString(@"str_xsdborrow_clickBorrow", @"点击“借款”默认同意");
    noteLabel.font = [UIFont systemFontOfSize:12.0f];
    [authorizedBtnView addSubview:noteLabel];

    [noteLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(authorizedBtnView.mas_centerX).offset(-50);
        make.top.equalTo(authorizedBtn.mas_bottom).offset(10);
    }];

    UIButton *agreementButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [agreementButton setTitle:XYBString(@"str_xsdborrow_agreementAndProtocol", @"《合同及相关协议》") forState:UIControlStateNormal];
    agreementButton.titleLabel.font = [UIFont systemFontOfSize:12.f];
    [agreementButton setTitleColor:COLOR_MAIN forState:UIControlStateNormal];
    [agreementButton addTarget:self action:@selector(clickTheAgreementButton) forControlEvents:UIControlEventTouchUpInside];
    [authorizedBtnView addSubview:agreementButton];

    [agreementButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(noteLabel.mas_right).offset(2);
        make.centerY.equalTo(noteLabel.mas_centerY);
        make.height.equalTo(@20);
    }];

    //
    //    UILabel *introductionsLab = [[UILabel alloc] init];
    //    introductionsLab.textAlignment = NSTextAlignmentCenter;
    //    introductionsLab.textColor = COLOR_LIGHT_GREY;
    //    introductionsLab.font = TEXT_FONT_12;
    //    introductionsLab.text = XYBString(@"string_borrow_introductions", @"本服务由“信用宝”旗下“信闪贷”提供");
    //    [authorizedBtnView addSubview:introductionsLab];
    //
    //    [introductionsLab mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.left.right.equalTo(authorizedBtnView);
    //        make.bottom.equalTo(authorizedBtnView.mas_bottom).offset(-10);
    //    }];

    borrowView = [[XsdBorrowView alloc] init];
    [mainScroll addSubview:borrowView];
    [borrowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(mainScroll);
        make.top.equalTo(authorizedBtnView.mas_bottom).offset(0);
        make.bottom.equalTo(mainScroll.mas_bottom).offset(-10);
    }];

    __weak XsdAuthorizedView *vi = self;
    borrowView.clickTheRecordBtn = ^() {
        if (vi.clickTheRecordBtn) {
            vi.clickTheRecordBtn();
        }
    };

    borrowView.clickTheDetailVC = ^(BorrowRecordModel *model) {
        if (vi.clickTheDetailVC) {
            vi.clickTheDetailVC(model);
        }
    };
}

- (void)creatTheProcessView:(BOOL)isHidden {
    int a = 3;
    if (isHidden) {
        a = 3;
    } else {
        a = 5;
    }

    UIButton *btn = (UIButton *) [processView viewWithTag:1008];
    [btn removeFromSuperview];
    for (id lab in processView.subviews) {
        if ([lab isKindOfClass:[UILabel class]]) {
            [lab removeFromSuperview];
        }
    }
    NSArray *titleArr = @[ XYBString(@"str_xsdborrow_dayInterest", @"日利息"), XYBString(@"str_xsdborrow_borrowLimit", @"借款期限"), XYBString(@"str_xsdborrow_lastRepaymentDay", @"最后还款日"), XYBString(@"str_xsdborrow_SKHKAccount", @"收款/还款账户"), XYBString(@"str_xsdborrow_totalRepayment", @"还款总额") ];
    UILabel *customLab;
    for (int x = 0; x < a; x++) {
        UILabel *titleLab = [[UILabel alloc] init];
        titleLab.text = [titleArr objectAtIndex:x];
        titleLab.textColor = COLOR_MAIN_GREY;
        titleLab.font = TEXT_FONT_16;
        [processView addSubview:titleLab];

        [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@Margin_Length);
            if (customLab) {
                make.top.equalTo(customLab.mas_bottom).offset(Margin_Length);
            } else {
                make.top.equalTo(@10);
            }
        }];
        customLab = titleLab;
        if (x == 4) {
            UIButton *explainBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [explainBtn setTitle:@"说明" forState:UIControlStateNormal];
            explainBtn.titleLabel.font = TEXT_FONT_16;
            [explainBtn setTitleColor:COLOR_MAIN forState:UIControlStateNormal];
            explainBtn.tag = 1008;
            [explainBtn addTarget:self action:@selector(clickTheExplainBtn) forControlEvents:UIControlEventTouchUpInside];
            [processView addSubview:explainBtn];

            [explainBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(@(-Margin_Length));
                make.centerY.equalTo(titleLab.mas_centerY);
            }];

            UILabel *contentLab = [[UILabel alloc] init];
            contentLab.textColor = COLOR_MAIN_GREY;
            contentLab.font = TEXT_FONT_16;
            contentLab.tag = 200 + x;
            UITextField *aField = (UITextField *) [self viewWithTag:MONEYLABTAG];
            NSString *monStr = [self calculate:aField.text];
            if ([monStr doubleValue] == 0) {
                contentLab.text = XYBString(@"str_xsdborrow_0.00yuanPerMonth", @"0.00元/30天");
            } else {
                contentLab.text = [NSString stringWithFormat:XYBString(@"str_xsdborrow_anyYuanPerMonth", @"%@元/30天"), [self calculate:aField.text]];
            }
            [processView addSubview:contentLab];

            [contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(explainBtn.mas_left).offset(-10);
                make.centerY.equalTo(titleLab.mas_centerY);
            }];

        } else {
            UILabel *contentLab = [[UILabel alloc] init];
            contentLab.textColor = COLOR_MAIN_GREY;
            contentLab.font = TEXT_FONT_16;
            contentLab.tag = 200 + x;
            [processView addSubview:contentLab];

            [contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(@(-Margin_Length));
                make.centerY.equalTo(titleLab.mas_centerY);
            }];
        }
    }
    [self reloadData];
}

- (void)moneyTextFieldChange {

    UIButton *btn = (UIButton *) [self viewWithTag:AUTHORIZEDBTNTAG];

    int moneyDou = (int) [moneyField.text integerValue];
    if (moneyDou == 0) {
        btn.userInteractionEnabled = NO;
        btn.backgroundColor = COLOR_LIGHTGRAY_BUTTONDISABLE;
    } else {
        btn.userInteractionEnabled = YES;
        btn.backgroundColor = COLOR_MAIN;
    }
}

- (void)clickTheAgreementButton {
    if (self.clickAgreementButton) {
        self.clickAgreementButton();
    }
}

- (void)clickTheExplainBtn {
    if (self.clickExplainBtn) {
        self.clickExplainBtn();
    }
}

- (void)clickTheTelescopicBtn:(UIButton *)sender {
    [processView mas_updateConstraints:^(MASConstraintMaker *make) {
        if (sender.selected) {
            make.height.equalTo(@130);
        } else {
            make.height.equalTo(@210);
        }

    }];
    [self creatTheProcessView:sender.selected];
    sender.selected = !sender.selected;
}

- (void)clickTheAuthorizedBtn:(UIButton *)btn {

    if (moneyField.text.length == 0) {

        [HUD showPromptViewWithToShowStr:XYBString(@"str_xsdborrow_enterBorrowAmount", @"请输入借款金额") autoHide:YES afterDelay:1.0 userInteractionEnabled:YES];
        return;
    }

    if (![Utility isValidateNumber:moneyField.text]) {

        [HUD showPromptViewWithToShowStr:XYBString(@"str_xsdborrow_borrowAmountEditError", @"借款金额填写错误") autoHide:YES afterDelay:1.0 userInteractionEnabled:YES];
        return;
    }

    [UMengAnalyticsUtil event:EVENT_XSDBORROW_MONEY];
    UITextField *aField = (UITextField *) [self viewWithTag:MONEYLABTAG];
    if (self.clickAuthorizedButton) {
        self.clickAuthorizedButton(aField.text);
    }
}

- (void)setModel:(XsdAuthorized *)model {
    _model = model;
    borrowView.recordUrl = model.historyUrl;
    //    if (model.repayInfoList.count > 0) {
    NSArray *arr = [BorrowRecordModel objectArrayWithKeyValuesArray:model.repayInfoList];
    [borrowArr addObjectsFromArray:arr];
    borrowView.arr = borrowArr;

    //    }

    ruler.maxMoney = [model.approvedAmount doubleValue];
    if ([model.approvedAmount doubleValue] < 10000) {
        [ruler showRulerScrollViewWithCount:100 average:[NSNumber numberWithFloat:0.1] currentValue:(int) [Utility shareInstance].xsdScale * 0.1 scaleValue:(int) [Utility shareInstance].xsdScale unableValie:[model.approvedAmount integerValue] / 100 smallMode:YES];
    } else {
        [ruler showRulerScrollViewWithCount:(int) [Utility shareInstance].xsdScale average:[NSNumber numberWithFloat:0.1] currentValue:(int) [Utility shareInstance].xsdScale * 0.1 scaleValue:(int) [Utility shareInstance].xsdScale unableValie:[model.approvedAmount integerValue] / 100 smallMode:YES];
    }

    UILabel *lab = (UILabel *) [self viewWithTag:RETURNTAG];
    UITextField *aField = (UITextField *) [self viewWithTag:MONEYLABTAG];
    UIButton *btn = (UIButton *) [self viewWithTag:AUTHORIZEDBTNTAG];
    if ([model.approvedAmount doubleValue] == 0) {
        ruler.userInteractionEnabled = NO;
        aField.userInteractionEnabled = NO;
        btn.userInteractionEnabled = NO;
        btn.backgroundColor = COLOR_LIGHTGRAY_BUTTONDISABLE;
    } else {
        ruler.userInteractionEnabled = YES;
        aField.userInteractionEnabled = YES;
        btn.userInteractionEnabled = YES;
        btn.backgroundColor = COLOR_MAIN;
    }

    if ([model.approvedState integerValue] == 13) {
        btn.userInteractionEnabled = NO;
        btn.backgroundColor = COLOR_LIGHTGRAY_BUTTONDISABLE;
        [btn setTitle:XYBString(@"str_xsdborrow_takeLoan", @"放款中...") forState:UIControlStateNormal];

    } else {
        [btn setTitle:XYBString(@"str_xsdborrow_borrow", @"借款") forState:UIControlStateNormal];
        if ([model.approvedAmount doubleValue] == 0) {
            btn.userInteractionEnabled = NO;
            btn.backgroundColor = COLOR_LIGHTGRAY_BUTTONDISABLE;
        } else {
            btn.userInteractionEnabled = YES;
            btn.backgroundColor = COLOR_MAIN;
        }
    }

    if ([model.approvedAmount doubleValue] == 0) {
        lab.text = XYBString(@"str_financing_zero", @"0.00");
        aField.text = XYBString(@"str_financing_zero", @"0.00");
    } else {
        lab.text = [Utility replaceTheNumberForNSNumberFormatter:[NSString stringWithFormat:@"%.2f", [model.approvedAmount doubleValue]]];
        aField.text = [NSString stringWithFormat:@"%.0f", [model.approvedAmount doubleValue]];
    }
    [self reloadData];
}

- (void)reloadData {

    UILabel *lab1 = (UILabel *) [self viewWithTag:200];
    UILabel *lab2 = (UILabel *) [self viewWithTag:201];
    UILabel *lab3 = (UILabel *) [self viewWithTag:202];
    UILabel *lab4 = (UILabel *) [self viewWithTag:203];
    UILabel *lab5 = (UILabel *) [self viewWithTag:204];
    lab1.text = [NSString stringWithFormat:@"%@", _model.dayRate];
    lab2.text = [NSString stringWithFormat:@"%@", _model.loanLimit];
    lab3.text = [NSString stringWithFormat:@"%@", _model.repayEndDay];
    if (!_model.bankName) {
        _model.bankName = @"";
    }
    if (!_model.cardNo) {
        _model.cardNo = @"";
    }

    lab4.text = [NSString stringWithFormat:@"%@ %@", _model.bankName, _model.cardNo];

    if ([_model.approvedState integerValue] == 13) {
        lab5.text = XYBString(@"str_xsdborrow_0.00yuanPerMonth", @"0.00元/30天");

    } else {
        UITextField *aField = (UITextField *) [self viewWithTag:MONEYLABTAG];
        NSString *monStr = [self calculate:aField.text];
        if ([_model.approvedAmount doubleValue] == 0) {
            lab5.text = XYBString(@"str_xsdborrow_0.00yuanPerMonth", @"0.00元/30天");
        } else {
            lab5.text = [NSString stringWithFormat:XYBString(@"str_xsdborrow_anyYuanPerMonth", @"%@元/30天"), monStr];
        }
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {

    int moneyDou = (int) [moneyField.text integerValue];
    double totalMoney = [_model.approvedAmount doubleValue];
    if (moneyDou > totalMoney) {
        xsdAlert.hidden = NO;
        xsdAlert.contentStr = [NSString stringWithFormat:XYBString(@"str_xsdborrow_mostBorrow", @"最高可借%.0f元"), totalMoney];
        xsdAlert.alpha = 1.0;

        [UIView animateWithDuration:2.0 animations:^{
            moneyField.text = [NSString stringWithFormat:@"%.0f", totalMoney];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"CHANGESCROLLVIEW" object:moneyField.text];

            xsdAlert.alpha = 0.0;
        }
            completion:^(BOOL finished) {
                xsdAlert.hidden = YES;

            }];

        return;
    }
    if (moneyDou % 100 != 0) {
        xsdAlert.hidden = NO;
        xsdAlert.contentStr = XYBString(@"str_xsdborrow_enterAmountXW100ZSB", @"输入金额必须为100的倍数");
        xsdAlert.alpha = 1.0;
        [UIView animateWithDuration:2.0 animations:^{
            xsdAlert.alpha = 0.0;
            int moneyNum = moneyDou / 100;
            moneyField.text = [NSString stringWithFormat:@"%d", moneyNum * 100];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"CHANGESCROLLVIEW" object:moneyField.text];

        }
            completion:^(BOOL finished) {
                xsdAlert.hidden = YES;
            }];

        return;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CHANGESCROLLVIEW" object:moneyField.text];
}

- (void)txhRrettyRuler:(TXHRulerScrollView *)rulerScrollView {

    UITextField *aField = (UITextField *) [self viewWithTag:MONEYLABTAG];
    double totalMoney = [_model.approvedAmount doubleValue];
    if (totalMoney - rulerScrollView.rulerValue * 1000 < 50) {
        aField.text = [NSString stringWithFormat:@"%.0f", totalMoney];
    } else {
        int moneyNum = rulerScrollView.rulerValue * 1000 / 100;
        aField.text = [NSString stringWithFormat:@"%d", moneyNum * 100];
    }

    //计算方式 申请金额 * (0.0002 + 0.0016) * 30 + 申请金额
    UILabel *lab5 = (UILabel *) [self viewWithTag:204];
    lab5.text = [NSString stringWithFormat:XYBString(@"str_xsdborrow_anyYuanPerMonth", @"%@元/30天"), [self calculate:aField.text]];
}

- (NSString *)calculate:(NSString *)str {
    double calculate = [str doubleValue];
    double total = calculate + calculate * (0.0002 + 0.0016) * 30;
    NSString *totalStr = [Utility replaceTheNumberForNSNumberFormatter:[NSString stringWithFormat:@"%.2f", total]];

    return totalStr;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
