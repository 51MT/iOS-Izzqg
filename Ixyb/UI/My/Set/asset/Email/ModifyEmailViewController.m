//
//  ModifyEmailViewController.m
//  Ixyb
//
//  Created by qiushuitian on 6/1/2016.
//  Copyright © 2016 xyb. All rights reserved.
//

#import "ModifyEmailViewController.h"

#import "Utility.h"

#import "EmailActiveAlertView.h"
#import "ProgressWebViewController.h"
#import "RegisterProblemViewController.h"
#import "User.h"
#import "WebService.h"
#import "XYButton.h"
#import "XYCellLine.h"

@interface ModifyEmailViewController ()
@property (nonatomic, strong) UITextField *verifyCodeTextField;
@property (nonatomic, strong) UITextField *emailTextField;

@property (nonatomic, strong) XYButton *codeButton;
@property (nonatomic, strong) ColorButton *submitButton;

@end

@implementation ModifyEmailViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initUI];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didTextChanged:) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)didTextChanged:(NSNotification *)notification {

    if (self.emailTextField.text.length > 0 && self.verifyCodeTextField.text.length > 0) {
        self.submitButton.isColorEnabled = YES;
    } else {
        self.submitButton.isColorEnabled = NO;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)initUI {
    self.navItem.title = XYBString(@"string_modify_email", @"修改邮箱");
    self.navItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(clickBackBtn:)];

    self.view.backgroundColor = COLOR_BG;
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight)];
    scrollView.scrollEnabled = NO;
    [self.view addSubview:scrollView];

    UIView *vi = [[UIView alloc] init];
    [scrollView addSubview:vi];

    [vi mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navBar.mas_bottom);
        make.left.right.equalTo(self.view);
        make.width.equalTo(@(MainScreenWidth));
        make.height.equalTo(@1);
    }];

    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navBar.mas_bottom);
        make.left.right.bottom.equalTo(self.view);

    }];

    User *user = [UserDefaultsUtil getUser];
    UILabel *tipEmailLabel = [[UILabel alloc] init];
    if (user.email == nil || user.email.length <= 0) {
        tipEmailLabel.text = XYBString(@"string_register_curr_email", @"当前邮箱：");
    } else {
        tipEmailLabel.text = [NSString stringWithFormat:XYBString(@"string_register_curr_email_some", @"当前邮箱：%@"), user.email];
    }

    tipEmailLabel.font = TEXT_FONT_14;
    tipEmailLabel.textColor = COLOR_AUXILIARY_GREY;
    [scrollView addSubview:tipEmailLabel];
    [tipEmailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(@Margin_Length);
    }];

    UILabel *tipPhoneLabel = [[UILabel alloc] init];
    tipPhoneLabel.text = [NSString stringWithFormat:XYBString(@"string_register_curr_phone_some", @"绑定手机：%@"), [Utility thePhoneReplaceTheStr:user.tel]];
    tipPhoneLabel.font = TEXT_FONT_14;
    tipPhoneLabel.textColor = COLOR_AUXILIARY_GREY;
    [scrollView addSubview:tipPhoneLabel];
    [tipPhoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(tipEmailLabel);
        make.top.equalTo(tipEmailLabel.mas_bottom).offset(Margin_Length);
    }];

    UIView *inputBgView = [[UIView alloc] init];
    [scrollView addSubview:inputBgView];
    inputBgView.backgroundColor = COLOR_COMMON_WHITE;
    [inputBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(vi);
        make.top.equalTo(tipPhoneLabel.mas_bottom).offset(Margin_Length);
    }];

    self.verifyCodeTextField = [[UITextField alloc] init];
    self.verifyCodeTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.verifyCodeTextField.placeholder = XYBString(@"string_please_input_the_verify_code", @"请输入短信中的验证码");
    self.verifyCodeTextField.font = TEXT_FONT_16;
    self.verifyCodeTextField.textColor = COLOR_MAIN_GREY;
    self.verifyCodeTextField.keyboardType = UIKeyboardTypeNumberPad;
    [inputBgView addSubview:self.verifyCodeTextField];

    [self.verifyCodeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(inputBgView.mas_top).offset(Line_Height);
        make.left.equalTo(@Margin_Length);
        make.height.equalTo(@(Cell_Height));
        make.right.equalTo(inputBgView.mas_right).offset(-100);
    }];

    self.codeButton = [[XYButton alloc] initWithSubordinationButtonTitle:@"获取验证码" isUserInteractionEnabled:YES];
    self.codeButton.titleLabel.font = TEXT_FONT_16;
    [self.codeButton addTarget:self action:@selector(clickCodeButton:) forControlEvents:UIControlEventTouchUpInside];
    [inputBgView addSubview:self.codeButton];

    [self.codeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@-Margin_Length);
        make.centerY.equalTo(self.verifyCodeTextField.mas_centerY);
    }];

    self.emailTextField = [[UITextField alloc] init];
    self.emailTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.emailTextField.placeholder = XYBString(@"string_input_new_email", @"输入新的邮箱地址");
    self.emailTextField.font = TEXT_FONT_16;
    self.emailTextField.textColor = COLOR_MAIN_GREY;
    [inputBgView addSubview:self.emailTextField];

    [self.emailTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.verifyCodeTextField.mas_bottom).offset(Line_Height);
        make.left.equalTo(@(Margin_Length));
        make.right.equalTo(@(-Margin_Length));
        make.height.equalTo(@(Cell_Height));
        make.bottom.equalTo(inputBgView.mas_bottom);
    }];

    [XYCellLine initWithTopLineAtSuperView:inputBgView];
    [XYCellLine initWithMiddleLineAtSuperView:inputBgView];
    [XYCellLine initWithBottomLineAtSuperView:inputBgView];

   
    self.submitButton  = [[ColorButton alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth - 30, Button_Height) Title:@"确定" ByGradientType:leftToRight];
    [self.submitButton addTarget:self action:@selector(clickSubmitButton:) forControlEvents:UIControlEventTouchUpInside];
    self.submitButton.isColorEnabled = NO;
    [scrollView addSubview:self.submitButton];

    [self.submitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(vi.mas_left).offset(Margin_Length);
        make.right.equalTo(vi.mas_right).offset(-Margin_Length);
        make.top.equalTo(self.emailTextField.mas_bottom).offset(20);
        make.height.equalTo(@45);
    }];

    UIButton *forgetQuestionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [forgetQuestionButton setTitle:XYBString(@"string_modify_email_question", @"修改邮箱遇到问题?") forState:UIControlStateNormal];
    [forgetQuestionButton setTitleColor:COLOR_MAIN forState:UIControlStateNormal];
    forgetQuestionButton.titleLabel.font = TEXT_FONT_14;
    [forgetQuestionButton addTarget:self action:@selector(clickForgetQuestionButton:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:forgetQuestionButton];

    [forgetQuestionButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.submitButton.mas_right);
        make.top.equalTo(self.submitButton.mas_bottom).offset(10);
    }];

    if (self.emailTextField.text.length > 0 && self.verifyCodeTextField.text.length > 0) {
        self.submitButton.isColorEnabled = YES;
    } else {
        self.submitButton.isColorEnabled = NO;
    }
}

