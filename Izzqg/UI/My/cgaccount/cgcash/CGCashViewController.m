//
//  CGCashViewController.m
//  Ixyb
//
//  Created by wang on 2017/12/18.
//  Copyright © 2017年 xyb. All rights reserved.
//

#import "CGCashViewController.h"
#import "CGAccounWebViewController.h"
#import "Utility.h"
#import "ChargeValidate.h"
#import "CgDepRegisterModel.h"
#import "WebService.h"
#import "CgAccountInfoResModel.h"
#import "WebviewViewController.h"

@interface CGCashViewController ()
{
    XYScrollView * mainScroll;
    UIImageView  * investBackImage;
    UITextField  * dustedMoneyTextField;
    UIView       * bankInfoView;
    UIImageView  * bankLogo;
    UILabel      * bankName;
    UILabel      * bankNumLab;
//    UILabel      * commissionNumLab;
    ColorButton  * okBtn;
    NSArray      * bankArr;
}
@end

@implementation CGCashViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNav];
    [self initUI];
    [self callCheckCGAccountWebserviceWith];
}

#pragma mark -- 初始化 UI
-(void)setNav
{
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
    
    NSString *bankJson = [[NSBundle mainBundle] pathForResource:@"bank" ofType:@"json"];
    bankArr = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:bankJson] options:NSJSONReadingMutableContainers error:nil];
}

-(void)initUI
{
    mainScroll = [[XYScrollView alloc] init];
    mainScroll.showsVerticalScrollIndicator = NO;
    mainScroll.scrollEnabled =  NO;
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
    
    NSString *usableAmountStr = [Utility replaceTheNumberForNSNumberFormatter:[NSString stringWithFormat:@"%.2f", [[UserDefaultsUtil getUser].cgUsableAmount doubleValue]]];
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
    
    bankInfoView = [[UIView alloc] init];
    bankInfoView.backgroundColor = COLOR_COMMON_CLEAR;
    [mainScroll addSubview:bankInfoView];
    [bankInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(mainScroll);
        make.top.equalTo(investBackImage.mas_bottom);
         make.height.equalTo(@45);
    }];
    
    bankLogo = [[UIImageView alloc] init];
    [bankInfoView addSubview:bankLogo];

    [bankLogo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bankInfoView.mas_top).offset(Text_Margin_Length);
        make.left.equalTo(@(Margin_Length));
    }];

    bankName = [[UILabel alloc] init];
    bankName.font = TEXT_FONT_12;
    bankName.textColor = COLOR_MAIN_GREY;
    [bankInfoView addSubview:bankName];
    
    [bankName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bankLogo.mas_right).offset(Text_Margin_Middle);
        make.centerY.equalTo(bankLogo.mas_centerY);
    }];
    
    
    bankNumLab = [[UILabel alloc] init];
    bankNumLab.font = TEXT_FONT_12;
    bankNumLab.textColor = COLOR_LIGHT_GREY;
    [bankInfoView addSubview:bankNumLab];
    [bankNumLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bankName.mas_right).offset(2);
        make.centerY.equalTo(bankLogo.mas_centerY);
    }];
    

    
    okBtn = [[ColorButton alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth - 30, Cell_Height) Title:XYBString(@"string_ok", @"确定") ByGradientType:leftToRight];
    okBtn.isColorEnabled = NO;
    [okBtn addTarget:self action:@selector(clickCashButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:okBtn];
    
    [okBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Margin_Length));
        make.right.equalTo(@(-Margin_Length));
        make.height.equalTo(@(Cell_Height));
        make.top.equalTo(bankInfoView.mas_bottom).offset(5.f);
    }];

    UILabel *tipLab = [[UILabel alloc] init];
    tipLab.font = TEXT_FONT_12;
    tipLab.textColor = COLOR_LIGHT_GREY;
    tipLab.text = XYBString(@"str_cash_cgtip", @"温馨提示：提现到账时间以银行处理时间为准。");
    tipLab.numberOfLines = 2;
    [mainScroll addSubview:tipLab];
    [tipLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(okBtn.mas_bottom).offset(Margin_Length);
        make.centerX.equalTo(mainScroll.mas_centerX);
    }];
}

#pragma mark -- 点击事件

//文本框触发
-(void)dustedMoneyTextFieldChange
{
    if (dustedMoneyTextField.text.length > 0) {
        okBtn.isColorEnabled = YES;
    } else {
        okBtn.isColorEnabled = NO;
    }
}

