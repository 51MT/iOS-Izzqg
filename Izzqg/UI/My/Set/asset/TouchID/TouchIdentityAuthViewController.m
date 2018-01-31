//
//  TouchIdentityAuthViewController.m
//  Ixyb
//
//  Created by wangjianimac on 16/6/8.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import "CheckRadePasswordModel.h"
#import "TouchIdentityAuthViewController.h"
#import "Utility.h"
#import "WebService.h"

@interface TouchIdentityAuthViewController ()

@property (nonatomic, strong) UITextField *textFieldPassWord;

@property (nonatomic, retain) NSMutableArray *dotArray;

@property (nonatomic, strong) ColorButton *determineButton;

@end

@implementation TouchIdentityAuthViewController

- (void)setNav {
    self.navItem.title = XYBString(@"string_Authentication", @"身份验证");
    self.navItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(clickleftBtn)];
}

- (void)clickleftBtn {
    [_textFieldPassWord resignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setNav];
    [self createMainView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didTextChanged:) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

/**
 *   初始化界面
 */
- (void)createMainView {

    UIView *backView = [[UIView alloc] initWithFrame:CGRectZero]; //白色背景
    backView.backgroundColor = COLOR_COMMON_WHITE;
    [self.view addSubview:backView];

    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.navBar.mas_bottom).offset(Margin_Length);
        make.height.equalTo(@45);
        make.width.equalTo(@(MainScreenWidth));
    }];

    _textFieldPassWord = [[UITextField alloc] initWithFrame:CGRectZero];
    _textFieldPassWord.placeholder = @"输入交易密码(6-20位字符)";
    _textFieldPassWord.font = TEXT_FONT_16;
    _textFieldPassWord.textColor = COLOR_MAIN_GREY;
    _textFieldPassWord.clearButtonMode = UITextFieldViewModeWhileEditing;
    _textFieldPassWord.secureTextEntry = YES;
    [backView addSubview:_textFieldPassWord];

    [_textFieldPassWord mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@Margin_Length);
        make.top.equalTo(backView.mas_top).offset(0);
        make.right.equalTo(@(-45));
        make.height.equalTo(@45);
    }];

    UIButton *eyeBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [eyeBtn1 setImage:[UIImage imageNamed:@"show_pwd"] forState:UIControlStateNormal];
    [eyeBtn1 setImage:[UIImage imageNamed:@"show_pwd_selected"] forState:UIControlStateSelected];
    [eyeBtn1 addTarget:self action:@selector(showPayWordBtn:) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:eyeBtn1];

    [eyeBtn1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_textFieldPassWord.mas_centerY);
        make.right.equalTo(backView.mas_right).offset(-Margin_Length);
    }];

    [XYCellLine initWithTopLineAtSuperView:backView]; //在白色背景上画分界线
    [XYCellLine initWithBottomLineAtSuperView:backView];


    _determineButton = [[ColorButton alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth - 30.f, Button_Height) Title:XYBString(@"str_ok", @"确定")  ByGradientType:leftToRight];
    [_determineButton addTarget:self action:@selector(clickDetermineButton:) forControlEvents:UIControlEventTouchUpInside];
    _determineButton.isColorEnabled = NO;
    [self.view addSubview:_determineButton];

    [_determineButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@Margin_Length);
        make.top.equalTo(backView.mas_bottom).offset(20);
        make.right.equalTo(@(-Margin_Length));
        make.height.equalTo(@45);
    }];
}

/**
 *  确定
 *
 *  @param sender
 */
- (void)clickDetermineButton:(UIButton *)sender {

    if (_textFieldPassWord.text.length == 0) {

        [HUD showPromptViewWithToShowStr:XYBString(@"string_pleaseEnter_password", @"请输入交易密码") autoHide:YES afterDelay:1.0 userInteractionEnabled:YES];
        return;
    }

    if (![Utility isValidatePassword:_textFieldPassWord.text]) {

        [HUD showPromptViewWithToShowStr:XYBString(@"string_length_password", @"请输入6-20位字符的密码") autoHide:YES afterDelay:1.0 userInteractionEnabled:YES];
        return;
    }

    if (![Utility checkThenullStringBystring:_textFieldPassWord.text]) {
        [HUD showPromptViewWithToShowStr:XYBString(@"string_nohave_space", @"交易密码中不能包含空格") autoHide:YES afterDelay:1.0 userInteractionEnabled:YES];
        return;
    }
    User *user = [UserDefaultsUtil getUser];
    NSDictionary *dic = @{ @"userId" : user.userId,
                           @"password" : _textFieldPassWord.text };
    [self callVerificationPassWordWebService:dic];
}

/**
 *  验证交易密码
 *
 *  @param dic  Field
 */
- (void)callVerificationPassWordWebService:(NSDictionary *)dic {
    NSString *requestURL = [RequestURL getRequestURL:UserVerifyTradePasswordURL param:dic];

    [self showDataLoading];
    [WebService postRequest:requestURL param:dic JSONModelClass:[CheckRadePasswordModel class] Success:^(AFHTTPRequestOperation *operation, id responseObject) {

        [self hideLoading];
        CheckRadePasswordModel *responseModel = responseObject;
        NSString *private_key_string = responseModel.privateKey;
        if (responseModel.resultCode == 1) {
            //  请求成功 保存秘钥
            [UserDefaultsUtil setEncryptionDataKey:[NSString stringWithFormat:@"%@", [dic objectForKey:@"userId"]] value:private_key_string];
            if (self.block) {
                self.block();
            }
            [self.navigationController popViewControllerAnimated:YES];
        }

    }
        fail:^(AFHTTPRequestOperation *operation, NSString *errorMessage) {
            [self hideLoading];
            [self showPromptTip:errorMessage];
        }];
}

/**
 *  通知
 *
 *  @param notification
 */
- (void)didTextChanged:(NSNotification *)notification {

    if (_textFieldPassWord.text.length > 0) {
        _determineButton.isColorEnabled = YES;
    } else {
        _determineButton.isColorEnabled = NO;
    }
}

/**
 *  显示密码
 *
 *  @param sender
 */
- (void)showPayWordBtn:(UIButton *)sender {

    UIButton *btn = (UIButton *) sender;
    btn.selected = !btn.selected;
    _textFieldPassWord.secureTextEntry = !_textFieldPassWord.secureTextEntry;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
