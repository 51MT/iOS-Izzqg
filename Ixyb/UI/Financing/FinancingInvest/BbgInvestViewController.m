//
//  BbgInvestViewController.m
//  Ixyb
//
//  Created by wang on 15/12/10.
//  Copyright © 2015年 xyb. All rights reserved.
//

#import "AlertViewShow.h"
#import "BbgDetailViewController.h"
#import "BbgInvestViewController.h"
#import "BbgPreIncomeResponseModel.h"
#import "CalculatorViewController.h"
#import "ChangePayPasswordViewController.h"
#import "ChargeViewController.h"
#import "ChargeViewController.h"
#import "CheckTheInvestMoney.h"
#import "DqbAndXtbInvestResponseModel.h"
#import "IncomeStatusViewController.h"
#import "LoginFlowViewController.h"
#import "MJRefresh.h"
#import "RiskEvaluatingViewController.h"
#import "TradePasswordView.h"
#import "UserDetailRealNamesViewController.h"
#import "Utility.h"
#import "WebService.h"
#import "WebviewViewController.h"
#import "XYAlertView.h"
#import "VerifyNameViewController.h"

#define NUMBERS @"0123456789\n"
#define BACKVIEW_TAG 1000

@interface BbgInvestViewController () <UIAlertViewDelegate, UITextFieldDelegate,RTLabelDelegate> {

    XYScrollView *mainScroll;
    
    UIView *usableAmountView;
    UIImageView *textFieldBackImage;
    UIView *calculatorView;
    UILabel *payAmountTitle; //title：实际支付金额
    
    int mouthNum;
    TradePasswordView *tradePayView; //交易密码弹窗
    XYButton *allInvestBtn;
    CGFloat keyBoardHight;   //键盘高度
    
    UIView *bottomView;      //底部出借按钮的背景视图
    UITextField *dustedMoneyTextField;
    NSMutableDictionary *mainDic;
    NSString *dustedMoneyStr;
}

@property (nonatomic, strong) ColorButton *nextBtn;  //立即出借按钮
@property (nonatomic, strong) UILabel *incomeLab; //首月历史收益

@end

@implementation BbgInvestViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    if ([Utility shareInstance].isLogin) {
        if (_info.projectId) {
            BOOL isNumber = [Utility isValidateNumber:dustedMoneyTextField.text];
            [self requestBbgPreIncomeWebServiceWithParam:@{
                @"userId" : [UserDefaultsUtil getUser].userId,
                @"projectId" : [NSString stringWithFormat:@"%@", _info.projectId],
                @"amount" : isNumber == YES ? dustedMoneyTextField.text : @"0",
                @"month" : [NSNumber numberWithInt:mouthNum]
            }];
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];

    dustedMoneyStr = nil;
    mainDic = [[NSMutableDictionary alloc] init];
    mouthNum = 1;
    [self setNav];
    [self creatTheMainScrollView];
    [self createTheTopUI];
    [self creatTheUsableAmountView];
    [self creatTheInvestView];
    [self creatTheCalculatorView];
    [self creatTheInvestBtnView];
    
    [self setupRefresh];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(chargeSuccess) name:@"chargeSuccessNotification" object:nil];
    //注册成功后发送通知，此处接收，然后弹出新手活动界面
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(presentNewHandView) name:@"REGISTERSUCESS" object:nil];
    //增加监听，当键盘出现或改变时收出消息
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    //增加监听，当键退出时收出消息
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark - 创建UI

- (void)setNav {
    self.navItem.title = XYBString(@"str_financing_investBBG", @"出借");

    self.navItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(clickBackBtn:)];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushChargeView:) name:@"BBG" object:nil];
}

- (void)creatTheMainScrollView {
    mainScroll = [[XYScrollView alloc] init];
    mainScroll.showsVerticalScrollIndicator = YES;
    [self.view addSubview:mainScroll];

    [mainScroll mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navBar.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
        make.width.equalTo(@(MainScreenWidth));
    }];
}


/**
 顶部视图：历史收益率、剩余可投
 */
