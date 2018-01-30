//
//  XtbInvestViewController.m
//  Ixyb
//
//  Created by dengjian on 2017/9/16.
//  Copyright © 2017年 xyb. All rights reserved.
//

#import "XtbInvestViewController.h"
#import "Utility.h"
#import "TradePasswordView.h"
#import "ChargeViewController.h"
#import "RequestURL.h"
#import "XYWebViewController.h"
#import "MyCouponsViewController.h"
#import "CheckTheInvestMoney.h"
#import "VerificationTouch.h"
#import "HBRSAHandler.h"
#import "OpenUDID.h"
#import "ChangePayPasswordViewController.h"
#import "TouchIdentityAuthViewController.h"
#import "WebService.h"
#import "IncomeStatusViewController.h"
#import "RTLabel.h"
#import "VerifyNameViewController.h"

#define BACKVIEW_TAG 1000

@interface XtbInvestViewController () <RTLabelDelegate> {
    
    UIScrollView *mainScroll;
    
    UILabel *titleLab;          //产品名称
    UILabel *rateLab;           //年化收益率
    UILabel *standardLab;       //期限
    UILabel *restLab;           //剩余可投金额
    
    UIView *usableAmountView;
    UIImageView *textFieldBackImage;
    XYTextField *dustedMoneyTextField;   //金额输入框
    XYButton *allInvestBtn;              //全投按钮
    
    UIView *investDetailView;
    UILabel *couponsDetailLab;  //优惠券详情
    UILabel *profitLab;         //礼金自动抵扣
    
    NSMutableDictionary *mainDic;
    NSString *projectTypeStr;
    NSString *productIdStr;
    
    TradePasswordView *tradePayView;
    CGFloat keyBoardHight; //键盘的高度
}

@property (nonatomic, strong) ColorButton *nextButton;
@property (nonatomic, copy) NSString *couponsID;    //优惠券的ID号
@property (nonatomic, assign) BOOL usableCard;      //是否有可用的优惠券
@property (nonatomic, assign) BOOL couponsAlert;    //若弹起优惠券未使用弹窗，则记录状态

@end

@implementation XtbInvestViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [UMengAnalyticsUtil beginLogPageView:NSStringFromClass([self class])];
    
    if ([Utility shareInstance].isLogin) {
        [self setRequestForDetail];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [UMengAnalyticsUtil endLogPageView:NSStringFromClass([self class])];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    projectTypeStr = @"BID";
    mainDic = [[NSMutableDictionary alloc] init];
    [self setNav];
    [self creatTheMainScrollView];
    [self createTheTopUI];
    [self creatTheUsableAmountView];
    [self creatTheInvestView];
    [self creatTheInvestDetailView];
    [self creatTheInvestBtnView];
    
    [self setupRefresh];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(chargeSuccess) name:@"chargeSuccessNotification" object:nil];
    //增加监听，当键盘出现或改变时收出消息
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    //增加监听，当键退出时收出消息
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark - 创建UI

- (void)setNav {

    self.navItem.title = XYBString(@"str_message_finance", @"出借");
    self.navItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(clickBackBtn:)];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushChargeView:) name:@"CHARGE" object:nil];
}

