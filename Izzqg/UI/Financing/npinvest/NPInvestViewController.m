//
//  NPInvestViewController.m
//  Ixyb
//
//  Created by wang on 2017/12/18.
//  Copyright © 2017年 xyb. All rights reserved.
//

#import "NPInvestViewController.h"
#import "Utility.h"
#import "RTLabel.h"
#import "WebService.h"
#import "MyCouponsViewController.h"
#import "XYWebViewController.h"
#import "CalculatorViewController.h"
#import "NPreInvestResModel.h"
#import "CheckTheInvestMoney.h"
#import "TouchIdentityAuthViewController.h"
#import "TradePasswordView.h"
#import "ChangePayPasswordViewController.h"
#import "NPinvestResModel.h"
#import "RiskEvaluatingViewController.h"
#import "XYAlertView.h"
#import "CGAccounWebViewController.h"
#import "NPInvestResultViewController.h"
#import "CGAccountOpenViewController.h"
#import "CGRechargeViewController.h"

@interface NPInvestViewController ()<RTLabelDelegate>
{
    XYScrollView *mainScroll;
    UIView *backView;
    UILabel *titleLab;
    UILabel *rateLab;
    UILabel *standardLab;
    UILabel *lockTimeLab;
    UILabel *restLab;
    UIView *usableAmountView;
    UIImageView *textFieldBackImage;
    XYTextField *dustedMoneyTextField;
    ColorButton *nextButton;
    XYButton *allInvestBtn;
    NSMutableDictionary *mainDic;
    NSString *dustedMoneyStr;
    TradePasswordView *tradePayView;
}

@property (nonatomic,strong) NPreInvestResModel *productModel;
@property (nonatomic,copy) NSString *productId;
@property (nonatomic,copy) NSString *loanTime;

@end

@implementation NPInvestViewController

- (instancetype)initWithProductId:(NSString *)productId
{
    self = [super init];
    if (self) {
        _productId = productId;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushChargeView:) name:@"YJCJ" object:nil];
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //不带有loading请求接口，刷新页面
    [self setRequestForDetail];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNav];
    [self creatTheMainScrollView];
    [self createTheTopUI];
    [self creatTheUsableAmountView];
    [self creatTheInvestView];
    [self creatTheInvestBtnView];
    [self setupRefresh];
    
    //默认投资金额0元，请求投资前接口
    [self startReqest];
}

#pragma mark - 初始化 UI
- (void)setNav {
    
    self.navItem.title = XYBString(@"str_common_yjcj", @"一键出借");
    self.navItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(clickBackBtn:)];
}

- (void)creatTheMainScrollView {
    
    mainScroll = [[XYScrollView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight - 40)];
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
    
    backView = [[UIView alloc] initWithFrame:CGRectMake(Margin_Length, Margin_Top, MainScreenWidth - 30, 109)];
    backView.backgroundColor = COLOR_COMMON_WHITE;
    backView.layer.cornerRadius  = 9.f;
    [mainScroll addSubview:backView];

    
    titleLab = [[UILabel alloc] initWithFrame:CGRectZero];
    titleLab.font = TEXT_FONT_16;
    titleLab.textColor = COLOR_MAIN_GREY;
    titleLab.text = XYBString(@"str_common_yjcj", @"一键出借");
    [backView addSubview:titleLab];
    
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backView.mas_left).offset(Margin_Length);
        make.top.equalTo(backView.mas_top).offset(Margin_Length);
    }];
    
    rateLab = [[UILabel alloc] initWithFrame:CGRectZero];
    rateLab.textAlignment = NSTextAlignmentLeft;
    rateLab.font = FONT_TEXT_20;
    rateLab.textColor = COLOR_CHUBBG_ORANGE;
    NSString *rateStr = @"0";
    NSMutableAttributedString *mutAttStr2 = [[NSMutableAttributedString alloc] initWithString:rateStr];
    rateLab.attributedText = mutAttStr2;
    [backView addSubview:rateLab];
    
    [rateLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleLab.mas_left).offset(0);
        make.top.equalTo(titleLab.mas_bottom).offset(17);
    }];
    
    lockTimeLab = [[UILabel alloc] initWithFrame:CGRectZero];
    lockTimeLab.font = TEXT_FONT_12;
    lockTimeLab.textColor = COLOR_AUXILIARY_GREY;
    lockTimeLab.text = @"锁定期:0个月";
    lockTimeLab.textAlignment = NSTextAlignmentLeft;
    [backView addSubview:lockTimeLab];
    
    [lockTimeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(rateLab.mas_left);
        make.top.equalTo(rateLab.mas_bottom).offset(5);
    }];
    
    standardLab = [[UILabel alloc] initWithFrame:CGRectZero];
    standardLab.font = NORMAL_TEXT_FONT_15;
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
        make.top.equalTo(lockTimeLab.mas_top).offset(0);
        make.left.equalTo(standardLab.mas_left).offset(0);
    }];
}