-(void)createTheTopUI {
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(Margin_Length, Margin_Top, MainScreenWidth - 30, 109)];
    backView.backgroundColor = COLOR_COMMON_WHITE;
    backView.layer.cornerRadius = 9.f;
    backView.tag = BACKVIEW_TAG;
    [mainScroll addSubview:backView];
    
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectZero];
    titleLab.font = TEXT_FONT_16;
    titleLab.textColor = COLOR_MAIN_GREY;
    titleLab.text = XYBString(@"str_common_bbg", @"步步高");
    [backView addSubview:titleLab];
    
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backView.mas_left).offset(Margin_Length);
        make.top.equalTo(backView.mas_top).offset(Margin_Length);
    }];

    UILabel *rateLab = [[UILabel alloc] initWithFrame:CGRectZero];
    rateLab.textAlignment = NSTextAlignmentLeft;
    NSString *rateStr = XYBString(@"str_financing_defaultZeroPercent", @"0-0%");
    NSMutableAttributedString *mutAttStr2 = [[NSMutableAttributedString alloc] initWithString:rateStr];
    [mutAttStr2 addAttributes:@{ NSFontAttributeName : FONT_TEXT_20,
                                 NSForegroundColorAttributeName : COLOR_CHUBBG_ORANGE }
                        range:NSMakeRange(0, 3)];
    [mutAttStr2 addAttributes:@{ NSFontAttributeName : TEXT_FONT_18,
                                 NSForegroundColorAttributeName : COLOR_CHUBBG_ORANGE }
                        range:NSMakeRange(3, 1)];
    rateLab.attributedText = mutAttStr2;
    [backView addSubview:rateLab];
    
    [rateLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleLab.mas_left).offset(0);
        make.top.equalTo(titleLab.mas_bottom).offset(17);
    }];

    UILabel *expectedLab = [[UILabel alloc] initWithFrame:CGRectZero];
    expectedLab.font = TEXT_FONT_12;
    expectedLab.textColor = COLOR_AUXILIARY_GREY;
    expectedLab.text = XYBString(@"str_bbg_dq_rate", @"历史年化结算利率");
    expectedLab.textAlignment = NSTextAlignmentLeft;
    [backView addSubview:expectedLab];
    
    [expectedLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(rateLab.mas_left);
        make.top.equalTo(rateLab.mas_bottom).offset(5);
    }];

    UILabel *standardLab = [[UILabel alloc] initWithFrame:CGRectZero];
    standardLab.font = NORMAL_TEXT_FONT_15;
    standardLab.textColor = COLOR_TITLE_GREY;
    standardLab.text = XYBString(@"str_financing_oneMonthAtLeast", @"1个月起");
    [backView addSubview:standardLab];
    
    [standardLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backView.mas_left).offset((MainScreenWidth - 30) *2/5);
        make.centerY.equalTo(rateLab.mas_centerY).offset(0);
    }];
    
    UILabel *restLab = [[UILabel alloc] initWithFrame:CGRectZero];
    restLab.font = TEXT_FONT_12;
    restLab.textColor = COLOR_AUXILIARY_GREY;
    restLab.text = [NSString stringWithFormat:XYBString(@"str_financing_restMoneyBlow", @"剩余可投:%@元"),@"0"];
    [backView addSubview:restLab];
    
    [restLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(expectedLab.mas_top).offset(0);
        make.left.equalTo(standardLab.mas_left).offset(0);
    }];
    
    if (_info) {
        
        NSString *minRateStr = [Utility rateReplaceTheNumberForNSNumberFormatter:[NSString stringWithFormat:@"%.2f", [_info.baseRate doubleValue]* 100]];
        NSString *maxRateStr = [Utility rateReplaceTheNumberForNSNumberFormatter:[NSString stringWithFormat:@"%.2f", [_info.maxRate doubleValue] * 100]];
        NSString *rateStr = [[[minRateStr stringByAppendingString:@"-"] stringByAppendingString:maxRateStr] stringByAppendingString:XYBString(@"str_financing_percentSymbol", @"%")];
        
        //历史年化结算利率
        NSMutableAttributedString *mutAttStr2 = [[NSMutableAttributedString alloc] initWithString:rateStr];
        [mutAttStr2 addAttributes:@{ NSFontAttributeName : FONT_TEXT_20,
                                     NSForegroundColorAttributeName : COLOR_ORANGE } range:NSMakeRange(0, rateStr.length - 1)];
        [mutAttStr2 addAttributes:@{ NSFontAttributeName : NORMAL_TEXT_FONT_15,
                                     NSForegroundColorAttributeName : COLOR_ORANGE } range:NSMakeRange(rateStr.length - 1,1)];
        rateLab.attributedText = mutAttStr2;
        
        //期限
        standardLab.text = [NSString stringWithFormat:XYBString(@"str_financing_investTimeAtLeast", @"%@个月起"), _info.minPeriods];
        
        //剩余可投
        if ([_info.restAmount doubleValue] <= 0) {
            restLab.text = [NSString stringWithFormat:XYBString(@"str_financing_restMoneyBlow", @"剩余可投:%@元"),@"0.00"];
        }
        
        if ([_info.restAmount doubleValue] > 0) {
            restLab.text = [NSString stringWithFormat:XYBString(@"str_financing_restMoneyBlow", @"剩余可投:%@元"),[Utility replaceTheNumberForNSNumberFormatter:_info.restAmount]];
        }
    }
}

- (void)creatTheUsableAmountView {
    
    usableAmountView = [[UIView alloc] initWithFrame:CGRectZero];
    [mainScroll addSubview:usableAmountView];

    UIView *topView = [mainScroll viewWithTag:BACKVIEW_TAG];
    [usableAmountView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topView.mas_bottom).offset(0);
        make.left.equalTo(mainScroll);
        make.width.equalTo(@(MainScreenWidth));
        make.height.equalTo(@(Cell_Height));
    }];

    UILabel *usableAmountTitleLab = [[UILabel alloc] initWithFrame:CGRectZero];
    usableAmountTitleLab.text = XYBString(@"str_financing_usable_amount", @"可用余额");
    usableAmountTitleLab.font = TEXT_FONT_12;
    usableAmountTitleLab.textColor = COLOR_AUXILIARY_GREY;
    [usableAmountView addSubview:usableAmountTitleLab];

    [usableAmountTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@Margin_Length);
        make.bottom.equalTo(usableAmountView.mas_bottom).offset(-10);
    }];

    UILabel *usableAmountLab = [[UILabel alloc] initWithFrame:CGRectZero];
    usableAmountLab.font = TEXT_FONT_12;
    usableAmountLab.textColor = COLOR_MAIN_GREY;
    usableAmountLab.tag = 2005;
    [usableAmountView addSubview:usableAmountLab];

    [usableAmountLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(usableAmountTitleLab.mas_right).offset(6);
        make.centerY.equalTo(usableAmountTitleLab.mas_centerY);
    }];

    if ([[UserDefaultsUtil getUser].usableAmount doubleValue] != 0) {
        NSString *usableAmount = [Utility replaceTheNumberForNSNumberFormatter:[NSString stringWithFormat:@"%.2f", [[UserDefaultsUtil getUser].usableAmount doubleValue]]];
        usableAmountLab.text = [NSString stringWithFormat:XYBString(@"str_financing_some_yuan", @"%@元"), usableAmount];
    } else {
        usableAmountLab.text = XYBString(@"str_financing_zero_yuan", @"0.00元");
    }

    XYButton *chargeButton = [[XYButton alloc] initWithSubordinationButtonTitle:XYBString(@"str_common_charge", @"充值") isUserInteractionEnabled:YES];
    chargeButton.titleLabel.font = TEXT_FONT_12;
    [chargeButton addTarget:self action:@selector(clickTheChargeButton:) forControlEvents:UIControlEventTouchUpInside];
    [usableAmountView addSubview:chargeButton];

    [chargeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(usableAmountLab.mas_right).offset(6);
        make.centerY.equalTo(usableAmountTitleLab.mas_centerY);
    }];
}