- (void)creatTheMainScrollView {
    mainScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight - 55)];
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
    backView.layer.cornerRadius  = 9.f;
    backView.tag = BACKVIEW_TAG;
    [mainScroll addSubview:backView];
    
    titleLab = [[UILabel alloc] initWithFrame:CGRectZero];
    titleLab.font = TEXT_FONT_14;
    titleLab.textColor = COLOR_MAIN_GREY;
    titleLab.text = XYBString(@"str_common_xtb", @"信投宝");
    [backView addSubview:titleLab];
    
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backView.mas_left).offset(Margin_Length);
        make.top.equalTo(backView.mas_top).offset(Margin_Length);
    }];
    
    rateLab = [[UILabel alloc] initWithFrame:CGRectZero];
    rateLab.textAlignment = NSTextAlignmentLeft;
    NSString *rateStr = @"0";
    NSMutableAttributedString *mutAttStr2 = [[NSMutableAttributedString alloc] initWithString:rateStr];
    rateLab.attributedText = mutAttStr2;
    [backView addSubview:rateLab];
    
    [rateLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleLab.mas_left).offset(0);
        make.top.equalTo(titleLab.mas_bottom).offset(17);
    }];
    
    UILabel *expectedLab = [[UILabel alloc] initWithFrame:CGRectZero];
    expectedLab.font = TEXT_FONT_12;
    expectedLab.textColor = COLOR_AUXILIARY_GREY;
    expectedLab.text = XYBString(@"str_xtb_rate", @"年化借款利率");
    expectedLab.textAlignment = NSTextAlignmentLeft;
    [backView addSubview:expectedLab];
    
    [expectedLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(rateLab.mas_left);
        make.top.equalTo(rateLab.mas_bottom).offset(5);
    }];
    
    standardLab = [[UILabel alloc] initWithFrame:CGRectZero];
    standardLab.font = TEXT_FONT_14;
    standardLab.textColor = COLOR_MAIN_GREY;
    standardLab.text = [NSString stringWithFormat:XYBString(@"str_financing_someMonth", @"%@个月"),@"0"];
    [backView addSubview:standardLab];
    
    [standardLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backView.mas_left).offset((MainScreenWidth - 30) *2/5);
        make.centerY.equalTo(rateLab.mas_centerY).offset(0);
    }];
    
    restLab = [[UILabel alloc] initWithFrame:CGRectZero];
    restLab.font = TEXT_FONT_12;
    restLab.textColor = COLOR_AUXILIARY_GREY;
    restLab.text = [NSString stringWithFormat:XYBString(@"str_financing_restMoneyBlow", @"剩余可投:%@元"),@"0"];
    [backView addSubview:restLab];
    
    [restLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(expectedLab.mas_top).offset(0);
        make.left.equalTo(standardLab.mas_left).offset(0);
    }];
    
    if (_info) {
        
        titleLab.text = [NSString stringWithFormat:@"%@", _info.title];
        
        //年化借款利率
        NSString *rateStr = [Utility rateReplaceTheNumberForNSNumberFormatter:[NSString stringWithFormat:@"%.2f", [_info.baseRate doubleValue] * 100]];
        rateStr = [rateStr stringByAppendingString:XYBString(@"str_financing_percentSymbol", @"%")];
        
        NSMutableAttributedString *mutAttStr2 = [[NSMutableAttributedString alloc] initWithString:rateStr];
        [mutAttStr2 addAttributes:@{ NSFontAttributeName : FONT_TEXT_20,
                                     NSForegroundColorAttributeName : COLOR_ORANGE } range:NSMakeRange(0, rateStr.length - 1)];
        [mutAttStr2 addAttributes:@{ NSFontAttributeName : NORMAL_TEXT_FONT_15,
                                     NSForegroundColorAttributeName : COLOR_ORANGE } range:NSMakeRange(rateStr.length - 1,1)];
        rateLab.attributedText = mutAttStr2;
        
        //期限
        standardLab.text =  _info.monthes2ReturnStr;
        
        //剩余可投
        if ([_info.bidRequestBal doubleValue] <= 0) {
            restLab.text = [NSString stringWithFormat:XYBString(@"str_financing_restMoneyBlow", @"剩余可投:%@元"),@"0.00"];
        }
        
        if ([_info.bidRequestBal doubleValue] > 0) {
            restLab.text = [NSString stringWithFormat:XYBString(@"str_financing_restMoneyBlow", @"剩余可投:%@元"),[Utility replaceTheNumberForNSNumberFormatter:_info.bidRequestBal]];
        }
    }
}

