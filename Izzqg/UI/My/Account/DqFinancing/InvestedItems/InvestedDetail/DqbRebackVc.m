//
//  DqbRebackVc.m
//  Ixyb
//
//  Created by wang on 16/7/20.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import "DqbRebackSuccessViewController.h"
#import "DqbRebackVc.h"
#import "DqbRedeemQueryModel.h"
#import "Utility.h"
#import "WebService.h"
#import "WebviewViewController.h"
#import "XYAlertView.h"
#import "BbgRedeemModel.h"
#import "ColorButton.h"

@interface DqbRebackVc () {
    TradePasswordView *tradePayView;
 }

@property(nonatomic,strong) DqbRedeemQueryModel * dqbRedeemQuery;

@end

@implementation DqbRebackVc

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    [self searchInvestedDqbBack];
}
- (void)initUI {
    [self initNav];
    [self initScrollView];
}

- (void)initScrollView {
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight)];
    [self.view addSubview:scrollView];

    UIView *sumaryView = [[UIView alloc] initWithFrame:CGRectZero];
    [scrollView addSubview:sumaryView];
    sumaryView.backgroundColor = COLOR_COMMON_WHITE;
    [sumaryView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(@0);
        make.top.equalTo(@Margin_Top);
        make.height.equalTo(@180);
        make.width.equalTo(@(MainScreenWidth));

    }];

    UIView *split21View = [[UIView alloc] initWithFrame:CGRectZero];
    split21View.backgroundColor = COLOR_LINE;
    [sumaryView addSubview:split21View];
    [split21View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Margin_Left));
        make.right.equalTo(sumaryView.mas_right);
        make.height.equalTo(@(Line_Height));
        make.top.equalTo(sumaryView.mas_top).offset(Button_Height);
    }];
    
    UIView *split31View = [[UIView alloc] initWithFrame:CGRectZero];
    split31View.backgroundColor = COLOR_LINE;
    [sumaryView addSubview:split31View];
    [split31View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Margin_Left));
        make.right.equalTo(sumaryView.mas_right);
        make.height.equalTo(@(Line_Height));
        make.top.equalTo(split21View.mas_top).offset(Button_Height);
    }];
    
    UIView *split41View = [[UIView alloc] initWithFrame:CGRectZero];
    split41View.backgroundColor = COLOR_LINE;
    [sumaryView addSubview:split41View];
    [split41View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Margin_Left));
        make.right.equalTo(sumaryView.mas_right);
        make.height.equalTo(@(Line_Height));
        make.top.equalTo(split31View.mas_top).offset(Button_Height);
    }];

    UILabel *principalLab = [[UILabel alloc] init];
    principalLab.font = TEXT_FONT_14;
    principalLab.textColor = COLOR_AUXILIARY_GREY;
    principalLab.text = @"赎回本金(元)";
    [sumaryView addSubview:principalLab];

    [principalLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(sumaryView.mas_top).offset(Margin_Top);
        make.bottom.equalTo(split21View.mas_top).offset(-Margin_Bottom);
        make.left.equalTo(split21View.mas_left);
    }];

    UILabel *principalAmountLab = [[UILabel alloc] init];
    principalAmountLab.font = TEXT_FONT_14;
    principalAmountLab.textColor = COLOR_TITLE_GREY;
    principalAmountLab.tag = 500;

    principalAmountLab.text = @"2000.00";
    [sumaryView addSubview:principalAmountLab];

    [principalAmountLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(sumaryView.mas_top).offset(Margin_Top);
        make.bottom.equalTo(split21View.mas_top).offset(-Margin_Bottom);
        make.right.equalTo(split21View.mas_right).offset(-Margin_Right);
    }];

    UILabel *interestLab = [[UILabel alloc] init];
    interestLab.font = TEXT_FONT_14;
    interestLab.textColor = COLOR_AUXILIARY_GREY;
    interestLab.text = @"利息+加息(元)";
    [sumaryView addSubview:interestLab];

    [interestLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(split21View.mas_top).offset(Margin_Top);
        make.bottom.equalTo(split31View.mas_top).offset(-Margin_Bottom);
        make.left.equalTo(split21View.mas_left);
    }];

    UILabel *interestAmountLab = [[UILabel alloc] init];
    interestAmountLab.font = TEXT_FONT_14;
    interestAmountLab.textColor = COLOR_TITLE_GREY;
    interestAmountLab.tag = 501;
    //    NSString *interestAmountStr = [Utility
    //                                   replaceTheNumberForNSNumberFormatter:
    //                                   [NSString stringWithFormat:@"%.2f", redemptionInfo.interests]];
    interestAmountLab.text = @"28.60";
    [sumaryView addSubview:interestAmountLab];

    [interestAmountLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(split21View.mas_top).offset(Margin_Top);
        make.bottom.equalTo(split31View.mas_top).offset(-Margin_Bottom);
        make.right.equalTo(split21View.mas_right).offset(-Margin_Right);
    }];

    UILabel *handlingChargeLab = [[UILabel alloc] init];
    handlingChargeLab.font = TEXT_FONT_14;
    handlingChargeLab.textColor = COLOR_AUXILIARY_GREY;
    handlingChargeLab.text = @"提前赎回手续费(元)";
    [sumaryView addSubview:handlingChargeLab];

    [handlingChargeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(split31View.mas_top).offset(Margin_Top);
        make.bottom.equalTo(split41View.mas_bottom).offset(-Margin_Bottom);
        make.left.equalTo(split31View.mas_left);
    }];

    UILabel *handlingChargeAmountLab = [[UILabel alloc] init];
    handlingChargeAmountLab.font = TEXT_FONT_14;
    handlingChargeAmountLab.textColor = COLOR_TITLE_GREY;
    //    NSString *handlingChargeStr = [Utility
    //                                   replaceTheNumberForNSNumberFormatter:[NSString
    //                                                                         stringWithFormat:@"%.2f",
    //                                                                         redemptionInfo
    //                                                                         .fee]];
    handlingChargeAmountLab.tag = 502;
    handlingChargeAmountLab.text = @"-1.00";
    [sumaryView addSubview:handlingChargeAmountLab];

    [handlingChargeAmountLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(split31View.mas_top).offset(Margin_Top);
        make.bottom.equalTo(split41View.mas_bottom).offset(-Margin_Bottom);
        make.right.equalTo(split31View.mas_right).offset(-Margin_Right);
    }];
    
    UILabel *payAmountTitle = [[UILabel alloc] initWithFrame:CGRectZero];
    payAmountTitle.textColor = COLOR_AUXILIARY_GREY;
    payAmountTitle.font = TEXT_FONT_14;
    payAmountTitle.text = @"预计到账金额(元)";
    [sumaryView addSubview:payAmountTitle];
    
    [payAmountTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(split41View.mas_top).offset(Margin_Top);
        make.bottom.equalTo(sumaryView.mas_bottom).offset(-Margin_Bottom);
        make.left.equalTo(split41View.mas_left);
    }];
    
    UILabel *payLab = [[UILabel alloc] initWithFrame:CGRectZero];
    payLab.font = TEXT_FONT_14;
    payLab.textColor = COLOR_TITLE_GREY;
    payLab.text = @"0.00";
    payLab.tag = 504;
    [sumaryView addSubview:payLab];
    
    [payLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(split41View.mas_top).offset(Margin_Top);
        make.bottom.equalTo(sumaryView.mas_bottom).offset(-Margin_Bottom);
        make.right.equalTo(split41View.mas_right).offset(-Margin_Right);
    }];

    UILabel *arriveAccountTimeLab = [[UILabel alloc] init];
    arriveAccountTimeLab.font = TEXT_FONT_12;
    arriveAccountTimeLab.textColor = COLOR_AUXILIARY_GREY;
    arriveAccountTimeLab.text = @"预计到账日期:";
    [self.view addSubview:arriveAccountTimeLab];

    [arriveAccountTimeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(sumaryView.mas_bottom).offset(Text_Margin_Arrow);
        make.left.equalTo(split31View.mas_left);
    }];

    UILabel *arriveAccountTimeDateLab = [[UILabel alloc] init];
    arriveAccountTimeDateLab.font = TEXT_FONT_12;
    arriveAccountTimeDateLab.textColor = COLOR_TITLE_GREY;
    arriveAccountTimeDateLab.text = @"2016-06-28";
    arriveAccountTimeDateLab.tag = 503;
    [self.view addSubview:arriveAccountTimeDateLab];

    [arriveAccountTimeDateLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(sumaryView.mas_bottom).offset(Text_Margin_Arrow);
        make.left.equalTo(arriveAccountTimeLab.mas_right).offset(2);
    }];

    UILabel * tipsLab = [[UILabel alloc] init];
    tipsLab.font = TEXT_FONT_12;
    tipsLab.textColor = COLOR_TITLE_GREY;
    tipsLab.tag  = 505;
    tipsLab.text = [NSString stringWithFormat:XYBString(@"str_Dqb_tipsSyDay", @"出借产品剩%@天到期，提前赎回收取手续费"),@"156"];
    [self.view addSubview:tipsLab];
    [tipsLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(sumaryView.mas_bottom).offset(55);
        make.centerX.equalTo(sumaryView.mas_centerX);
    }];
    

    ColorButton *nextBtn = [[ColorButton alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth - 30, Cell_Height) Title:XYBString(@"str_sure_invested_immidiate", @"确认赎回")  ByGradientType:leftToRight];
    nextBtn.layer.masksToBounds = YES;
    [nextBtn addTarget:self action:@selector(clickTheRedeemButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextBtn];
    
    [nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Margin_Left));
        make.right.equalTo(@(-Margin_Right));
        make.height.equalTo(@(Cell_Height));
        make.top.equalTo(sumaryView.mas_bottom).offset(83.f);
        make.width.equalTo(@(MainScreenWidth - 30));
    }];
}

