//
//  ChangeUserPhoneViewController.m
//  Ixyb
//
//  Created by dengjian on 16/4/27.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import "ChangeUserPhoneViewController.h"
#import "PinlessNewPhoneViewController.h"
#import "Utility.h"
#import "WebService.h"
#import "XYCellLine.h"

@interface ChangeUserPhoneViewController () {
    MBProgressHUD *hud;
}

@end

@implementation ChangeUserPhoneViewController

- (void)setNav {
    self.navItem.title = XYBString(@"string_modify_phone", @"手机修改");

    self.navItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(clickBackBtn:)];
}

- (void)clickBackBtn:(id)sender {
    [_codeTextField resignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {

    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setNav];
    [self createMainView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didTextChanged:) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)didTextChanged:(NSNotification *)notification {

    if (self.codeTextField.text.length > 0) {
        self.nextButton.isColorEnabled = YES;
    } else {
        self.nextButton.isColorEnabled = NO;
    }
}

- (void)createMainView {
    UILabel *phoneLab = [[UILabel alloc] initWithFrame:CGRectZero]; //手机号字符
    phoneLab.text = @"原手机号：";
    phoneLab.font = TEXT_FONT_14;
    phoneLab.textAlignment = NSTextAlignmentLeft;
    phoneLab.textColor = COLOR_AUXILIARY_GREY;
    [self.view addSubview:phoneLab];

    [phoneLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navBar.mas_bottom).offset(Margin_Length);
        make.left.equalTo(@Margin_Length);
    }];

    self.phoneLabel = [[UILabel alloc] initWithFrame:CGRectZero]; //显示的手机号码
    self.phoneLabel.text = [Utility thePhoneReplaceTheStr:[UserDefaultsUtil getUser].tel];
    self.phoneLabel.font = TEXT_FONT_16;
    self.phoneLabel.textAlignment = NSTextAlignmentLeft;
    self.phoneLabel.textColor = COLOR_AUXILIARY_GREY;
    [self.view addSubview:self.phoneLabel];

    [self.phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(phoneLab.mas_right).offset(-8);
        make.centerY.equalTo(phoneLab.mas_centerY);
    }];

    UIView *backView = [[UIView alloc] initWithFrame:CGRectZero]; //白色背景
    backView.backgroundColor = COLOR_COMMON_WHITE;
    [self.view addSubview:backView];

    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(phoneLab.mas_bottom).offset(Margin_Length);
        make.height.equalTo(@45);
    }];

    self.codeTextField = [[UITextField alloc] initWithFrame:CGRectZero]; //验证码输入框
    self.codeTextField.placeholder = @"请输入短信中的验证码";
    self.codeTextField.font = TEXT_FONT_16;
    self.codeTextField.textColor = COLOR_MAIN_GREY;
    self.codeTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [backView addSubview:self.codeTextField];

    [self.codeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@Margin_Length);
        make.centerY.equalTo(backView.mas_centerY);
        make.right.equalTo(backView.mas_right).offset(-93);

    }];

    //    [_codeTextField becomeFirstResponder];

    _codeButton = [[XYButton alloc] initWithSubordinationButtonTitle:@"获取验证码" isUserInteractionEnabled:YES];
    [_codeButton addTarget:self action:@selector(clcikTheCodeButton:) forControlEvents:UIControlEventTouchUpInside];
    _codeButton.titleLabel.font = TEXT_FONT_16;
    _codeButton.titleLabel.textAlignment = NSTextAlignmentLeft;
    [backView addSubview:_codeButton];

    [_codeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.codeTextField.mas_right).offset(3);
        make.top.bottom.equalTo(backView);
    }];

    [XYCellLine initWithTopLineAtSuperView:backView]; //在白色背景上画分界线
    [XYCellLine initWithBottomLineAtSuperView:backView];

    _nextButton = [[ColorButton alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth - 30, Cell_Height) Title:@"下一步" ByGradientType:leftToRight];
    [_nextButton addTarget:self action:@selector(clickTheNextButton:) forControlEvents:UIControlEventTouchUpInside];
    _nextButton.isColorEnabled = NO;
    [self.view addSubview:_nextButton];

    [_nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@Margin_Length);
        make.top.equalTo(backView.mas_bottom).offset(20);
        make.right.equalTo(@(-Margin_Length));
        make.height.equalTo(@45);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)clickTheNextButton:(id)sender {

    [_codeTextField resignFirstResponder];

    if (_codeTextField.text.length == 0) {
        [HUD showPromptViewWithToShowStr:XYBString(@"string_please_input_code", @"请输入验证码") autoHide:YES afterDelay:1.0 userInteractionEnabled:YES];
        return;
    }

    [self requestCheckPhoneCodeWebServiceWithParam:@{
        @"mobilePhone" : [UserDefaultsUtil getUser].tel,
        @"code" : _codeTextField.text
    }];
}

- (IBAction)clcikTheCodeButton:(id)sender {

    [_codeTextField resignFirstResponder];

    [self requestGetVerifyCodeWithDictionary:@{
        @"mobilePhone" : [UserDefaultsUtil getUser].tel,
        @"businessType" : [NSNumber numberWithInt:5],
        @"userId" : [UserDefaultsUtil getUser].userId
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

                [_codeButton setTitle:XYBString(@"string_send_varify_code", @"获取验证码") forState:UIControlStateNormal];
                [_codeButton setBackgroundColor:COLOR_COMMON_WHITE];
                [_codeButton setTitleColor:COLOR_MAIN forState:UIControlStateNormal];
                _codeButton.titleLabel.font = TEXT_FONT_16;
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

/**
 *  获取验证码
 *
 *  @param param 入参
 */
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
            _codeButton.isEnabled = YES;

            [self hideLoading];
            [self showPromptTip:errorMessage];
        }];
}

/**
 *  检验手机验证码
 *
 *  @param param 入参
 */
- (void)requestCheckPhoneCodeWebServiceWithParam:(NSDictionary *)param {
    NSString *requestURL = [RequestURL getRequestURL:checkPhoneCodeURL param:param];
    [self showDataLoading];
    [WebService postRequest:requestURL param:param JSONModelClass:[ResponseModel class] Success:^(AFHTTPRequestOperation *operation, id responseObject) {

        [self hideLoading];
        ResponseModel *responseModel = responseObject;
        if (responseModel.resultCode == 1) {
            PinlessNewPhoneViewController *pinlessNewPhoneViewController = [[PinlessNewPhoneViewController alloc] init];
            [self.navigationController pushViewController:pinlessNewPhoneViewController animated:YES];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
