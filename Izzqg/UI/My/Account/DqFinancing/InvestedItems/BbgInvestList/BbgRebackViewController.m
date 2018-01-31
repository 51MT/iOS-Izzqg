//
//  BbgRebackViewController.m
//  Ixyb
//
//  Created by dengjian on 12/14/15.
//  Copyright © 2015 xyb. All rights reserved.
//
#import "BbgRebackViewController.h"
#import "BbgRedeemModel.h"
#import "BbgRedeemQueryModel.h"
#import "ChangePayPasswordViewController.h"
#import "ChargeViewController.h"
#import "DMInvestedProjectBbg.h"
#import "InvestedDetailBbgViewController.h"
#import "StatusViewController.h"
#import "TradePasswordView.h"
#import "BbgRebackSuccessViewController.h"
#import "UserDetailRealNamesViewController.h"
#import "Utility.h"
#import "WebService.h"
#import "WebviewViewController.h"

#define VIEW_TAG_TIP1VALUE_LABEL 101001
#define VIEW_TAG_TIP2VALUE_LABEL 101002
#define VIEW_TAG_REBACK          101003

@interface BbgRebackViewController () {
    TradePasswordView *tradePayView;
}
@property (nonatomic, strong) XYTextField *moneyTextField;
@end

@implementation BbgRebackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initUI];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(chargeSuccess) name:@"chargeSuccessNotification" object:nil];
}

- (void)chargeSuccess {
    [self showPromptTip:XYBString(@"str_recharge_success", @"充值成功")];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)initUI {
    self.navItem.title = XYBString(@"str_bbg_back", @"步步高本金赎回");
    self.navItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(clickBackBtn:)];

    self.view.backgroundColor = COLOR_BG;
    
    CGFloat restAmount = [[self.dic objectForKey:@"restAmount"] floatValue];
    NSString *canInvestAmountStr = [Utility replaceTheNumberForNSNumberFormatter:[NSString stringWithFormat:@"%.2f", restAmount]];
    UILabel *tip1Label = [[UILabel alloc] initWithFrame:CGRectZero];
    tip1Label.textColor = COLOR_CHU_ORANGE;
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:XYBString(@"str_bbg_back_remain_some", @"可赎回本金: %@元"), canInvestAmountStr]];
    [attributedStr addAttribute:NSForegroundColorAttributeName value:COLOR_MAIN_GREY range:NSMakeRange(0, 6)];
    
    tip1Label.attributedText = attributedStr;
    tip1Label.font = SMALL_TEXT_FONT_13;
    [self.view addSubview:tip1Label];
    [tip1Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navBar.mas_bottom).offset(21);
        make.left.equalTo(@(Margin_Left));
    }];
    
    
    UIButton *allInvestBtn = [[UIButton alloc] initWithFrame:CGRectZero];
    [allInvestBtn setTitle:XYBString(@"str_all", @"全部赎回") forState:UIControlStateNormal];
    [allInvestBtn setTitleColor:COLOR_MAIN forState:UIControlStateNormal];
    allInvestBtn.titleLabel.font = TEXT_FONT_14;
    [allInvestBtn addTarget:self action:@selector(clickTheAllInvestBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:allInvestBtn];
    
    [allInvestBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(tip1Label.mas_centerY);
        make.right.equalTo(@(-Margin_Length));
    }];
    
    
    UIView * bttomView = [[UIView alloc] init];
    bttomView.backgroundColor = COLOR_COMMON_WHITE;
    [self.view addSubview:bttomView];
    [bttomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tip1Label.mas_bottom).offset(10);
        make.left.right.equalTo(self.view);
        make.height.equalTo(@(56));
    }];
    
    [XYCellLine initWithTopLineAtSuperView:bttomView];
    [XYCellLine initWithBottomLineAtSuperView:bttomView];
    
    UIImageView * moneyImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    moneyImageView.image = [UIImage imageNamed:@"bbgmoney"];
    moneyImageView.userInteractionEnabled = YES;
    [bttomView addSubview:moneyImageView];
    
    [moneyImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Margin_Left));
        make.centerY.equalTo(bttomView.mas_centerY);
    }];
    
    self.moneyTextField = [[XYTextField alloc] initWithIsEnabledNoPaste:YES];
    self.moneyTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.moneyTextField.placeholder = @"100元起";
    self.moneyTextField.font = TEXT_FONT_14;
    self.moneyTextField.keyboardType = UIKeyboardTypeNumberPad;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doInputAction) name:UITextFieldTextDidChangeNotification object:self.moneyTextField];
    [bttomView addSubview:self.moneyTextField];

    [self.moneyTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(moneyImageView.mas_right).offset(10);
        make.width.equalTo(@(MainScreenWidth-moneyImageView.frame.size.width - 30));
        make.centerY.equalTo(bttomView.mas_centerY);
    }];
    
    
    UILabel *tip2Label = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.view addSubview:tip2Label];
    tip2Label.text = [NSString stringWithFormat:XYBString(@"str_to_account_date", @"预计到账日期:%@"),[self.dic objectForKey:@"refundDate"]];
    tip2Label.textColor = COLOR_AUXILIARY_GREY;
    tip2Label.tag = VIEW_TAG_TIP2VALUE_LABEL;
    tip2Label.font = TEXT_FONT_12;
    [tip2Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@Margin_Length);
        make.top.equalTo(bttomView.mas_bottom).offset(12);
    }];
    
    ColorButton * rebackButton =[[ColorButton alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth - 30, Cell_Height) Title:XYBString(@"str_be_sure_back", @"确认赎回")  ByGradientType:leftToRight];
    rebackButton.isColorEnabled = NO;
    rebackButton.tag = VIEW_TAG_REBACK;
    [rebackButton addTarget:self action:@selector(clickRebackButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:rebackButton];
    
    [rebackButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Margin_Left));
        make.right.equalTo(@(-Margin_Right));
        make.height.equalTo(@(Cell_Height));
        make.top.equalTo(tip2Label.mas_bottom).offset(19);
    }];
    
    UILabel *noteLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    noteLabel.textColor = COLOR_LEND_STATE_GRAY;
    noteLabel.text = XYBString(@"str_financing_withAgree", @"点击“确认赎回”，即表示阅读并同意");
    noteLabel.font = [UIFont systemFontOfSize:12.0f];
    [self.view addSubview:noteLabel];

    [noteLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(rebackButton.mas_bottom).offset(10);
        make.left.equalTo(@Margin_Length);
    }];

    UIButton *agreementButton = [UIButton buttonWithType:UIButtonTypeSystem];
    agreementButton.titleLabel.font = [UIFont systemFontOfSize:12.f];
    [agreementButton setTitle:XYBString(@"str_bbg_agreement", @"《步步高服务协议》") forState:UIControlStateNormal];
    [agreementButton setTitleColor:COLOR_MAIN forState:UIControlStateNormal];
    [agreementButton addTarget:self action:@selector(clickTheAgreementButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:agreementButton];

    [agreementButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(noteLabel.mas_right).offset(2);
        make.centerY.equalTo(noteLabel.mas_centerY);
        make.height.equalTo(@20);
    }];
    
}


