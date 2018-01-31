//
//  PhoneLoginViewController.m
//  Ixyb
//
//  Created by dengjian on 16/7/15.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import "PhoneLoginViewController.h"

#import "LoginFlowViewController.h"
#import "OpenUDID.h"
#import "RTLabel.h"
#import "Utility.h"
#import "WebviewViewController.h"
#import "XYCellLine.h"

#import "XiaoNengSdkUtil.h"

#import "H5UrlDefine.h"
#import "LoginResponseModel.h"
#import "WebService.h"

@interface PhoneLoginViewController () <RTLabelDelegate, UITextFieldDelegate>

@property (nonatomic, strong) XYTextField *userNameTextField;
@property (nonatomic, strong) UIButton *codeButton;
@property (nonatomic, strong) XYTextField *verifyCodeTextField;
@property (nonatomic, strong) ColorButton *loginButton;

@end

@implementation PhoneLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initUI];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didTextChanged:) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)didTextChanged:(NSNotification *)notification {

    if (self.userNameTextField.text.length > 0 && self.verifyCodeTextField.text.length > 0) {
        self.loginButton.isColorEnabled = YES;
    } else {
        self.loginButton.isColorEnabled = NO;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)initUI {
    self.navItem.title = XYBString(@"string_phone_login", @"手机快捷登录");
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

    UIView *inputBgView = [[UIView alloc] init];
    inputBgView.backgroundColor = COLOR_COMMON_WHITE;
    [scrollView addSubview:inputBgView];

    [inputBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(vi);
        make.top.equalTo(@16);
    }];

    [XYCellLine initWithTopLineAtSuperView:inputBgView];
    [XYCellLine initWithHalfMiddleLineAtSuperView:inputBgView];
    [XYCellLine initWithBottomLineAtSuperView:inputBgView];

    self.userNameTextField = [[XYTextField alloc] initWithIsEnabledNoPaste:YES];
    self.userNameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.userNameTextField.placeholder = XYBString(@"str_login_enterTelePhone", @"请输入手机号码");
    self.userNameTextField.font = TEXT_FONT_16;
    self.userNameTextField.keyboardType = UIKeyboardTypeNumberPad;
    NSString *lastUserName = [[NSUserDefaults standardUserDefaults] objectForKey:@"xyb_login_last_username"];
    if (lastUserName && lastUserName.length > 0) {
        self.userNameTextField.text = lastUserName;
    }
    self.userNameTextField.delegate = self;
    [inputBgView addSubview:self.userNameTextField];

    [self.userNameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(inputBgView.mas_top).offset(0);
        make.left.equalTo(@Margin_Length);
        make.right.equalTo(self.view.mas_right).offset(-107);
        make.height.equalTo(@(Cell_Height));
    }];

    self.codeButton = [[XYButton alloc] initWithSubordinationButtonTitle:XYBString(@"str_account_KqCharge_postMessageCode", @"获取验证码") isUserInteractionEnabled:YES];
    [self.codeButton addTarget:self action:@selector(clickCodeButton:) forControlEvents:UIControlEventTouchUpInside];
    self.codeButton.titleLabel.font = TEXT_FONT_16;
    [inputBgView addSubview:self.codeButton];

    [self.codeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@-Margin_Length);
        make.centerY.equalTo(self.userNameTextField.mas_centerY);
    }];

    self.verifyCodeTextField = [[XYTextField alloc] initWithIsEnabledNoPaste:YES];
    self.verifyCodeTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.verifyCodeTextField.keyboardType = UIKeyboardTypeNumberPad;
    self.verifyCodeTextField.placeholder = XYBString(@"str_login_pleaseEnterEmailCode", @"请输入短信验证码");
    self.verifyCodeTextField.font = TEXT_FONT_16;
    self.verifyCodeTextField.delegate = self;
    [inputBgView addSubview:self.verifyCodeTextField];

    [self.verifyCodeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.userNameTextField.mas_bottom).offset(Line_Height);
        make.left.equalTo(@(Margin_Length));
        make.right.equalTo(@(-Margin_Length));
        make.height.equalTo(@(Cell_Height));
        make.bottom.equalTo(inputBgView.mas_bottom).offset(0);
    }];

    
    self.loginButton  = [[ColorButton alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth - 15, Cell_Height) Title:XYBString(@"str_login_verify_and_login", @"验证并登录") ByGradientType:leftToRight];
    self.loginButton.titleLabel.font = TEXT_FONT_16;
    [self.loginButton addTarget:self action:@selector(clickLoginButton:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:self.loginButton];

    [self.loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.left.equalTo(@Margin_Length);
        make.top.equalTo(inputBgView.mas_bottom).offset(20);
        make.height.equalTo(@(Cell_Height));
    }];

    if (self.userNameTextField.text.length > 0 && self.verifyCodeTextField.text.length > 0) {
        self.loginButton.isColorEnabled = YES;
    } else {
        self.loginButton.isColorEnabled = NO;
    }
}

