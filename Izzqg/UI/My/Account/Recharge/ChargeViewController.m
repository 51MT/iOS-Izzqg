//
//  BuyFinancingViewController.m
//  Ixyb
//
//  Created by wang on 15/5/20.
//  Copyright (c) 2015年 xyb. All rights reserved.
//

#import "ChargeViewController.h"

#import "BankInfoViewController.h"
#import "ChargeValidate.h"
#import "LLChargeViewController.h"
#import "LoginFlowViewController.h" //注册—注册成功—充值—返回跳转
#import "MyBanksResponseModel.h"
#import "RealNameViewController.h"
#import "Utility.h"
#import "WebService.h"
#import "WebviewViewController.h"
#import "XYAlertView.h"
#import "UMengAnalyticsUtil.h"

#import "CommissionView.h"
#import "MJExtension.h"
#import "MposModel.h"

#import "BankTypeResponseModel.h"
#import "ChargePayRouteResponseModel.h"
#import "KQViewController.h"
#import "LLChargeCallBackResponseModel.h"
#import "WebService.h"
#import "ChargeFailureViewController.h"

#define BANKIMAGE 10003
#define MPOSIMAGETAG 10004
#define LLBTNTAG 10005
#define MPOSBTNTAG 10006
#define BANKINFOLABTAG 10007
#define MPOSVIEW 10008
#define BANKNAMETAG 10009
#define SINGLE_DEAL_AMOUNT_TAG 10010

@interface ChargeViewController () {
    
    int bankTypeNumber;
    UIScrollView *mainScroll;
    UIImageView *investBackImage;
    UITextField *dustedMoneyTextField;
    UIView *payWayView;
    
    MyBanksResponseModel *bankModel;
    NSMutableDictionary *bankInfoDic;
    UIView *chargeBtnView;
    ColorButton * chargeBtn;
    NSMutableDictionary *contentDic;
    NSDictionary *amountDic; //userId + amount
    NSMutableDictionary *kqDic;
    
    XYAlertView *alertView; //快钱弹出框
    UILabel *remaindLab;    //大额充值提醒
    int paySelectType;      //选中充值方式 1 连连 2 mpos
}

@property (nonatomic, assign) int excludeKq2; //是否过滤掉KQ2
@property (nonatomic, assign) BOOL identifer; //是否从实名认证提示页面进入

@end

@implementation ChargeViewController

-(id)initWithIdetifer:(BOOL)identifer {
    self = [super init];
    if (self) {
        _identifer = identifer;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    User *user = [UserDefaultsUtil getUser];
    if ([user.isBankSaved boolValue]) {
        [self reloadTheBankInfo];
    }
    
    [self callCheckBankWebService:@{ @"userId" : [UserDefaultsUtil getUser].userId }];
    [UMengAnalyticsUtil beginLogPageView:NSStringFromClass([self class])];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [UMengAnalyticsUtil endLogPageView:NSStringFromClass([self class])];
}

- (void)setNav {
    self.navItem.title = XYBString(@"string_charge", @"充值");
    
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

- (void)clickBackBtn:(id)sender {
    [dustedMoneyTextField resignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)clickTheRightBtn {
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", [RequestURL getNodeJsH5URL:App_Bank_Limit_URL withIsSign:NO], App_Bank_Tab_Nav1_URL];
    
    NSString *titleStr = XYBString(@"str_bank_limit", @"充值提现说明");
    WebviewViewController *webView = [[WebviewViewController alloc] initWithTitle:titleStr webUrlString:urlStr];
    [self.navigationController pushViewController:webView animated:YES];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self setNav];
    
    [self creatTheMianScroll];
    bankInfoDic = [[NSMutableDictionary alloc] init];
    paySelectType = 1;
    [self creatTheChargeButtonView];
}

/**
 *  本地缓存中取银行账户accountNumber 和 银行简称bankTypeName
 */
- (void)reloadTheBankInfo {
    
    User *user = [UserDefaultsUtil getUser];
    
    //银行账号
    if (user.accountNumber.length > 4) {
        [bankInfoDic setObject:user.accountNumber forKey:@"accountNumber"];
    }
    
    //预留手机
    if (user.bankmobilePhone.length > 8) {
        [bankInfoDic setObject:user.bankmobilePhone forKey:@"mobilePhone"];
    }
    
    //取手机号码后四位
    NSString *bankNumStr = [bankInfoDic objectForKey:@"accountNumber"];
    if (bankNumStr) {
        bankNumStr = [bankNumStr substringWithRange:NSMakeRange(bankNumStr.length - 4, 4)];
    }
    
    UILabel *lab = (UILabel *) [self.view viewWithTag:BANKINFOLABTAG];
    UIImageView * imageBank = (UIImageView *) [self.view viewWithTag:BANKIMAGE];
    /**
     *  首先从缓存中取bankTypeName，取不到就根据bankType从本地取
     */
    if (user.bankTypeName && user.bankTypeName != nil) {
        if (![StrUtil isEmptyString:bankNumStr]) {
            lab.text = [NSString stringWithFormat:@"%@(尾号%@)", user.bankTypeName, bankNumStr];
        }
    } else {
        bankTypeNumber = -1;
        NSString *bankJson = [[NSBundle mainBundle] pathForResource:@"bank" ofType:@"json"];
        NSArray *bankArr = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:bankJson] options:NSJSONReadingMutableContainers error:nil];
        
        bankTypeNumber = [user.bankType intValue];
        for (NSDictionary *bankDic in bankArr) {
            int bankType = [[bankDic objectForKey:@"bankType"] intValue];
            if (bankType == [user.bankType intValue]) {
                [bankInfoDic setObject:[bankDic objectForKey:@"bankName"] forKey:@"bankTypeName"];
                [bankInfoDic setObject:[bankDic objectForKey:@"bankImage"] forKey:@"bankImage"];
                break;
            }
        }
        
        if (![StrUtil isEmptyString:[bankInfoDic objectForKey:@"bankImage"]]) {
             imageBank.image = [UIImage imageNamed:[bankInfoDic objectForKey:@"bankImage"]];
        }
        
        if (![StrUtil isEmptyString:[bankInfoDic objectForKey:@"bankTypeName"]] && ![StrUtil isEmptyString:bankNumStr] ) {
            lab.text = [NSString stringWithFormat:@"%@(尾号%@)", [bankInfoDic objectForKey:@"bankTypeName"], bankNumStr];
        }
    }
}

