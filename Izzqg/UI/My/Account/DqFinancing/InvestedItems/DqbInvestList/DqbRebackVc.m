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

@interface DqbRebackVc () {
    TradePasswordView *tradePayView;
 }

@property(nonatomic,strong) DqbRedeemQueryModel * dqbRedeemQuery;

@end

@implementation DqbRebackVc

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNav];
    [self initScrollView];
    [self searchInvestedDqbBack];
}


- (void)initNav {
    self.navItem.title = XYBString(@"str_Dqb_back", @"定期宝赎回");
    ;
    self.view.backgroundColor = COLOR_BG;
    
    self.navItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(clickBackBtn:)];
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpacer.width = -12; //这个数值可以根据情况自由变化
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0.0f, 0.0f, 80.0f, 40.0f);
    [button setTitle:XYBString(@"str_dqb_back_rule", @"赎回规则") forState:UIControlStateNormal];
    button.titleLabel.font = TEXT_FONT_14;
    [button addTarget:self action:@selector(clickRightBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.navBar addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.navBar);
        make.right.equalTo(@(-Margin_Right));
    }];
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
    [scrollView addSubview:sumaryView];
    sumaryView.backgroundColor = COLOR_COMMON_WHITE;
    sumaryView.layer.cornerRadius = Corner_Radius;
    [sumaryView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Margin_Left));
        make.right.equalTo(@(-Margin_Right));
        make.top.equalTo(self.navBar.mas_bottom).offset(Margin_Top);
        make.height.equalTo(@265);
        make.width.equalTo(@(MainScreenWidth - 30));

    }];

    UILabel *principalLab = [[UILabel alloc] init];
    principalLab.font = SMALL_TEXT_FONT_13;
    principalLab.textColor = COLOR_AUXILIARY_GREY;
    principalLab.text = @"赎回本金(元)";
    [sumaryView addSubview:principalLab];

    [principalLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(sumaryView.mas_top).offset(24);
        make.centerX.equalTo(sumaryView.mas_centerX);
    }];

    UILabel *principalAmountLab = [[UILabel alloc] init];
    principalAmountLab.font = XTB_RATE_FONT;
    principalAmountLab.textColor = COLOR_TITLE_GREY;
    principalAmountLab.tag = 500;

    principalAmountLab.text = @"2000.00";
    [sumaryView addSubview:principalAmountLab];

    [principalAmountLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(principalLab.mas_bottom).offset(10);
        make.centerX.equalTo(sumaryView.mas_centerX);
    }];
    
    UIView *split21View = [[UIView alloc] initWithFrame:CGRectZero];
    split21View.backgroundColor = COLOR_LINE;
    [sumaryView addSubview:split21View];
    [split21View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Margin_Left));
        make.right.equalTo(@(-Margin_Right));
        make.height.equalTo(@(Line_Height));
        make.top.equalTo(sumaryView.mas_top).offset(90);
    }];
    
    UIView *split31View = [[UIView alloc] initWithFrame:CGRectZero];
    split31View.backgroundColor = COLOR_LINE;
    [sumaryView addSubview:split31View];
    [split31View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Margin_Left));
        make.right.equalTo(@(-Margin_Right));
        make.height.equalTo(@(Line_Height));
        make.bottom.equalTo(sumaryView.mas_bottom).offset(-76);
    }];

    UILabel *interestLxLab = [[UILabel alloc] init];
    interestLxLab.font = SMALL_TEXT_FONT_13;
    interestLxLab.textColor = COLOR_AUXILIARY_GREY;
    interestLxLab.text = @"利息(元)";
    [sumaryView addSubview:interestLxLab];

    [interestLxLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(split21View.mas_bottom).offset(18);
        make.left.equalTo(split21View.mas_left);
    }];

    UILabel *interestLxAmountLab = [[UILabel alloc] init];
    interestLxAmountLab.font = SMALL_TEXT_FONT_13;
    interestLxAmountLab.textColor = COLOR_TITLE_GREY;
    interestLxAmountLab.tag = 501;
    interestLxAmountLab.text = @"28.60";
    [sumaryView addSubview:interestLxAmountLab];

    [interestLxAmountLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(interestLxLab.mas_centerY);
        make.right.equalTo(split21View.mas_right);
    }];
    
    UILabel *tipJxLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    tipJxLabel.text = @"加息(元)";
    tipJxLabel.font = SMALL_TEXT_FONT_13;
    tipJxLabel.textColor = COLOR_AUXILIARY_GREY;
    [sumaryView addSubview:tipJxLabel];
    [tipJxLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(interestLxLab.mas_bottom).offset(7);
        make.left.equalTo(interestLxLab.mas_left);
    }];
    
    UILabel *jxLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [sumaryView addSubview:jxLabel];
    jxLabel.text = XYBString(@"str_common_zero_yuan", @"0.00元");
    jxLabel.tag = 5001;
    jxLabel.font = SMALL_TEXT_FONT_13;
    jxLabel.textColor = COLOR_MAIN_GREY;
    [sumaryView addSubview:jxLabel];
    [jxLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(tipJxLabel.mas_centerY);
        make.right.equalTo(split21View.mas_right);
    }];

    

    UILabel *handlingChargeLab = [[UILabel alloc] init];
    handlingChargeLab.font = SMALL_TEXT_FONT_13;
    handlingChargeLab.textColor = COLOR_AUXILIARY_GREY;
    handlingChargeLab.text = @"提前赎回手续费(元)";
    [sumaryView addSubview:handlingChargeLab];

    [handlingChargeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(split31View.mas_bottom).offset(-17);
        make.left.equalTo(split31View.mas_left);
    }];

    UILabel *handlingChargeAmountLab = [[UILabel alloc] init];
    handlingChargeAmountLab.font = SMALL_TEXT_FONT_13;
    handlingChargeAmountLab.textColor = COLOR_INTRODUCE_RED;
    handlingChargeAmountLab.tag = 502;
    handlingChargeAmountLab.text = @"-1.00";
    [sumaryView addSubview:handlingChargeAmountLab];

    [handlingChargeAmountLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(handlingChargeLab.mas_centerY);
        make.right.equalTo(split31View.mas_right);
    }];
    
    
    UILabel *arriveAccountTimeLab = [[UILabel alloc] init];
    arriveAccountTimeLab.font = SMALL_TEXT_FONT_13;
    arriveAccountTimeLab.textColor = COLOR_AUXILIARY_GREY;
    arriveAccountTimeLab.text = @"预计到账时间";
    [self.view addSubview:arriveAccountTimeLab];
    
    [arriveAccountTimeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(split31View.mas_bottom).offset(Margin_Top);
        make.left.equalTo(split31View.mas_left);
    }];
    
    UILabel *arriveAccountTimeDateLab = [[UILabel alloc] init];
    arriveAccountTimeDateLab.font = SMALL_TEXT_FONT_13;
    arriveAccountTimeDateLab.textColor = COLOR_TITLE_GREY;
    arriveAccountTimeDateLab.text = @"2016-06-28";
    arriveAccountTimeDateLab.tag = 503;
    [self.view addSubview:arriveAccountTimeDateLab];
    
    [arriveAccountTimeDateLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(arriveAccountTimeLab.mas_centerY);
        make.right.equalTo(split31View.mas_right);
    }];
    
    
    UILabel *payAmountTitle = [[UILabel alloc] initWithFrame:CGRectZero];
    payAmountTitle.textColor = COLOR_AUXILIARY_GREY;
    payAmountTitle.font = SMALL_TEXT_FONT_13;
    payAmountTitle.text = @"预计到账金额";
    [sumaryView addSubview:payAmountTitle];
    
    [payAmountTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(sumaryView.mas_bottom).offset(-25);
        make.left.equalTo(split31View.mas_left);
    }];
    
    UILabel *payLab = [[UILabel alloc] initWithFrame:CGRectZero];
    payLab.font = SMALL_TEXT_FONT_13;
    payLab.textColor = COLOR_XTB_ORANGE;
    payLab.text = @"0.00";
    payLab.tag = 504;
    [sumaryView addSubview:payLab];
    
    [payLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(payAmountTitle.mas_centerY);
        make.right.equalTo(split31View.mas_right);
    }];

 
    UIImageView *image_Info = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_info_gray"]];
    [self.view addSubview:image_Info];
    [image_Info mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@Margin_Length);