- (void)hideKeyBorad {
    if (self.userNameTextField) {
        [self.userNameTextField resignFirstResponder];
    }
    if (self.verifyCodeTextField) {
        [self.verifyCodeTextField resignFirstResponder];
    }
}

- (void)clickCodeButton:(id)sender {
    [self hideKeyBorad];
    [self reqVerifyCode];
}

- (void)clickBackBtn:(id)sender {
    [self hideKeyBorad];

    [self.navigationController popViewControllerAnimated:YES];
}

- (void)clickLoginButton:(id)sender {

    [self reqPhoneLogin];
}

- (void)rtLabel:(id)rtLabel didSelectLinkWithURL:(NSURL *)url {
    if ([url.description isEqualToString:@"sytk"]) {
        NSString *requestUrl = [Constant sharedConstant].baseUrl;
        NSString *urlStr = [NSString stringWithFormat:@"%@%@", requestUrl, App_Protocol_URL];
        NSString *titleStr = XYBString(@"str_xyb_service_protocol", @"信用宝服务协议");
        WebviewViewController *webView = [[WebviewViewController alloc] initWithTitle:titleStr webUrlString:urlStr];
        [self.navigationController pushViewController:webView animated:YES];
    } else if ([url.description isEqualToString:@"ystk"]) {
    }
}

- (void)reqVerifyCode {

    NSString *errMsg = [Utility checkUserName:self.userNameTextField.text];
    if (errMsg != nil) {
        [self showDelayTip:errMsg];
        return;
    }

    NSDictionary *param = @{
        @"mobilePhone" : self.userNameTextField.text,
        @"businessType" : [NSNumber numberWithInt:7] //1 注册，2 重置密码，3 提现，4 修改交易密码，5 验证原手机 6 绑定新手机
    };

    [self requestGetVerifyCodeWithDictionary:[NSMutableDictionary dictionaryWithDictionary:param]];
}

- (void)requestGetVerifyCodeWithDictionary:(NSMutableDictionary *)param {

    NSString *requestURL = [RequestURL getRequestURL:UserPhoneVerifyCodeRequestURL param:param];
    [self showDataLoading];
    [WebService postRequest:requestURL param:param JSONModelClass:[ResponseModel class] Success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self hideLoading];
        [self countDownTheButton];

    }
        fail:^(AFHTTPRequestOperation *operation, NSString *errorMessage) {
            [self hideLoading];
            [self showPromptTip:errorMessage];
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

                [self.codeButton setTitle:XYBString(@"str_account_KqCharge_postMessageCode", @"获取验证码") forState:UIControlStateNormal];
                [self.codeButton setBackgroundColor:COLOR_COMMON_WHITE];
                [self.codeButton setTitleColor:COLOR_MAIN forState:UIControlStateNormal];
                self.codeButton.titleLabel.font = TEXT_FONT_16;
                self.codeButton.userInteractionEnabled = YES;

            });
        } else {

            NSString *strTime = [NSString stringWithFormat:@"%.2d", timeout];
            dispatch_async(dispatch_get_main_queue(), ^{

                [self.codeButton setTitle:[NSString stringWithFormat:XYBString(@"str_login_resend_some", @"重新获取(%@)"), strTime] forState:UIControlStateNormal];
                [self.codeButton setTitleColor:COLOR_AUXILIARY_GREY forState:UIControlStateNormal];
                self.codeButton.titleLabel.font = TEXT_FONT_16;
                self.codeButton.userInteractionEnabled = NO;

            });
            timeout--;
        }
    });
    dispatch_resume(timer);
}

