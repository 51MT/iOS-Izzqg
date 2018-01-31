//
//  PinlessNewPhoneViewController.m
//  Ixyb
//
//  Created by dengjian on 16/4/28.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import "PinlessNewPhoneViewController.h"

#import "AccountSafeSetViewController.h"
#import "Utility.h"
#import "WebService.h"
#import "XYCellLine.h"

@interface PinlessNewPhoneViewController () {
    MBProgressHUD *hud;
}
@end

@implementation PinlessNewPhoneViewController

- (void)setNav {
    self.navItem.title = XYBString(@"string_bind_phone", @"手机绑定");

    self.navItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(clickBackBtn:)];
}

- (void)clickBackBtn:(id)sender {
    [_phoneTextField resignFirstResponder];
    [_codeTextField resignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setNav];

    [self creatMainView];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didTextChanged:) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)didTextChanged:(NSNotification *)notification {

    if (self.phoneTextField.text.length > 0 && self.codeTextField.text.length > 0) {
        self.pinlessButton.isColorEnabled = YES;
    } else {
        self.pinlessButton.isColorEnabled = NO;
    }
}

- (void)creatMainView {
    UIView *backView = [[UIView alloc] init];
    backView.backgroundColor = COLOR_COMMON_WHITE;
    [self.view addSubview:backView];

    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.navBar.mas_bottom).offset(Margin_Length);
        make.height.equalTo(@105);
    }];

    self.phoneTextField = [[UITextField alloc] init];
    self.phoneTextField.font = TEXT_FONT_16;
    self.phoneTextField.textColor = COLOR_MAIN_GREY;
    self.phoneTextField.placeholder = @"请输入新手机号";
    self.phoneTextField.textColor = COLOR_MAIN_GREY;
    self.phoneTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [backView addSubview:self.phoneTextField];

    [self.phoneTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(backView.mas_centerX);
        make.left.equalTo(@Margin_Length);
        make.top.equalTo(backView.mas_top).offset(0);
        make.height.equalTo(@45);
    }];

    UIView *grayView = [[UIView alloc] init]; //两个文本框之间的灰色区域
    grayView.backgroundColor = COLOR_BG;
    [backView addSubview:grayView];

    [grayView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(backView);
        make.top.equalTo(self.phoneTextField.mas_bottom).offset(0);
        make.height.equalTo(@Margin_Length);
    }];

    [XYCellLine initWithTopLineAtSuperView:grayView];
    [XYCellLine initWithBottomLineAtSuperView:grayView];

    self.codeTextField = [[UITextField alloc] init];
    self.codeTextField.font = TEXT_FONT_16;
    self.codeTextField.placeholder = @"验证码";
    self.codeTextField.textColor = COLOR_MAIN_GREY;
    self.codeTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [backView addSubview:self.codeTextField];

    [self.codeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@Margin_Length);
        make.top.equalTo(grayView.mas_bottom).offset(0);
        make.right.equalTo(@(-93));
        make.height.equalTo(@45);
    }];

    self.codeButton = [[XYButton alloc] initWithSubordinationButtonTitle:@"获取验证码" isUserInteractionEnabled:YES];
    self.codeButton.titleLabel.font = TEXT_FONT_16;
    [self.codeButton addTarget:self action:@selector(clickTheCodeButton:) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:self.codeButton];

    [self.codeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.codeTextField.mas_centerY);
        make.right.equalTo(@(-Margin_Length));
    }];

    [XYCellLine initWithTopLineAtSuperView:backView];
    [XYCellLine initWithBottomLineAtSuperView:backView];

    self.pinlessButton  = [[ColorButton alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth - 30, Button_Height) Title:@"绑定" ByGradientType:leftToRight];
    [self.pinlessButton addTarget:self action:@selector(clickThePinlessButton:) forControlEvents:UIControlEventTouchUpInside];
    self.pinlessButton.isColorEnabled = NO;
    [self.view addSubview:self.pinlessButton];

    [self.pinlessButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@Margin_Length);
        make.right.equalTo(@(-Margin_Length));
        make.top.equalTo(self.codeTextField.mas_bottom).offset(20);
        make.height.equalTo(@45);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

                [_codeButton setTitle:XYBString(@"string_send_varify_code", @"获取验证码") forState:UIControlStateNormal];
                [_codeButton setBackgroundColor:COLOR_COMMON_WHITE];
                [_codeButton setTitleColor:COLOR_MAIN forState:UIControlStateNormal];
                _codeButton.titleLabel.font = [UIFont systemFontOfSize:12.0f];
                _codeButton.userInteractionEnabled = YES;

            });
        } else {

            NSString *strTime = [NSString stringWithFormat:@"%.2d", timeout];
            dispatch_async(dispatch_get_main_queue(), ^{

                [_codeButton setTitle:[NSString stringWithFormat:XYBString(@"string_resend_some", @"重新获取(%@)"), strTime] forState:UIControlStateNormal];
                [_codeButton setTitleColor:COLOR_AUXILIARY_GREY forState:UIControlStateNormal];
                _codeButton.titleLabel.font = [UIFont systemFontOfSize:12.0f];
                _codeButton.userInteractionEnabled = NO;

            });
            timeout--;
        }
    });
    dispatch_resume(timer);
}