//        make.width.height.equalTo(@(13));
        make.top.equalTo(sumaryView.mas_bottom).offset(Margin_Top);
    }];

    UILabel * tipsLab = [[UILabel alloc] init];
    tipsLab.font = SMALL_TEXT_FONT_13;
    tipsLab.textColor = COLOR_INTRODUCE_RED;
    tipsLab.tag  = 505;
    tipsLab.text = [NSString stringWithFormat:XYBString(@"str_Dqb_tipsSyDay", @"出借产品剩%@天到期，提前赎回收取手续费"),self.syDay];
    [self.view addSubview:tipsLab];
    [tipsLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(image_Info.mas_right).offset(6);
        make.centerY.equalTo(image_Info.mas_centerY);
    }];
    

    ColorButton *nextBtn = [[ColorButton alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth - 30, Cell_Height) Title:XYBString(@"str_sure_invested_immidiate", @"确认赎回")  ByGradientType:leftToRight];
    nextBtn.layer.masksToBounds = YES;
    [nextBtn addTarget:self action:@selector(clickTheRedeemButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextBtn];
    
    [nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Margin_Left));
        make.right.equalTo(@(-Margin_Right));
        make.height.equalTo(@(Cell_Height));
        make.top.equalTo(image_Info.mas_bottom).offset(Margin_Top);
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
            ChargeViewController *chargeViewController = [[ChargeViewController alloc] initWithIdetifer:NO];
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
                    rebackAmount = @"0.00";
                } else {
                    rebackAmount = [Utility replaceTheNumberForNSNumberFormatter:[NSString stringWithFormat:@"%.2f", [[resultDic objectForKey:@"rebackAmount"] doubleValue]]];
                }
                
                NSString *currentTime = [resultDic objectForKey:@"currentTime"];
                if (currentTime == nil) {
                    currentTime = @"";
                }
        
                
                DqbRebackSuccessViewController * dqbReback = [[DqbRebackSuccessViewController alloc] init];
                dqbReback.applyDate = currentTime;
                dqbReback.moneyStr = [NSString stringWithFormat:@"%@",self.dqbRedeemQuery.amount];
                dqbReback.estimateDate = refundDate;
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
    UILabel *labelxlinterests = (UILabel *) [self.view viewWithTag:501];
    UILabel *labelJxinterests = (UILabel *) [self.view viewWithTag:5001];
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
                NSString *addInterest;
                if ([dqbRedeemQuery.addInterest doubleValue] > 0) {
               
                    addInterest = [Utility
                                   replaceTheNumberForNSNumberFormatter:[NSString
                                                                         stringWithFormat:@"%.2f",
                                                                         [dqbRedeemQuery.addInterest doubleValue]]];
                }else
                {
                    addInterest = @"0.00";
                }
                NSString *strInterests = [Utility
                                          replaceTheNumberForNSNumberFormatter:[NSString
                                                                                stringWithFormat:@"%.2f",
                                                                                [dqbRedeemQuery.interests doubleValue]]];
                labelxlinterests.text = [NSString stringWithFormat:@"+%@", strInterests];
                labelJxinterests.text = [NSString stringWithFormat:@"+%@", addInterest];
                labelfee.text = [NSString stringWithFormat:@"-%@",[Utility
                                                                   replaceTheNumberForNSNumberFormatter:[NSString
                                                                                                         stringWithFormat:@"%.2f",
                                                                                                         [dqbRedeemQuery.fee doubleValue]]]];
                labelarrivalDate.text = dqbRedeemQuery.arrivalDate;
                
                labelarrivalAmount.text = [NSString stringWithFormat:@"%@元",[Utility
                                                                             replaceTheNumberForNSNumberFormatter:[NSString
                                                                                                                   stringWithFormat:@"%.2f",
                                                                                                                   [dqbRedeemQuery.arrivalAmount doubleValue]]]];
                if (![StrUtil isEmptyString:self.syDay]) {
                    labelSyDay.text = [NSString stringWithFormat:XYBString(@"str_Dqb_tipsSyDay", @"出借产品剩%@天到期，提前赎回收取手续费"),self.syDay];
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
