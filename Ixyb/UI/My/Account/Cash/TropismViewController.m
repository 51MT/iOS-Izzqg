//
//  TropismViewController.m
//  Ixyb
//
//  Created by wang on 15/5/20.
//  Copyright (c) 2015年 xyb. All rights reserved.
//

#import "TropismViewController.h"

#import "HandleUserInfo.h"
#import "MyAlertView.h"
#import "Utility.h"

#import "BankInfoViewController.h"
#import "WebviewViewController.h"

#import "BankBranchModel.h"
#import "BankBranchViewController.h"
#import "ChangePayPasswordViewController.h"
#import "CityModel.h"
#import "IncomeStatusViewController.h"
#import "ProvinceModel.h"
#import "ProvinceViewController.h"
//#import "TradePasswordView.h"
#import "MyBanksResponseModel.h"
#import "TBankInfoViewController.h"
#import "TBranchViewController.h"
#import "TropismTradePasswordView.h"
#import "WebService.h"
#import "WithdrawalsCounterFeeModel.h"
#import "UMengAnalyticsUtil.h"
#import "XYTextField.h"

@interface TropismViewController () <TBankInfoViewControllerDelegate, TBranchViewControllerDelegate> {

    XYTextField *dustedMoneyTextField;

    UIScrollView *mainScroll;
    UIImageView *investBackImage;

    UIView *bankInfoView;
    int bankTypeNumber;

    UIView *customerView;
    UIView *unSaveView;
    UIView *branchView;

    TropismTradePasswordView *tradePayView;

    TBankInfoViewController *tropismBankInfoVc;
    NSArray *bankArr;

    UIButton *nextButton;

    NSMutableDictionary *requestDataDic;

    UILabel *commissionNumLab;

    float viewHight;

    double uncollectedAmount; //未还款金额
}
@end

@implementation TropismViewController
- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    [UMengAnalyticsUtil beginLogPageView:NSStringFromClass([self class])];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [UMengAnalyticsUtil endLogPageView:NSStringFromClass([self class])];
}

- (void)setNav {
    self.navItem.title = XYBString(@"str_withdraw", @"提现");

    self.navItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(clickBackBtn:)];

    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"question_mark"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"question_mark_ed"] forState:UIControlStateHighlighted];
    button.frame = CGRectMake(0.0f, 0.0f, 40.0f, 40.0f);
    [button addTarget:self action:@selector(clickTheRightBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.navBar addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.navBar);
        make.right.equalTo(@(-Margin_Right));
    }];
}

- (void)clickTheRightBtn {

    [dustedMoneyTextField resignFirstResponder];

    NSString *urlStr = [NSString stringWithFormat:@"%@%@", [RequestURL getNodeJsH5URL:App_Bank_Limit_URL withIsSign:NO], App_Bank_Tab_Nav2_URL];
    NSString *titleStr = XYBString(@"str_bank_limit", @"充值提现说明");
    WebviewViewController *webView = [[WebviewViewController alloc] initWithTitle:titleStr webUrlString:urlStr];
    [self.navigationController pushViewController:webView animated:YES];
}

- (void)clickBackBtn:(id)sender {
    [dustedMoneyTextField resignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    NSString *bankJson = [[NSBundle mainBundle] pathForResource:@"bank" ofType:@"json"];
    bankArr = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:bankJson] options:NSJSONReadingMutableContainers error:nil];
    requestDataDic = [[NSMutableDictionary alloc] init];
    viewHight = 50.f;
    [self setNav];
    [self creatTheMianScroll];
    [self creatTheBankInfoView];   //创建页面的上半部分视图
    [self creatTheNoBankSaveView]; //创建填写银行信息视图

    User *user = [UserDefaultsUtil getUser];
    if ([user.bankType intValue] == 0) {
        [self creatTheNoBankSaveView]; //创建填写银行信息视图

    } else {
        if ([user.isBankSaved boolValue] && [user.isWithdrawMoney boolValue]) {
            [self creatTheNextButtonView];
        } else if ([user.isBankSaved boolValue] && ![user.isWithdrawMoney boolValue]) {
            [self creatTheNextButtonView]; //创建银行
        } else {
            [self creatTheNoBankSaveView]; //创建填写银行信息视图
        }
    }

    [self requestDrawMoneyFeeWebService:@{
        @"userId" : [UserDefaultsUtil getUser].userId,
        @"amount" : @"0"
    }];
}

