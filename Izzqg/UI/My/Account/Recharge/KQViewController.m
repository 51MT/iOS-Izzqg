//
//  KQViewController.m
//  Ixyb
//
//  Created by dengjian on 16/11/21.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import "KQViewController.h"
#import "Utility.h"
#import "WebService.h"

@interface KQViewController () <UITextFieldDelegate>

@property (nonatomic, strong) XYButton *postCodeBtn;      //发送验证码btn
@property (nonatomic, strong) UITextField *codeTextField; //短信验证码
@property (nonatomic, strong) ColorButton *bindCardBtn;      //确认绑卡

@end

@implementation KQViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self createNav];
    [self createMainUI];
}

#pragma mark - 创建视图UI
/**
 *
 *  @brief 导航栏的title  取消按钮
 */
- (void)createNav {

    self.navItem.title = XYBString(@"str_account_bindBankCard", @"绑定银行卡");

    UIButton *leftNavBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 29, 40)];
    leftNavBtn.titleLabel.font = TEXT_FONT_14;
    [leftNavBtn setTitle:XYBString(@"str_common_cancel", @"取消") forState:UIControlStateNormal];
    [leftNavBtn setTitleColor:COLOR_COMMON_GRAY forState:UIControlStateHighlighted];
    [leftNavBtn addTarget:self action:@selector(clickLeftNavBtn:) forControlEvents:UIControlEventTouchUpInside];

    self.navItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftNavBtn];
}

/**
 *  @author xyb, 16-11-22 09:11:58
 *
 *  @brief 创建UI
 */