- (void)clickBackBtn:(id)sender {
    [self hideKeyBorad];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)hideKeyBorad {
    if (self.verifyCodeTextField) {
        [self.verifyCodeTextField resignFirstResponder];
    }
    if (self.emailTextField) {
        [self.emailTextField resignFirstResponder];
    }
}

- (void)clickSubmitButton:(id)sender {
    [self hideKeyBorad];

    NSString *errMsg = nil;
    if (errMsg == nil) {
        errMsg = [Utility checkVerifyCode:self.verifyCodeTextField.text];
    }
    if (errMsg == nil) {
        errMsg = [Utility checkEmail:self.emailTextField.text];
    }

    if (errMsg != nil) {
        [self showPromptTip:errMsg];
        return;
    }

    NSDictionary *param = @{
        @"userId" : [UserDefaultsUtil getUser].userId,
        @"email" : self.emailTextField.text,
        @"code" : self.verifyCodeTextField.text,
        @"mobilePhone" : [UserDefaultsUtil getUser].tel
    };
    [self callBindEmailWebService:param];
}

- (void)callBindEmailWebService:(NSDictionary *)param {
    [self showDataLoading];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:param];
    NSString *urlPath = [RequestURL getRequestURL:BindEmailURL param:params];

    [WebService postRequest:urlPath param:params JSONModelClass:[ResponseModel class] Success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self hideLoading];
        ResponseModel *Response = responseObject;
        if (Response.resultCode == 1) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"bindEmailSuccessNotificaton" object:nil];

            User *user = [UserDefaultsUtil getUser];
            user.email = self.emailTextField.text;
            [UserDefaultsUtil setUser:user];

            EmailActiveAlertView *activeView = [[EmailActiveAlertView alloc] init];
            [activeView show:^(EmailActiveAlertViewAction action) {
                if (action == EmailActiveAlertViewActionCancel) {
                    [self hideKeyBorad];
                    [self.navigationController popViewControllerAnimated:YES];
                } else {
                    [[UIApplication sharedApplication] openURL:[Utility emailWebAddress:self.emailTextField.text]];
                }
            }];
        }

    }
        fail:^(AFHTTPRequestOperation *operation, NSString *errorMessage) {

            [self hideLoading];
            [self showPromptTip:errorMessage];
        }];
}