- (void)creatTheMianScroll {

    mainScroll = [[UIScrollView alloc] init];
    mainScroll.showsVerticalScrollIndicator = NO;
    mainScroll.scrollEnabled = NO;
    [self.view addSubview:mainScroll];

    [mainScroll mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navBar.mas_bottom);
        make.left.bottom.right.equalTo(self.view);
    }];

    UIView *vi = [[UIView alloc] init];
    [self.view addSubview:vi];

    [vi mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.width.equalTo(@(MainScreenWidth));
        make.height.equalTo(@1);
    }];

    investBackImage = [[UIImageView alloc] init];
    investBackImage.image = [UIImage imageNamed:@"viewBackImage"];
    investBackImage.userInteractionEnabled = YES;
    [mainScroll addSubview:investBackImage];

    [investBackImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(mainScroll);
        make.width.equalTo(vi.mas_width);
        make.top.equalTo(@20);
    }];

    NSString *usableAmountStr = [Utility replaceTheNumberForNSNumberFormatter:[NSString stringWithFormat:@"%.2f", [[UserDefaultsUtil getUser].usableAmount doubleValue]]];
    if ([usableAmountStr doubleValue] == 0) {
        usableAmountStr = @"0.00";
    }

    dustedMoneyTextField = [[XYTextField alloc] initWithIsEnabledNoPaste:YES];
    dustedMoneyTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    dustedMoneyTextField.placeholder = [NSString stringWithFormat:XYBString(@"str_amount_tropism", @"可提现金额%@"), usableAmountStr];
    dustedMoneyTextField.textColor = COLOR_MAIN_GREY;
    dustedMoneyTextField.font = TEXT_FONT_16;
    dustedMoneyTextField.keyboardType = UIKeyboardTypeDecimalPad;

    [investBackImage addSubview:dustedMoneyTextField];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dustedMoneyTextFieldChange) name:UITextFieldTextDidChangeNotification object:dustedMoneyTextField];
    [dustedMoneyTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Margin_Length));
        make.centerY.equalTo(investBackImage.mas_centerY);
        make.height.equalTo(@30);
    }];

    UILabel *unitLab = [[UILabel alloc] init];
    unitLab.text = XYBString(@"str_yuan", @"元");
    unitLab.textColor = COLOR_MAIN_GREY;
    unitLab.font = TEXT_FONT_16;
    [investBackImage addSubview:unitLab];
    [unitLab setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh + 20 forAxis:UILayoutConstraintAxisHorizontal];
    [unitLab setContentHuggingPriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    [unitLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(dustedMoneyTextField.mas_right).offset(Margin_Length);
        make.centerY.equalTo(investBackImage.mas_centerY);
    }];

    UIView *splitPView = [[UIView alloc] init];
    splitPView.backgroundColor = COLOR_LINE;
    [investBackImage addSubview:splitPView];
    [splitPView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(unitLab.mas_right).offset(10);
        make.width.equalTo(@(Line_Height));
        make.top.equalTo(dustedMoneyTextField.mas_top).offset(5);
        make.bottom.equalTo(dustedMoneyTextField.mas_bottom).offset(-5);
    }];

    UIButton *allButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [investBackImage addSubview:allButton];
    [allButton setTitle:XYBString(@"str_allTropism", @"全提") forState:UIControlStateNormal];
    [allButton setTitleColor:COLOR_MAIN forState:UIControlStateNormal];
    allButton.titleLabel.font = TEXT_FONT_16;
    [allButton addTarget:self action:@selector(clickAllButton:) forControlEvents:UIControlEventTouchUpInside];
    [investBackImage addSubview:allButton];
    [allButton setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh + 20 forAxis:UILayoutConstraintAxisHorizontal];
    [allButton setContentHuggingPriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    [allButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@-10);
        make.left.equalTo(splitPView.mas_right).offset(10);
        make.centerY.equalTo(@0);
        make.height.equalTo(dustedMoneyTextField.mas_height);

    }];
}