- (void)createMainUI {
    self.view.backgroundColor = COLOR_BG;
    UILabel *remaindLab1 = [[UILabel alloc] init];
    remaindLab1.font = FONT_SMALL_8;
    remaindLab1.textColor = COLOR_AUXILIARY_GREY;

    NSString *bankName; //银行名称
    NSString *fourNum;  //银行账户的后四位

    NSString *bankJson = [[NSBundle mainBundle] pathForResource:@"bank" ofType:@"json"];
    NSMutableArray *bankArr = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:bankJson] options:NSJSONReadingMutableContainers error:nil];
    User *user = [UserDefaultsUtil getUser];
    for (NSDictionary *bankDic in bankArr) {
        int bankType = [[bankDic objectForKey:@"bankType"] intValue];
        if (bankType == [user.bankType intValue]) {
            bankName = [NSString stringWithFormat:@"%@", [bankDic objectForKey:@"bankName"]];
            break;
        }
    }
    if ([UserDefaultsUtil getUser].accountNumber) {
        NSString *bankNum = [NSString stringWithFormat:@"%@", [UserDefaultsUtil getUser].accountNumber];
        fourNum = [bankNum substringWithRange:NSMakeRange(bankNum.length - 4, 4)]; //取银行卡后四位
    }
    remaindLab1.text = [NSString stringWithFormat:XYBString(@"str_account_KqCharge_wltgczed", @"•为了提高充值额度，请绑定您的%@卡(尾号%@)到快钱支付"), bankName, fourNum];
    [self.view addSubview:remaindLab1];

    [remaindLab1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navBar.mas_bottom).offset(Margin_Length);
        make.left.equalTo(self.view).offset(Margin_Length);
        make.right.equalTo(self.view.mas_right).offset(-Margin_Length);
    }];

    UILabel *remaindLab2 = [[UILabel alloc] init];
    remaindLab2.font = FONT_SMALL_8;
    remaindLab2.textColor = COLOR_AUXILIARY_GREY;
    NSString *phoneNum = [self.phoneNum stringByReplacingCharactersInRange:NSMakeRange(self.phoneNum.length - 1 - 8, 4) withString:XYBString(@"str_account_KqCharge_jm", @"****")];
    remaindLab2.text = [NSString stringWithFormat:XYBString(@"str_account_KqCharge_bkxdxyz", @"•绑卡需短信验证，您的手机号：%@"), phoneNum];
    [self.view addSubview:remaindLab2];

    [remaindLab2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(Margin_Length);
        make.top.equalTo(remaindLab1.mas_bottom).offset(8);
        make.right.equalTo(self.view).offset(-Margin_Length);
    }];

    //白色背景
    UIView *backView = [[UIView alloc] init];
    backView.backgroundColor = COLOR_COMMON_WHITE;
    [self.view addSubview:backView];

    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(remaindLab2.mas_bottom).offset(Margin_Length);
        make.height.equalTo(@(Cell_Height));
    }];

    [XYCellLine initWithTopLineAtSuperView:backView];
    [XYCellLine initWithBottomLineAtSuperView:backView];

    self.codeTextField = [[UITextField alloc] init];
    self.codeTextField.font = TEXT_FONT_14;
    self.codeTextField.textColor = COLOR_MAIN_GREY;
    self.codeTextField.textAlignment = NSTextAlignmentLeft;
    self.codeTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.codeTextField.keyboardType = UIKeyboardTypeNumberPad;
    self.codeTextField.placeholder = XYBString(@"str_account_KqCharge_messageCode", @"短信验证码");
    self.codeTextField.delegate = self;
    [backView addSubview:self.codeTextField];

    [self.codeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backView).offset(Margin_Length);
        make.centerY.equalTo(backView);
        make.height.equalTo(@(Cell_Height));
    }];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didTextFieldTextChange:) name:UITextFieldTextDidChangeNotification object:nil];

    //发送验证码 XYBString(@"str_account_KqCharge_postMessageCode", @"发送验证码")
    self.postCodeBtn = [[XYButton alloc] initWithSubordinationButtonTitle:XYBString(@"str_account_KqCharge_postMessageCode", @"获取验证码") isUserInteractionEnabled:YES];
    [self.postCodeBtn addTarget:self action:@selector(clickPostCodeBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.postCodeBtn.titleLabel.font = TEXT_FONT_16;
    [backView addSubview:self.postCodeBtn];

    [self.postCodeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(backView.mas_centerY);
        make.right.equalTo(backView).offset(-Margin_Length);
        make.left.equalTo(self.codeTextField.mas_right).offset(5);
        make.width.equalTo(@(82));
    }];

    //确认绑卡
    _bindCardBtn = [[ColorButton alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth - 30, Cell_Height) Title:XYBString(@"str_account_KqCharge_sureBindCard", @"确认绑卡") ByGradientType:leftToRight];
    [_bindCardBtn addTarget:self action:@selector(clickBindCardBtn:) forControlEvents:UIControlEventTouchUpInside];
    _bindCardBtn.isColorEnabled = NO;
    [self.view addSubview:_bindCardBtn];

    [_bindCardBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(Margin_Length);
        make.top.equalTo(backView.mas_bottom).offset(Margin_Length);
        make.right.equalTo(self.view).offset(-Margin_Length);
        make.height.equalTo(@(Cell_Height));
    }];

    //暂不绑定银行卡
    XYButton *cancelBtn = [[XYButton alloc] initWithSubordinationButtonTitle:XYBString(@"str_account_KqCharge_noBindCard", @"暂不绑定银行卡") isUserInteractionEnabled:YES];
    cancelBtn.titleLabel.font = TEXT_FONT_14;
    [cancelBtn addTarget:self action:@selector(clickCancelBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cancelBtn];

    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(_bindCardBtn.mas_bottom).offset(Margin_Length);
    }];
}

#pragma mark - 点击事件部分

/**
 *  @brief 返回点击事件
 */
- (void)clickLeftNavBtn:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    self.cancelBlock(1);
}

/**
 *  @brief 发送验证码点击事件
 */
- (void)clickPostCodeBtn:(id)sender {
    [self.codeTextField resignFirstResponder];

    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    NSString *userId = [NSString stringWithFormat:@"%@", [UserDefaultsUtil getUser].userId];
    [param setValue:userId forKey:@"userId"];
    [self requestkQ_DLJQ_SendCodeWithParam:[param copy]];
}

/**
 *  @brief 确认绑卡点击事件
 */
- (void)clickBindCardBtn:(id)sender {
    [self.codeTextField resignFirstResponder];

    //判断其输入是否为整数
    if (![StrUtil isPureInt:self.codeTextField.text]) {
        [HUD showPromptViewWithToShowStr:XYBString(@"str_financing_integralNumberEnter", @"验证码须为数字") autoHide:YES afterDelay:1.0 userInteractionEnabled:YES];
        return;
    }

    //判断是否为6位
    if (self.codeTextField.text.length != 6) {
        [HUD showPromptViewWithToShowStr:XYBString(@"str_account_KqCharge_enterSixCodePlease", @"请输入6位数字的验证码") autoHide:YES afterDelay:1.0 userInteractionEnabled:YES];
        return;
    }

    //验证验证码
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    NSString *userId = [NSString stringWithFormat:@"%@", [UserDefaultsUtil getUser].userId]; //这样取防止崩溃
    [param setValue:userId forKey:@"userId"];
    [param setValue:self.codeTextField.text forKey:@"code"];
    [self requestkQ_DLJQ_VerifyCodeWithParam:[param copy]];
}