- (void)creatTheMianScroll {
    
    mainScroll = [[UIScrollView alloc] initWithFrame:CGRectZero];
    mainScroll.scrollEnabled = NO;
    mainScroll.showsVerticalScrollIndicator = NO;
    [self.view addSubview:mainScroll];
    
    [mainScroll mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navBar.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
    
    UIView *vi = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:vi];
    
    [vi mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.width.equalTo(@(MainScreenWidth));
        make.height.equalTo(@1);
    }];
    
    
    payWayView = [[UIView alloc] initWithFrame:CGRectZero];
    payWayView.backgroundColor = COLOR_COMMON_WHITE;
    payWayView.layer.masksToBounds = YES;
    payWayView.hidden = YES;
    payWayView.layer.borderWidth = Border_Width;
    payWayView.layer.borderColor = COLOR_LINE.CGColor;
    [mainScroll addSubview:payWayView];
    
    [payWayView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(mainScroll);
        make.height.equalTo(@(0));
        make.top.equalTo(mainScroll.mas_top);
    }];
    
    UIView *llPayView = [[UIView alloc] initWithFrame:CGRectZero];
    [payWayView addSubview:llPayView];
    
    [llPayView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(payWayView);
    }];
    
    
    UIImageView *imageBankView = [[UIImageView alloc] initWithFrame:CGRectZero];
    imageBankView.image = [UIImage imageNamed:@"QuicklyPay_Image"];
    imageBankView.tag = BANKIMAGE;
    [llPayView addSubview:imageBankView];
    
    [imageBankView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(7));
        make.left.equalTo(@(11));
    }];
    
    UILabel *bankInfoLab = [[UILabel alloc] initWithFrame:CGRectZero];
    bankInfoLab.font = NORMAL_TEXT_FONT_15;
    bankInfoLab.textColor = COLOR_COMMON_BLACK;
    bankInfoLab.lineBreakMode = NSLineBreakByTruncatingMiddle;
    bankInfoLab.tag = BANKINFOLABTAG;
    [llPayView addSubview:bankInfoLab];
    
    [bankInfoLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imageBankView.mas_right).offset(6);
        make.centerY.equalTo(imageBankView.mas_centerY);
    }];
    
    UILabel *singleDealAmount = [[UILabel alloc] initWithFrame:CGRectZero];
    singleDealAmount.text = @"单笔:0万 | 日:0万 | 月:0万";
    singleDealAmount.textColor = COLOR_AUXILIARY_GREY;
    singleDealAmount.font = WEAK_TEXT_FONT_11;
    singleDealAmount.tag = SINGLE_DEAL_AMOUNT_TAG;
    singleDealAmount.hidden = YES;
    [llPayView addSubview:singleDealAmount];
    
    [singleDealAmount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bankInfoLab.mas_left);
        make.bottom.equalTo(llPayView.mas_bottom).offset(-13);
    }];
    
    
    investBackImage = [[UIImageView alloc] initWithFrame:CGRectZero];
    investBackImage.image = [UIImage imageNamed:@"viewBackImage"];
    investBackImage.userInteractionEnabled = YES;
    [mainScroll addSubview:investBackImage];
    
    [investBackImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(mainScroll);
        make.width.equalTo(vi.mas_width);
        make.top.equalTo(llPayView.mas_bottom).offset(22);
    }];
    
    UILabel *moneyLab = [[UILabel alloc] initWithFrame:CGRectZero];
    moneyLab.text = XYBString(@"string_amount", @"金额");
    moneyLab.textColor = COLOR_MAIN_GREY;
    moneyLab.font = TEXT_FONT_16;
    [investBackImage addSubview:moneyLab];
    [moneyLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Margin_Left));
        make.centerY.equalTo(investBackImage.mas_centerY);
    }];
    
    dustedMoneyTextField = [[UITextField alloc] initWithFrame:CGRectZero];
    dustedMoneyTextField.placeholder = XYBString(@"string_more_than_100", @"100元起");
    dustedMoneyTextField.textColor = COLOR_MAIN_GREY;
    dustedMoneyTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    dustedMoneyTextField.font = TEXT_FONT_16;
    dustedMoneyTextField.keyboardType = UIKeyboardTypeNumberPad;
    [investBackImage addSubview:dustedMoneyTextField];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dustedMoneyTextFieldChange) name:UITextFieldTextDidChangeNotification object:dustedMoneyTextField];
    [dustedMoneyTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(moneyLab.mas_right).offset(10);
        make.centerY.equalTo(investBackImage.mas_centerY);
        make.height.equalTo(@30);
        //        make.right.equalTo (investBackImage.mas_right).offset(-40);
        make.width.equalTo(@(MainScreenWidth - 90));
    }];
    
    UILabel *unitLab = [[UILabel alloc] initWithFrame:CGRectZero];
    unitLab.text = XYBString(@"string_yuan", @"元");
    unitLab.textColor = COLOR_MAIN_GREY;
    unitLab.font = TEXT_FONT_16;
    [investBackImage addSubview:unitLab];
    [unitLab setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh + 20 forAxis:UILayoutConstraintAxisHorizontal];
    [unitLab setContentHuggingPriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    [unitLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(investBackImage.mas_right).offset(-10);
        make.centerY.equalTo(investBackImage.mas_centerY);
    }];
}