- (void)creatTheUsableAmountView {
    
    usableAmountView = [[UIView alloc] initWithFrame:CGRectZero];
    [mainScroll addSubview:usableAmountView];
    
    [usableAmountView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(backView.mas_bottom).offset(0);
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
    
    UILabel * lccgTipsLab = [[UILabel alloc] initWithFrame:CGRectZero];
    lccgTipsLab.font = TEXT_FONT_12;
    lccgTipsLab.text = XYBString(@"str_financing_lccgamount", @"(理财存管账户)");
    lccgTipsLab.textColor = COLOR_AUXILIARY_GREY;
    [usableAmountView addSubview:lccgTipsLab];
    
    [lccgTipsLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(chargeButton.mas_right).offset(0);
        make.centerY.equalTo(chargeButton.mas_centerY);
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
    dustedMoneyTextField.placeholder = XYBString(@"str_financing_100YuanQT", @"100元起投");
    dustedMoneyTextField.font = TEXT_FONT_16;
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

- (void)creatTheInvestBtnView {
    
    nextButton =  [[ColorButton alloc]initWithFrame:CGRectMake(0, 0, MainScreenWidth - 30, Cell_Height) Title:XYBString(@"str_financing_sureInvest", @"确认出借")  ByGradientType:leftToRight];
    nextButton.isColorEnabled = NO;
    [nextButton addTarget:self action:@selector(clickTheNextButton:) forControlEvents:UIControlEventTouchUpInside];
    [mainScroll addSubview:nextButton];
    
    [nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(mainScroll.mas_left).offset(Margin_Length);
        make.top.equalTo(textFieldBackImage.mas_bottom).offset(20.f);
        make.right.equalTo(mainScroll.mas_right).offset(-Margin_Length);
        make.width.equalTo(@(MainScreenWidth - 30));
        make.height.equalTo(@(Cell_Height));
    }];
    
    RTLabel *remaindLab = [[RTLabel alloc] initWithFrame:CGRectZero];
    remaindLab.font = TEXT_FONT_12;
    remaindLab.delegate = self;
    NSString *protocolStr = XYBString(@"str_financing_yjcjProductjkxy",@"点击“确认出借”，即表示阅读并同意<font color='#4385f5' ><u color=clear><a href='cjrfwxy'>《出借人服务协议》</a></u></font>、<font color='#4385f5' ><u color=clear><a href='cjrsqs'>《出借人授权书》</a></u></font>和<font color='#4385f5' ><u color=clear><a href='fxjss'>《风险警示书》</a></u></font>");
    remaindLab.text = protocolStr;
    remaindLab.textColor = COLOR_AUXILIARY_GREY;
    [mainScroll addSubview:remaindLab];
    
    float InfoViewHeight = [ToolUtil getLabelHightWithLabelStr:protocolStr MaxSize:CGSizeMake(MainScreenWidth - 30, MainScreenHeight) AndFont:12.f LineSpace:6];
    
    [remaindLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(mainScroll.mas_left).offset(Margin_Length);
        make.top.equalTo(nextButton.mas_bottom).offset(22);
        make.right.equalTo(mainScroll.mas_right).offset(-Margin_Length);
        make.height.equalTo(@(InfoViewHeight + 3));
        make.bottom.equalTo(mainScroll.mas_bottom);
    }];
    
    UILabel *remaindLab2 = [[UILabel alloc] initWithFrame:CGRectZero];
    remaindLab2.font = TEXT_FONT_12;
    remaindLab2.textColor = COLOR_AUXILIARY_GREY;
    remaindLab2.text = XYBString(@"str_financing_hasRiskAndInvestShouldBePrudent", @"市场有风险，出借需谨慎");
    remaindLab2.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:remaindLab2];

    [remaindLab2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.width.equalTo(@(MainScreenWidth));
        make.bottom.equalTo(self.view.mas_bottom).offset(-Margin_Length);
    }];
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

