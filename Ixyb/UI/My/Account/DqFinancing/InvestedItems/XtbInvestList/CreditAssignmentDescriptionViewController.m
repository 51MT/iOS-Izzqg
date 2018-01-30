//
//  CreditAssignmentDescriptionViewController.m
//  Ixyb
//
//  Created by dengjian on 10/16/15.
//  Copyright (c) 2015 xyb. All rights reserved.
//

#import "ChangePayPasswordViewController.h"
#import "CreditAssignmentDescriptionViewController.h"
#import "DMInvestedProject.h"
#import "XtbRebackSuccessViewController.h"
#import "Utility.h"
#import "WebService.h"
#import "WebviewViewController.h"
#import "XtbPossessionModel.h"

@interface CreditAssignmentDescriptionViewController () {
    TradePasswordView *tradePayView;
}

@property (nonatomic, strong) UITextView *ruleTextView;
@property (nonatomic, strong) UITextField *pwdTextField;
@property (nonatomic, strong) UILabel *totalLabel;
@property (nonatomic, strong) UILabel *feeLabel;
@property (nonatomic, strong) UILabel *interestlxLabel;
@property (nonatomic, strong) UILabel *interestjxLabel;
@property (nonatomic, strong) UILabel *disScoreAmountLabel;
@property (nonatomic, strong) UILabel *yjdzjeAmountLabel;

@end

@implementation CreditAssignmentDescriptionViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initUI];
    [self updateAssignRule];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)initUI {
    [self initNav];
    [self initScrollView];
}

- (void)initNav {
    self.navItem.title = XYBString(@"str_i_need_trans", @"我要转让");

    self.navItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(clickBackBtn:)];

    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0.0f, 0.0f, 60.0f, 40.0f);
    [button setTitle:XYBString(@"str_trans_rule", @"转让规则") forState:UIControlStateNormal];
    button.titleLabel.font = TEXT_FONT_14;
    [button addTarget:self action:@selector(clickRightBtn:) forControlEvents:UIControlEventTouchUpInside];
    [button setTitleColor:COLOR_BUTTON_HIGHLIGHT forState:UIControlStateHighlighted];
    [self.navBar addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.navBar);
        make.right.equalTo(@(-Margin_Right));
    }];
}

/**
 *  债权转让规则
 */
- (void)clickRightBtn:(id)sender {

    NSString *urlStr = [RequestURL getNodeJsH5URL:App_Assign_Rule_URL withIsSign:NO];
    NSString *titleStr = XYBString(@"str_trans_rule", @"转让规则");
    WebviewViewController *webViewVC = [[WebviewViewController alloc] initWithTitle:titleStr webUrlString:urlStr];
    [self.navigationController pushViewController:webViewVC animated:YES];
}