- (void)creatTheBankInfoView {
    if (bankInfoView) {
        [bankInfoView removeFromSuperview];
    }

    User *user = [UserDefaultsUtil getUser];

    bankInfoView = [[UIView alloc] init];
    bankInfoView.backgroundColor = COLOR_COMMON_CLEAR;
    [mainScroll addSubview:bankInfoView];

    [bankInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(mainScroll);
        make.top.equalTo(investBackImage.mas_bottom);
        if ([user.isBankSaved boolValue] == YES && [user.bankType intValue] != 0) {
            make.height.equalTo(@90);
        } else {
            make.height.equalTo(@45);
        }
    }];

    viewHight = 45.f;
    UIImageView *costomerLogo = nil;
    if ([user.isBankSaved boolValue] == YES && [user.bankType intValue] != 0) {
        viewHight = 90.f;
        UIImageView *saveBank3VerlineImage = [[UIImageView alloc] init];
        saveBank3VerlineImage.image = [UIImage imageNamed:@"onePoint"];
        [bankInfoView addSubview:saveBank3VerlineImage];

        [saveBank3VerlineImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@(Margin_Length));
            make.right.equalTo(@0);
            make.centerY.equalTo(bankInfoView.mas_centerY);
            make.height.equalTo(@1);
        }];

        UIImageView *bankLogo = [[UIImageView alloc] init];
        [bankInfoView addSubview:bankLogo];

        [bankLogo mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(saveBank3VerlineImage.mas_top).offset(Text_Margin_Length);
            make.left.equalTo(@(Margin_Length));
        }];
        costomerLogo = bankLogo;

        UILabel *commissionLab = [[UILabel alloc] init];
        commissionLab.font = TEXT_FONT_12;
        commissionLab.textColor = COLOR_AUXILIARY_GREY;
        commissionLab.text = XYBString(@"str_yuan_free_fees_amt", @"免手续费额度:");
        [bankInfoView addSubview:commissionLab];

        [commissionLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@Margin_Length);
            make.top.equalTo(bankInfoView.mas_top).offset(15);
        }];

        commissionNumLab = [[UILabel alloc] init];
        commissionNumLab.font = TEXT_FONT_14;
        commissionNumLab.textColor = COLOR_STRONG_RED;
        commissionNumLab.text = @"0.00元";
        [bankInfoView addSubview:commissionNumLab];

        [commissionNumLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(commissionLab.mas_right).offset(5);
            make.centerY.equalTo(commissionLab.mas_centerY);
        }];

        UILabel *bankName = [[UILabel alloc] init];
        bankName.font = TEXT_FONT_12;
        bankName.textColor = COLOR_MAIN_GREY;
        [bankInfoView addSubview:bankName];

        [bankName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(bankLogo.mas_right).offset(Text_Margin_Middle);
            make.centerY.equalTo(bankLogo.mas_centerY);
        }];

        UILabel *bankNumLab = [[UILabel alloc] init];
        bankNumLab.font = TEXT_FONT_12;
        bankNumLab.textColor = COLOR_LIGHT_GREY;
        if (user.accountNumber) {
            bankNumLab.text = [NSString stringWithFormat:XYBString(@"str_last_number", @"(尾号%@)"), [user.accountNumber substringWithRange:NSMakeRange(user.accountNumber.length - 4, 4)]];
        }

        [bankInfoView addSubview:bankNumLab];

        [bankNumLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(bankName.mas_right).offset(2);
            make.centerY.equalTo(bankLogo.mas_centerY);
        }];

        bankTypeNumber = [user.bankType intValue];
        for (NSDictionary *dic in bankArr) {
            int bankType = [[dic objectForKey:@"bankType"] intValue];
            if (bankType == [user.bankType intValue]) {
                bankLogo.image = [UIImage imageNamed:[NSString stringWithFormat:@"bank%@", user.bankType]];
                bankName.text = [dic objectForKey:@"bankName"];
                break;
            }
        }
        
    } else {

        UILabel *commissionLab = [[UILabel alloc] init];
        commissionLab.font = TEXT_FONT_12;
        commissionLab.textColor = COLOR_AUXILIARY_GREY;
        commissionLab.text = XYBString(@"str_yuan_free_fees_amt", @"免手续费额度:");
        [bankInfoView addSubview:commissionLab];
        
        [commissionLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@Margin_Length);
            make.top.equalTo(bankInfoView.mas_top).offset(15);
        }];

        commissionNumLab = [[UILabel alloc] init];
        commissionNumLab.font = TEXT_FONT_14;
        commissionNumLab.textColor = COLOR_STRONG_RED;
        commissionNumLab.text = @"0.00元";
        [bankInfoView addSubview:commissionNumLab];

        [commissionNumLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(commissionLab.mas_right).offset(5);
            make.centerY.equalTo(commissionLab.mas_centerY);
        }];
    }
}