- (void)creatTheChargeButtonView {

    chargeBtnView = [[UIView alloc] initWithFrame:CGRectZero];
    chargeBtnView.backgroundColor = COLOR_COMMON_CLEAR;
    [mainScroll addSubview:chargeBtnView];
    
    [chargeBtnView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(mainScroll);
        make.top.equalTo(investBackImage.mas_bottom).offset(20);
        make.bottom.equalTo(mainScroll.mas_bottom).offset(0);
    }];
    
    chargeBtn = [[ColorButton alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth - 30, Cell_Height) Title:XYBString(@"string_ok", @"确定") ByGradientType:leftToRight];
    chargeBtn.isColorEnabled = NO;
    [chargeBtn addTarget:self action:@selector(clickTheNextButton:) forControlEvents:UIControlEventTouchUpInside];
    [chargeBtnView addSubview:chargeBtn];
    
    [chargeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Margin_Length));
        make.right.equalTo(@(-Margin_Length));
        make.height.equalTo(@(Cell_Height));
        make.top.equalTo(chargeBtnView.mas_top).offset(0);
    }];
    
    
    remaindLab = [[UILabel alloc] init];
    remaindLab.font = TEXT_FONT_12;
    remaindLab.textColor = COLOR_LIGHT_GREY;
    remaindLab.text = @"大额充值，请到官网www.xyb100.com选择京东支付";
    [chargeBtnView addSubview:remaindLab];
    
    [remaindLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(chargeBtnView.mas_left).offset(Margin_Length);
        make.top.equalTo(chargeBtn.mas_bottom).offset(Margin_Length);
        make.bottom.equalTo(chargeBtnView.mas_bottom).offset(0);
    }];
}


#pragma mark - 点击事件/响应事件

- (void)dustedMoneyTextFieldChange {
    
    if ([dustedMoneyTextField.text isEqualToString:@"\n"]) {
        //禁止输入换行
        [dustedMoneyTextField resignFirstResponder];
        return;
    }
    
    if (dustedMoneyTextField.text.length > 7) {
        dustedMoneyTextField.text = [dustedMoneyTextField.text substringToIndex:7];
    }
    
    [self checkTheChargeBtnuserInteractionEnabled];
}

- (void)checkTheChargeBtnuserInteractionEnabled {
    
    if (dustedMoneyTextField.text.length > 0 && paySelectType > 0) {
        chargeBtn.isColorEnabled = YES;
    } else {
        chargeBtn.isColorEnabled = NO;
    }
}

// 选择充值方式，1：连连充值 2：Mpos
- (void)clickTheSelectPayBtn:(UIButton *)btn {
    
    UIImageView *image1 = (UIImageView *) [self.view viewWithTag:BANKIMAGE];
    UIImageView *image2 = (UIImageView *) [self.view viewWithTag:MPOSIMAGETAG];
    
    switch (btn.tag) {
        case LLBTNTAG: {
            paySelectType = 1;
            image1.image = [UIImage imageNamed:@"pay_select"];
            image2.image = [UIImage imageNamed:@"pay_unselect"];
            
        } break;
        case MPOSBTNTAG: {
            image2.image = [UIImage imageNamed:@"pay_select"];
            image1.image = [UIImage imageNamed:@"pay_unselect"];
            paySelectType = 2;
            
        } break;
            
        default:
            break;
    }
    
    [self checkTheChargeBtnuserInteractionEnabled];
}