- (void)initScrollView {
    
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    [self.view addSubview:scrollView];
    
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.navBar.mas_bottom);
        make.width.equalTo(@(MainScreenWidth));
        make.height.equalTo(@(MainScreenHeight - 64.f));
    }];


    UIView *sumaryView = [[UIView alloc] initWithFrame:CGRectZero];
    sumaryView.layer.cornerRadius = Corner_Radius;
    [scrollView addSubview:sumaryView];
    sumaryView.backgroundColor = COLOR_COMMON_WHITE;
    [sumaryView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Margin_Left));
        make.right.equalTo(@(-Margin_Right));
        make.top.equalTo(self.navBar.mas_bottom).offset(Margin_Top);
        make.height.equalTo(@255.5);
        make.width.equalTo(@(MainScreenWidth - 30));
    }];

    UILabel *tip11Label = [[UILabel alloc] initWithFrame:CGRectZero];
    tip11Label.text = XYBString(@"str_Xtb_TipsCreditor_YMoney", @"债权本金(元)");
    tip11Label.font = SMALL_TEXT_FONT_13;
    tip11Label.textColor = COLOR_AUXILIARY_GREY;
    [sumaryView addSubview:tip11Label];
    [tip11Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(sumaryView.mas_centerX);
        make.top.equalTo(@(24));
    }];

    UILabel *totalLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    totalLabel.text = XYBString(@"str_common_zero_yuan", @"0.00元");
    totalLabel.font = XTB_RATE_FONT;
    totalLabel.textColor = COLOR_MAIN_GREY;
    self.totalLabel = totalLabel;
    [sumaryView addSubview:totalLabel];
    [totalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(sumaryView.mas_centerX);
        make.top.equalTo(tip11Label.mas_bottom).offset(7);
    }];
    
    UIView *splitView = [[UIView alloc] initWithFrame:CGRectZero];
    splitView.backgroundColor = COLOR_LINE;
    [sumaryView addSubview:splitView];
    [splitView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Margin_Left));
        make.right.equalTo(@(-Margin_Right));
        make.height.equalTo(@(Line_Height));
        make.top.equalTo(sumaryView.mas_top).offset(90);
    }];
    
    UIView *splitBttomView = [[UIView alloc] initWithFrame:CGRectZero];
    splitBttomView.backgroundColor = COLOR_LINE;
    [sumaryView addSubview:splitBttomView];
    [splitBttomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Margin_Left));
        make.right.equalTo(@(-Margin_Right));
        make.height.equalTo(@(Line_Height));
        make.bottom.equalTo(sumaryView.mas_bottom).offset(-45);
    }];
    
    UILabel *tipLxLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    tipLxLabel.text = @"利息(元)";
    tipLxLabel.font = SMALL_TEXT_FONT_13;
    tipLxLabel.textColor = COLOR_AUXILIARY_GREY;
    [sumaryView addSubview:tipLxLabel];
    [tipLxLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(splitView.mas_top).offset(18.5);
        make.left.equalTo(splitView.mas_left);
    }];
    
    UILabel *lxLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [sumaryView addSubview:lxLabel];
    lxLabel.text = XYBString(@"str_common_zero_yuan", @"0.00元");
    self.interestlxLabel = lxLabel;
    lxLabel.font = SMALL_TEXT_FONT_13;
    lxLabel.textColor = COLOR_MAIN_GREY;
    [sumaryView addSubview:lxLabel];
    [lxLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(tipLxLabel.mas_centerY);
        make.right.equalTo(splitView.mas_right);
    }];
    
    UILabel *tipJxLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    tipJxLabel.text = @"加息(元)";
    tipJxLabel.font = SMALL_TEXT_FONT_13;
    tipJxLabel.textColor = COLOR_AUXILIARY_GREY;
    [sumaryView addSubview:tipJxLabel];
    [tipJxLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tipLxLabel.mas_bottom).offset(7);
        make.left.equalTo(tipLxLabel.mas_left);
    }];
    
    UILabel *jxLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [sumaryView addSubview:jxLabel];
    jxLabel.text = XYBString(@"str_common_zero_yuan", @"0.00元");
    self.interestjxLabel = jxLabel;
    jxLabel.font = SMALL_TEXT_FONT_13;
    jxLabel.textColor = COLOR_MAIN_GREY;
    [sumaryView addSubview:jxLabel];
    [jxLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(tipJxLabel.mas_centerY);
        make.right.equalTo(splitView.mas_right);
    }];


    UILabel *tip12Label = [[UILabel alloc] initWithFrame:CGRectZero];
    tip12Label.text = XYBString(@"str_trans_fee_yuan", @"转让服务费(元)");
    tip12Label.font = SMALL_TEXT_FONT_13;
    tip12Label.textColor = COLOR_AUXILIARY_GREY;
    [sumaryView addSubview:tip12Label];
    [tip12Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tipJxLabel.mas_bottom).offset(7);
        make.left.equalTo(tipJxLabel.mas_left);
    }];

    UILabel *feeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [sumaryView addSubview:feeLabel];
    feeLabel.text = XYBString(@"str_common_zero_yuan", @"0.00元");
    self.feeLabel = feeLabel;
    feeLabel.font = SMALL_TEXT_FONT_13;
    feeLabel.textColor = COLOR_INTRODUCE_RED;
    [sumaryView addSubview:feeLabel];
    [feeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tip12Label.mas_top);
        make.right.equalTo(splitView.mas_right);
    }];


    UILabel *tip3Label = [[UILabel alloc] initWithFrame:CGRectZero];
    tip3Label.text = XYBString(@"str_trans_fee_zrf", @"积分折让费(元)");
    tip3Label.font = SMALL_TEXT_FONT_13;
    tip3Label.textColor = COLOR_AUXILIARY_GREY;
    [sumaryView addSubview:tip3Label];
    [tip3Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(splitBttomView.mas_top).offset(-18.5);
        make.left.equalTo(splitBttomView.mas_left);
    }];

    UILabel *fee2Label = [[UILabel alloc] initWithFrame:CGRectZero];
    [sumaryView addSubview:fee2Label];
    fee2Label.text = XYBString(@"str_common_zero_yuan", @"0.00元");
    self.disScoreAmountLabel = fee2Label;
    fee2Label.font = SMALL_TEXT_FONT_13;
    fee2Label.textColor = COLOR_MAIN_GREY;
    [sumaryView addSubview:fee2Label];
    [fee2Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(tip3Label.mas_centerY);
        make.right.equalTo(splitBttomView.mas_right);
    }];

    
    UILabel *yjdzjeTipsLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    yjdzjeTipsLabel.text = XYBString(@"str_Dqb_tipsredeem_estimate_money", @"预计到账金额");
    yjdzjeTipsLabel.font = SMALL_TEXT_FONT_13;
    yjdzjeTipsLabel.textColor = COLOR_AUXILIARY_GREY;
    [sumaryView addSubview:yjdzjeTipsLabel];
    [yjdzjeTipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(sumaryView.mas_bottom).offset(-Margin_Bottom);
        make.left.equalTo(splitBttomView.mas_left);
    }];
    
    UILabel *yjdzjeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [sumaryView addSubview:yjdzjeLabel];
    yjdzjeLabel.text = XYBString(@"str_common_zero_yuan", @"0.00元");
    self.yjdzjeAmountLabel = yjdzjeLabel;
    yjdzjeLabel.font = SMALL_TEXT_FONT_13;
    yjdzjeLabel.textColor = COLOR_XTB_ORANGE;
    [sumaryView addSubview:yjdzjeLabel];
    [yjdzjeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(yjdzjeTipsLabel.mas_centerY);
        make.right.equalTo(splitBttomView.mas_right);
    }];
    
    ColorButton *submitButton = [[ColorButton alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth - 30, Cell_Height) Title:XYBString(@"str_begin_trans", @"确认转让")  ByGradientType:leftToRight];
    [submitButton addTarget:self action:@selector(clickSubmitButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:submitButton];
    
    [submitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Margin_Left));
        make.right.equalTo(@(-Margin_Right));
        make.height.equalTo(@(Cell_Height));
        make.top.equalTo(sumaryView.mas_bottom).offset(20.f);
        make.width.equalTo(@(MainScreenWidth - 30));
    }];
    

    UILabel *tipAgreenLabel = [[UILabel alloc] init];
    tipAgreenLabel.text = XYBString(@"str_financing_withAgreezr", @"点击“确认转让”，即表示阅读并同意");
    tipAgreenLabel.font = TEXT_FONT_12;
    tipAgreenLabel.textAlignment = NSTextAlignmentCenter;
    tipAgreenLabel.textColor = COLOR_AUXILIARY_GREY;
    [self.view addSubview:tipAgreenLabel];
    
    [tipAgreenLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.bottom.equalTo(submitButton.mas_bottom).offset(30.f);
    }];
    
    UIButton *protocolButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view  addSubview:protocolButton];
    [protocolButton setTitle:XYBString(@"string_zqzr_agreement", @"《债权转让服务协议》") forState:UIControlStateNormal];
    [protocolButton setTitleColor:COLOR_MAIN forState:UIControlStateNormal];
    protocolButton.titleLabel.font = [UIFont systemFontOfSize:12.0f];
    [protocolButton addTarget:self action:@selector(clickProtocolButton:) forControlEvents:UIControlEventTouchUpInside];
    [protocolButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tipAgreenLabel.mas_bottom).offset(3);
        make.centerX.equalTo(tipAgreenLabel.mas_centerX);
    }];
 
}