- (void)clickTheCodeButton:(UIButton *)sender {

    [_phoneTextField resignFirstResponder];
    [_codeTextField resignFirstResponder];

    if (_phoneTextField.text.length == 0) {

        [HUD showPromptViewWithToShowStr:XYBString(@"string_enter_phone", @"请输入手机号") autoHide:YES afterDelay:1.0 userInteractionEnabled:YES];
        return;
    }

    if (![Utility isValidateMobile:_phoneTextField.text]) {
        [HUD showPromptViewWithToShowStr:XYBString(@"string_input_correct_phone_number", @"请输入正确的手机号") autoHide:YES afterDelay:1.0 userInteractionEnabled:YES];
        return;
    }

    [self requestGetVerifyCodeWithDictionary:@{
        @"mobilePhone" : _phoneTextField.text,
        @"businessType" : [NSNumber numberWithInt:6],
        @"userId" : [UserDefaultsUtil getUser].userId
    }];
}

- (void)clickThePinlessButton:(UIButton *)sender {

    [_codeTextField resignFirstResponder];
    [_phoneTextField resignFirstResponder];

    if (_codeTextField.text.length == 0) {

        [HUD showPromptViewWithToShowStr:XYBString(@"string_please_input_the_verify_code", @"请输入短信中的验证码") autoHide:YES afterDelay:1.0 userInteractionEnabled:YES];
        return;
    }
    if (_phoneTextField.text.length == 0) {

        [HUD showPromptViewWithToShowStr:XYBString(@"string_please_input_new_phone_number", @"请输入新手机号") autoHide:YES afterDelay:1.0 userInteractionEnabled:YES];
        return;
    }

    if (![Utility isValidateMobile:_phoneTextField.text]) {
        [HUD showPromptViewWithToShowStr:XYBString(@"string_input_correct_phone_number", @"请输入正确的手机号") autoHide:YES afterDelay:1.0 userInteractionEnabled:YES];
        return;
    }

    NSDictionary *contentDic = @{
        @"userId" : [UserDefaultsUtil getUser].userId,
        @"mobilePhone" : [UserDefaultsUtil getUser].tel,
        @"newMobilePhone" : _phoneTextField.text,
        @"code" : _codeTextField.text
    };
    [self callUpdateMobilePhoneWebService:contentDic];
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

/*****************************修改手机号码接口**********************************/
- (void)callUpdateMobilePhoneWebService:(NSDictionary *)dictionary {

    [self showDataLoading];

    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:dictionary];
    NSString *urlPath = [RequestURL getRequestURL:UpdateMobilePhoneURL param:params];

    [WebService postRequest:urlPath param:dictionary JSONModelClass:[ResponseModel class] Success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self hideLoading];
        ResponseModel *response = responseObject;
        if (response.resultCode == 1) {

            User *user = [UserDefaultsUtil getUser];
            user.tel = _phoneTextField.text;
            [UserDefaultsUtil setUser:user];

            NSString *lastLoginName = [dictionary objectForKey:@"mobilePhone"];
            if (lastLoginName && lastLoginName.length > 0) {
                [[NSUserDefaults standardUserDefaults] setObject:lastLoginName forKey:@"xyb_login_last_username"];
            }

            NSArray *arr = self.navigationController.viewControllers;
            for (UIViewController *controller in arr) {
                if ([controller isKindOfClass:[AccountSafeSetViewController class]]) {

                    [self.navigationController popToViewController:controller animated:YES];
                    return;
                }
            }
        }

    }
        fail:^(AFHTTPRequestOperation *operation, NSString *errorMessage) {

            [self hideLoading];
            [self showPromptTip:errorMessage];

        }];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