- (void)creatTheNoBankSaveView {

    if (unSaveView) {
        [unSaveView removeFromSuperview];
    }

    if (branchView) {
        [branchView removeFromSuperview];
    }

    if (tropismBankInfoVc) {
        [tropismBankInfoVc removeFromParentViewController];
        tropismBankInfoVc.delegate = nil;
    }

    tropismBankInfoVc = [[TBankInfoViewController alloc] init];
    unSaveView = tropismBankInfoVc.view;
    tropismBankInfoVc.delegate = self;
    [self addChildViewController:tropismBankInfoVc];
    [mainScroll addSubview:unSaveView];

    [unSaveView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(-1));
        make.right.equalTo(@(1));
        make.top.equalTo(investBackImage.mas_bottom).offset(viewHight);
        make.height.equalTo(@340);
        make.bottom.equalTo(mainScroll.mas_bottom).offset(0);
    }];
    
}

- (void)creatTheNextButtonView {

    if (unSaveView) {
        [unSaveView removeFromSuperview];
    }
    if (branchView) {
        [branchView removeFromSuperview];
    }

    nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [nextButton setTitle:XYBString(@"str_ok", @"确定") forState:UIControlStateNormal];
    [nextButton addTarget:self action:@selector(clickTheNextButton:) forControlEvents:UIControlEventTouchUpInside];
    [nextButton setTitleColor:COLOR_COMMON_WHITE forState:UIControlStateNormal];
    nextButton.backgroundColor = COLOR_LIGHTGRAY_BUTTONDISABLE;
    nextButton.userInteractionEnabled = NO;
    [nextButton setBackgroundImage:[ColorUtil imageWithColor:COLOR_HIGHTBULE_BUTTON] forState:UIControlStateHighlighted];
    [nextButton.layer setMasksToBounds:YES];
    [nextButton.layer setCornerRadius:4.0];
    [mainScroll addSubview:nextButton];

    [nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@10);
        make.right.equalTo(@(-10));
        make.top.equalTo(investBackImage.mas_bottom).offset(viewHight);
        make.height.equalTo(@44);
        make.bottom.equalTo(mainScroll.mas_bottom).offset(-20);
    }];
    
    UILabel *tipLab = [[UILabel alloc] init];
    tipLab.font = TEXT_FONT_12;
    tipLab.textColor = COLOR_MAIN_GREY;
    tipLab.text = XYBString(@"str_cash_tip", @"温馨提示：若申请提现T+1个工作日后仍未到账，可能是银行卡信息异常，请及时联系客服400-070-7663。");
    tipLab.numberOfLines = 2;
    [mainScroll addSubview:tipLab];
    
    NSMutableParagraphStyle *mutableParagraphStyle = [[NSMutableParagraphStyle alloc] init];
    mutableParagraphStyle.lineSpacing = 5;
    mutableParagraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
    NSMutableAttributedString *mutableAttributedString = [[NSMutableAttributedString alloc]
        initWithString:XYBString(@"str_cash_tip", @"温馨提示：若申请提现T+1个工作日后仍未到账，可能是银行卡信息异常，请及时联系客服400-070-7663。")
           attributes : @{NSForegroundColorAttributeName : COLOR_AUXILIARY_GREY,
                                    NSFontAttributeName  : TEXT_FONT_12,
                             NSParagraphStyleAttributeName:mutableParagraphStyle
                         }];
    tipLab.attributedText = mutableAttributedString;
    
    
    [tipLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nextButton.mas_bottom).offset(Margin_Length);
        make.left.equalTo(@(Margin_Length));
        make.right.equalTo(@(-Margin_Length));
    }];
}