/**
 *  确认赎回
 *
 *  @param sender
 */
- (void)clickTheRedeemButton:(id)sender {
    [self payTheTouIDFinancing];
}

- (void)initNav {
    self.navigationItem.title = XYBString(@"str_Dqb_back", @"定期宝赎回");
    ;
    self.view.backgroundColor = COLOR_BG;

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(clickBackBtn:)];

    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpacer.width = -12; //这个数值可以根据情况自由变化

    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0.0f, 0.0f, 80.0f, 40.0f);
    [button setTitle:XYBString(@"str_dqb_back_rule", @"赎回规则") forState:UIControlStateNormal];
    button.titleLabel.font = TEXT_FONT_14;
    [button addTarget:self action:@selector(clickRightBtn:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    negativeSpacer.width = -12; //这个数值可以根据情况自由变化

    self.navigationItem.rightBarButtonItems = @[ negativeSpacer, rightButtonItem ];
}

- (void)clickBackBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 *  定期宝赎回规则
 */
- (void)clickRightBtn:(id)sender {
    NSString *urlStr = [RequestURL getNodeJsH5URL:App_Redemption_Explain_URL withIsSign:NO];
    NSString *titleStr = XYBString(@"string_dqb_back_rule", @"定期宝赎回规则");
    WebviewViewController *webView = [[WebviewViewController alloc] initWithTitle:titleStr webUrlString:urlStr];
    [self.navigationController pushViewController:webView animated:YES];
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
                                    if (self.strOrderId) {
                                        [param setObject:[NSNumber numberWithInteger:[self.strOrderId integerValue]] forKey:@"orderId"];
                                    }
                                    if (sigPassWord) {
                                        [param setObject:sigPassWord forKey:@"tradePassword"];
                                    }
                                    [param setObject:[OpenUDID value] forKey:@"deviceId"];
                                    [param setObject:[DateTimeUtil getCurrentTime] forKey:@"timestamp"];
                                    [param setObject:@"1" forKey:@"paymentMode"];
                                    [self commitInvestedDqbBackRequestWebServiceWithParam:param];

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
    __weak DqbRebackVc *weakSelf = self;
    NSString *orderId = self.strOrderId;
    tradePayView.clickSureButton = ^(NSString *payStr) {
        NSDictionary *param = @{ @"userId" : [UserDefaultsUtil getUser].userId,                    //用户ID
                                 @"orderId" : [NSNumber numberWithInteger:[orderId integerValue]], //订单ID
                                 @"tradePassword" : payStr
        };
        [weakSelf commitInvestedDqbBackRequestWebServiceWithParam:param];
    };

    tradePayView.clickForgetButton = ^{
        if (![user.isIdentityAuth boolValue]) {
            //            UserDetailRealNamesViewController   *realNameVC  = [[UserDetailRealNamesViewController alloc] init];
            //            [weakSelf.navigationController pushViewController:realNameVC animated:YES];

            ChargeViewController *chargeViewController = [[ChargeViewController alloc] init];
            chargeViewController.hidesBottomBarWhenPushed = YES;
            [weakSelf.navigationController pushViewController:chargeViewController animated:YES];

            return;
        }
        ChangePayPasswordViewController *payPassWordVC = [[ChangePayPasswordViewController alloc] init];
        [weakSelf.navigationController pushViewController:payPassWordVC animated:YES];
    };
}

//确认定期宝赎回
- (void)commitInvestedDqbBackRequestWebServiceWithParam:(NSDictionary *)params {

    [self showTradeLoadingOnAlertView];

    NSString *urlPath = [RequestURL getRequestURL:DqbMyinvestDoRedemptionURL param:params];
    [WebService postRequest:urlPath param:params JSONModelClass:[BbgRedeemModel class]
        Success:^(AFHTTPRequestOperation *operation, id responseObject) {
            BbgRedeemModel  * dqbRedeem = responseObject;
            [self hideLoading];
            [tradePayView removeFromSuperview];
            if (dqbRedeem.resultCode == 1) {
                XYAlertView *alertView = [self.view viewWithTag:1111];
                [alertView removeFromSuperview]; //赎回成功之后，删除弹出框
                NSDictionary *resultDic = dqbRedeem.toDictionary;
                NSString *refundDate = [resultDic objectForKey:@"refundDate"];
                if (refundDate == nil) {
                    refundDate = @"";
                }
                
                NSString *rebackAmount = nil;
                if ([resultDic objectForKey:@"rebackAmount"] == nil) {
                    rebackAmount = @"0";
                } else {
                    rebackAmount = [Utility replaceTheNumberForNSNumberFormatter:[NSString stringWithFormat:@"%.2f", [[resultDic objectForKey:@"rebackAmount"] floatValue]]];
                }
                
                NSString *currentTime = [resultDic objectForKey:@"currentTime"];
                if (currentTime == nil) {
                    currentTime = @"";
                }
                
                //                NSString *title1 = [NSString stringWithFormat:XYBString(@"str_success_back_some", @"成功申请赎回%@元"), self.moneyTextField.text];
                //                NSString *subTitle2 = [NSString stringWithFormat:XYBString(@"str_expect_in_account_some", @"预计到账%@元"), rebackAmount];
                
                NSRange range = NSMakeRange(5,5);
                NSString* currentFormtTime = [currentTime substringWithRange:range];
                
                NSString* refundFormtTime = [refundDate substringWithRange:range];
                
                DqbRebackSuccessViewController * dqbReback = [[DqbRebackSuccessViewController alloc] init];
                dqbReback.applyDate = currentFormtTime;
                dqbReback.moneyStr = [NSString stringWithFormat:@"%@",self.dqbRedeemQuery.amount];
                dqbReback.estimateDate = refundFormtTime;
                dqbReback.estimateMoney = rebackAmount;
                [self.navigationController pushViewController:dqbReback animated:YES];

            }
        }
        fail:^(AFHTTPRequestOperation *operation, NSString *errorMessage) {
            [self hideLoading];
            if ([params objectForKey:@"paymentMode"]) {

                [HUD showPromptViewWithToShowStr:errorMessage autoHide:YES afterDelay:1.0 userInteractionEnabled:YES];
            } else {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"ERRORNOTIFICATION" object:errorMessage];
            }

        }];
}