/*点击充值按钮后的的充值逻辑如下：
 1.首先检测输入数据的规范性（是否整形，是否小于100，是否为数字，是否大于0）
 2.根据选择充值方式(快捷支付、刷卡器充值)对应的paySelectType的值分为两大块：
 
 快捷支付类：
 2.1  判断客户是否实名认证
 是：(1)若没有绑卡，连连首冲绑卡（此时进入到LLChargeViewController页面填写银行卡，页面上的充值金额、用户名、身份证号是不可修改的，银行卡信息可以编辑，然后点击确定，连连进行充值）；
    (2)若绑卡了，则请求支付路由接口，返回相应实惠的支付方式(连连、快钱、富友)，这些返回的支付方式是通过payType（5：连连 10：快钱消费鉴权  13：快钱独立鉴权）来判断的，根据payType的值来使用相应的充值方式
 
 否：进入到LLChargeViewController页面填写银行卡、用户名、身份证号，页面上的充值金额不可修改的，然后点击确定，连连进行充值
 
 刷卡器充值类：
 2.2  判断客户是否实名认证
 是：直接进入到刷卡器充值页面，点击确定，在弹窗中选择支付方式（音频刷卡器充值 + 蓝牙刷卡器充值）后充值
 否：进入到实名认证页面填写姓名 + 身份证号后，点击确定跳入到刷卡器充值界面，然后在弹窗中选择支付方式（音频刷卡器充值 + 蓝牙刷卡器充值）后充值
 */

- (void)clickTheNextButton:(XYButton *)sender {
    [dustedMoneyTextField resignFirstResponder];
    
    if (![ChargeValidate checkTheChargeDustedMoneyStr:dustedMoneyTextField.text]) {
        [self hideLoading];
        return;
    }
    
    User *user = [UserDefaultsUtil getUser];
    if (paySelectType == 1) {
        if ([user.isBankSaved boolValue] && [user.isIdentityAuth boolValue]) { //非首次充值
            
            amountDic = @{
                          @"userId" : user.userId,                    //用户Id
                          @"amount" : dustedMoneyTextField.text,      //用户充值金额
                          @"excludeKq2" : [NSNumber numberWithInt:0], //不过滤掉快钱独立鉴权
                          };
            
            [self reqestChargeWayWebServiceWithParam:amountDic];
            
        } else { //首次充值|后台解绑银行卡|后台解绑实名认证——连连支付
            
            LLChargeViewController *llVC = [[LLChargeViewController alloc] initWithIdentifer:_identifer];
            llVC.chargeStr = dustedMoneyTextField.text;
            llVC.fromType = self.fromType;
            [self.navigationController pushViewController:llVC animated:YES];
            [self hideLoading];
            return;
        }
        
    } else { // 首次充值 连连支付
        
        if (![user.isIdentityAuth boolValue]) {
            RealNameViewController *realNameVC = [[RealNameViewController alloc] init];
            realNameVC.chargeMoneyStr = dustedMoneyTextField.text;
            [self.navigationController pushViewController:realNameVC animated:YES];
        }
        [self hideLoading];
    }
}

#pragma mark - 支付路由请求（ 5：连连 、 10：快钱消费鉴权 、13：快钱独立鉴权、14：通联支付 ）

/**
 *  非首次充值时，后台根据用户充值金额判断支付费用，并选择费用低的支付路由
 *
 *  @param resultDic 返回数据（费用低的支付路由）
 *
 *  @return 返回数据中的payType代表支付路由方式：5代表连连支付 11代表富有支付 10代表快钱支付
 */