- (void)creatTheUsableAmountView {
    
    usableAmountView = [[UIView alloc] initWithFrame:CGRectZero];
    [mainScroll addSubview:usableAmountView];
    
    UIView *topView = [mainScroll viewWithTag:BACKVIEW_TAG];
    [usableAmountView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topView.mas_bottom).offset(0);
        make.left.right.equalTo(mainScroll);
        make.width.equalTo(@(MainScreenWidth));
        make.height.equalTo(@45);
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
    usableAmountLab.tag = 503;
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
        make.top.equalTo(usableAmountView.mas_bottom);
        make.width.equalTo(@(MainScreenWidth));
    }];
    
    dustedMoneyTextField = [[XYTextField alloc] initWithIsEnabledNoPaste:YES];
    dustedMoneyTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    dustedMoneyTextField.placeholder = XYBString(@"str_financing_50YuanQT", @"50元起投");
    dustedMoneyTextField.font = TEXT_FONT_16;
    dustedMoneyTextField.keyboardType = UIKeyboardTypeDecimalPad;
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
    
    UILabel *calculatorLab = [[UILabel alloc] initWithFrame:CGRectZero];
    calculatorLab.text = XYBString(@"str_financing_expectProfit", @"预期收益");
    calculatorLab.font = TEXT_FONT_12;
    calculatorLab.textColor = COLOR_AUXILIARY_GREY;
    [mainScroll addSubview:calculatorLab];
    
    [calculatorLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@Margin_Length);
        make.top.equalTo(textFieldBackImage.mas_bottom).offset(10);
    }];
    
    profitLab = [[UILabel alloc] init];
    profitLab.font = TEXT_FONT_12;
    profitLab.textColor = COLOR_ORANGE;
    profitLab.text = XYBString(@"str_financing_zero_yuan", @"0.00元");
    [mainScroll addSubview:profitLab];
    
    [profitLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(calculatorLab.mas_right).offset(6);
        make.centerY.equalTo(calculatorLab.mas_centerY);
    }];
}

- (void)creatTheInvestDetailView {
    
    investDetailView = [[UIView alloc] init];
    investDetailView.backgroundColor = COLOR_COMMON_WHITE;
    [mainScroll addSubview:investDetailView];
    
    [investDetailView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(mainScroll);
        make.top.equalTo(profitLab.mas_bottom).offset(23);
        make.width.equalTo(@(MainScreenWidth));
    }];
    
    [XYCellLine initWithTopLineAtSuperView:investDetailView];
    [XYCellLine initWithBottomLineAtSuperView:investDetailView];
    
    //优惠券按钮
    XYButton *couponsBtn = [[XYButton alloc] initWithGeneralBtnTitle:nil titleColor:nil isUserInteractionEnabled:YES];
    [couponsBtn addTarget:self action:@selector(clickTheCouponsButton:) forControlEvents:UIControlEventTouchUpInside];
    [investDetailView addSubview:couponsBtn];
    
    [couponsBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(investDetailView);
        make.top.equalTo(investDetailView.mas_top).offset(Line_Height);
        make.height.equalTo(@(Cell_Height));
    }];
    
    [XYCellLine initWithBottomLine_2_AtSuperView:couponsBtn];
    
    UILabel *titleLab1 = [[UILabel alloc] init];
    titleLab1.font = TEXT_FONT_14;
    titleLab1.textColor = COLOR_AUXILIARY_GREY;
    titleLab1.text = XYBString(@"str_financing_Coupons", @"优惠券");
    [couponsBtn addSubview:titleLab1];
    
    [titleLab1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Margin_Length));
        make.centerY.equalTo(couponsBtn.mas_centerY);
    }];
    
    UIImageView *arrowImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cell_arrow"]];
    arrowImage.userInteractionEnabled = NO;
    [couponsBtn addSubview:arrowImage];
    
    [arrowImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(couponsBtn.mas_right).offset(-Margin_Length);
        make.centerY.equalTo(couponsBtn.mas_centerY);
    }];
    
    //优惠券详情label
    couponsDetailLab = [[UILabel alloc] init];
    couponsDetailLab.font = TEXT_FONT_14;
    couponsDetailLab.textColor = COLOR_AUXILIARY_GREY;
    couponsDetailLab.text = XYBString(@"str_financing_pleaseCheckCoupons", @"请选择优惠券");
    couponsDetailLab.userInteractionEnabled = NO;
    [couponsBtn addSubview:couponsDetailLab];
    
    [couponsDetailLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(arrowImage.mas_left).offset(0);
        make.centerY.equalTo(arrowImage);
    }];
    
    //礼金自动抵扣
    UILabel *cashLab = [[UILabel alloc] init];
    cashLab.font = TEXT_FONT_14;
    cashLab.textColor = COLOR_AUXILIARY_GREY;
    cashLab.text = XYBString(@"str_financing_cashDeductionAuto", @"礼金自动抵扣");
    [investDetailView addSubview:cashLab];
    
    [cashLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(investDetailView.mas_left).offset(Margin_Length);
        make.top.equalTo(couponsBtn.mas_bottom).offset(Margin_Length);
        make.bottom.equalTo(investDetailView.mas_bottom).offset(-Margin_Length);
    }];
    
    UILabel *cashDetailLab = [[UILabel alloc] init];
    cashDetailLab.font = TEXT_FONT_14;
    cashDetailLab.textColor = COLOR_MAIN_GREY;
    cashDetailLab.text = XYBString(@"str_financing_zero_yuan", @"0.00元");
    cashDetailLab.tag = 501;
    [investDetailView addSubview:cashDetailLab];
    
    [cashDetailLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(arrowImage);
        make.top.equalTo(couponsBtn.mas_bottom).offset(Margin_Length);
    }];
}

