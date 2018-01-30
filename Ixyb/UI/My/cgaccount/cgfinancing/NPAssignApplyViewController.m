//
//  NPAssignApplyViewController.m
//  Ixyb
//
//  Created by wang on 2017/12/18.
//  Copyright © 2017年 xyb. All rights reserved.
//

#import "NPAssignApplyViewController.h"
#import "NPAssignApplyCompleteViewController.h"
#import "ChargeViewController.h"
#import "ChangePayPasswordViewController.h"
#import "CgRebackInfoModel.h"
#import "HBRSAHandler.h"
#import "WebviewViewController.h"
#import "OpenUDID.h"
#import "TradePasswordView.h"
#import "VerificationTouch.h"
#import "Utility.h"
#import "WebService.h"

@interface NPAssignApplyViewController ()
{
    UILabel * syzqbjLab; //剩余债权本金
    UILabel * yjlxLab;   //应计利息
    UILabel * zrfwfLab;  //转让服务费
    UILabel * yjdzjeLab; //预计到账金额
    ColorButton * confirmZrBut;  //确认转让
    TradePasswordView *tradePayView;
    CgRebackInfoModel * cgReabackInfo;
}
@end

@implementation NPAssignApplyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNav];
    [self initUI];
    [self cgRebackInfoRequestWebServiceWithParam];
}

#pragma mark -- 初始化 UI

-(void)setNav
{
    self.navItem.title = XYBString(@"str_account_yjzr", @"一键转让");
    self.view.backgroundColor = COLOR_BG;
    self.navItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(clickBackBtn:)];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0.0f, 0.0f, 60.0f, 40.0f);
    [button setTitle:XYBString(@"str_trans_rule", @"转让规则") forState:UIControlStateNormal];
    button.titleLabel.font = TEXT_FONT_14;
    [button addTarget:self action:@selector(clickRightBtn:) forControlEvents:UIControlEventTouchUpInside];
    [button setTitleColor:COLOR_COMMON_GRAY forState:UIControlStateHighlighted];
    [self.navBar addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.navBar);
        make.right.equalTo(@(-Margin_Right));
    }];
}