- (void)reqestChargeWayWebServiceWithParam:(NSDictionary *)param {
    
    [self showDataLoading];
    NSString *requestURL = [RequestURL getRequestURL:ChargePayRouteURL param:param];
    [WebService postRequest:requestURL param:param JSONModelClass:[ChargePayRouteResponseModel class]
     
                    Success:^(AFHTTPRequestOperation *operation, id responseObject) {
                        
                        [self hideLoading];
                        ChargePayRouteResponseModel *responseModel = responseObject;
                        
                        //连连支付
                        if (responseModel.payType == 5) {
                            contentDic = [NSMutableDictionary dictionaryWithDictionary:[responseModel.resultData toDictionary]];
                            [contentDic setValue:responseModel.bankType forKey:@"bankType"];
                            [self callLLTwiceChargeWebService:contentDic]; //进行连连支付
                            
                        }
                        
                        //快钱消费鉴权支付 步骤如下：1.首先弹出验证码输入框 2.进行支付
                        else if (responseModel.payType == 10) {
                            NSString *mobilePhoneNo = responseModel.mobilePhone;
                            alertView = [[XYAlertView alloc] initPaySureBorderWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight) title:@"付款确认" telephoneNo:mobilePhoneNo alertStyle:KQAlertStyleDefault];
                            [self.view addSubview:alertView];
                            
                            [alertView mas_makeConstraints:^(MASConstraintMaker *make) {
                                make.edges.equalTo(self.view);
                            }];
                            
                            kqDic = [[NSMutableDictionary alloc] initWithDictionary:@{
                                                                                      @"userId" : responseModel.userId,
                                                                                      @"orderno" : responseModel.orderno,
                                                                                      }];
                            
                            __weak XYAlertView *weakVC = alertView;
                            weakVC.clickSureButton = ^(NSString *payStr) {
                                [kqDic setValue:payStr forKey:@"code"];
                                [self requestBill99ChargeWebServiceWithParam:kqDic]; //进行快钱支付
                            };
                            
                            weakVC.clickCodeButton = ^{
                                [self requestCreateBill99OrderWebServiceWithParam:amountDic];
                            };
                        }
                        
                        //快钱独立鉴权支付
                        else if (responseModel.payType == 13) {
                            
                            KQViewController *kqVC = [[KQViewController alloc] init];
                            kqVC.phoneNum = responseModel.mobilePhone;
                            
                            //绑卡block回调
                            kqVC.bindBlock = ^(int isExcludeKq2) {
                                self.excludeKq2 = isExcludeKq2;
                                NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
                                NSString *userId = [NSString stringWithFormat:@"%@", [UserDefaultsUtil getUser].userId];
                                [param setValue:userId forKey:@"userId"];                                       //用户Id
                                [param setValue:dustedMoneyTextField.text forKey:@"amount"];                    //用户充值金额
                                [param setValue:[NSNumber numberWithInt:self.excludeKq2] forKey:@"excludeKq2"]; //是否过滤掉快钱独立鉴权
                                
                                //重新调用支付路由返回优惠支付方式
                                [self reqestChargeWayWebServiceWithParam:[param copy]];
                            };
                            
                            //取消绑卡block回调
                            kqVC.cancelBlock = ^(int isExcludeKq2) {
                                self.excludeKq2 = isExcludeKq2;
                                NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
                                NSString *userId = [NSString stringWithFormat:@"%@", [UserDefaultsUtil getUser].userId];
                                [param setValue:userId forKey:@"userId"];                                       //用户Id
                                [param setValue:dustedMoneyTextField.text forKey:@"amount"];                    //用户充值金额
                                [param setValue:[NSNumber numberWithInt:self.excludeKq2] forKey:@"excludeKq2"]; //是否过滤掉快钱独立鉴权
                                //调用支付路由
                                [self reqestChargeWayWebServiceWithParam:[param copy]];
                            };
                            
                            XYNavigationController *nav = [[XYNavigationController alloc] initWithRootViewController:kqVC];
                            nav.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
                            
                            if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
                                nav.providesPresentationContextTransitionStyle = YES;
                                nav.definesPresentationContext = YES;
                                nav.modalPresentationStyle = UIModalPresentationOverCurrentContext;
                                [self presentViewController:nav animated:YES completion:nil];
                            } else {
                                self.view.window.rootViewController.modalPresentationStyle = UIModalPresentationCurrentContext;
                                [self presentViewController:nav animated:NO completion:nil];
                                self.view.window.rootViewController.modalPresentationStyle = UIModalPresentationFullScreen;
                            }
                        }
                        
                        //通联支付
                        else if (responseModel.payType == 14) {
                            
                            NSString *mobilePhoneNo = responseModel.mobilePhone;
                            alertView = [[XYAlertView alloc] initPaySureBorderWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight) title:@"付款确认" telephoneNo:mobilePhoneNo alertStyle:TLAlertStyle];
                            [self.view addSubview:alertView];
                            
                            [alertView mas_makeConstraints:^(MASConstraintMaker *make) {
                                make.edges.equalTo(self.view);
                            }];
                            
                            kqDic = [[NSMutableDictionary alloc] initWithDictionary:@{
                                                                                      @"userId" : responseModel.userId,
                                                                                      @"orderId":responseModel.orderId,
                                                                                      @"orderno" : responseModel.orderno,
                                                                                      }];
                            
                            __weak XYAlertView *weakVC = alertView;
                            weakVC.clickSureButton = ^(NSString *payStr) {
                                [kqDic setValue:payStr forKey:@"code"];
                                [self requestTNPayOrderWebserviceWithParam:kqDic]; //进行通联支付
                            };
                            
                            weakVC.clickCodeButton = ^{
                                [self requestTNPaySendVerifyCodeWebserviceWithParam:kqDic];
                            };
                        }
                    }
                       fail:^(AFHTTPRequestOperation *operation, NSString *errorMessage) {
                           [self hideLoading];
                           [self showPromptTip:errorMessage];
                       }];
}

#pragma mark - 连连支付二次充值

- (void)callLLTwiceChargeWebService:(NSDictionary *)dictionary {
    [LLPaySdk sharedSdk].sdkDelegate = self;
    
    //接入什么产品就传什么LLPayType
    [[LLPaySdk sharedSdk] presentLLPaySDKInViewController:self
                                              withPayType:1
                                            andTraderInfo:dictionary];
}

#pragma mark 连连充值成功后将支付信息发送给后台的接口(新接口)