- (void)creatTheInvestBtnView {
    
    _nextButton =  [[ColorButton alloc]initWithFrame:CGRectMake(0, 0, MainScreenWidth - 30, Cell_Height) Title:XYBString(@"str_financing_sureInvest", @"确认出借")  ByGradientType:leftToRight];
    [_nextButton addTarget:self action:@selector(clickTheNextButton:) forControlEvents:UIControlEventTouchUpInside];
    _nextButton.isColorEnabled = NO;
    [mainScroll addSubview:_nextButton];
    
    [_nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(mainScroll.mas_left).offset(Margin_Length);
        make.top.equalTo(investDetailView.mas_bottom).offset(19);
        make.right.equalTo(mainScroll.mas_right).offset(-Margin_Length);
        make.width.equalTo(@(MainScreenWidth - 30));
        make.height.equalTo(@(Cell_Height));
    }];
    
    RTLabel *remaindLab = [[RTLabel alloc] initWithFrame:CGRectZero];
    remaindLab.font = TEXT_FONT_12;
    remaindLab.delegate = self;
    NSString *protocolStr = XYBString(@"str_financing_xtbjkxy",@"点击“确认出借”，即表示阅读并同意<font color='#0ab0ef' ><u color=clear><a href='jkxy'>《借款协议》</a></u></font>和<font color='#0ab0ef' ><u color=clear><a href='fxjss'>《风险警示书》</a></u></font>");
    remaindLab.text = protocolStr;
    remaindLab.textColor = COLOR_AUXILIARY_GREY;
    [mainScroll addSubview:remaindLab];
    
    float InfoViewHeight = [ToolUtil getLabelHightWithLabelStr:XYBString(@"str_financing_jkxystring",@"点击“确认出借”，即表示阅读并同意《借款协议》和《风险警示书》") MaxSize:CGSizeMake(MainScreenWidth - 30, MainScreenHeight) AndFont:12.f LineSpace:6];
    
    [remaindLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(mainScroll.mas_left).offset(Margin_Length);
        make.top.equalTo(_nextButton.mas_bottom).offset(22);
        make.right.equalTo(mainScroll.mas_right).offset(-Margin_Length);
        make.height.equalTo(@(InfoViewHeight + 6));
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
    
    //信投保的剩余可投为0，出借按钮置灰
    if (_info) {
        if (_info.bidRequestBal <= 0) {
            _nextButton.isColorEnabled = NO;
            dustedMoneyTextField.enabled = NO;
            allInvestBtn.isEnabled = NO;
        }
    }
}