- (void)creatTheInvestView {

    textFieldBackImage = [[UIImageView alloc] initWithFrame:CGRectZero];
    textFieldBackImage.image = [UIImage imageNamed:@"viewBackImage"];
    textFieldBackImage.userInteractionEnabled = YES;
    [mainScroll addSubview:textFieldBackImage];

    [textFieldBackImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(mainScroll);
        make.width.equalTo(@(MainScreenWidth));
        make.top.equalTo(usableAmountView.mas_bottom);
    }];

    [XYCellLine initWithTopLineAtSuperView:textFieldBackImage];

    dustedMoneyTextField = [[UITextField alloc] initWithFrame:CGRectZero];
    dustedMoneyTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    dustedMoneyTextField.placeholder = XYBString(@"str_financing_100yqt", @"100元起投");
    dustedMoneyTextField.font = TEXT_FONT_16;
    dustedMoneyTextField.delegate = self;
    dustedMoneyTextField.keyboardType = UIKeyboardTypeNumberPad;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doaction) name:UITextFieldTextDidChangeNotification object:dustedMoneyTextField];
    [textFieldBackImage addSubview:dustedMoneyTextField];

    [dustedMoneyTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@Margin_Length);
        make.centerY.equalTo(textFieldBackImage.mas_centerY);
        make.right.equalTo(@(-125));
    }];

    UILabel *unitLab = [[UILabel alloc] initWithFrame:CGRectZero];
    unitLab.text = XYBString(@"str_financing_yuan", @"元");
    unitLab.font = TEXT_FONT_16;
    unitLab.textColor = COLOR_MAIN_GREY;
    [textFieldBackImage addSubview:unitLab];

    [unitLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@(-110));
        make.centerY.equalTo(textFieldBackImage.mas_centerY);
    }];

    allInvestBtn = [[XYButton alloc] initWithSubordinationButtonTitle:XYBString(@"str_financing_allInvest", @"全部出借") isUserInteractionEnabled:YES];
    allInvestBtn.titleLabel.font = TEXT_FONT_16;
    [allInvestBtn addTarget:self action:@selector(clickTheAllInvestBtn) forControlEvents:UIControlEventTouchUpInside];
    [textFieldBackImage addSubview:allInvestBtn];

    [allInvestBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(textFieldBackImage.mas_centerY);
        make.right.equalTo(@(-Margin_Length));
        make.height.equalTo(@40);
    }];

    UIView *horlineLine = [[UIView alloc] initWithFrame:CGRectZero];
    horlineLine.backgroundColor = COLOR_LINE;
    [textFieldBackImage addSubview:horlineLine];

    [horlineLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(textFieldBackImage.mas_centerY);
        make.height.equalTo(@(Margin_Length));
        make.right.equalTo(allInvestBtn.mas_left).offset(-Margin_Length);
        make.width.equalTo(@1);
    }];
}