- (void)clickAllButton:(id)sender {
    //    NSString *usableAmountStr = [Utility replaceTheNumberForNSNumberFormatter:[UserDefaultsUtil getUser].usableAmount];
    dustedMoneyTextField.text = [NSString stringWithFormat:@"%@", [UserDefaultsUtil getUser].usableAmount];
    [[NSNotificationCenter defaultCenter] postNotificationName:UITextFieldTextDidChangeNotification object:dustedMoneyTextField];
}

- (void)dustedMoneyTextFieldChange {
    if ([dustedMoneyTextField.text isEqualToString:@"\n"]) {
        //禁止输入换行
        [dustedMoneyTextField resignFirstResponder];
        return;
    }

    if (dustedMoneyTextField.text.length > 12) {
        dustedMoneyTextField.text = [dustedMoneyTextField.text substringToIndex:12];
    }
    if (dustedMoneyTextField.text.length != 0) {
        nextButton.backgroundColor = COLOR_MAIN;
        nextButton.userInteractionEnabled = YES;
    } else {
        nextButton.backgroundColor = COLOR_LIGHTGRAY_BUTTONDISABLE;
        nextButton.userInteractionEnabled = NO;
    }
    if (dustedMoneyTextField.text.length == 0) {
        return;
    }
    if (![Utility isValidateNumber:dustedMoneyTextField.text]) {
        [HUD showPromptViewWithToShowStr:XYBString(@"str_error_amount", @"提现金额填写错误") autoHide:YES afterDelay:1.0 userInteractionEnabled:YES];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"dustedMoneyTextField" object:dustedMoneyTextField.text];
        return;
    }
    if (dustedMoneyTextField.text.length > 1) {
        [self requestDrawMoneyFeeWebService:@{
            @"userId" : [UserDefaultsUtil getUser].userId,
            @"amount" : dustedMoneyTextField.text
        }];
    }

    [[NSNotificationCenter defaultCenter] postNotificationName:@"dustedMoneyTextField" object:dustedMoneyTextField.text];
}

- (void)clickTheNextButton:(id)sender {

    [dustedMoneyTextField resignFirstResponder];
    nextButton.userInteractionEnabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        nextButton.userInteractionEnabled = YES;
    });

    if (dustedMoneyTextField.text.length == 0) {
        [HUD showPromptViewWithToShowStr:XYBString(@"str_enter_rightAmount", @"请输入正确的提现金额") autoHide:YES afterDelay:1.0 userInteractionEnabled:YES];
        return;
    }
    if (![Utility isValidateNumber:dustedMoneyTextField.text]) {
        [HUD showPromptViewWithToShowStr:XYBString(@"str_error_amount", @"提现金额填写错误") autoHide:YES afterDelay:1.0 userInteractionEnabled:YES];
        return;
    }

    double balanceMoneyNum = [[UserDefaultsUtil getUser].usableAmount doubleValue];
    double dustedMoney = [dustedMoneyTextField.text doubleValue];

    if (dustedMoney > balanceMoneyNum) {
        [HUD showPromptViewWithToShowStr:XYBString(@"str_lessthan_amount", @"提现金额超限") autoHide:YES afterDelay:1.0 userInteractionEnabled:YES];
        return;
    }

    if (dustedMoney < 100) {

        [HUD showPromptViewWithToShowStr:XYBString(@"str_notlessthan_100", @"提现金额不能低于100元") autoHide:YES afterDelay:1.0 userInteractionEnabled:YES];
        return;
    }

    //    if (uncollectedAmount >= balanceMoneyNum) {
    //        [HUD showPromptViewWithToShowStr:XYBString(@"string_low_amount",@"本次提现金额上限为0元") autoHide:YES afterDelay:1.0 userInteractionEnabled:YES];
    //        return;
    //    }
    //    if (uncollectedAmount < balanceMoneyNum) {
    //        if (dustedMoney > (balanceMoneyNum-uncollectedAmount)) {
    //            NSString *uncollectedStr = [Utility stringrangeStr:[NSString stringWithFormat:@"%.2f",uncollectedAmount]];
    //            NSString *factStr = [Utility stringrangeStr:[NSString stringWithFormat:@"%.2f",balanceMoneyNum-uncollectedAmount]];
    //            [HUD showPromptViewWithToShowStr:[NSString stringWithFormat:@"您尚有%@元借款未还清,本次提现金额上限为%@元",uncollectedStr,factStr] autoHide:YES afterDelay:1.0 userInteractionEnabled:YES];
    //               return;
    //        }
    //
    //    }
    //    if (dustedMoney > 1000000 ) {
    //
    //        [HUD showPromptViewWithToShowStr:XYBString(@"string_notGreaterthan",@"提现金额不能大于100万元") autoHide:YES afterDelay:1.0 userInteractionEnabled:YES];
    //        return;
    //    }

    NSString *userPhoneStr = [UserDefaultsUtil getUser].bankmobilePhone;
    NSDictionary *contenDic = @{
        @"userId" : [UserDefaultsUtil getUser].userId,
        @"amount" : dustedMoneyTextField.text,
        @"mobilePhone" : userPhoneStr.length > 0 ? userPhoneStr : @""
    };
    [self tropismCounterFee:contenDic];
}