- (void)clickForgetQuestionButton:(id)sender {
    RegisterProblemViewController *registerProblemViewController = [[RegisterProblemViewController alloc] init];
    [self.navigationController pushViewController:registerProblemViewController animated:YES];
}

- (void)clickCodeButton:(id)sender {
    [self.verifyCodeTextField becomeFirstResponder];
    [self reqVerifyCode];
}

- (void)reqVerifyCode {

    NSDictionary *param = @{
        @"mobilePhone" : [UserDefaultsUtil getUser].tel,
        @"businessType" : [NSNumber numberWithInt:8] //1 注册，2 重置密码，3 提现，4 修改交易密码，5 验证原手机 6 绑定新手机
    };
    [self requestGetVerifyCodeWithDictionary:param];
}
/*****************************获取验证码接口**********************************/
- (void)requestGetVerifyCodeWithDictionary:(NSDictionary *)param {

    NSString *requestURL = [RequestURL getRequestURL:UserPhoneVerifyCodeRequestURL param:param];
    [self showDataLoading];
    [WebService postRequest:requestURL param:param JSONModelClass:[ResponseModel class] Success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self hideLoading];
        [self countDownTheButton];

    }
        fail:^(AFHTTPRequestOperation *operation, NSString *errorMessage) {
            [self.codeButton setTitle:XYBString(@"string_send_again", @"重新获取") forState:UIControlStateNormal];
            [self.codeButton setTitleColor:COLOR_MAIN forState:UIControlStateNormal];
            self.codeButton.titleLabel.font = TEXT_FONT_16;
            [self.codeButton setBackgroundColor:COLOR_COMMON_WHITE];
            self.codeButton.userInteractionEnabled = YES;

            [self showDelayTip:errorMessage];
        }];
}

- (void)countDownTheButton {

    __block int timeout = 60;

    dispatch_queue_t queen = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queen);
    dispatch_source_set_timer(timer, dispatch_walltime(NULL, 0), 1.0 * NSEC_PER_SEC, 0);

    dispatch_source_set_event_handler(timer, ^{
        if (timeout <= 0) {
            dispatch_source_cancel(timer);
            dispatch_async(dispatch_get_main_queue(), ^{

                [self.codeButton setTitle:XYBString(@"string_send_varify_code", @"获取验证码") forState:UIControlStateNormal];
                [self.codeButton setBackgroundColor:COLOR_COMMON_WHITE];
                [self.codeButton setTitleColor:COLOR_MAIN forState:UIControlStateNormal];
                self.codeButton.titleLabel.font = TEXT_FONT_16;
                self.codeButton.userInteractionEnabled = YES;

            });
        } else {

            NSString *strTime = [NSString stringWithFormat:@"%.2d", timeout];
            dispatch_async(dispatch_get_main_queue(), ^{

                [self.codeButton setTitle:[NSString stringWithFormat:XYBString(@"string_resend_some", @"重新获取(%@)"), strTime] forState:UIControlStateNormal];
                [self.codeButton setTitleColor:COLOR_AUXILIARY_GREY forState:UIControlStateNormal];
                self.codeButton.titleLabel.font = TEXT_FONT_16;
                self.codeButton.userInteractionEnabled = NO;

            });
            timeout--;
        }
    });
    dispatch_resume(timer);
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