#pragma mark - 设置刷新的方法

- (void)setupRefresh {
    mainScroll.header = self.gifHeader3;
}

- (void)headerRereshing {
    [self setRequestForDetail];
    [self performSelector:@selector(endRefresh) withObject:nil afterDelay:1.0f];
}

- (void)endRefresh {
    [mainScroll.header endRefreshing];
}

#pragma mark - 刷新界面UI

- (void)reloadDataTheInvestDetailView:(DqbAndXtbResponseModel *)model {

    double dustedMoney = [dustedMoneyTextField.text doubleValue];
    NSString *actualStr = [Utility replaceTheNumberForNSNumberFormatter:[NSString stringWithFormat:@"%.2f", dustedMoney]];
    if (dustedMoney <= 0) {
        actualStr = XYBString(@"str_financing_zero", @"0.00");
    }
    
    UILabel *lab2 = (UILabel *) [self.view viewWithTag:501];
    UILabel *lab3 = (UILabel *) [self.view viewWithTag:502];
    UILabel *lab4 = (UILabel *) [self.view viewWithTag:503];
    
    lab3.text = [NSString stringWithFormat:@"¥%@", actualStr];
    if ([model.usableAmount doubleValue] != 0) {
        NSString *usableAmount = [Utility replaceTheNumberForNSNumberFormatter:[NSString stringWithFormat:@"%.2f", [model.usableAmount doubleValue]]];
        lab4.text = [NSString stringWithFormat:XYBString(@"str_financing_some_yuan", @"%@元"), usableAmount];
    } else {
        lab4.text = XYBString(@"str_financing_zero_yuan", @"0.00元");
    }
    
    if ([model.rewardAmount doubleValue] != 0) {
        double dustedMoney = [dustedMoneyTextField.text doubleValue];
        
        NSString *rewardAmountStr = [Utility replaceTheNumberForNSNumberFormatter:[NSString stringWithFormat:@"%.2f", [model.rewardAmount doubleValue]]];
        if (dustedMoney < [model.rewardAmount doubleValue]) {
            rewardAmountStr = [Utility replaceTheNumberForNSNumberFormatter:[NSString stringWithFormat:@"%.2f", dustedMoney]];
        }
        if ([rewardAmountStr doubleValue] <= 0) {
            rewardAmountStr = XYBString(@"str_financing_zero", @"0.00");
            lab2.text = [NSString stringWithFormat:XYBString(@"str_financing_some_yuan", @"%@元"), rewardAmountStr];
            
        } else {
            lab2.text = [NSString stringWithFormat:@"-%@", [NSString stringWithFormat:XYBString(@"str_financing_some_yuan", @"%@元"), rewardAmountStr]];
        }
        
    } else {
        lab2.text = XYBString(@"str_financing_zero_yuan", @"0.00元");
    }
    
    double totalInvest = [model.income doubleValue] + [model.addIncome doubleValue];
    NSString *investStr = [Utility replaceTheNumberForNSNumberFormatter:[NSString stringWithFormat:@"%.2f", totalInvest]];
    
    if ([investStr doubleValue] <= 0) {
        investStr = XYBString(@"str_financing_zero", @"0.00");
    }
    profitLab.text = [NSString stringWithFormat:XYBString(@"str_financing_some_yuan", @"%@元"), investStr];
}

#pragma mark RTLableDelegate