-(void)initUI
{
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
        make.height.equalTo(@165.5);
        make.width.equalTo(@(MainScreenWidth - 30));
    }];
    
    UILabel *tip11Label = [[UILabel alloc] initWithFrame:CGRectZero];
    tip11Label.text = @"集合剩余债权本金（元）";
    tip11Label.font = SMALL_TEXT_FONT_13;
    tip11Label.textColor = COLOR_AUXILIARY_GREY;
    [sumaryView addSubview:tip11Label];
    [tip11Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(sumaryView.mas_centerX);
        make.top.equalTo(@(24));
    }];
    
    syzqbjLab = [[UILabel alloc] initWithFrame:CGRectZero];
    syzqbjLab.text = XYBString(@"str_common_zero_yuan", @"0.00元");
    syzqbjLab.font = XTB_RATE_FONT;
    syzqbjLab.textColor = COLOR_MAIN_GREY;
    [sumaryView addSubview:syzqbjLab];
    [syzqbjLab mas_makeConstraints:^(MASConstraintMaker *make) {
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
        
    UILabel *tip12Label = [[UILabel alloc] initWithFrame:CGRectZero];
    tip12Label.text = XYBString(@"str_trans_fee_yuan", @"转让服务费(元)");
    tip12Label.font = SMALL_TEXT_FONT_13;
    tip12Label.textColor = COLOR_AUXILIARY_GREY;
    [sumaryView addSubview:tip12Label];
    [tip12Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(splitView.mas_top).offset(18.5);
        make.left.equalTo(splitView.mas_left);
    }];
    
    zrfwfLab = [[UILabel alloc] initWithFrame:CGRectZero];
    zrfwfLab.text = XYBString(@"str_all_asert_account", @"0.00");
    zrfwfLab.font = SMALL_TEXT_FONT_13;
    zrfwfLab.textColor = COLOR_INTRODUCE_RED;
    [sumaryView addSubview:zrfwfLab];
    [zrfwfLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tip12Label.mas_top);
        make.right.equalTo(splitView.mas_right);
    }];
    
    
    UILabel *yjdzjeTipsLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    yjdzjeTipsLabel.text = [NSString stringWithFormat:@"%@(元)",XYBString(@"str_Dqb_tipsredeem_estimate_money", @"预计到账金额")];
    yjdzjeTipsLabel.font = SMALL_TEXT_FONT_13;
    yjdzjeTipsLabel.textColor = COLOR_AUXILIARY_GREY;
    [sumaryView addSubview:yjdzjeTipsLabel];
    [yjdzjeTipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(sumaryView.mas_bottom).offset(-Margin_Bottom);
        make.left.equalTo(tip12Label.mas_left);
    }];
    
    yjdzjeLab = [[UILabel alloc] initWithFrame:CGRectZero];
    yjdzjeLab.text = XYBString(@"str_all_asert_account", @"0.00");
    yjdzjeLab.font = SMALL_TEXT_FONT_13;
    yjdzjeLab.textColor = COLOR_XTB_ORANGE;
    [sumaryView addSubview:yjdzjeLab];
    [yjdzjeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(yjdzjeTipsLabel.mas_centerY);
        make.right.equalTo(zrfwfLab.mas_right);
    }];

    UILabel * tipsZr = [[UILabel alloc] initWithFrame:CGRectZero];
    tipsZr.text = XYBString(@"str_acount_tipsZr", @"各项目转让成功金额将进入可用余额，所有可转让项目全部转让成功则本次转让结束。");
    tipsZr.font = WEAK_TEXT_FONT_11;
    tipsZr.numberOfLines = 0;
    tipsZr.textColor = COLOR_LIGHT_GREY;
    [self.view addSubview:tipsZr];
    [tipsZr mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Margin_Left));
        make.right.equalTo(@(-Margin_Right));
        make.top.equalTo(sumaryView.mas_bottom).offset(20.f);
    }];
    
    confirmZrBut = [[ColorButton alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth - 30, Cell_Height) Title:XYBString(@"str_begin_trans", @"确认转让")  ByGradientType:leftToRight];
    [confirmZrBut addTarget:self action:@selector(clickConfirmZrButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:confirmZrBut];
    
    [confirmZrBut mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Margin_Left));
        make.right.equalTo(@(-Margin_Right));
        make.height.equalTo(@(Cell_Height));
        make.top.equalTo(tipsZr.mas_bottom).offset(20.f);
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
        make.bottom.equalTo(confirmZrBut.mas_bottom).offset(30.f);
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

#pragma mark -- 点击事件

//确认转让
-(void)clickConfirmZrButton:(id)sender
{
    [self payTheTouIDFinancing];
}

//债权服务协议
-(void)clickProtocolButton:(id)sender
{
    NSString *urlStr = [RequestURL getNodeJsH5URL:App_Ca_Protocol_URL withIsSign:NO];
    WebviewViewController *webView = [[WebviewViewController alloc] initWithTitle:nil webUrlString:urlStr];
    [self.navigationController pushViewController:webView animated:YES];
}

//转让规则
-(void)clickRightBtn:(id)sender
{
    NSString *urlStr = [RequestURL getNodeJsH5URL:App_Dep_Assign_Rule_URL withIsSign:NO];
    WebviewViewController *webView = [[WebviewViewController alloc] initWithTitle:nil webUrlString:urlStr];
    [self.navigationController pushViewController:webView animated:YES];
}