- (void)requestLLChargeReturnWebServiceWithParam:(NSDictionary *)param {
    
    NSString *requstURL = [RequestURL getRequestURL:LLChargeReturnURL param:param];
    [WebService postRequest:requstURL param:param JSONModelClass:[LLChargeCallBackResponseModel class]
     
                    Success:^(AFHTTPRequestOperation *operation, id responseObject) {
                        
                    }
                       fail:^(AFHTTPRequestOperation *operation, NSString *errorMessage) {
                           [self showPromptTip:errorMessage];
                       }];
}

#pragma mark - 连连支付结果回调 LLPaySdkDelegate

// 连连支付订单支付结果返回，主要是异常和成功的不同状态
- (void)paymentEnd:(LLPayResult)resultCode withResultDic:(NSDictionary *)dic {
    
    NSString *msg = XYBString(@"string_pay_error", @"支付异常");
    switch (resultCode) {
        case kLLPayResultSuccess: {
            
            NSString *result_pay = dic[@"result_pay"];
            if ([result_pay isEqualToString:@"SUCCESS"]) {
                User *user = [UserDefaultsUtil getUser];
                if (![user.isIdentityAuth boolValue]) {
                    user.isIdentityAuth = @"1";
                }
                [UserDefaultsUtil setUser:user];
                NSDictionary *codntentDic = @{
                                              @"dt_order" : [dic objectForKey:@"dt_order"],
                                              @"money_order" : [dic objectForKey:@"money_order"],
                                              @"no_order" : [dic objectForKey:@"no_order"],
                                              @"oid_partner" : [dic objectForKey:@"oid_partner"],
                                              @"oid_paybill" : [dic objectForKey:@"oid_paybill"],
                                              @"result_pay" : [dic objectForKey:@"result_pay"],
                                              @"settle_date" : [dic objectForKey:@"settle_date"],
                                              @"sign" : [dic objectForKey:@"sign"],
                                              @"sign_type" : [dic objectForKey:@"sign_type"],
                                              @"userId" : [UserDefaultsUtil getUser].userId,
                                              @"card_no" : [contentDic objectForKey:@"card_no"],
                                              @"bankType" : bankTypeNumber > 0 ? [contentDic objectForKey:@"bankType"] : @""
                                              };
                //充值成功后，将支付结果数据传输给后台
                [self requestLLChargeReturnWebServiceWithParam:codntentDic];
                //充值成功，新手任务页面刷新
                [[NSNotificationCenter defaultCenter] postNotificationName:@"chargeSuccessNotification" object:nil];
                [self.navigationController popToViewController:self.navigationController.viewControllers[self.navigationController.viewControllers.count - 2] animated:YES];
                
                msg = XYBString(@"string_pay_success", @"支付成功");
                
            } else if ([result_pay isEqualToString:@"PROCESSING"]) {
                msg = XYBString(@"string_charege_dealing", @"支付单处理中");
                [self alertShow:msg];
                
            } else if ([result_pay isEqualToString:@"FAILURE"]) {
                msg = XYBString(@"string_charege_fail", @"支付单失败");
                [self alertShow:msg];
                
            } else if ([result_pay isEqualToString:@"REFUND"]) {
                msg = XYBString(@"string_charge_back", @"支付单已退款");
                [self alertShow:msg];
            }
        }
            break;
            
        case kLLPayResultFail: {
            msg = XYBString(@"string_charge_failure", @"支付失败");
            [self alertShow:msg];
            if (![StrUtil isEmptyString:bankModel.bank.dayLimit] && ![StrUtil isEmptyString:bankModel.bank.monthLimit] && ![StrUtil isEmptyString:bankModel.bank.singleLimit]) {
                NSString *bankName = [NSString stringWithFormat:@"%@", bankModel.bank.bankName];
                NSString *singleLimStr = [NSString stringWithFormat:@"%@", bankModel.bank.singleLimit];
                NSString *dayLimStr = [NSString stringWithFormat:@"%@", bankModel.bank.dayLimit];
                NSString *monthLimStr = [NSString stringWithFormat:@"%@", bankModel.bank.monthLimit];
                ChargeFailureViewController *failureVC = [[ChargeFailureViewController alloc] initWithObject:@[bankName,singleLimStr,dayLimStr,monthLimStr]];
                [self.navigationController pushViewController:failureVC animated:YES];
            }
        }
            break;
            
        case kLLPayResultCancel: {
            msg = XYBString(@"string_charge_cancel", @"支付取消");
            [self alertShow:msg];
        }
            break;
            
        case kLLPayResultInitError: {
            msg = XYBString(@"string_sdk_init_failure", @"sdk初始化异常");
            [self alertShow:msg];
        }
            break;
            
        case kLLPayResultInitParamError: {
            msg = dic[@"ret_msg"];
            [self alertShow:msg];
        }
            break;
            
        default:
            break;
    }
    
    msg = [NSString stringWithFormat:@"LL:%@", msg];
    if (![msg isEqualToString:XYBString(@"string_pay_LLsuccess", @"LL:支付成功")]) {
        [self postResultDicToBackGround:dic Message:msg];
        
    }
}