- (void)creatTheCalculatorView {

    _incomeLab = [[UILabel alloc] init];
    _incomeLab.font = TEXT_FONT_12;
    _incomeLab.textColor = COLOR_AUXILIARY_GREY;
    NSString *str = XYBString(@"str_financing_firstMonthProfitZeroYuan", @"预期收益：首月0.00元");
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:str];
    [attrStr addAttributes:@{ NSForegroundColorAttributeName : COLOR_ORANGE } range:NSMakeRange(7, 4)];
    _incomeLab.attributedText = attrStr;
    [mainScroll addSubview:_incomeLab];

    [_incomeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@Margin_Length);
        make.top.equalTo(textFieldBackImage.mas_bottom).offset(10);
    }];

    XYButton *checkBtn = [[XYButton alloc] initWithSubordinationButtonTitle:XYBString(@"str_financing_checkMore", @"查看更多") isUserInteractionEnabled:YES];
    checkBtn.titleLabel.font = TEXT_FONT_12;
    checkBtn.titleLabel.textColor = COLOR_MAIN;
    [checkBtn addTarget:self action:@selector(ClickTheCheckBtn:) forControlEvents:UIControlEventTouchUpInside];
    [mainScroll addSubview:checkBtn];

    [checkBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_incomeLab.mas_right).offset(6);
        make.centerY.equalTo(_incomeLab.mas_centerY);
    }];

    calculatorView = [[UIView alloc] initWithFrame:CGRectZero];
    calculatorView.backgroundColor = COLOR_COMMON_WHITE;
    [mainScroll addSubview:calculatorView];

    [calculatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(mainScroll);
        make.width.equalTo(@(MainScreenWidth));
        make.top.equalTo(_incomeLab.mas_bottom).offset(23);
        make.height.equalTo(@(Cell_Height));
    }];

    [XYCellLine initWithTopLineAtSuperView:calculatorView];
    [XYCellLine initWithBottomLineAtSuperView:calculatorView];

    UILabel *ljtitleLab = [[UILabel alloc] initWithFrame:CGRectZero];
    ljtitleLab.font = TEXT_FONT_14;
    ljtitleLab.textColor = COLOR_MAIN_GREY;
    ljtitleLab.text = XYBString(@"str_financing_cashDeductionAuto", @"礼金自动抵扣");
    [calculatorView addSubview:ljtitleLab];

    [ljtitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@Margin_Length);
        make.top.equalTo(calculatorView.mas_top).offset(Margin_Length);
    }];

    UILabel *ljLab = [[UILabel alloc] initWithFrame:CGRectZero];
    ljLab.font = TEXT_FONT_14;
    ljLab.textColor = COLOR_MAIN_GREY;
    ljLab.text = XYBString(@"str_financing_zero_yuan", @"0.00元");
    ljLab.tag = 502;
    [calculatorView addSubview:ljLab];

    [ljLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@-Margin_Length);
        make.centerY.equalTo(ljtitleLab.mas_centerY);
    }];
}

- (void)creatTheInvestBtnView {

    self.nextBtn = [[ColorButton alloc]initWithFrame:CGRectMake(0, 0, MainScreenWidth - 30, Cell_Height) Title:XYBString(@"str_financing_sureInvest", @"确认出借")  ByGradientType:leftToRight];
    [self.nextBtn addTarget:self action:@selector(clickTheNextButton:) forControlEvents:UIControlEventTouchUpInside];
    [mainScroll addSubview:self.nextBtn];
    
    [self.nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(mainScroll.mas_left).offset(Margin_Length);
        make.top.equalTo(calculatorView.mas_bottom).offset(19);
        make.right.equalTo(mainScroll.mas_right).offset(-Margin_Length);
        make.width.equalTo(@(MainScreenWidth - 30));
        make.height.equalTo(@(Cell_Height));
    }];
    
    RTLabel *remaindLab = [[RTLabel alloc] initWithFrame:CGRectZero];
    remaindLab.font = TEXT_FONT_12;
    remaindLab.delegate = self;
    NSString *str = XYBString(@"str_financing_djqrbs", @"点击“确认出借”，即表示阅读并同意<font color='#4385f5' ><u color=clear><a href='bbgfwxy'>《步步高服务协议》</a></u></font>和<font color='#4385f5' ><u color=clear><a href='fxjss'>《风险警示书》</a></u></font>");
    remaindLab.text = str;
    remaindLab.textColor = COLOR_AUXILIARY_GREY;
    [mainScroll addSubview:remaindLab];
    
    float InfoViewHeight2 = [ToolUtil getLabelHightWithLabelStr:XYBString(@"str_financing_djqrbsStr", @"点击“确认出借”，即表示阅读并同意《步步高服务协议》和《风险警示书》") MaxSize:CGSizeMake(MainScreenWidth - 30, MainScreenHeight) AndFont:12.f LineSpace:6];
    
    [remaindLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(mainScroll.mas_left).offset(Margin_Length);
        make.top.equalTo(_nextBtn.mas_bottom).offset(22);
        make.right.equalTo(mainScroll.mas_right).offset(-Margin_Length);
        make.height.equalTo(@(InfoViewHeight2 + 6));
    }];
    
    UILabel *remaindLab2 = [[UILabel alloc] initWithFrame:CGRectZero];
    remaindLab2.font = TEXT_FONT_12;
    remaindLab2.textColor = COLOR_AUXILIARY_GREY;
    remaindLab2.text = XYBString(@"str_financing_hasRiskAndInvestShouldBePrudent", @"市场有风险，出借需谨慎");
    remaindLab2.textAlignment = NSTextAlignmentCenter;
    [mainScroll addSubview:remaindLab2];
    
    [remaindLab2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(mainScroll);
        make.width.equalTo(@(MainScreenWidth));
        make.top.equalTo(remaindLab.mas_bottom).offset(Margin_Length);
        make.bottom.equalTo(mainScroll.mas_bottom).offset(-Margin_Length);
    }];
    
    //1. 步步高的剩余可投为0，出借按钮置灰、投资金额不可编辑、全部出借按钮置灰 2. 若步步高为预定标，则全部出借按钮置灰，投资金额为预约金额，且不可编辑
    if (_info) {
        if (_info.restAmount <= 0) {
            self.nextBtn.isColorEnabled = NO;
            dustedMoneyTextField.enabled = NO;
            allInvestBtn.isEnabled = NO;
        }
        
        if (_isBookBid == YES) {
            dustedMoneyTextField.text = [Utility notRounding:[_info.restAmount doubleValue] afterPoint:0];
            dustedMoneyTextField.enabled = NO;
            allInvestBtn.isEnabled = NO;
        }
    }
}