- (void)tropismCounterFee:(NSDictionary *)dic {
    AlertViewToSetShow *alertView = [[AlertViewToSetShow alloc] init];
    alertView.amount = dustedMoneyTextField.text;
    [alertView show:^{
    }];
    __weak AlertViewToSetShow *weakAlert = alertView;
    alertView.chargeBlock = ^() {
        [weakAlert removeFromSuperview];
        [self payTheTouIDFinancing:dic];
    };
}

/**
 *  指纹支付
 *
 *  @param payStr 输入密码
 */
- (void)payTheTouIDFinancing:(NSDictionary *)contenDic {

    //验证是否支持TouID
    [[VerificationTouch shared] isSupportTouch:^(XybTouIDVerification touchType) {

        if (touchType == NotSupportedTouID) {

            [self payTheFinancing:contenDic];

        } else if (touchType == YesSupportedTouID) {
            if (![[UserDefaultsUtil getUser].isTradePassword boolValue]) { //是否设置交易密码

                [self payTheFinancing:contenDic];

            } else {
                //根据当前登录用户ID  查询私钥 是否开始指纹交易
                NSString *encryption = [UserDefaultsUtil getEncryptionData:[UserDefaultsUtil getUser].userId];
                if (encryption > 0) {

                    //验证指纹
                    [[VerificationTouch shared] SupportTouchID:^(XybTouIDVerification touchType) {
                        switch (touchType) {
                            case TouIDVerficationSuccess: //验证成功
                            {
                                dispatch_async(dispatch_get_main_queue(), ^{

                                    HBRSAHandler *handler = [[HBRSAHandler alloc] init];
                                    [handler importKeyWithType:KeyTypePrivate andkeyString:encryption];
                                    NSString *string = [NSString stringWithFormat:@"%@%@%@", [UserDefaultsUtil getUser].userId, [DateTimeUtil getCurrentTime], [OpenUDID value]];

                                    //生成指纹 交易密码
                                    NSString *sigPassWord = [handler signMD5String:string];
                                    NSMutableDictionary *requestDic = [NSMutableDictionary dictionaryWithDictionary:contenDic];
                                    [requestDic setObject:[UserDefaultsUtil getUser].userId forKey:@"userId"];
                                    [requestDic setObject:dustedMoneyTextField.text forKey:@"amount"];
                                    [requestDic setObject:sigPassWord forKey:@"tradePassword"];
                                    [requestDic setObject:[OpenUDID value] forKey:@"deviceId"];
                                    [requestDic setObject:[DateTimeUtil getCurrentTime] forKey:@"timestamp"];
                                    [requestDic setObject:@"1" forKey:@"paymentMode"];
                                    User *user = [UserDefaultsUtil getUser];
                                    if ([contenDic objectForKey:@"bankType"]) {
                                        bankTypeNumber = [[contenDic objectForKey:@"bankType"] intValue];
                                    }

                                    if ([user.isBankSaved boolValue]) {
                                        [requestDic setObject:[NSNumber numberWithInt:bankTypeNumber] forKey:@"bankType"];
                                    }

                                    [self callDrawMoneyWebService:requestDic];

                                });
                            } break;
                            case TouIDVerficationFail: //验证失败
                            {
                                dispatch_async(dispatch_get_main_queue(), ^{

                                    [HUD showPromptViewWithToShowStr:XYBString(@"transaction_message", @"指纹验证失败，请输入交易密码") autoHide:YES afterDelay:1.0 userInteractionEnabled:YES];
                                    [self performSelector:@selector(payTheFinancingInfo:) withObject:contenDic afterDelay:1.2f];

                                });
                            } break;
                            case UserCancelTouID: //用户取消验证TouID
                            {
                                dispatch_async(dispatch_get_main_queue(), ^{

                                               });
                            } break;
                            case UserInputPassWord: //用户选择请输入密码
                            {
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    [self payTheFinancing:contenDic];
                                });
                            } break;
                            case UserNotInputTouID: //用户未录入TouID
                            {
                                dispatch_async(dispatch_get_main_queue(), ^{

                                    [UserDefaultsUtil clearEncryptionData:[NSString stringWithFormat:@"%@", [UserDefaultsUtil getUser].userId]];
                                    [self payTheFinancing:contenDic];

                                });
                            } break;
                            default:
                                break;
                        }

                    }];

                } else {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self payTheFinancing:contenDic];
                    });
                }
            }
        } else if (touchType == UserNotInputTouID) {
            [UserDefaultsUtil clearEncryptionData:[NSString stringWithFormat:@"%@", [UserDefaultsUtil getUser].userId]];
            [self payTheFinancing:contenDic];
            return;
        }

    }];
}