- (void)alertShow:(NSString *)message {
    [[[UIAlertView alloc] initWithTitle:XYBString(@"stirng_result", @"结果")
                                message:message
                               delegate:nil
                      cancelButtonTitle:XYBString(@"string_ok", @"确定")
                      otherButtonTitles:nil] show];
}

/**
 将连连支付的错误码ret_code和错误描述ret_msg传给后台，BI做统计用

 @param dic 参数
 @param msg 错误提示
 */
- (void)postResultDicToBackGround:(NSDictionary *)dic Message:(NSString *)msg {
    
    NSDictionary *resultDic = @{
                                @"dt_order" : [contentDic objectForKey:@"dt_order"],
                                @"money_order" : [contentDic objectForKey:@"money_order"],
                                @"no_order" : [contentDic objectForKey:@"no_order"],
                                @"oid_partner" : [contentDic objectForKey:@"oid_partner"],
                                @"oid_paybill" : [dic objectForKey:@"oid_paybill"] ? [dic objectForKey:@"oid_paybill"] : @" ",
                                @"result_pay" : [dic objectForKey:@"result_pay"] ? [dic objectForKey:@"result_pay"] : @"  ",
                                @"settle_date" : [dic objectForKey:@"settle_date"] ? [dic objectForKey:@"settle_date"] : @" ",
                                @"sign" : [dic objectForKey:@"sign"] ? [dic objectForKey:@"sign"]:@"",
                                @"sign_type" : [dic objectForKey:@"sign_type"] ? [dic objectForKey:@"sign_type"]:@"",
                                @"ret_code" : [dic objectForKey:@"ret_code"],
                                @"errorDesc" : msg,
                                @"userId" : [UserDefaultsUtil getUser].userId,
                                @"card_no" : [contentDic objectForKey:@"card_no"],
                                @"bankType" : bankTypeNumber > 0 ? [contentDic objectForKey:@"bankType"] : @""
                                };
    
    //充值成功后，将支付结果数据传输给后台
    [self requestLLChargeReturnWebServiceWithParam:resultDic];
}

/**
 *  快钱充值接口（新接口）
 *
 *  @param param 参数
 */
- (void)requestBill99ChargeWebServiceWithParam:(NSDictionary *)param {
    
    NSString *requestURL = [RequestURL getRequestURL:Bill99ChargeURL param:param];
    [self showTradeLoadingOnAlertView];
    [WebService postRequest:requestURL param:param JSONModelClass:[ResponseModel class]
     
                    Success:^(AFHTTPRequestOperation *operation, id responseObject) {
                        
                        [self hideLoading];
                        //支付成功
                        [alertView removeFromSuperview];
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"chargeSuccessNotification" object:nil];
                        [self.navigationController popToViewController:self.navigationController.viewControllers[self.navigationController.viewControllers.count - 2] animated:YES];
                    }
                       fail:^(AFHTTPRequestOperation *operation, NSString *errorMessage) {
                           [self hideLoading];
                           [self showPromptTip:errorMessage];
                       }];
}

/**
 *  快钱创建订单并重新发送短信验证码接口(新接口)
 *
 *  @param param 参数
 */
- (void)requestCreateBill99OrderWebServiceWithParam:(NSDictionary *)param {
    
    NSString *requstURL = [RequestURL getRequestURL:BillCreatOrderURL param:param];
    [self showTradeLoadingOnAlertView];
    [WebService postRequest:requstURL param:param JSONModelClass:[ChargePayRouteResponseModel class]
     
                    Success:^(AFHTTPRequestOperation *operation, id responseObject) {
                        
                        [self hideLoading];
                        ChargePayRouteResponseModel *responseModel = responseObject;
                        [kqDic removeAllObjects];
                        [kqDic setObject:responseModel.userId forKey:@"userId"];
                        [kqDic setObject:responseModel.orderno forKey:@"orderno"];
                        
                        alertView.remaindLab.hidden = YES; //将弹出框中的remaindLab隐藏并将更新约束
                        [alertView.remaindLab mas_updateConstraints:^(MASConstraintMaker *make) {
                            make.top.equalTo(alertView.telephoneLab.mas_bottom).offset(0);
                            make.height.equalTo(@0);
                        }];
                    }
                       fail:^(AFHTTPRequestOperation *operation, NSString *errorMessage) {
                           [self hideLoading];
                           [self showPromptTip:errorMessage];
                       }];
}

/**
 通联支付交易接口

 @param param 入参
 */
- (void)requestTNPayOrderWebserviceWithParam:(NSDictionary *)param {
    
    NSString *requstURL = [RequestURL getRequestURL:TNPayURL param:param];
    [self showTradeLoadingOnAlertView];
    [WebService postRequest:requstURL param:param JSONModelClass:[ResponseModel class]
     
                    Success:^(AFHTTPRequestOperation *operation, id responseObject) {
                        
                        [self hideLoading];
                        ResponseModel *model = responseObject;
                        if (model.resultCode == 1) {
                            
                            //支付成功
                            [alertView removeFromSuperview];
                            [[NSNotificationCenter defaultCenter] postNotificationName:@"chargeSuccessNotification" object:nil];
                            [self.navigationController popToViewController:self.navigationController.viewControllers[self.navigationController.viewControllers.count - 2] animated:YES];
                        }else{
                            NSLog(@"支付----失败失败");
                        }
                    }
                       fail:^(AFHTTPRequestOperation *operation, NSString *errorMessage) {
                           [self hideLoading];
                           [self showPromptTip:errorMessage];
                       }];

}