- (void)rtLabel:(id)rtLabel didSelectLinkWithURL:(NSURL *)url {
    
    if ([url.description isEqualToString:@"bbgfwxy"]) {
        NSString *urlStr = [RequestURL getNodeJsH5URL:App_Bbg_Protocol_URL withIsSign:NO];
        WebviewViewController *webView = [[WebviewViewController alloc] initWithTitle:nil webUrlString:urlStr];
        [self.navigationController pushViewController:webView animated:YES];
        
    } else if ([url.description isEqualToString:@"fxjss"]) {
        NSString *requestUrl = [RequestURL getNodeJsH5URL:App_Risk_Warn_URL withIsSign:NO];
        WebviewViewController *webView = [[WebviewViewController alloc] initWithTitle:nil webUrlString:requestUrl];
        [self.navigationController pushViewController:webView animated:YES];
    }
}

#pragma mark - 设置刷新的方法

- (void)setupRefresh {
    mainScroll.header = self.gifHeader3;
}

- (void)headerRereshing {
    [self setRequest];
    [self performSelector:@selector(endRefresh) withObject:nil afterDelay:1.0f];
}

- (void)endRefresh {
    [mainScroll.header endRefreshing];
}

#pragma mark - 点击事件 和 响应事件

- (void)pushChargeView:(NSNotification *)notify {
    ChargeViewController *chargeViewController = [[ChargeViewController alloc] initWithIdetifer:NO];
    [self.navigationController pushViewController:chargeViewController animated:YES];
}

- (void)chargeSuccess {
    [self showPromptTip:XYBString(@"str_common_chargeSuccess", @"充值成功")];
}

////当键盘出现或改变时调用
//- (void)keyboardWillShow:(NSNotification *)aNotification {
//    //获取键盘的高度
//    NSDictionary *userInfo = [aNotification userInfo];
//    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
//    CGRect keyboardRect = [aValue CGRectValue];
//    keyBoardHight = keyboardRect.size.height;
//
//    mainScroll.bounces = NO;
//    mainScroll.scrollEnabled = NO;
//    mainScroll.contentSize = CGSizeMake(MainScreenWidth, MainScreenHeight - 55 + 70);
//    mainScroll.contentOffset = CGPointMake(0, 177);
//
//    [UIView animateWithDuration:0.3 animations:^{
//        bottomView.frame = CGRectMake(0, MainScreenHeight - 55 - keyBoardHight, MainScreenWidth, 55);
//        [bottomView mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.left.right.equalTo(self.view);
//            make.bottom.equalTo(self.view.mas_bottom).offset(-keyBoardHight);
//            make.height.equalTo(@(55));
//        }];
//    }
//                     completion:nil];
//}

////当键退出时调用
//- (void)keyboardWillHide:(NSNotification *)aNotification {
//    mainScroll.bounces = YES;
//    mainScroll.scrollEnabled = YES;
//    mainScroll.contentSize = CGSizeMake(MainScreenWidth, 10);
//    mainScroll.contentOffset = CGPointMake(0, 0);
//
//    [UIView animateWithDuration:0.3 animations:^{
//        bottomView.frame = CGRectMake(0, MainScreenHeight - 55, MainScreenWidth, 55);
//        [bottomView mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.left.right.bottom.equalTo(self.view);
//            make.height.equalTo(@(55));
//        }];
//    }
//                     completion:nil];
//}