- (void)payTheFinancingInfo:(NSDictionary *)contenDic {
    [self payTheFinancing:contenDic];
}

/**
 *   交易密码弹窗
 *
 *  @param requestataDic 传参
 */
- (void)payTheFinancing:(NSDictionary *)requestataDic {
    __weak TropismViewController *investVC = self;
    tradePayView = [[TropismTradePasswordView alloc] init];
    tradePayView.amount = dustedMoneyTextField.text;
    [tradePayView show:^(TropismTradePasswordViewAction action, NSString *password) {
        if (action == TropismTradePasswordViewActionOK) {
            NSMutableDictionary *requestDic = [NSMutableDictionary dictionaryWithDictionary:requestataDic];
            [requestDic setObject:[UserDefaultsUtil getUser].userId forKey:@"userId"];
            [requestDic setObject:dustedMoneyTextField.text forKey:@"amount"];
            [requestDic setObject:password forKey:@"tradePassword"];

            if ([requestataDic objectForKey:@"bankType"]) {
                bankTypeNumber = [[requestataDic objectForKey:@"bankType"] intValue];
            }

            User *user = [UserDefaultsUtil getUser];
            if ([user.isBankSaved boolValue]) {
                [requestDic setObject:[NSNumber numberWithInt:bankTypeNumber] forKey:@"bankType"];
            }
            [self callDrawMoneyWebService:requestDic];
        } else if (action == TropismTradePasswordViewActionForgetPassword) {
            ChangePayPasswordViewController *payPassWordVC = [[ChangePayPasswordViewController alloc] init];
            [investVC.navigationController pushViewController:payPassWordVC animated:YES];
        }
    }];
}

#pragma
#pragma - mark TBankInfoViewControllerDelegate

- (void)clickTheBtnForAddBank:(NSDictionary *)bankInfo {
    [requestDataDic addEntriesFromDictionary:bankInfo];
    [self tropismCounterFee:requestDataDic];
}

- (void)checkDustedMoneyTextFieldChange {
    [dustedMoneyTextField resignFirstResponder];
}

#pragma
#pragma - mark TBranchViewControllerDelegate
- (void)clickTheBankBranch:(NSDictionary *)bankInfo {
    [dustedMoneyTextField resignFirstResponder];
    if (requestDataDic) {
        [requestDataDic removeAllObjects];
    }
    [requestDataDic addEntriesFromDictionary:bankInfo];
    [requestDataDic setObject:[UserDefaultsUtil getUser].accountNumber forKey:@"accountNumber"];
    [self tropismCounterFee:requestDataDic];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

/*****************************提现接口**********************************/
- (void)callDrawMoneyWebService:(NSDictionary *)dictionary {

    [self showTradeLoadingOnAlertView];
    NSString *urlPath = [RequestURL getRequestURL:AccountDrawMoneyURL param:dictionary];
    [WebService postRequest:urlPath param:dictionary JSONModelClass:[ResponseModel class] Success:^(AFHTTPRequestOperation *operation, id responseObject) {

        [tradePayView removeFromSuperview];
        [self hideLoading];
        ResponseModel *response = responseObject;

        if (response.resultCode == 1) {
            IncomeStatusViewController *incomeStatusViewController = [[IncomeStatusViewController alloc] init];
            incomeStatusViewController.navItem.title = [NSString stringWithFormat:XYBString(@"str_some_success", @"%@成功"), self.navItem.title];
            incomeStatusViewController.moneyString = dustedMoneyTextField.text;
            [self.navigationController pushViewController:incomeStatusViewController animated:YES];
        }
    }
        fail:^(AFHTTPRequestOperation *operation, NSString *errorMessage) {
            [self hideLoading];
            if ([dictionary objectForKey:@"paymentMode"]) {
                [self showPromptTip:errorMessage];
            } else {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"TROPISM_ERRORNOTIFICATION" object:errorMessage];
            }
        }];
}