- (void)doReback:(NSString *)tradePassword {
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithCapacity:10];
    if ([UserDefaultsUtil getUser].userId) {
        [param setObject:[UserDefaultsUtil getUser].userId forKey:@"userId"];
    }
    if ([self.dic objectForKey:@"orderId"]) {
        [param setObject:[self.dic objectForKey:@"orderId"] forKey:@"orderId"];
    }
    if (self.moneyTextField.text) {
        [param setObject:self.moneyTextField.text forKey:@"amount"];
    }
    if (tradePassword) {
        [param setObject:tradePassword forKey:@"tradePassword"];
    }
    [self BbgRebackWeb:param];
}
- (void)BbgRebackWeb:(NSDictionary *)dic {
    __weak BbgRebackViewController *weakSelf = self;

    [self showTradeLoadingOnAlertView];
    NSString *urlPath = [RequestURL getRequestURL:BbgInvestRebackURL param:dic];
    [WebService postRequest:urlPath param:dic JSONModelClass:[BbgRedeemModel class]
        Success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [self hideLoading];
            [tradePayView removeFromSuperview];
            User *user = [UserDefaultsUtil getUser];
            if (![user.isTradePassword boolValue]) {
                user.isTradePassword = @"1";
            }
            [UserDefaultsUtil setUser:user];

            BbgRedeemModel *dqbOrXtb = responseObject;
            NSDictionary *resultDic = dqbOrXtb.toDictionary;
            if (dqbOrXtb.resultCode == 1) {
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
                
                
                BbgRebackSuccessViewController * bbgReback = [[BbgRebackSuccessViewController alloc] init];
                bbgReback.applyDate = currentTime;
                bbgReback.moneyStr = [NSString stringWithFormat:@"%@",self.moneyTextField.text];
                bbgReback.estimateDate = refundDate;
                bbgReback.estimateMoney = rebackAmount;
                [weakSelf.navigationController pushViewController:bbgReback animated:YES];
                
//                StatusViewController *statusViewController = [[StatusViewController alloc] init];
//                statusViewController.navigationItem.title = XYBString(@"str_apply_back_success", @"赎回申请成功");
//                statusViewController.dataArray = @[ @{
//                                                       @"iconName" : @"green_click",
//                                                       @"title" : title1,
//                                                       @"subTitle" : currentTime,
//                                                       @"isDone" : @YES,
//                                                   },
//                                                    @{
//                                                        @"iconName" : @"income_end",
//                                                        @"title" : subTitle2,
//                                                        @"subTitle" : refundDate,
//                                                        @"isDone" : @NO,
//                                                    } ];
//
//                for (UIViewController *controller in self.navigationController.viewControllers) {
//                    if ([controller isKindOfClass:[InvestedDetailBbgViewController class]]) {
//                        [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadDataInvestedDetail" object:nil userInfo:nil];
//                        statusViewController.backVC = controller;
//                        statusViewController.gotoVC = controller;
//                        break;
//                    }
//                }

                //            for (UIViewController * controller in self.navigationController.viewControllers) {
                //                if ([controller isKindOfClass:[InvestedItemsViewController class]]) {
                //                    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadDataInvestedDetail" object:nil userInfo:nil];
                //                    statusViewController.gotoVC = controller;
                //                    break;
                //                }
                //            }
                //修改部分 隐藏确定按钮
//                statusViewController.nextTitleStr = XYBString(@"str_ok", @"确定");
//                [weakSelf.navigationController pushViewController:statusViewController animated:YES];
            }
        }
        fail:^(AFHTTPRequestOperation *operation, NSString *errorMessage) {
            [self hideLoading];
            if ([dic objectForKey:@"paymentMode"]) {

                [self showPromptTip:errorMessage];
            } else {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"ERRORNOTIFICATION" object:errorMessage];
            }
        }

    ];
}