- (void)reloadDataTheInvestDetailView:(NPreInvestResModel *)model {
    
    //标题
    titleLab.text = model.productInfo.name;
    
    //综合约定年化利率
    NSString *rateStr = [Utility rateReplaceTheNumberForNSNumberFormatter:[NSString stringWithFormat:@"%.2f", [model.productInfo.rate doubleValue] * 100]];
    rateStr = [rateStr stringByAppendingString:XYBString(@"str_financing_percentSymbol", @"%")];
    rateLab.attributedText = [self getAttributeStrWithString:rateStr];
    
    //期限
    if ([model.productInfo.loanMonths intValue] > 0 && [model.productInfo.loanDays intValue] > 0) {
        _loanTime = [NSString stringWithFormat:@"%@个月%@天",model.productInfo.loanMonths,model.productInfo.loanDays];
    }else{
        
        if ([model.productInfo.loanMonths intValue] > 0 && [model.productInfo.loanDays intValue] <= 0) {
            _loanTime = [NSString stringWithFormat:@"%@个月", model.productInfo.loanMonths];
        }else if ([model.productInfo.loanDays intValue] > 0  && [model.productInfo.loanMonths intValue] <= 0) {
            _loanTime = [NSString stringWithFormat:@"%@天", model.productInfo.loanDays];
        }else{
            _loanTime = [NSString stringWithFormat:@"%@天", model.productInfo.loanDays];
        }
    }
    
    standardLab.text =  _loanTime;
    
    //锁定期
    if ([model.productInfo.lockMonths intValue] > 0) {
        lockTimeLab.text = [NSString stringWithFormat:@"锁定期:%@个月",model.productInfo.lockMonths];
    }else{
        lockTimeLab.text = [NSString stringWithFormat:@"锁定期:%@天", model.productInfo.lockMonths];
    }
    
    //剩余可投
    if ([model.productInfo.restAmount doubleValue] <= 0) {
        restLab.text = [NSString stringWithFormat:XYBString(@"str_financing_restMoneyBlow", @"剩余可投:%@元"),@"0.00"];
    }else{
        restLab.text = [NSString stringWithFormat:XYBString(@"str_financing_restMoneyBlow", @"剩余可投:%@元"),[Utility replaceTheNumberForNSNumberFormatter:model.productInfo.restAmount]];
    }

    //可用余额
    UILabel *accAmountLab = (UILabel *) [self.view viewWithTag:503];
    if ([model.usableAmt doubleValue] > 0) {
        NSString *usableAmount = [Utility replaceTheNumberForNSNumberFormatter:[NSString stringWithFormat:@"%.2f", [model.usableAmt doubleValue]]];
        accAmountLab.text = [NSString stringWithFormat:XYBString(@"str_financing_some_yuan", @"%@元"), usableAmount];
    } else {
        accAmountLab.text = XYBString(@"str_financing_zero_yuan", @"0.00元");
    }
}

- (NSMutableAttributedString *)getAttributeStrWithString:(NSString *)rate {
    
    NSMutableAttributedString *mutAttStr = [[NSMutableAttributedString alloc] initWithString:rate];
    [mutAttStr addAttributes:@{ NSFontAttributeName : FONT_TEXT_20,
                                NSForegroundColorAttributeName : COLOR_ORANGE } range:NSMakeRange(0, rate.length - 1)];
    [mutAttStr addAttributes:@{ NSFontAttributeName : NORMAL_TEXT_FONT_15,
                                NSForegroundColorAttributeName : COLOR_ORANGE } range:NSMakeRange(rate.length - 1,1)];
    
    return mutAttStr;
}

#pragma mark - 点击事件 和 响应事件