- (void)rtLabel:(id)rtLabel didSelectLinkWithURL:(NSURL *)url {
    NSString *urlStr;
    if ([url.description isEqualToString:@"jkxy"]) { // 借款协议
        urlStr = [RequestURL getNodeJsH5URL:App_Borrow_Protocol_URL withIsSign:NO];
        
    }else if ([url.description isEqualToString:@"fxjss"]) { // 风险警示书
        urlStr = [RequestURL getNodeJsH5URL:App_Risk_Warn_URL withIsSign:NO];
    }
    
    XYWebViewController *webView = [[XYWebViewController alloc] initWithTitle:nil webUrlString:urlStr];
    [self.navigationController pushViewController:webView animated:YES];
}

#pragma mark - 点击事件 和 响应事件

- (void)clickBackBtn:(id)sender {
    [dustedMoneyTextField resignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)clickTheChargeButton:(id)sender {
    [dustedMoneyTextField resignFirstResponder];
    ChargeViewController *chargeViewController = [[ChargeViewController alloc] initWithIdetifer:NO];
    [self.navigationController pushViewController:chargeViewController animated:YES];
}

- (void)clickTheCouponsButton:(id)sender {
    [dustedMoneyTextField resignFirstResponder];
    [self pushToCouponsViewController];
}

/**
 进入选择优惠券选择界面
 */
- (void)pushToCouponsViewController {
    MyCouponsViewController *myCouponsVC = [[MyCouponsViewController alloc] init];
    myCouponsVC.productType = projectTypeStr;
    myCouponsVC.projectId = productIdStr;
    myCouponsVC.couponsBlock = ^(NSString *couponsId, NSString *couponseName, double rate) { //回调传入加息券ID
        
        self.couponsID = [[NSString alloc] initWithString:couponsId];
        couponsDetailLab.textColor = COLOR_ORANGE;
        if ([couponseName isEqualToString:XYBString(@"str_financing_incomeCard", @"专属加息券")]) {
            couponsDetailLab.text = [NSString stringWithFormat:@"+%@%% %@", [Utility rateReplaceTheNumberForNSNumberFormatter:[NSString stringWithFormat:@"%.2f", rate * 100]], couponseName];
        } else if ([couponseName isEqualToString:@"加息券"]) {
            couponsDetailLab.text = [NSString stringWithFormat:@"+%@%% %@", [Utility replaceTheNumberForNSNumberFormatter:[NSString stringWithFormat:@"%.2f", rate * 100]], couponseName];
        } else {
            couponsDetailLab.text = couponseName;
        }
    };
    [self.navigationController pushViewController:myCouponsVC animated:YES];
}

- (void)clickTheAllInvestBtn {
    dustedMoneyTextField.text = [CheckTheInvestMoney allInvestMoneyPreInvest:mainDic fromTag:XYBString(@"str_common_xtb", @"信投宝") prouduct:self.info ccProuduct:nil]; // dustedMoneyStr;
    [self doaction];
}

/**
 *  确认出借
 */
- (void)clickTheNextButton:(id)sender {
    
    [dustedMoneyTextField resignFirstResponder];
    User *user = [UserDefaultsUtil getUser];
    if (![user.isIdentityAuth boolValue]) {
        
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
//                                                            message:XYBString(@"str_common_noRealNameAuthentication", @"您尚未实名认证，要先充值实名认证哦")
//                                                           delegate:self
//                                                  cancelButtonTitle:XYBString(@"str_common_cancel", @"取消")
//                                                  otherButtonTitles:XYBString(@"str_common_goToCharge", @"去充值"), nil];
//        alertView.tag = 1000;
//        [alertView show];
//        return;
        
        VerifyNameViewController *verifyVC = [[VerifyNameViewController alloc] initWithType:1];
        [self.navigationController pushViewController:verifyVC animated:YES];
        return;
    }
    
    if ([user.isIdentityAuth boolValue]) {
        
        if (dustedMoneyTextField.text.length <= 0) {
            [HUD showPromptViewWithToShowStr:XYBString(@"str_financing_input_amount", @"请输入出借金额") autoHide:YES afterDelay:1.0 userInteractionEnabled:YES];
            return;
        }
        
        BOOL isScuess = [CheckTheInvestMoney checkTheInvestMoney:dustedMoneyTextField.text preInvest:mainDic fromTag:XYBString(@"str_common_xtb", @"信投宝") prouduct:self.info ccProuduct:nil];
        
        //添加优惠券判断：若用户有优惠券，但用户未使用时进行提示 (前提是投资金额检验通过，有可用优惠券，并且未选择优惠券,且未弹窗提示过)
        if (isScuess == YES && _couponsAlert == NO &&_usableCard == YES  && [StrUtil isEmptyString:_couponsID] && ![couponsDetailLab.text isEqualToString:@"未使用"] ) {
            [self showCouponsAlertControllerWithCheckResult:isScuess];
            return;
        }
        
        if (isScuess) {
            [self payTheTouIDFinancing:dustedMoneyTextField.text];
        }
    }
}

/**
 弹窗提示用户未使用优惠券
 
 @param result 检测投资金额是否符合投资规范
 */
- (void)showCouponsAlertControllerWithCheckResult:(BOOL)result {
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:XYBString(@"str_financing_noUseCouponsAlert", @"您有优惠券可使用\n使用优惠券，增加收益") preferredStyle:UIAlertControllerStyleAlert];
    [alertVC addAction:[UIAlertAction actionWithTitle:XYBString(@"str_financing_UseCoupons", @"使用") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self pushToCouponsViewController];
    }]];
    
    [alertVC addAction:[UIAlertAction actionWithTitle:XYBString(@"str_financing_noUseCoupons", @"暂不使用") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        if (result == YES) {
            [self payTheTouIDFinancing:dustedMoneyTextField.text];
        }
    }]];
    
    _couponsAlert = YES;
    [self presentViewController:alertVC animated:YES completion:nil];
}