//返回
-(void)clickBackBtn:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark -- 数据处理

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
                                    [param setObject: [StrUtil isEmptyString:_depOrderDetail.orderId] ? @"" : _depOrderDetail.orderId forKey:@"orderId"];
                                
                                    if (sigPassWord) {
                                        [param setObject:sigPassWord forKey:@"tradePassword"];
                                    }
                        
                                    [param setObject:[OpenUDID value] forKey:@"deviceId"];
                                    [param setObject:_depOrderDetail.orderNo forKey:@"orderNo"];
                                    [param setObject:[DateTimeUtil getCurrentTime] forKey:@"timestamp"];
                                    [param setObject:@"1" forKey:@"paymentMode"];
                                    [self cgRebackRequestWebServiceWithParam:param];
                                    
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

    __weak NPAssignApplyViewController *weakSelf = self;
    NSString *orderId = _depOrderDetail.orderId;
    tradePayView.clickSureButton = ^(NSString *payStr) {
        
        NSDictionary *params = @{
                                 @"userId" : [UserDefaultsUtil getUser].userId,
                                 @"orderId" : [NSNumber numberWithInteger:[orderId integerValue]],
                                 @"orderNo": weakSelf.depOrderDetail.orderNo,
                                 @"tradePassword" : payStr
                                 };
        [weakSelf cgRebackRequestWebServiceWithParam:params];
        
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

//一键转让
-(void)cgRebackRequestWebServiceWithParam:(NSDictionary *)parmDic
{
    NSString *urlPath = [RequestURL getRequestURL:OrderRebackURL param:parmDic];
    
    [self showDataLoading];
    
    [WebService postRequest:urlPath param:parmDic JSONModelClass:[ResponseModel class] Success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         [self hideLoading];
        [tradePayView removeFromSuperview];
         ResponseModel * response = responseObject;
         if (response.resultCode == 1) {
             
             NPAssignApplyCompleteViewController *  npAssignApplyComplete = [[NPAssignApplyCompleteViewController alloc] init];
             npAssignApplyComplete.strApplyAmount =  cgReabackInfo.restPrincipal;
             [self.navigationController pushViewController:npAssignApplyComplete animated:YES];
         }
         
     }fail:^(AFHTTPRequestOperation *operation, NSString *errorMessage) {
         [self hideLoading];
         if ([parmDic objectForKey:@"paymentMode"]) {
             [self showPromptTip:errorMessage];
         } else {
             [[NSNotificationCenter defaultCenter] postNotificationName:@"ERRORNOTIFICATION" object:errorMessage];
         }
     }
     
    ];
    
}

//转让信息查询
-(void)cgRebackInfoRequestWebServiceWithParam
{
    NSMutableDictionary * parmDic = [[NSMutableDictionary alloc] init];
    [parmDic setObject: _depOrderDetail.orderId forKey:@"orderId"];
    [parmDic setObject:_depOrderDetail.orderNo forKey:@"orderNo"];
    [parmDic setObject: [UserDefaultsUtil getUser].userId forKey:@"userId"];
    
    NSString *urlPath = [RequestURL getRequestURL:OrderRebackInfoURL param:parmDic];
    
    [self showDataLoading];
    
    [WebService postRequest:urlPath param:parmDic JSONModelClass:[CgRebackInfoModel class] Success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         [self hideLoading];
         cgReabackInfo = responseObject;
         
         if ([cgReabackInfo.fee doubleValue] != 0) {
             zrfwfLab.text = [NSString stringWithFormat:@"-%@",[Utility replaceTheNumberForNSNumberFormatter:cgReabackInfo.fee]];
         }
  
         if ([cgReabackInfo.actualAmt doubleValue] != 0) {
             yjdzjeLab.text = [Utility replaceTheNumberForNSNumberFormatter:cgReabackInfo.actualAmt];
         }
         
         if ([cgReabackInfo.restPrincipal doubleValue] != 0) {
             syzqbjLab.text = [Utility replaceTheNumberForNSNumberFormatter:cgReabackInfo.restPrincipal];
         }
         
         
     }fail:^(AFHTTPRequestOperation *operation, NSString *errorMessage) {
         [self hideLoading];
         [self showPromptTip:errorMessage];
         
     }
     
    ];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
 
}


@end