- (void)clickBackBtn:(id)sender {
    [dustedMoneyTextField resignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)ClickTheCheckBtn:(XYButton *)button {
    [dustedMoneyTextField resignFirstResponder];
    CalculatorViewController *calculatorVC = [[CalculatorViewController alloc] init];
    calculatorVC.projectId = _info.projectId;
    calculatorVC.moneyStr = dustedMoneyTextField.text;
    [self.navigationController pushViewController:calculatorVC animated:YES];
}

- (void)clickTheSubtractBtn:(UIButton *)btn {
    UIButton *addBtn = (UIButton *) [self.view viewWithTag:507];
    addBtn.userInteractionEnabled = YES;
    addBtn.backgroundColor = COLOR_COMMON_CLEAR;
    UITextField *field = (UITextField *) [self.view viewWithTag:505];
    mouthNum = mouthNum - 1;

    if (mouthNum <= 1) {
        btn.userInteractionEnabled = NO;
        btn.backgroundColor = COLOR_LIGHTGRAY_BUTTONDISABLE;
        mouthNum = 1;
    }
    field.text = [NSString stringWithFormat:@"%d", mouthNum];
    [self setRequest];
}

- (void)clickTheChargeButton:(id)sender {
    [dustedMoneyTextField resignFirstResponder];
    ChargeViewController *chargeViewController = [[ChargeViewController alloc] initWithIdetifer:NO];
    [self.navigationController pushViewController:chargeViewController animated:YES];
}

- (void)clickTheNextButton:(id)sender {
    [dustedMoneyTextField resignFirstResponder];
    User *user = [UserDefaultsUtil getUser];

    //没有进行实名认证，进入实名认证页面
    if (![user.isIdentityAuth boolValue]) {
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
//                                                            message:XYBString(@"str_common_noRealNameAuthentication", @"您尚未实名认证，要先充值实名认证哦")
//                                                           delegate:self
//                                                  cancelButtonTitle:XYBString(@"str_common_cancel", @"取消")
//                                                  otherButtonTitles:XYBString(@"str_common_goToCharge", @"去充值"), nil];
//        alertView.tag = 1000;
//        [alertView show];
        
        VerifyNameViewController *verifyVC = [[VerifyNameViewController alloc] initWithType:1];
        [self.navigationController pushViewController:verifyVC animated:YES];
        return;
    }

    //已经实名认证过，就直接判断金额
    if ([user.isIdentityAuth boolValue]) {
        BOOL isScuess = [CheckTheInvestMoney checkTheBbgInvestMoney:dustedMoneyTextField.text preInvest:mainDic prouduct:self.info];

        if (isScuess) {
            [self payTheTouIDFinancing:dustedMoneyTextField.text];
        }
    }
}


/**
 *  步步高全部出借
 */
- (void)clickTheAllInvestBtn {

    double canUseAmount = [[UserDefaultsUtil getUser].usableAmount doubleValue]; //可用金额
    if ([mainDic objectForKey:@"rewardAmount"]) {
        canUseAmount = canUseAmount + [[mainDic objectForKey:@"rewardAmount"] doubleValue]; //可用金额 = 可用金额+礼金
    }
    double permitAmount = [self.info.restAmount doubleValue]; //可投金额

    /**
     *  可投金额>=100时，分两种情况分析判断：1.可用金额>=可投金额时，全部出借显示可投金额；2.可用金额<可投金额时，分两种情况：(2.1 可用金额>=100时，显示可用余额取整 2.2 可用余额<100时，显示“0.00”)
     */
    if (permitAmount >= 100) {

        if (canUseAmount >= permitAmount) {
            dustedMoneyStr = [NSString stringWithFormat:@"%zi", (int) permitAmount / 100 * 100];
        } else {
            if (canUseAmount >= 100) {
                dustedMoneyStr = [NSString stringWithFormat:@"%d", (int) canUseAmount / 100 * 100]; //可用金额取整
            } else {
                dustedMoneyStr = XYBString(@"str_financing_zero", @"0.00");
            }
        }
    }

    /**
     *  可投金额<100时，分两种情况分析判断：1.可用金额 > 可投金额时，全部出借显示可投金额；2.可用金额<可投金额时，全部出借显示“0.00”
     */
    if (permitAmount < 100) {
        if (canUseAmount >= permitAmount) {
            dustedMoneyStr = [NSString stringWithFormat:@"%.2f", permitAmount];
        } else {
            dustedMoneyStr = XYBString(@"str_financing_zero", @"0.00");
        }
    }

    dustedMoneyTextField.text = dustedMoneyStr;
    [self doaction];
}

- (void)doaction {

    if (dustedMoneyTextField.text.length > 0) {
        if (![Utility isValidateinvestNum:dustedMoneyTextField.text]) {

            [HUD showPromptViewWithToShowStr:XYBString(@"str_financing_wrong_amount", @"出借金额填写错误") autoHide:YES afterDelay:1.0 userInteractionEnabled:YES];
            return;
        }
    }

    NSRange range = [dustedMoneyTextField.text rangeOfString:@"."];
    if (range.length > 0) {
        NSArray *array = [dustedMoneyTextField.text componentsSeparatedByString:@"."];

        NSString *pointStr = [array objectAtIndex:1];
        if (pointStr.length > 2) {
            pointStr = [pointStr substringToIndex:2];
        }
        dustedMoneyTextField.text = [NSString stringWithFormat:@"%@.%@", [array objectAtIndex:0], pointStr];
    }

    if (dustedMoneyTextField.text.length > 8) {
        dustedMoneyTextField.text = [dustedMoneyTextField.text substringToIndex:8];
    }

    dustedMoneyStr = dustedMoneyTextField.text;
    BOOL isNumber = [Utility isValidateNumber:dustedMoneyTextField.text];

    [self requestBbgPreIncomeWebServiceWithParam:@{
        @"userId" : [UserDefaultsUtil getUser].userId,
        @"projectId" : [NSString stringWithFormat:@"%@", _info.projectId],
        @"amount" : isNumber == YES ? dustedMoneyStr : @"0",
        @"month" : [NSNumber numberWithInt:mouthNum]
    }];

    if (dustedMoneyTextField.text.length > 0) {
        self.nextBtn.isColorEnabled = YES;
    } else {
        self.nextBtn.isColorEnabled = NO;
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 页面刷新UI

- (void)reoladData:(BbgPreIncomeResponseModel *)model {

    UILabel *lab2 = (UILabel *) [self.view viewWithTag:502]; //礼金
    UILabel *lab3 = (UILabel *) [self.view viewWithTag:503]; //实际支付
    UILabel *lab4 = (UILabel *) [self.view viewWithTag:504]; //历史收益

    if (model.income == 0) {
        NSString *str = XYBString(@"str_financing_firstMonthProfitZeroYuan", @"预期收益：首月0.00元");
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:str];
        [attrStr addAttributes:@{ NSForegroundColorAttributeName : COLOR_ORANGE } range:NSMakeRange(7, 4)];
        _incomeLab.attributedText = attrStr;
    } else {
        NSString *str = [NSString stringWithFormat:XYBString(@"str_financing_firstMonthProfitSomeYuan", @"预期收益：首月%@元"), [Utility replaceTheNumberForNSNumberFormatter:[NSString stringWithFormat:@"%.2f", model.income]]]; //首月预期收益
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:str];
        [attrStr addAttributes:@{ NSForegroundColorAttributeName : COLOR_ORANGE } range:NSMakeRange(7, str.length - 7 - 1)];
        _incomeLab.attributedText = attrStr;
    }

    double dustedMoney = [dustedMoneyTextField.text doubleValue];
    NSString *actualStr = [Utility replaceTheNumberForNSNumberFormatter:[NSString stringWithFormat:@"%.2f", dustedMoney]];
    if (dustedMoney <= 0) {
        actualStr = XYBString(@"str_financing_zero", @"0.00");
    }
    lab3.text = [NSString stringWithFormat:XYBString(@"str_financing_¥_some", @"¥%@"), actualStr];
    
    if (model.rewardAmount != 0) {
        double dustedMoney = [dustedMoneyTextField.text doubleValue];

        NSString *rewardAmountStr = [Utility replaceTheNumberForNSNumberFormatter:[NSString stringWithFormat:@"%.2f", model.rewardAmount]];
        if (dustedMoney < model.rewardAmount) {
            rewardAmountStr = [Utility replaceTheNumberForNSNumberFormatter:[NSString stringWithFormat:@"%.2f", dustedMoney]];
        }
        if ([rewardAmountStr doubleValue] <= 0) {
            rewardAmountStr = XYBString(@"str_financing_zero", @"0.00");
            lab2.text = [NSString stringWithFormat:XYBString(@"str_financing_some_yuan", @"%@元"), rewardAmountStr];

        } else {
            lab2.text = [NSString stringWithFormat:XYBString(@"str_financing_ljzddk_some", @"-%@元"), rewardAmountStr];
        }
    } else {
        lab2.text = XYBString(@"str_financing_zero_yuan", @"0.00元");
    }
    
    NSString *investStr = [NSString stringWithFormat:@"%.2f", model.income];
    investStr = [Utility replaceTheNumberForNSNumberFormatter:investStr];
    if ([investStr doubleValue] <= 0) {
        investStr = XYBString(@"str_financing_zero", @"0.00");
    }
    lab4.text = [NSString stringWithFormat:XYBString(@"str_financing_some_yuan", @"%@元"), investStr];
}

#pragma mark - 指纹支付

/**
 *  指纹支付
 *
 *  @param moneyStr 输入金额
 */
- (void)payTheTouIDFinancing:(NSString *)moneyStr {
    //验证是否支持TouID
    [[VerificationTouch shared] isSupportTouch:^(XybTouIDVerification touchType) {

        if (touchType == NotSupportedTouID) {

            [self payTheFinancing:moneyStr];

        } else if (touchType == YesSupportedTouID) {
            if (![[UserDefaultsUtil getUser].isTradePassword boolValue]) { //是否设置交易密码

                [self payTheFinancing:moneyStr];

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
                                    [self requestBbgInvestWebServiceWithParam:@{
                                        @"userId" : [UserDefaultsUtil getUser].userId,
                                        @"projectId" : _info.projectId,
                                        @"amount" : dustedMoneyTextField.text,
                                        @"tradePassword" : sigPassWord,
                                        @"deviceId" : [OpenUDID value],
                                        @"paymentMode" : @"1",
                                        @"timestamp" : [DateTimeUtil getCurrentTime]
                                    }];
                                });
                            } break;
                            case TouIDVerficationFail: //验证失败
                            {
                                dispatch_async(dispatch_get_main_queue(), ^{

                                    [HUD showPromptViewWithToShowStr:XYBString(@"str_financing_fingerprintTestFailureNextEnterPasswort", @"指纹验证失败，请输入交易密码") autoHide:YES afterDelay:1.0 userInteractionEnabled:YES];
                                    [self performSelector:@selector(payTheFinancingInfo:) withObject:moneyStr afterDelay:1.2f];
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
                                    [self payTheFinancing:moneyStr];
                                });
                            } break;
                            case UserNotInputTouID: //用户未录入TouID
                            {
                                dispatch_async(dispatch_get_main_queue(), ^{

                                    [UserDefaultsUtil clearEncryptionData:[NSString stringWithFormat:@"%@", [UserDefaultsUtil getUser].userId]];
                                    [self payTheFinancing:moneyStr];

                                });
                            } break;
                            default:
                                break;
                        }

                    }];

                } else {
                    [self payTheFinancing:moneyStr];
                }
            }
        } else if (touchType == UserNotInputTouID) {
            [UserDefaultsUtil clearEncryptionData:[NSString stringWithFormat:@"%@", [UserDefaultsUtil getUser].userId]];
            [self payTheFinancing:moneyStr];
            return;
        }
    }];
}

