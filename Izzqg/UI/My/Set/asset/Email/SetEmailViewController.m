//
//  SetEmailViewController.m
//  Ixyb
//
//  Created by qiushuitian on 6/1/2016.
//  Copyright © 2016 xyb. All rights reserved.
//

#import "SetEmailViewController.h"

#import "EmailActiveAlertView.h"
#import "Utility.h"
#import "WebService.h"

@interface SetEmailViewController ()
@property (nonatomic, strong) UITextField *emailTextField;
@property (nonatomic, strong) UIButton *submitButton;

@end

@implementation SetEmailViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)initUI {
    self.navItem.title = XYBString(@"string_bound_email", @"绑定邮箱");
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
    [scrollView addSubview:inputBgView];
    inputBgView.backgroundColor = COLOR_COMMON_WHITE;
    [inputBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(vi);
        make.top.equalTo(@20);
    }];

    UIView *split1View = [[UIView alloc] init];
    split1View.backgroundColor = COLOR_LINE;
    [inputBgView addSubview:split1View];
    [split1View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(@(0));
        make.height.equalTo(@(Line_Height));
    }];

    self.emailTextField = [[UITextField alloc] init];
    self.emailTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.emailTextField.placeholder = XYBString(@"string_input_new_email", @"输入新的邮箱地址");
    self.emailTextField.font = TEXT_FONT_16;
    [inputBgView addSubview:self.emailTextField];
    [self.emailTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0);
        make.left.equalTo(@10);
        make.right.equalTo(@-10);
        make.height.equalTo(@53);
        make.bottom.equalTo(@0);
    }];

    UIView *split2View = [[UIView alloc] init];
    split2View.backgroundColor = COLOR_LINE;
    [inputBgView addSubview:split2View];
    [split2View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(0));
        make.right.equalTo(@(0));
        make.height.equalTo(@(Line_Height));
        make.top.equalTo(inputBgView.mas_bottom);
    }];

    self.submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.submitButton setTitle:XYBString(@"string_ok", @"确定") forState:UIControlStateNormal];
    [self.submitButton addTarget:self action:@selector(clickSubmitButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.submitButton setTitleColor:COLOR_COMMON_WHITE forState:UIControlStateNormal];
    [self.submitButton setBackgroundImage:[ColorUtil imageWithColor:COLOR_HIGHTBULE_BUTTON] forState:UIControlStateHighlighted];
    [self.submitButton setBackgroundImage:[ColorUtil imageWithColor:COLOR_MAIN] forState:UIControlStateNormal];
    [self.submitButton setBackgroundImage:[ColorUtil imageWithColor:COLOR_LIGHTGRAY_BUTTONDISABLE] forState:UIControlStateDisabled];
    [self.submitButton.layer setMasksToBounds:YES];
    [self.submitButton.layer setCornerRadius:4.0];
    [scrollView addSubview:self.submitButton];

    [self.submitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(vi.mas_left).offset(Margin_Length);
        make.right.equalTo(vi.mas_right).offset(-Margin_Length);
        make.top.equalTo(inputBgView.mas_bottom).offset(20);
        make.height.equalTo(@44);
    }];

    if (self.emailTextField.text.length > 0) {
        self.submitButton.enabled = YES;
    } else {
        self.submitButton.enabled = NO;
    }

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didTextChanged:) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)didTextChanged:(NSNotification *)notification {

    if (self.emailTextField.text.length > 0) {
        self.submitButton.enabled = YES;
    } else {
        self.submitButton.enabled = NO;
    }
}

- (void)clickSubmitButton:(id)sender {
    [self hideKeyBorad];
    if (![Utility isValidateEmail:self.emailTextField.text]) {
        [self showDelayTip:XYBString(@"string_email_error_email", @"请输入正确的Email")];
        return;
    }

    NSDictionary *param = @{
        @"userId" : [UserDefaultsUtil getUser].userId,
        @"email" : self.emailTextField.text,
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
                if (action == EmailActiveAlertViewActionSend) {
                    [[UIApplication sharedApplication] openURL:[Utility emailWebAddress:self.emailTextField.text]];
                }
                [self hideKeyBorad];
                [self.navigationController popViewControllerAnimated:YES];
            }];
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

- (void)clickBackBtn:(id)sender {
    [self hideKeyBorad];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)hideKeyBorad {
    if (self.emailTextField) {
        [self.emailTextField resignFirstResponder];
    }
}
@end