//全提
-(void)clickAllButton:(id)sender
{
    dustedMoneyTextField.text = [NSString stringWithFormat:@"%@", [UserDefaultsUtil getUser].cgUsableAmount];
    [[NSNotificationCenter defaultCenter] postNotificationName:UITextFieldTextDidChangeNotification object:dustedMoneyTextField];
}

//提现
-(void)clickCashButton:(id)sender
{
    [dustedMoneyTextField resignFirstResponder];
    
    if (dustedMoneyTextField.text.length == 0) {
        [HUD showPromptViewWithToShowStr:XYBString(@"str_enter_rightAmount", @"请输入正确的提现金额") autoHide:YES afterDelay:1.0 userInteractionEnabled:YES];
        return;
    }
    if (![Utility isValidateNumber:dustedMoneyTextField.text]) {
        [HUD showPromptViewWithToShowStr:XYBString(@"str_error_amount", @"提现金额填写错误") autoHide:YES afterDelay:1.0 userInteractionEnabled:YES];
        return;
    }
    
    double balanceMoneyNum = [[UserDefaultsUtil getUser].cgUsableAmount doubleValue];
    double dustedMoney = [dustedMoneyTextField.text doubleValue];
    
    if (dustedMoney > balanceMoneyNum) {
        [HUD showPromptViewWithToShowStr:XYBString(@"str_lessthan_amount", @"提现金额超限") autoHide:YES afterDelay:1.0 userInteractionEnabled:YES];
        return;
    }
    
    if (dustedMoney < 100) {
        
        [HUD showPromptViewWithToShowStr:XYBString(@"str_notlessthan_100", @"提现金额不能低于100元") autoHide:YES afterDelay:1.0 userInteractionEnabled:YES];
        return;
    }
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:[UserDefaultsUtil getUser].userId forKey:@"userId"];
    [params setValue:dustedMoneyTextField.text forKey:@"amount"];
    
    NSString *baseURL = [NSString stringWithFormat:@"%@%@",[Constant sharedConstant].baseUrl,CgWithdrawURL];
    [params setValue:baseURL forKey:@"baseURL"];
    
    CGAccounWebViewController *cgWebVC = [[CGAccounWebViewController alloc] initWithParams:params];
    [self.navigationController pushViewController:cgWebVC animated:YES];
}

//返回
-(void)clickBackBtn:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

//提现说明
-(void)clickTheRightBtn
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", [RequestURL getNodeJsH5URL:App_Bank_Limit_URL withIsSign:NO], App_Bank_Tab_CGNav2_URL];
    NSString *titleStr = XYBString(@"str_bank_limit", @"充值提现说明");
    WebviewViewController *webView = [[WebviewViewController alloc] initWithTitle:titleStr webUrlString:urlStr];
    [self.navigationController pushViewController:webView animated:YES];
}


#pragma mark -- 数据处理

- (void)callCheckCGAccountWebserviceWith {
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:[UserDefaultsUtil getUser].userId forKey:@"userId"];
    [params setValue:@"INVESTOR" forKey:@"userRole"];
    [self reqestCheckCGAccountWebserviceWithParam:params];
}

- (void)reqestCheckCGAccountWebserviceWithParam:(NSDictionary *)param{
    [self showDataLoading];
    NSString *requestURL = [RequestURL getRequestURL:CGAccountInfo_URL param:param];

    [WebService postRequest:requestURL param:param JSONModelClass:[CgAccountInfoResModel class]
     
                    Success:^(AFHTTPRequestOperation *operation, id responseObject) {
                        
                        [self hideLoading];
                        CgAccountInfoResModel *model = responseObject;
                        bankNumLab.text = [NSString stringWithFormat:XYBString(@"str_last_number", @"(尾号%@)"), [model.accountInfo.cardNo substringWithRange:NSMakeRange(model.accountInfo.cardNo.length - 4, 4)]];
                        
                        for (NSDictionary *dic in bankArr) {
                            int bankType = [[dic objectForKey:@"bankType"] intValue];
                            if (bankType == [model.accountInfo.bankType intValue]) {
                                bankLogo.image = [UIImage imageNamed:[NSString stringWithFormat:@"bank%@", model.accountInfo.bankType]];
                                bankName.text = [dic objectForKey:@"bankName"];
                                break;
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