/*****************************检测银行卡绑定接口**********************************/
- (void)callCheckBankWebService:(NSDictionary *)dictionary {

    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:dictionary];
    NSString *urlPath = [RequestURL getRequestURL:BankURL param:params];
    [WebService postRequest:urlPath param:params JSONModelClass:[MyBanksResponseModel class]

        Success:^(AFHTTPRequestOperation *operation, id responseObject) {

            MyBanksResponseModel *myBankResponse = responseObject;
            User *user = [UserDefaultsUtil getUser];
            user.accountNumber = myBankResponse.bank.accountNumber;
            user.bankName = myBankResponse.bank.bankName;
            user.bankType = myBankResponse.bank.bankType;
            user.bankmobilePhone = myBankResponse.bank.mobilePhone;
            user.bankId = myBankResponse.bank.bankId;
            BOOL isBank = [myBankResponse.isBankSaved boolValue];
            if (isBank == YES) {
                user.isBankSaved = @"1";
            }

            BOOL isIdentityAuth = [myBankResponse.isIdentityAuth boolValue];
            if (isIdentityAuth) {
                user.isIdentityAuth = @"1";
            }
            user.realName = myBankResponse.user.realName;
            user.idNumber = myBankResponse.user.idNumber;

            BOOL isWithdrawMoney = [myBankResponse.isWithdrawMoney boolValue];
            if (isWithdrawMoney) {
                user.isWithdrawMoney = @"1";
            }
            [UserDefaultsUtil setUser:user];
            if ([user.bankType intValue] == 0) {
                [self creatTheNoBankSaveView]; //创建填写银行信息视图

            } else {
                if ([user.isBankSaved boolValue] && [user.isWithdrawMoney boolValue]) {
                    [self creatTheNextButtonView];
                } else if ([user.isBankSaved boolValue] && ![user.isWithdrawMoney boolValue]) {
                    [self creatTheNextButtonView]; //创建银行
                } else {
                    [self creatTheNoBankSaveView]; //创建填写银行信息视图
                }
            }

            [self requestDrawMoneyFeeWebService:@{
                @"userId" : [UserDefaultsUtil getUser].userId,
                @"amount" : @"0"
            }];
        }
        fail:^(AFHTTPRequestOperation *operation, NSString *errorMessage) {

            [self showPromptTip:errorMessage];
        }

    ];
}

/*****************************6.2	提现手续费*********************************/
- (void)requestDrawMoneyFeeWebService:(NSDictionary *)dictionary {
    NSString *urlPath = [RequestURL getRequestURL:AccountDrawMoneyFeeURL param:dictionary];
    [WebService postRequest:urlPath param:dictionary JSONModelClass:[WithdrawalsCounterFeeModel class] Success:^(AFHTTPRequestOperation *operation, id responseObject) {
        WithdrawalsCounterFeeModel *withdrawalsCounterFee = responseObject;
        if (withdrawalsCounterFee.resultCode == 1) {
            double freeAmount = [withdrawalsCounterFee.freeAmount doubleValue];

            if (freeAmount == 0) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    commissionNumLab.text = @"0.00元";

                });
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    commissionNumLab.text = [NSString stringWithFormat:@"%@元",[Utility replaceTheNumberForNSNumberFormatter:[NSString stringWithFormat:@"%.2f", freeAmount]]];
                });
            }
        }
    }
        fail:^(AFHTTPRequestOperation *operation, NSString *errorMessage) {
            [self showPromptTip:errorMessage];
        }];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