- (void)reqPhoneLogin {

    [self hideKeyBorad];
    NSString *errMsg = nil;
    if (errMsg == nil) {
        errMsg = [Utility checkUserName:self.userNameTextField.text];
    }
    if (errMsg == nil) {
        errMsg = [Utility checkVerifyCode:self.verifyCodeTextField.text];
    }
    if (errMsg != nil) {
        [self showPromptTip:errMsg];
        return;
    }

    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];

    if (self.userNameTextField.text) {
        [param setObject:self.userNameTextField.text forKey:@"mobilePhone"];
    }

    if (self.verifyCodeTextField.text) {
        [param setObject:self.verifyCodeTextField.text forKey:@"code"];
    }

    NSString *deviceToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"deviceToken"];
    if (deviceToken) {
        [param setObject:deviceToken forKey:@"deviceToken"];
    }

    [self showDataLoading];

    NSString *requestURL = [RequestURL getRequestURL:UserPhoneSMSRequestURL param:param];
    [WebService postRequest:requestURL param:param JSONModelClass:[LoginResponseModel class] Success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self hideLoading];
        LoginResponseModel *loginResponseModel = responseObject;

        if (loginResponseModel.user && ![loginResponseModel.user isKindOfClass:[NSNull class]]) {
            User *user = [[User alloc] init];
            NSString *userId = [NSString stringWithFormat:@"%@", loginResponseModel.user.id];
            NSUserDefaults *userUser = [NSUserDefaults standardUserDefaults];

            if (![loginResponseModel.user.id isEqualToString:@" "]) {
                NSDictionary *gestureDic = [userUser objectForKey:userId];
                user.gestureUnlock = [gestureDic objectForKey:@"gestureUnlock"];
                user.gestureUnlockNumber = [gestureDic objectForKey:@"gestureUnlockNumber"];
            }

            [userUser setObject:[NSDate date] forKey:@"scoreDate"];
            [userUser synchronize];

            user.userId = loginResponseModel.user.id;
            user.tel = loginResponseModel.user.mobilePhone;
            user.isHaveAddr = [loginResponseModel.user.isHaveAddr boolValue];
            user.userName = loginResponseModel.user.username;
            user.isIdentityAuth = loginResponseModel.user.isIdentityAuth;
            user.isPhoneAuth = loginResponseModel.user.isPhoneAuth;
            user.isTradePassword = loginResponseModel.user.isTradePassword;
            user.url = loginResponseModel.user.url;
            user.recommendCode = loginResponseModel.user.recommendCode;
            user.email = loginResponseModel.user.email;
            user.isNewUser = loginResponseModel.user.isNewUser;
            user.bonusState = loginResponseModel.user.bonusState;
            user.loginToken = loginResponseModel.loginToken;
            user.realName = loginResponseModel.user.realName;
            [UserDefaultsUtil setUser:user];

            NSString *lastLoginName = [param objectForKey:@"mobilePhone"];
            if (lastLoginName && lastLoginName.length > 0) {
                [[NSUserDefaults standardUserDefaults] setObject:lastLoginName forKey:@"xyb_login_last_username"];
            }

            //登录成功初始化小能 用户
            [XiaoNengSdkUtil initXNUser];


            if ([Utility shareInstance].isGestureUnlock) {
                [Utility shareInstance].isGestureUnlock = NO;
                [[NSNotificationCenter defaultCenter] postNotificationName:@"loadLoginView" object:nil];
            }

            //缓存是否测评字段
            [self synchronizeTheTestState:loginResponseModel.isEvaluation];
            //缓存是否强制测评字段，后台可控
            [self synchronizeIsForceEvaluation:loginResponseModel.forceEvaluation];

            if (self.loginFlowDelegate && [self.loginFlowDelegate respondsToSelector:@selector(loginFlowDidFinish:)]) {
                if ([loginResponseModel.user.isIdentityAuth intValue] == 0) {
                    [self.loginFlowDelegate loginFlowDidFinish:LoginFlowStateDoneUnIdentityAuth];
                } else {
                    [self.loginFlowDelegate loginFlowDidFinish:LoginFlowStateDone];
                }
            }
        }
    }
        fail:^(AFHTTPRequestOperation *operation, NSString *errorMessage) {
            [self hideLoading];
            [self showPromptTip:errorMessage];
        }];
}

/**
 *  缓存是否测评的字段
 *
 *  @param isEvaluation 是否测评
 */
- (void)synchronizeTheTestState:(BOOL)isEvaluation {

    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setBool:isEvaluation forKey:@"isEvaluation"];
    [userDefault synchronize];
}

/**
 *  缓存是否是否强制测评的字段，开关：控制测评弹出框
 *
 *  @param isEvaluation 是否强制测评
 */
- (void)synchronizeIsForceEvaluation:(BOOL)forceEvaluation {

    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setBool:forceEvaluation forKey:@"forceEvaluation"];
    [userDefault synchronize];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == self.userNameTextField) {
        if (string.length == 0) return YES;

        NSInteger existedLength = textField.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = string.length;
        if (existedLength - selectedLength + replaceLength > 11) {
            return NO;
        }

    } else if (textField == self.verifyCodeTextField) {
        if (string.length == 0) return YES;

        NSInteger existedLength = textField.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = string.length;
        if (existedLength - selectedLength + replaceLength > 6) {
            return NO;
        }
    }

    return YES;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