- (void)clickBackBtn:(id)sender {
    [dustedMoneyTextField resignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)clickTheChargeButton:(id)sender {
    
    [dustedMoneyTextField resignFirstResponder];
    [self pushToChargeViewController];
}

- (void)pushChargeView:(NSNotification *)notify {
    [self pushToChargeViewController];
}

- (void)clickTheAllInvestBtn {
    dustedMoneyTextField.text = [CheckTheInvestMoney np_allInvestMoneyPreInvest:mainDic nProuduct:self.productModel.productInfo];
    [self doaction];
}

/**
 *  确认出借
 */
- (void)clickTheNextButton:(id)sender {
    
    [dustedMoneyTextField resignFirstResponder];

    //1.是否测评过;
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    BOOL isEvaluation = [userDefault boolForKey:@"isEvaluation"];
    if (isEvaluation == NO) {
        [self presentTheTestAlerView];
        return;
    }
    
    //2.未开通理财存管账户
    User *user = [UserDefaultsUtil getUser];
    if (user.depAcctId.length == 0) {
        
        if ([user.isIdentityAuth boolValue] == YES) {
            
            NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
            [params setValue:[UserDefaultsUtil getUser].userId forKey:@"userId"];
            [params setValue:[UserDefaultsUtil getUser].realName forKey:@"realName"];
            [params setValue:[UserDefaultsUtil getUser].idNumber forKey:@"idCard"];
            [params setValue:@"INVESTOR" forKey:@"userRole"];//存管账户开户
            NSString *baseURL = [NSString stringWithFormat:@"%@%@",[Constant sharedConstant].baseUrl,CGAccountRegister_URL];
            [params setValue:baseURL forKey:@"baseURL"];
            
            CGAccounWebViewController *cgWebVC = [[CGAccounWebViewController alloc] initWithParams:params];
            [self.navigationController pushViewController:cgWebVC animated:YES];
            
        }else{
            CGAccountOpenViewController *openVC = [[CGAccountOpenViewController alloc] initWithType:1];
            [self.navigationController pushViewController:openVC animated:YES];
        }
        return;
    }
    
    //3.资金校验
    if (dustedMoneyTextField.text.length <= 0) {
        [HUD showPromptViewWithToShowStr:XYBString(@"str_financing_input_amount", @"请输入出借金额") autoHide:YES afterDelay:1.0 userInteractionEnabled:YES];
        return;
    }
    
    BOOL isScuess = [CheckTheInvestMoney checkTheNProductInvestMoney:dustedMoneyTextField.text preInvest:mainDic prouduct:self.productModel.productInfo];
    
    if (isScuess) {
        [self payTheTouIDFinancing:dustedMoneyTextField.text];
    }
}

//弹出测评弹窗
- (void)presentTheTestAlerView {
    
    UIAlertController *riskTestAlert = [UIAlertController alertControllerWithTitle:XYBString(@"str_common_riskTest", @"风险测评") message:XYBString(@"str_common_remaindRiskTest", @"应监管合规要求，您需要在出借相关产品前完成风险承受能力测评") preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelBtn = [UIAlertAction actionWithTitle:XYBString(@"str_common_cancel", @"取消") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [riskTestAlert dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [riskTestAlert addAction:cancelBtn];
    
    UIAlertAction *testBtn = [UIAlertAction actionWithTitle:XYBString(@"str_common_toFinishRiskTest", @"去测评") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [riskTestAlert dismissViewControllerAnimated:YES completion:nil];
        //跳转到测评h5界面
        NSString *urlStr = [RequestURL getNodeJsH5URL:App_Risk_Evaluating_URL withIsSign:YES];
        RiskEvaluatingViewController *riskEvaluatingVC = [[RiskEvaluatingViewController alloc] initWithTitle:XYBString(@"str_common_riskTest", @"风险测评") webUrlString:urlStr];
        [self.navigationController pushViewController:riskEvaluatingVC animated:YES];
    }];
    
    [riskTestAlert addAction:testBtn];
    
    [self presentViewController:riskTestAlert animated:YES completion:nil];
}

- (void)doaction {
    
    if (dustedMoneyTextField.text.length > 0) {
        if (![Utility isValidateinvestNum:dustedMoneyTextField.text]) {
            [HUD showPromptViewWithToShowStr:XYBString(@"str_financing_wrong_amount", @"出借金额填写错误") autoHide:YES afterDelay:1.0 userInteractionEnabled:YES];
            return;
        }
        nextButton.isColorEnabled = YES;
    }else{
        nextButton.isColorEnabled = NO;
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

- (void)chargeSuccess {
    [self showPromptTip:XYBString(@"str_common_chargeSuccess", @"充值成功")];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - RTLabelDelegate

- (void)rtLabel:(id)rtLabel didSelectLinkWithURL:(NSURL *)url {
    
    NSString *urlStr;
    if ([url.description isEqualToString:@"cjrfwxy"]) {
        //出借人服务协议
        urlStr = [RequestURL getNodeJsH5URL:App_investorServiceProtocol_URL withIsSign:NO];
        
    } else if ([url.description isEqualToString:@"cjrsqs"]) {
        //出借人授权书
        urlStr = [RequestURL getNodeJsH5URL:App_InvestorAuthLetter_URL withIsSign:NO];
        
    } else if ([url.description isEqualToString:@"fxjss"]) {
        urlStr = [RequestURL getNodeJsH5URL:App_Risk_Warn_URL withIsSign:NO];
    }
    
    XYWebViewController *webView = [[XYWebViewController alloc] initWithTitle:nil webUrlString:urlStr];
    [self.navigationController pushViewController:webView animated:YES];
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
                                                                 @"productId" : _productId,
                                                                 @"amount" : dustedMoneyTextField.text,
                                                                 @"tradePassword" : sigPassWord,
                                                                 @"deviceId" : [OpenUDID value],
                                                                 @"paymentMode" : @"1",
                                                                 @"timestamp" : [DateTimeUtil getCurrentTime]
                                                                 };
                                    [self requestOneKeyProductDoInvestWebServiceWithParam:contentDic];
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
 *跳转至存管开户H5页面
 *1.未开户
 *  1.1:用户实名认证过，跳转进入开户H5页面
 *  1.2:用户未实名认证，跳转到开户输入姓名+身份证页面
 *
 *2.已开户 直接进入充值页面
 */
- (void)pushToChargeViewController {
    
    User *user = [UserDefaultsUtil getUser];
    if (user.depAcctId.length == 0) {
        
        if ([user.isIdentityAuth boolValue] == YES) {
            
            NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
            [params setValue:[UserDefaultsUtil getUser].userId forKey:@"userId"];
            [params setValue:[UserDefaultsUtil getUser].realName forKey:@"realName"];
            [params setValue:[UserDefaultsUtil getUser].idNumber forKey:@"idCard"];
            [params setValue:@"INVESTOR" forKey:@"userRole"];//存管账户开户
            NSString *baseURL = [NSString stringWithFormat:@"%@%@",[Constant sharedConstant].baseUrl,CGAccountRegister_URL];
            [params setValue:baseURL forKey:@"baseURL"];
            
            CGAccounWebViewController *cgWebVC = [[CGAccounWebViewController alloc] initWithParams:params];
            [self.navigationController pushViewController:cgWebVC animated:YES];
            
        }else{
            CGAccountOpenViewController *openVC = [[CGAccountOpenViewController alloc] initWithType:1];
            [self.navigationController pushViewController:openVC animated:YES];
        }
        
    }else{
        CGRechargeViewController * chargeVC = [[CGRechargeViewController alloc] init];
        [self.navigationController pushViewController:chargeVC animated:YES];
    }
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
    
    __weak NPInvestViewController *weakVC = self;
    tradePayView.clickSureButton = ^(NSString *payStr) {
        [weakVC requestDoInvest:payStr];
    };
    
    tradePayView.clickForgetButton = ^{
        ChangePayPasswordViewController *payPassWordVC = [[ChangePayPasswordViewController alloc] init];
        [weakVC.navigationController pushViewController:payPassWordVC animated:YES];
    };
}

#pragma mark - AlertView Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    switch (alertView.tag) {
        case 1000: //去充值
        {
            if (buttonIndex == 1) {
                NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
                [params setValue:[UserDefaultsUtil getUser].userId forKey:@"userId"];
                [params setValue:dustedMoneyTextField.text forKey:@"amount"];
                
                NSString *baseURL = [NSString stringWithFormat:@"%@%@",[Constant sharedConstant].baseUrl,CgRechargeURL];
                [params setValue:baseURL forKey:@"baseURL"];
                
                CGAccounWebViewController *cgWebVC = [[CGAccounWebViewController alloc] initWithParams:params];
                [self.navigationController pushViewController:cgWebVC animated:YES];
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

#pragma mark - 一键出借产品 出借前接口

- (void)setRequestForDetail {
    
    BOOL isNumber = [Utility isValidateNumber:dustedMoneyTextField.text];
    if (isNumber) {
        NSDictionary *contentDic = @{
                                     @"userId" : [UserDefaultsUtil getUser].userId,
                                     @"productId" : _productId,
                                     @"amount" : dustedMoneyTextField.text,
                                     };
        [self requestPreInvestDetailWebServiceWithParam:contentDic];
    }
}

- (void)startReqest {
    NSDictionary *contentDic = @{
                                 @"userId" : [UserDefaultsUtil getUser].userId,
                                 @"productId" : _productId,
                                 @"amount" : @"0",
                                 };
    [self showDataLoading];
    [self requestPreInvestDetailWebServiceWithParam:contentDic];
}

- (void)requestPreInvestDetailWebServiceWithParam:(NSDictionary *)params {
    
    NSString *requestURL = [RequestURL getRequestURL:OneKeyProductPreInvest_URL param:params];
    [WebService postRequest:requestURL param:params JSONModelClass:[NPreInvestResModel class]
     
                    Success:^(AFHTTPRequestOperation *operation, id responseObject) {
                        
                        [self hideLoading];
                        [mainDic removeAllObjects];
                        NPreInvestResModel *responseModel = responseObject;
                        _productModel = responseModel;
                        
                        [mainDic addEntriesFromDictionary:responseModel.productInfo.toDictionary];
                        [self reloadDataTheInvestDetailView:_productModel];
                        
                        User *user = [UserDefaultsUtil getUser];
                        user.usableAmount = [Utility stringrangeStr:[NSString stringWithFormat:@"%.2f", [responseModel.usableAmt doubleValue]]];
                        user.depAcctId = responseModel.depAcctId;
                        [UserDefaultsUtil setUser:user];
                    }
                       fail:^(AFHTTPRequestOperation *operation, NSString *errorMessage) {
                           [self hideLoading];
                           [self showPromptTip:errorMessage];
                       }];
}

#pragma mark - 一键出借产品 出借接口

- (void)requestDoInvest:(NSString *)payStr {
    
    NSDictionary *contentDic = @{
                                 @"userId" : [UserDefaultsUtil getUser].userId,
                                 @"productId" : _productId,
                                 @"amount" : dustedMoneyTextField.text,
                                 @"tradePassword" : payStr,
                                 };
    
    [self requestOneKeyProductDoInvestWebServiceWithParam:contentDic];
}

- (void)requestOneKeyProductDoInvestWebServiceWithParam:(NSDictionary *)params {
    
    NSString *requestURL = [RequestURL getRequestURL:OneKeyProductDoInvest_URL param:params];
    [self showTradeLoadingOnAlertView];
    
    [WebService postRequest:requestURL param:params JSONModelClass:[NPinvestResModel class]
     
                    Success:^(AFHTTPRequestOperation *operation, id responseObject) {
                        
                        [self hideLoading];
                        [tradePayView removeFromSuperview];
                        NPinvestResModel *responseModel = responseObject;
                        User *user = [UserDefaultsUtil getUser];
                        if (![user.isTradePassword boolValue]) {
                            user.isTradePassword = @"1";
                        }
                        [UserDefaultsUtil setUser:user];
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"investedSuccessNotificaton" object:nil];
                        
                        //出借成功页面
                        NPInvestResultViewController *successVC = [[NPInvestResultViewController alloc] initWithName:_productModel.productInfo.name loanTime:_loanTime model:responseModel];
                        [self.navigationController pushViewController:successVC animated:YES];
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




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