- (void)doaction {
    
    if (dustedMoneyTextField.text.length > 0) {
        if (![Utility isValidateinvestNum:dustedMoneyTextField.text]) {
            [HUD showPromptViewWithToShowStr:XYBString(@"str_financing_wrong_amount", @"出借金额填写错误") autoHide:YES afterDelay:1.0 userInteractionEnabled:YES];
            _nextButton.isColorEnabled = NO;
            return;
        }
        _nextButton.isColorEnabled = YES;
    }else
    {
        _nextButton.isColorEnabled = NO;
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
    [self setRequestForDetail];
}

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
//    
//    //键盘弹起并向上偏移154
//    mainScroll.contentOffset = CGPointMake(0, 154);
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

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
                                    NSDictionary *contentDic = @{
                                                                 @"userId" : [UserDefaultsUtil getUser].userId,
                                                                 @"bidRequestId" : productIdStr,
                                                                 @"amount" : dustedMoneyTextField.text,
                                                                 @"tradePassword" : sigPassWord,
                                                                 @"increaseCardId" : self.couponsID.length > 0 ? self.couponsID : @"",
                                                                 @"deviceId" : [OpenUDID value],
                                                                 @"paymentMode" : @"1",
                                                                 @"timestamp" : [DateTimeUtil getCurrentTime]
                                                                 };
                                    [self requestDqbInvestWebServiceWithParam:contentDic];
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

/**
 *  出借页面
 *
 *  @param moneyStr 出借金额
 */
- (void)payTheFinancing:(NSString *)moneyStr {
    
    AppDelegate *app = (AppDelegate *) [UIApplication sharedApplication].delegate;
    tradePayView = [TradePasswordView shareInstancesaidView];
    [app.window addSubview:tradePayView];
    
    [tradePayView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(app.window);
    }];
    
    User *user = [UserDefaultsUtil getUser];
    __weak XtbInvestViewController *investVC = self;
    tradePayView.clickSureButton = ^(NSString *payStr) {
        [investVC requestDoInvest:payStr];
        
    };
    
    tradePayView.clickForgetButton = ^{
        if (![user.isIdentityAuth boolValue]) {
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
        case 1001: //开启指纹交易功能
        {
            if (buttonIndex == 1) {
                TouchIdentityAuthViewController *TouchIdentityAuth = [[TouchIdentityAuthViewController alloc] init];
                [self.navigationController pushViewController:TouchIdentityAuth animated:YES];
            } else {
            }
        } break;
        default:
            break;
    }
}

#pragma mark - 信投宝--出借前接口

- (void)setRequestForDetail {
    
    productIdStr = _info.productId;
    BOOL isNumber = [Utility isValidateNumber:dustedMoneyTextField.text];
    
    [self requestPreInvestDetailWebServiceWithParam:@{
                                                      @"userId" : [UserDefaultsUtil getUser].userId,
                                                      @"projectType" : projectTypeStr,
                                                      @"bidRequestId" : productIdStr,
                                                      @"amount" : isNumber == YES ? dustedMoneyTextField.text : @"0",
                                                      @"increaseCardId" : self.couponsID.length > 0 ? self.couponsID : @"",
                                                      }];
}

- (void)requestPreInvestDetailWebServiceWithParam:(NSDictionary *)params {
    
    NSString *requestURL = [RequestURL getRequestURL:DqbAndXtbPreInvestURL param:params];
    [WebService postRequest:requestURL param:params JSONModelClass:[DqbAndXtbResponseModel class]
     
                    Success:^(AFHTTPRequestOperation *operation, id responseObject) {
                        
                        [mainDic removeAllObjects];
                        DqbAndXtbResponseModel *responseModel = responseObject;
                        _usableCard = [responseModel.usableCard boolValue];//记录是否有可用的优惠券的状态
                        [mainDic addEntriesFromDictionary:responseModel.toDictionary];
                        [self reloadDataTheInvestDetailView:responseModel];
                        
                        User *user = [UserDefaultsUtil getUser];
                        user.usableAmount = [Utility stringrangeStr:[NSString stringWithFormat:@"%.2f", [responseModel.usableAmount doubleValue]]];
                        [UserDefaultsUtil setUser:user];
                        
                    }
                       fail:^(AFHTTPRequestOperation *operation, NSString *errorMessage) {
                           [self hideLoading];
                           [self showPromptTip:errorMessage];
                       }];
}

#pragma mark - 信投宝--出借接口

- (void)requestDoInvest:(NSString *)payStr {
    NSDictionary *contentDic = @{
                                 @"userId" : [UserDefaultsUtil getUser].userId,
                                 @"bidRequestId" : productIdStr,
                                 @"amount" : dustedMoneyTextField.text,
                                 @"tradePassword" : payStr,
                                 @"increaseCardId" : self.couponsID.length > 0 ? self.couponsID : @""
                                 };
    
    [self requestDqbInvestWebServiceWithParam:contentDic];
}

- (void)requestDqbInvestWebServiceWithParam:(NSDictionary *)params {
    
    NSString *requestURL = [RequestURL getRequestURL:XtbInvestURL param:params];
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
                        incomeStatusViewController.returnDataDic = [responseModel toDictionary];
                        incomeStatusViewController.fromTag = XYBString(@"str_common_xtb", @"信投宝");
                        [self.navigationController pushViewController:incomeStatusViewController animated:YES];
                        
                    }
                       fail:^(AFHTTPRequestOperation *operation, NSString *errorMessage) {
                           [self hideLoading];
                           if ([params objectForKey:@"paymentMode"]) {
                               [self showPromptTip:errorMessage];
                           } else {
                               [[NSNotificationCenter defaultCenter] postNotificationName:@"ERRORNOTIFICATION" object:errorMessage];
                           }
                           
                       }];
}

@end