- (void)clickProtocolButton:(id)sender {
    NSString *urlStr = [RequestURL getNodeJsH5URL:App_Ca_Protocol_URL withIsSign:NO];
    WebviewViewController *webView = [[WebviewViewController alloc] initWithTitle:nil webUrlString:urlStr];
    [self.navigationController pushViewController:webView animated:YES];
}

- (void)clickForgetPwdButton:(id)sender {

    ChangePayPasswordViewController *payPassWordVC = [[ChangePayPasswordViewController alloc] init];
    [self.navigationController pushViewController:payPassWordVC animated:YES];
}

- (void)clickBackBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 *  指纹支付
 *
 *  @param payStr 输入密码
 */
- (void)payTheTouIDFinancing {
    //验证是否支持TouID
    [[VerificationTouch shared] isSupportTouch:^(XybTouIDVerification touchType) {

        if (touchType == NotSupportedTouID) {

            [self transactionPassWord];

        } else if (touchType == YesSupportedTouID) {
            if (![[UserDefaultsUtil getUser].isTradePassword boolValue]) { //是否设置交易密码

                [self transactionPassWord];

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
                                    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithCapacity:10];
                                    if ([UserDefaultsUtil getUser].userId) {
                                        [param setObject:[UserDefaultsUtil getUser].userId forKey:@"userId"];
                                    }
                                    if ([self.dicXtbInfo objectForKey:@"orderId"]) {
                                        [param setObject:[NSNumber numberWithInteger:[[self.dicXtbInfo objectForKey:@"orderId"] integerValue]] forKey:@"orderId"];
                                    }
                                    if ([self.dicXtbInfo objectForKey:@"projectType"]) {
                                        [param setObject:[NSNumber numberWithInteger:[[self.dicXtbInfo objectForKey:@"projectType"] integerValue]] forKey:@"projectType"];
                                    }
                                    if (sigPassWord) {
                                        [param setObject:sigPassWord forKey:@"tradePassword"];
                                    }
                                    [param setObject:[OpenUDID value] forKey:@"deviceId"];
                                    [param setObject:[DateTimeUtil getCurrentTime] forKey:@"timestamp"];
                                    [param setObject:@"1" forKey:@"paymentMode"];
                                    [self clickSubmitRequestWebServiceWithParam:param];

                                });
                            } break;
                            case TouIDVerficationFail: //验证失败
                            {
                                dispatch_async(dispatch_get_main_queue(), ^{

                                    [HUD showPromptViewWithToShowStr:XYBString(@"str_transaction_message", @"指纹验证失败，请输入交易密码") autoHide:YES afterDelay:1.0 userInteractionEnabled:YES];
                                    [self performSelector:@selector(payTheFinancingInfo) withObject:nil afterDelay:1.2f];

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
                                    [self transactionPassWord];
                                });
                            } break;
                            case UserNotInputTouID: //用户未录入TouID
                            {
                                dispatch_async(dispatch_get_main_queue(), ^{

                                    [UserDefaultsUtil clearEncryptionData:[NSString stringWithFormat:@"%@", [UserDefaultsUtil getUser].userId]];
                                    [self transactionPassWord];

                                });
                            } break;
                            default:
                                break;
                        }

                    }];

                } else {
                    [self transactionPassWord];
                }
            }
        } else if (touchType == UserNotInputTouID) {
            [UserDefaultsUtil clearEncryptionData:[NSString stringWithFormat:@"%@", [UserDefaultsUtil getUser].userId]];
            [self transactionPassWord];
            return;
        }

    }];
}