/**
 *  @brief 暂不绑定银行卡点击事件
 */
- (void)clickCancelBtn:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    self.cancelBlock(1);
}

/**
 *  messageCode 监听事件
 */
- (void)didTextFieldTextChange:(NSNotification *)notification {
    if (self.codeTextField.text.length > 0) {
        self.bindCardBtn.isColorEnabled = YES;
    } else {
        self.bindCardBtn.isColorEnabled = NO;
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - textField Delegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (range.length + range.location > textField.text.length) {
        return NO;
    }
    NSUInteger length = textField.text.length + string.length - range.length;
    return length <= 6;
}

- (void)timeGo {

    __block int timeout = 60;

    dispatch_queue_t queen = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queen);
    dispatch_source_set_timer(timer, dispatch_walltime(NULL, 0), 1.0 * NSEC_PER_SEC, 0);

    dispatch_source_set_event_handler(timer, ^{
        if (timeout <= 0) {
            dispatch_source_cancel(timer);
            dispatch_async(dispatch_get_main_queue(), ^{

                [self.postCodeBtn setTitle:XYBString(@"str_account_KqCharge_postMessageCodeAgain", @"重新获取验证码") forState:UIControlStateNormal];
                [self.postCodeBtn setTitleColor:COLOR_MAIN forState:UIControlStateNormal];
                self.postCodeBtn.titleLabel.font = NORMAL_TEXT_FONT_15;
                self.postCodeBtn.userInteractionEnabled = YES;
                [self.postCodeBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.width.equalTo(@(110));
                }];
            });
        } else {

            NSString *strTime = [NSString stringWithFormat:@"%.2d", timeout];
            dispatch_async(dispatch_get_main_queue(), ^{

                [self.postCodeBtn setTitle:[NSString stringWithFormat:@"%@秒", strTime] forState:UIControlStateNormal];
                [self.postCodeBtn setTitleColor:COLOR_AUXILIARY_GREY forState:UIControlStateNormal];
                self.postCodeBtn.titleLabel.font = TEXT_FONT_16;
                self.postCodeBtn.userInteractionEnabled = NO;
                [self.postCodeBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.width.equalTo(@(40));
                }];
            });
            timeout--;
        }
    });
    dispatch_resume(timer);
}

#pragma mark - 快钱独立鉴权（发送验证码） webservice

/**
 *
 *  @brief 快钱独立鉴权（发送验证码）
 *
 *  @param param userId
 */
- (void)requestkQ_DLJQ_SendCodeWithParam:(NSDictionary *)param {
    NSString *requestUrl = [RequestURL getRequestURL:KqdljqSendCode param:param];
    [self showDataLoading];
    [WebService postRequest:requestUrl param:param JSONModelClass:[ResponseModel class]
        Success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [self hideLoading];
            [self timeGo];
        }

        fail:^(AFHTTPRequestOperation *operation, NSString *errorMessage) {
            [self hideLoading];
            [self showPromptTip:errorMessage];
        }];
}

#pragma mark - 快钱独立鉴权（验证验证码） webservice

/**
 *  快钱独立鉴权（验证验证码）
 *
 *  @param param userId + 验证码
 */
- (void)requestkQ_DLJQ_VerifyCodeWithParam:(NSDictionary *)param {
    NSString *requestUrl = [RequestURL getRequestURL:KqdljqVerifyCode param:param];
    [self showDataLoading];
    [WebService postRequest:requestUrl param:param JSONModelClass:[ResponseModel class]

        Success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [self hideLoading];
            ResponseModel *model = responseObject;
            if (model.resultCode == 1) {
                //验证成功后，bindBlock回调，页面消失，出现快钱弹窗
                [self dismissViewControllerAnimated:YES completion:nil];
                _bindBlock(0);
            }
        }
        fail:^(AFHTTPRequestOperation *operation, NSString *errorMessage) {
            [self hideLoading];
            [self showPromptTip:errorMessage];
        }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