- (void)payTheFinancingInfo:(NSString *)moneyStr {
    [self payTheFinancing:moneyStr];
}

- (void)payTheFinancing:(NSString *)moneyStr {

    AppDelegate *app = (AppDelegate *) [UIApplication sharedApplication].delegate;
    tradePayView = [TradePasswordView shareInstancesaidView];
    [app.window addSubview:tradePayView];

    [tradePayView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(app.window);
    }];

    User *user = [UserDefaultsUtil getUser];
    __weak BbgInvestViewController *investVC = self;
    tradePayView.clickSureButton = ^(NSString *payStr) {
        [investVC requestDoInvest:payStr];

    };

    tradePayView.clickForgetButton = ^{
        if (![user.isIdentityAuth boolValue]) {
            //            UserDetailRealNamesViewController   *realNameVC  = [[UserDetailRealNamesViewController alloc] init];
            //            [investVC.navigationController pushViewController:realNameVC animated:YES];

            ChargeViewController *chargeViewController = [[ChargeViewController alloc] initWithIdetifer:NO];
            chargeViewController.hidesBottomBarWhenPushed = YES;
            [investVC.navigationController pushViewController:chargeViewController animated:YES];
            return;
        }
        ChangePayPasswordViewController *payPassWordVC = [[ChangePayPasswordViewController alloc] init];
        [investVC.navigationController pushViewController:payPassWordVC animated:YES];
    };
}