- (void)doInputAction {
    
    ColorButton * rebackButton = (ColorButton *)[self.view viewWithTag:VIEW_TAG_REBACK];
    if (self.moneyTextField.text.length <= 0) {
         rebackButton.isColorEnabled = NO;
        UILabel *value1Label = [self.view viewWithTag:VIEW_TAG_TIP1VALUE_LABEL];
        NSString *text = @"0.00元";
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:text];
        [str addAttributes:@{ NSForegroundColorAttributeName : COLOR_STRONG_RED } range:NSMakeRange(0, [text length] - 1)];
        value1Label.attributedText = str;
        return;
    }else
    {
        rebackButton.isColorEnabled = YES;
    }

    if (![Utility isValidateNumber:self.moneyTextField.text]) {
        [self showPromptTip:XYBString(@"str_error_back_amount", @"赎回金额填写错误")];
        return;
    }

    if (self.moneyTextField.text.length > 8) {
        self.moneyTextField.text = [self.moneyTextField.text substringToIndex:8];
    }

    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithCapacity:12];
    if ([UserDefaultsUtil getUser].userId) {
        [param setObject:[UserDefaultsUtil getUser].userId forKey:@"userId"];
    }
    if ([self.dic objectForKey:@"orderId"]) {
        [param setObject:[self.dic objectForKey:@"orderId"] forKey:@"orderId"];
    }
    if (self.moneyTextField.text) {
        [param setObject:self.moneyTextField.text forKey:@"amount"];
    }

    NSString *urlPath = [RequestURL getRequestURL:BbgInvestRebackInfoURL param:param];
    [WebService postRequest:urlPath param:param JSONModelClass:[BbgRedeemQueryModel class]

        Success:^(AFHTTPRequestOperation *operation, id responseObject) {
            BbgRedeemQueryModel *bbgRedeem = responseObject;
            if (bbgRedeem.resultCode == 1) {
                NSString *rebackAmount = nil;
                if (bbgRedeem.rebackAmount == nil) {
                    rebackAmount = @"0.00";
                } else {

                    rebackAmount = [Utility replaceTheNumberForNSNumberFormatter:[NSString stringWithFormat:@"%.2f", [bbgRedeem.rebackAmount doubleValue]]];
                }
                NSString *refundDate = bbgRedeem.refundDate;
                if (refundDate == nil) {
                    refundDate = @"";
                }
                UILabel *value1Label = [self.view viewWithTag:VIEW_TAG_TIP1VALUE_LABEL];
                value1Label.text = rebackAmount;

                UILabel *value2Label = [self.view viewWithTag:VIEW_TAG_TIP2VALUE_LABEL];
                value2Label.text = [NSString stringWithFormat:XYBString(@"str_to_account_date", @"预计到账日期%@"),refundDate];
            }
        }

        fail:^(AFHTTPRequestOperation *operation, NSString *errorMessage) {
            [self hideLoading];
            [self showPromptTip:errorMessage];
        }

    ];
}

