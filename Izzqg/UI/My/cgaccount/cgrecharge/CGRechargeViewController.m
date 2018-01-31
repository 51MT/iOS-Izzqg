//
//  CGRechargeViewController.m
//  Ixyb
//
//  Created by wang on 2017/12/18.
//  Copyright © 2017年 xyb. All rights reserved.
//

#import "CGRechargeViewController.h"
#import "CGAccounWebViewController.h"
#import "ChargeValidate.h"
#import "Utility.h"
#import "WebService.h"
#import "WebviewViewController.h"
#import "CgAccountInfoResModel.h"
#import "CgDepRegisterModel.h"

@interface CGRechargeViewController ()
{
    XYScrollView * mainScroll;
    UIView      * payWayView;
    UIImageView * investBackImage;
    UIImageView * imageBankView;
    UITextField * dustedMoneyTextField;
    UILabel     * bankInfoLab;
    UILabel     * singleDealAmount;
    ColorButton * chargeBtn;
    NSArray     * bankArr;
}
@end

@implementation CGRechargeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNav];
    [self initUI];
    [self callCheckCGAccountWebserviceWith];
}

#pragma mark -- 初始化 UI
-(void)setNav
{
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
    
    NSString *bankJson = [[NSBundle mainBundle] pathForResource:@"bank" ofType:@"json"];
    bankArr = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:bankJson] options:NSJSONReadingMutableContainers error:nil];
}

-(void)initUI
{
    mainScroll = [[XYScrollView alloc] initWithFrame:CGRectZero];
    mainScroll.showsVerticalScrollIndicator = NO;
    mainScroll.scrollEnabled = NO;
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
    
    
    imageBankView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [llPayView addSubview:imageBankView];
    
    [imageBankView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(7));
        make.left.equalTo(@(11));
    }];
    
    bankInfoLab = [[UILabel alloc] initWithFrame:CGRectZero];
    bankInfoLab.font = NORMAL_TEXT_FONT_15;
    bankInfoLab.textColor = COLOR_COMMON_BLACK;
    bankInfoLab.lineBreakMode = NSLineBreakByTruncatingMiddle;
    [llPayView addSubview:bankInfoLab];
    
    [bankInfoLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imageBankView.mas_right).offset(6);
        make.centerY.equalTo(imageBankView.mas_centerY);
    }];
    
    singleDealAmount = [[UILabel alloc] initWithFrame:CGRectZero];
    singleDealAmount.text = @"单笔:0万 | 日:0万 | 月:0万";
    singleDealAmount.textColor = COLOR_AUXILIARY_GREY;
    singleDealAmount.font = WEAK_TEXT_FONT_11;
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
    
    chargeBtn = [[ColorButton alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth - 30, Cell_Height) Title:XYBString(@"string_ok", @"确定") ByGradientType:leftToRight];
    chargeBtn.isColorEnabled = NO;
    [chargeBtn addTarget:self action:@selector(clickChargeButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:chargeBtn];
    
    [chargeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Margin_Length));
        make.right.equalTo(@(-Margin_Length));
        make.height.equalTo(@(Cell_Height));
        make.top.equalTo(investBackImage.mas_bottom).offset(20.f);
    }];
}

#pragma mark -- 点击事件

//文本框触发
-(void)dustedMoneyTextFieldChange
{
    if (dustedMoneyTextField.text.length > 0) {
        chargeBtn.isColorEnabled = YES;
    } else {
        chargeBtn.isColorEnabled = NO;
    }
}

//充值
-(void)clickChargeButton:(id)sender
{
    [dustedMoneyTextField resignFirstResponder];
    
    if (![ChargeValidate checkTheChargeDustedMoneyStr:dustedMoneyTextField.text]) {
        [self hideLoading];
        return;
    }
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:[UserDefaultsUtil getUser].userId forKey:@"userId"];
    [params setValue:dustedMoneyTextField.text forKey:@"amount"];
    
    NSString *baseURL = [NSString stringWithFormat:@"%@%@",[Constant sharedConstant].baseUrl,CgRechargeURL];
    [params setValue:baseURL forKey:@"baseURL"];
    
    CGAccounWebViewController *cgWebVC = [[CGAccounWebViewController alloc] initWithParams:params];
    [self.navigationController pushViewController:cgWebVC animated:YES];
}

//返回
-(void)clickBackBtn:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

//充值说明
-(void)clickTheRightBtn
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", [RequestURL getNodeJsH5URL:App_Bank_Limit_URL withIsSign:NO], App_Bank_Tab_CGNav1_URL];
    NSString *titleStr = XYBString(@"str_bank_limit", @"充值提现说明");
    WebviewViewController *webView = [[WebviewViewController alloc] initWithTitle:titleStr webUrlString:urlStr];
    [self.navigationController pushViewController:webView animated:YES];
}

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
                        
                        payWayView.hidden = NO;
                        [payWayView mas_updateConstraints:^(MASConstraintMaker *make) {
                            make.height.equalTo(@(60));
                        }];
                        
                        NSString * strBankName;
                        for (NSDictionary *dic in bankArr) {
                            int bankType = [[dic objectForKey:@"bankType"] intValue];
                            if (bankType == [model.accountInfo.bankType intValue]) {
                                imageBankView.image = [UIImage imageNamed:[NSString stringWithFormat:@"bank%@", model.accountInfo.bankType]];
                                strBankName = [dic objectForKey:@"bankName"];
                                break;
                            }
                        }
                        
                        NSString *bankNumStr;
                        if (model.accountInfo.cardNo != nil) {
                            bankNumStr = [model.accountInfo.cardNo substringWithRange:NSMakeRange(model.accountInfo.cardNo.length - 4, 4)];
                        }
                        
                        if (![StrUtil isEmptyString:model.accountInfo.bankName] && ![StrUtil isEmptyString:bankNumStr]) {
                  
                            bankInfoLab.text = [NSString stringWithFormat:@"%@(尾号%@)", strBankName, bankNumStr];
                        }
                
                        //限额提示
                        if (![StrUtil isEmptyString:model.accountInfo.limitOnceStr] && ![StrUtil isEmptyString:model.accountInfo.limitDayStr]) {
                            
                            singleDealAmount.text = [NSString stringWithFormat:@"单笔:%@ | 日:%@ | 月:%@", model.accountInfo.limitOnceStr, model.accountInfo.limitDayStr, model.accountInfo.limitMonthStr];
                            
                        }
                    
                    }fail:^(AFHTTPRequestOperation *operation, NSString *errorMessage) {
                           [self hideLoading];
                           [self showPromptTip:errorMessage];
                       }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}


@end