#pragma mark - AlertView Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {

    switch (alertView.tag) {
        case 1000: //去充值
        {
            if (buttonIndex == 1) {
                ChargeViewController *chargeViewController = [[ChargeViewController alloc] initWithIdetifer:NO];
                chargeViewController.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:chargeViewController animated:YES];
            }
        } break;
        case 1001: //设置 指纹交易
        {
            if (buttonIndex == 1) {

                TouchIdentityAuthViewController *touchIdentityAuth = [[TouchIdentityAuthViewController alloc] init];
                [self.navigationController pushViewController:touchIdentityAuth animated:YES];
            }
        } break;
        default:
            break;
    }
}

#pragma mark - Webservice
#pragma mark 1.步步高历史收益查询 Webservice

- (void)setRequest {

    dustedMoneyStr = dustedMoneyTextField.text;
    BOOL isNumber = [Utility isValidateNumber:dustedMoneyTextField.text];

    [self requestBbgPreIncomeWebServiceWithParam:@{
        @"userId" : [UserDefaultsUtil getUser].userId,
        @"projectId" : [NSString stringWithFormat:@"%@", _info.projectId],
        @"amount" : isNumber == YES ? dustedMoneyStr : @"0",
        @"month" : [NSNumber numberWithInt:mouthNum]
    }];
}

- (void)requestBbgPreIncomeWebServiceWithParam:(NSDictionary *)param {
    NSString *requestURL = [RequestURL getRequestURL:BbgPreIncomeCheckURL param:param];
    [WebService postRequest:requestURL param:param JSONModelClass:[BbgPreIncomeResponseModel class]

        Success:^(AFHTTPRequestOperation *operation, id responseObject) {

            BbgPreIncomeResponseModel *responseModel = responseObject;
            NSDictionary *dict = [responseModel toDictionary];
            if (mainDic) {
                [mainDic removeAllObjects];
            }
            [mainDic addEntriesFromDictionary:dict];
            [self reoladData:responseModel];

            User *user = [UserDefaultsUtil getUser];
            user.usableAmount = [Utility stringrangeStr:[NSString stringWithFormat:@"%.2f", responseModel.usableAmount]];
            [UserDefaultsUtil setUser:user];

            UILabel *lab = (UILabel *) [self.view viewWithTag:2005];
            if ([[UserDefaultsUtil getUser].usableAmount doubleValue] != 0) {
                NSString *usableAmount = [Utility replaceTheNumberForNSNumberFormatter:[NSString stringWithFormat:@"%.2f", [[UserDefaultsUtil getUser].usableAmount doubleValue]]];
                lab.text = [NSString stringWithFormat:XYBString(@"str_financing_some_yuan", @"%@元"), usableAmount];
            } else {
                lab.text = XYBString(@"str_financing_zero_yuan", @"0.00元");
            }

        }

        fail:^(AFHTTPRequestOperation *operation, NSString *errorMessage) {
            [self hideLoading];
            [self showPromptTip:errorMessage];
        }

    ];
}

#pragma mark 2.步步高出借 Webservice
- (void)requestDoInvest:(NSString *)payStr {
    NSDictionary *contentDic = nil;
    contentDic = @{
        @"userId" : [UserDefaultsUtil getUser].userId,
        @"projectId" : _info.projectId,
        @"amount" : dustedMoneyTextField.text,
        @"tradePassword" : payStr
    };

    [self requestBbgInvestWebServiceWithParam:contentDic];
}

- (void)requestBbgInvestWebServiceWithParam:(NSDictionary *)params {

    NSString *requestURL = [RequestURL getRequestURL:BbgInvestURL param:params];
    [self showTradeLoadingOnAlertView];
    [WebService postRequest:requestURL param:params JSONModelClass:[DqbAndXtbInvestResponseModel class]

        Success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [self hideLoading];
            [tradePayView removeFromSuperview];
            DqbAndXtbInvestResponseModel *responseModel = responseObject;
            User *user = [UserDefaultsUtil getUser];
            if (![user.isTradePassword boolValue]) {
                user.isTradePassword = @"1";
            }
            [UserDefaultsUtil setUser:user];

            [[NSNotificationCenter defaultCenter] postNotificationName:@"investedSuccessNotificaton" object:nil];
            IncomeStatusViewController *incomeStatusViewController = [[IncomeStatusViewController alloc] init];
            incomeStatusViewController.navItem.title = XYBString(@"str_common_investSuccess", @"出借结果");
            incomeStatusViewController.moneyString = dustedMoneyTextField.text;
            incomeStatusViewController.fromType = self.fromType;
            incomeStatusViewController.isBookBid = self.isBookBid;
            incomeStatusViewController.returnDataDic = [NSDictionary dictionaryWithDictionary:responseModel.toDictionary];
            incomeStatusViewController.fromTag = XYBString(@"str_common_bbg", @"步步高");
            [self.navigationController pushViewController:incomeStatusViewController animated:YES];
        }

        fail:^(AFHTTPRequestOperation *operation, NSString *errorMessage) {
            [self hideLoading];
            if ([params objectForKey:@"paymentMode"]) {

                [self showPromptTip:errorMessage];
            } else {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"ERRORNOTIFICATION" object:errorMessage];
            }

        }

    ];
}
@end