/**
 通联支付发送验证码接口

 @param param 入参
 */
- (void)requestTNPaySendVerifyCodeWebserviceWithParam:(NSDictionary *)param {
    
    NSString *requstURL = [RequestURL getRequestURL:TNPaySendCodeURL param:param];
    [self showTradeLoadingOnAlertView];
    [WebService postRequest:requstURL param:param JSONModelClass:[ResponseModel class]
     
                    Success:^(AFHTTPRequestOperation *operation, id responseObject) {
                        
                        [self hideLoading];
                        ResponseModel *model = responseObject;
                        if (model.resultCode == 1) {
                            NSLog(@"验证码发送成功");
                        }else{
                            NSLog(@"验证码发送支付----失败失败");
                        }
                    }
                       fail:^(AFHTTPRequestOperation *operation, NSString *errorMessage) {
                           [self hideLoading];
                           [self showPromptTip:errorMessage];
                       }];
    
}

/**
 *  检测银行卡绑定接口(新接口)
 *
 *  @param dictionary 参数
 */
- (void)callCheckBankWebService:(NSDictionary *)dictionary {
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:dictionary];
    NSString *urlPath = [RequestURL getRequestURL:BankURL param:params];
    [self showDataLoading];
    [WebService postRequest:urlPath param:params JSONModelClass:[MyBanksResponseModel class]
     
                    Success:^(AFHTTPRequestOperation *operation, id responseObject) {
                        
                        [self hideLoading];
                        
                        MyBanksResponseModel *myBankResponse = responseObject;
                        bankModel = myBankResponse;
                        User *user = [UserDefaultsUtil getUser];
                        BOOL isWithdrawMoney = [myBankResponse.isWithdrawMoney boolValue];
                        if (isWithdrawMoney) {
                            user.isWithdrawMoney = @"1";
                        }
                        
                        BOOL isBank = [myBankResponse.isBankSaved boolValue];
                        NSDictionary *bankDic = myBankResponse.bank.toDictionary;
                        [bankInfoDic addEntriesFromDictionary:bankDic];
                        user.accountNumber = [bankDic objectForKey:@"accountNumber"];
                        user.bankName = [bankDic objectForKey:@"bankName"];
                        user.bankType = [bankDic objectForKey:@"bankType"];
                        user.bankTypeName = [bankDic objectForKey:@"bankTypeName"];
                        user.bankmobilePhone = [bankDic objectForKey:@"mobilePhone"];
                        user.bankId = [bankDic objectForKey:@"id"];
                        
                        bankTypeNumber = [user.bankType intValue];
                        user.idNumber = myBankResponse.user.idNumber;
                        user.realName = myBankResponse.user.realName;
                        
                        //只有绑卡时才显示
                        if (isBank == YES) {
                            user.isBankSaved = @"1";
                            
                            payWayView.hidden = NO;
                            [payWayView mas_updateConstraints:^(MASConstraintMaker *make) {
                                make.height.equalTo(@(60));
                            }];
                            
                            NSString *bankNumStr;
                            if (user.accountNumber != nil) {
                                bankNumStr = [user.accountNumber substringWithRange:NSMakeRange(user.accountNumber.length - 4, 4)];
                            }
                            
                            if (![StrUtil isEmptyString:user.bankTypeName] && ![StrUtil isEmptyString:bankNumStr]) {
                                UILabel *lab = (UILabel *) [self.view viewWithTag:BANKINFOLABTAG];
                                lab.text = [NSString stringWithFormat:@"%@(尾号%@)", user.bankTypeName, bankNumStr];
                            }
                            
                            //限额提示
                            if (myBankResponse.bank.bankType && myBankResponse.bank.bankType.length > 0) {
                                if (![StrUtil isEmptyString:myBankResponse.bank.dayLimit] && ![StrUtil isEmptyString:myBankResponse.bank.monthLimit] && ![StrUtil isEmptyString:myBankResponse.bank.singleLimit]) {
                                    
                                    
                                    UILabel *singleDealAmount = [self.view viewWithTag:SINGLE_DEAL_AMOUNT_TAG];
                                    bankTypeNumber = [myBankResponse.bank.bankType intValue];
                                    singleDealAmount.text = [NSString stringWithFormat:@"单笔:%@ | 日:%@ | 月:%@", myBankResponse.bank.singleLimit, myBankResponse.bank.dayLimit, myBankResponse.bank.monthLimit];
                                    singleDealAmount.hidden = NO;
                              
                                }
                            }
                        }
                        
                        [UserDefaultsUtil setUser:user];
                        
                    }
     
                       fail:^(AFHTTPRequestOperation *operation, NSString *errorMessage) {
                           [self hideLoading];
                           [self showPromptTip:errorMessage];
                       }
     
     ];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