- (void)payTheFinancingInfo {
    [self transactionPassWord];
}

- (void)updateAssignRule {
   
    NSDictionary *param = @{
        @"userId" : [UserDefaultsUtil getUser].userId,
        @"orderId" : [NSNumber numberWithInteger:[[self.dicXtbInfo objectForKey:@"orderId"]integerValue]],
        @"projectType" : [NSNumber numberWithInteger:[ [self.dicXtbInfo objectForKey:@"projectType"] integerValue]],
    };

    NSString *urlPath = [RequestURL getRequestURL:XtbCaAssignRuleURL param:param];
    [WebService postRequest:urlPath param:param JSONModelClass:[XtbPossessionModel class]
        Success:^(AFHTTPRequestOperation *operation, id responseObject) {
            XtbPossessionModel *xtbPossession = responseObject;
            if (xtbPossession.resultCode == 1) {
                NSString *assertValueStr = [NSString stringWithFormat:@"%.2f", [xtbPossession.assertValue doubleValue]];
                NSString *assignFeeStr = [NSString stringWithFormat:@"%.2f", [xtbPossession.assignFee doubleValue]];
                NSString *interestStr = [NSString stringWithFormat:@"%.2f", [xtbPossession.interest doubleValue]];
                NSString *addInterest = [NSString stringWithFormat:@"%.2f", [xtbPossession.addInterest doubleValue]];
                NSString *disScoreAmountStr = [NSString stringWithFormat:@"%.2f", [xtbPossession.disScoreAmount doubleValue]];
                NSString *yjdzjeAmountStr = [NSString stringWithFormat:@"%.2f", [xtbPossession.actualAmount doubleValue]];

                self.totalLabel.text = assertValueStr;
                self.feeLabel.text = [NSString stringWithFormat:@"-%@",assignFeeStr];
                self.interestlxLabel.text = [NSString stringWithFormat:@"+%@",interestStr];
                self.interestjxLabel.text = [NSString stringWithFormat:@"+%@",addInterest];
                self.disScoreAmountLabel.text =  [NSString stringWithFormat:@"-%@",disScoreAmountStr];
                self.yjdzjeAmountLabel.text = [NSString stringWithFormat:@"%@元",yjdzjeAmountStr];
            }
        }
        fail:^(AFHTTPRequestOperation *operation, NSString *errorMessage) {
            [self hideLoading];
            [self showPromptTip:errorMessage];
        }];
}
- (void)clickSubmitRequestWebServiceWithParam:(NSDictionary *)paramsDic {
    [self showTradeLoadingOnAlertView];
    NSString *urlPath = [RequestURL getRequestURL:XtbCaAssignApplyURL param:paramsDic];
    [WebService postRequest:urlPath param:paramsDic JSONModelClass:[ResponseModel class]
        Success:^(AFHTTPRequestOperation *operation, id responseObject) {
            ResponseModel *response = responseObject;
            [self hideLoading];
            [tradePayView removeFromSuperview];
            if (response.resultCode == 1) {
                XtbRebackSuccessViewController * xtbRebackSuccess = [[XtbRebackSuccessViewController alloc] init];
                xtbRebackSuccess.moneyStr = self.totalLabel.text;
                [self.navigationController pushViewController:xtbRebackSuccess animated:YES];
            }
        }
        fail:^(AFHTTPRequestOperation *operation, NSString *errorMessage) {
            [self hideLoading];
            if ([paramsDic objectForKey:@"paymentMode"]) {
                [self showPromptTip:errorMessage];
            } else {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"ERRORNOTIFICATION" object:errorMessage];
            }
        }];
}
/**
 *  交易密码
 *
 *  @param sender
 */