- (void)clickTheAgreementButton:(id)sender {

    NSString *urlStr = [RequestURL getNodeJsH5URL:App_Bbg_Protocol_URL withIsSign:NO];
    NSString *titleStr = XYBString(@"str_bbg_serve_protocol", @"步步高服务协议");
    WebviewViewController *webView = [[WebviewViewController alloc] initWithTitle:titleStr webUrlString:urlStr];
    [self.navigationController pushViewController:webView animated:YES];
}

- (void)clickTheAllInvestBtn:(id)sender {
    CGFloat restAmount = [[self.dic objectForKey:@"restAmount"] floatValue];
    self.moneyTextField.text = [NSString stringWithFormat:@"%.0lf", restAmount];

    [self doInputAction];
}

- (void)clickRebackButton:(id)sender {
    CGFloat rbcAmount = [self.moneyTextField.text floatValue];
    CGFloat amount = [[self.dic objectForKey:@"restAmount"] floatValue];

    if (self.moneyTextField.text.length <= 0) {
        [self showPromptTip:XYBString(@"str_please_input_back_amount", @"请输入赎回金额")];
        return;
    }

    if (![Utility isValidateNumber:self.moneyTextField.text]) {
        [self showPromptTip:XYBString(@"str_error_back_amount", @"赎回金额填写错误")];
        return;
    }

    if (amount >= 100) {
        NSRange found = [self.moneyTextField.text rangeOfString:@"."];
        BOOL isXiaoShu = NO;
        if (found.length > 0) {
            NSString *sub = [self.moneyTextField.text substringFromIndex:found.location + 1];
            if ([sub integerValue] != 0) {
                isXiaoShu = YES;
            }
        }

        if (rbcAmount < 100 || isXiaoShu) {
            [self showPromptTip:XYBString(@"str_money_must_be_zheng", @"赎回金额须大于等于100且为整数")];
            return;
        }

        if (rbcAmount > [[self.dic objectForKey:@"restAmount"] floatValue]) {
            [self showPromptTip:XYBString(@"str_too_much_amount", @"赎回金额不能大于最大可赎回金额")];
            return;
        }

    } else {
        if (rbcAmount != amount) {
            [self showPromptTip:XYBString(@"str_amount_must_be_equal", @"输入的可赎金额值必须等于剩余可赎金额")];
            return;
        }
    }
    [self.moneyTextField resignFirstResponder];
    [self payTheTouIDFinancing];
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
                                    if ([self.dic objectForKey:@"orderId"]) {
                                        [param setObject:[self.dic objectForKey:@"orderId"] forKey:@"orderId"];
                                    }
                                    if (self.moneyTextField.text) {
                                        [param setObject:self.moneyTextField.text forKey:@"amount"];
                                    }
                                    if (sigPassWord) {
                                        [param setObject:sigPassWord forKey:@"tradePassword"];
                                    }
                                    [param setObject:[OpenUDID value] forKey:@"deviceId"];
                                    [param setObject:[DateTimeUtil getCurrentTime] forKey:@"timestamp"];
                                    [param setObject:@"1" forKey:@"paymentMode"];
                                    [self BbgRebackWeb:param];

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
    __weak BbgRebackViewController *weakSelf = self;

    tradePayView.clickSureButton = ^(NSString *payStr) {

        [weakSelf doReback:payStr];
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

- (void)clickBackBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