//查询定期宝赎回数据
- (void)searchInvestedDqbBack {

    UILabel *labelamount = (UILabel *) [self.view viewWithTag:500];
    UILabel *labelinterests = (UILabel *) [self.view viewWithTag:501];
    UILabel *labelfee = (UILabel *) [self.view viewWithTag:502];
    UILabel *labelarrivalDate = (UILabel *) [self.view viewWithTag:503];
    UILabel *labelarrivalAmount = (UILabel *) [self.view viewWithTag:504];
    UILabel *labelSyDay = (UILabel *)[self.view viewWithTag:505];
    NSDictionary *param = @{ @"userId" : [UserDefaultsUtil getUser].userId,                            //用户ID
                             @"orderId" : [NSNumber numberWithInteger:[self.strOrderId integerValue]], //订单ID
    };

    [self showDataLoading];

    NSString *urlPath = [RequestURL getRequestURL:DqbMyinvestRedemptionInfoURL param:param];
    [WebService postRequest:urlPath param:param JSONModelClass:[DqbRedeemQueryModel class]
        Success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [self hideLoading];
            DqbRedeemQueryModel *dqbRedeemQuery = responseObject;
            self.dqbRedeemQuery = dqbRedeemQuery;
            if (dqbRedeemQuery.resultCode == 1) {
                labelamount.text = [Utility
                    replaceTheNumberForNSNumberFormatter:[NSString
                                                             stringWithFormat:@"%.2f",
                                                                              [dqbRedeemQuery.amount doubleValue]]];
                if (![StrUtil isEmptyString:dqbRedeemQuery.addInterest]) {
                    NSString *strInterests = [Utility
                        replaceTheNumberForNSNumberFormatter:[NSString
                                                                 stringWithFormat:@"%.2f",
                                                                                  [dqbRedeemQuery.interests doubleValue]]];
                    NSString *addInterest = [Utility
                        replaceTheNumberForNSNumberFormatter:[NSString
                                                                 stringWithFormat:@"%.2f",
                                                                                  [dqbRedeemQuery.addInterest doubleValue]]];
                    labelinterests.text = [NSString stringWithFormat:@"%@+%@(加息)", strInterests, addInterest];

                } else {
                    labelinterests.text = [Utility
                        replaceTheNumberForNSNumberFormatter:[NSString
                                                                 stringWithFormat:@"%.2f",
                                                                                  [dqbRedeemQuery.interests doubleValue]]];
                }
                labelfee.text = [Utility
                    replaceTheNumberForNSNumberFormatter:[NSString
                                                             stringWithFormat:@"%.2f",
                                                                              [dqbRedeemQuery.fee doubleValue]]];
                labelarrivalDate.text = dqbRedeemQuery.arrivalDate;
                
                labelarrivalAmount.text = [Utility
                    replaceTheNumberForNSNumberFormatter:[NSString
                                                             stringWithFormat:@"%.2f",
                                                                              [dqbRedeemQuery.arrivalAmount doubleValue]]];
                if (![StrUtil isEmptyString:dqbRedeemQuery.restDay]) {
                    labelSyDay.text = [NSString stringWithFormat:XYBString(@"str_Dqb_tipsSyDay", @"出借产品剩%@天到期，提前赎回收取手续费"),dqbRedeemQuery.restDay];
                }
          
            }
        }
        fail:^(AFHTTPRequestOperation *operation, NSString *errorMessage) {
            [self hideLoading];
            [self showPromptTip:errorMessage];
        }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