- (void)transactionPassWord {
    AppDelegate *app = (AppDelegate *) [UIApplication sharedApplication].delegate;
    tradePayView = [TradePasswordView shareInstancesaidView];
    [app.window addSubview:tradePayView];

    [tradePayView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(app.window);
    }];

    User *user = [UserDefaultsUtil getUser];
    __weak CreditAssignmentDescriptionViewController *weakSelf = self;

    NSString *orderId = [self.dicXtbInfo objectForKey:@"orderId"];
    NSString *projectType =  [self.dicXtbInfo objectForKey:@"projectType"];
    tradePayView.clickSureButton = ^(NSString *payStr) {
        NSDictionary *params = @{
            @"userId" : [UserDefaultsUtil getUser].userId,
            @"orderId" : [NSNumber numberWithInteger:[orderId integerValue]],
            @"projectType" : [NSNumber numberWithInteger:[projectType integerValue]],
            @"tradePassword" : payStr
        };
        [weakSelf clickSubmitRequestWebServiceWithParam:params];
    };

    tradePayView.clickForgetButton = ^{
        if (![user.isIdentityAuth boolValue]) {
            //            UserDetailRealNamesViewController   *realNameVC  = [[UserDetailRealNamesViewController alloc] init];
            //            [weakSelf.navigationController pushViewController:realNameVC animated:YES];

            ChargeViewController *chargeViewController = [[ChargeViewController alloc] initWithIdetifer:NO];
            chargeViewController.hidesBottomBarWhenPushed = YES;
            [weakSelf.navigationController pushViewController:chargeViewController animated:YES];

            return;
        }
        ChangePayPasswordViewController *payPassWordVC = [[ChangePayPasswordViewController alloc] init];
        [weakSelf.navigationController pushViewController:payPassWordVC animated:YES];
    };
}
- (void)clickSubmitButton:(id)sender {
    [self payTheTouIDFinancing];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
