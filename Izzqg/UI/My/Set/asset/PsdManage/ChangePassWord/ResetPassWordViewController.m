//
//  ResetPassWordViewController.m
//  Ixyb
//
//  Created by dengjian on 16/4/28.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import "ResetPassWordViewController.h"

#import "Utility.h"
#import "WebService.h"
#import "XYCellLine.h"

@interface ResetPassWordViewController () {
    MBProgressHUD *hud;
}
@end

@implementation ResetPassWordViewController

- (void)setNav {
    self.navItem.title = XYBString(@"string_change_loginps", @"修改登录密码");

    self.navItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(clickBackBtn)];
}

- (void)clickBackBtn {
    [_olderTextField resignFirstResponder];
    [_payNewTextField resignFirstResponder];
    [_payPasswordTextField resignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setNav];
    [self createMainView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didTextChange:) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)didTextChange:(NSNotification *)notification {
    if (self.olderTextField.text.length > 0 && self.payNewTextField.text.length > 0 && self.payPasswordTextField.text.length > 0) {
        self.reviseButton.isColorEnabled = YES;
    } else {
        self.reviseButton.isColorEnabled = NO;
    }
}

- (void)createMainView {
    UIView *backView = [[UIView alloc] init];
    backView.backgroundColor = COLOR_COMMON_WHITE;
    [self.view addSubview:backView];

    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.left.equalTo(self.view);
        make.top.equalTo(self.navBar.mas_bottom).offset(Margin_Length);
        make.height.equalTo(@(150.5));
    }];

    self.olderTextField = [[UITextField alloc] init];
    self.olderTextField.font = TEXT_FONT_16;
    self.olderTextField.textColor = COLOR_MAIN_GREY;
    self.olderTextField.placeholder = @"请输入旧密码";
    self.olderTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.olderTextField.secureTextEntry = YES;
    [backView addSubview:self.olderTextField];

    [self.olderTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@Margin_Length);
        make.top.equalTo(backView.mas_top).offset(0);
        make.right.equalTo(@(-45));
        make.height.equalTo(@45);
    }];

    UIButton *eyeBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    //    eyeBtn1.selected = YES;
    [eyeBtn1 setImage:[UIImage imageNamed:@"show_pwd"] forState:UIControlStateNormal];
    [eyeBtn1 setImage:[UIImage imageNamed:@"show_pwd_selected"] forState:UIControlStateSelected];
    [eyeBtn1 addTarget:self action:@selector(showOlderWord:) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:eyeBtn1];

    [eyeBtn1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.olderTextField.mas_centerY);
        make.right.equalTo(backView.mas_right).offset(-Margin_Length);
    }];

    UIView *greyView = [[UIView alloc] init];
    greyView.backgroundColor = COLOR_BG;
    [backView addSubview:greyView];

    [greyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(backView);
        make.top.equalTo(self.olderTextField.mas_bottom).offset(0);
        make.height.equalTo(@Margin_Length);
    }];

    [XYCellLine initWithTopLineAtSuperView:greyView];
    [XYCellLine initWithBottomLineAtSuperView:greyView];

    self.payNewTextField = [[UITextField alloc] init];
    self.payNewTextField.font = TEXT_FONT_16;
    self.payNewTextField.textColor = COLOR_MAIN_GREY;
    self.payNewTextField.placeholder = @"请输入新密码";
    self.payNewTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.payNewTextField.secureTextEntry = YES;
    [backView addSubview:self.payNewTextField];

    [self.payNewTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@Margin_Length);
        make.top.equalTo(greyView.mas_bottom).offset(0);
        make.right.equalTo(backView.mas_right).offset(-45);
        make.height.equalTo(@45);
    }];

    UIButton *eyeBtn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    //    eyeBtn2.selected = YES;
    [eyeBtn2 setImage:[UIImage imageNamed:@"show_pwd"] forState:UIControlStateNormal];
    [eyeBtn2 setImage:[UIImage imageNamed:@"show_pwd_selected"] forState:UIControlStateSelected];
    [eyeBtn2 addTarget:self action:@selector(showNewWord:) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:eyeBtn2];

    [eyeBtn2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.payNewTextField.mas_centerY);
        make.right.equalTo(backView.mas_right).offset(-Margin_Length);
    }];

    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = COLOR_LINE;
    [backView addSubview:lineView];

    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(backView);
        make.top.equalTo(self.payNewTextField.mas_bottom).offset(0);
        make.height.equalTo(@(Line_Height));
    }];

    self.payPasswordTextField = [[UITextField alloc] init];
    self.payPasswordTextField.font = TEXT_FONT_16;
    self.payPasswordTextField.textColor = COLOR_MAIN_GREY;
    self.payPasswordTextField.placeholder = @"请再次输入新密码";
    self.payPasswordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.payPasswordTextField.secureTextEntry = YES;
    [backView addSubview:self.payPasswordTextField];

    [self.payPasswordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@Margin_Length);
        make.top.equalTo(lineView.mas_bottom).offset(0);
        make.right.equalTo(@(-45));
        make.height.equalTo(@45);
    }];

    UIButton *eyeBtn3 = [UIButton buttonWithType:UIButtonTypeCustom];
    //    eyeBtn3.selected = YES;
    [eyeBtn3 setImage:[UIImage imageNamed:@"show_pwd"] forState:UIControlStateNormal];
    [eyeBtn3 setImage:[UIImage imageNamed:@"show_pwd_selected"] forState:UIControlStateSelected];
    [eyeBtn3 addTarget:self action:@selector(showNewWordAgain:) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:eyeBtn3];

    [eyeBtn3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.payPasswordTextField.mas_centerY);
        make.right.equalTo(backView.mas_right).offset(-Margin_Length);
    }];
    
    self.reviseButton = [[ColorButton alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth - 30.f, Button_Height) Title:@"修改"   ByGradientType:leftToRight];
    [self.reviseButton addTarget:self action:@selector(reviseTheButton:) forControlEvents:UIControlEventTouchUpInside];
    self.reviseButton.isColorEnabled= NO;
    [self.view addSubview:self.reviseButton];

    [self.reviseButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.left.equalTo(self.view).offset(Margin_Length);
        make.top.equalTo(backView.mas_bottom).offset(20);
        make.height.equalTo(@45);
    }];

    [XYCellLine initWithTopLineAtSuperView:backView];
    [XYCellLine initWithBottomLineAtSuperView:backView];
}

- (void)showOlderWord:(UIButton *)sender {

    UIButton *btn = (UIButton *) sender;
    btn.selected = !btn.selected;
    _olderTextField.secureTextEntry = !_olderTextField.secureTextEntry;
}

- (void)showNewWord:(UIButton *)sender {

    UIButton *btn = (UIButton *) sender;
    btn.selected = !btn.selected;
    _payNewTextField.secureTextEntry = !_payNewTextField.secureTextEntry;
}

- (void)showNewWordAgain:(UIButton *)sender {
    UIButton *btn = (UIButton *) sender;
    btn.selected = !btn.selected;
    _payPasswordTextField.secureTextEntry = !_payPasswordTextField.secureTextEntry;
}

- (void)reviseTheButton:(UIButton *)sender {

    [_olderTextField resignFirstResponder];
    [_payNewTextField resignFirstResponder];
    [_payPasswordTextField resignFirstResponder];

    if (_olderTextField.text.length == 0) {

        [HUD showPromptViewWithToShowStr:XYBString(@"string_input_oldps", @"请输入旧密码") autoHide:YES afterDelay:1.0 userInteractionEnabled:YES];
        return;
    }

    if (_payPasswordTextField.text.length == 0) {

        [HUD showPromptViewWithToShowStr:XYBString(@"string_input_newps", @"请输入新密码") autoHide:YES afterDelay:1.0 userInteractionEnabled:YES];
        return;
    }

    if (![Utility isValidatePassword:_payPasswordTextField.text]) {

        [HUD showPromptViewWithToShowStr:XYBString(@"string_length_ps", @"请输入6-20位字符的密码") autoHide:YES afterDelay:1.0 userInteractionEnabled:YES];
        return;
    }

    if (![Utility checkThenullStringBystring:_payPasswordTextField.text]) {
        [HUD showPromptViewWithToShowStr:XYBString(@"string_no_space", @"密码中不能包含空格") autoHide:YES afterDelay:1.0 userInteractionEnabled:YES];
        return;
    }

    if (_payNewTextField.text.length == 0) {

        [HUD showPromptViewWithToShowStr:XYBString(@"string_input_againps", @"请再次输入新密码") autoHide:YES afterDelay:1.0 userInteractionEnabled:YES];
        return;
    }

    if (![_payPasswordTextField.text isEqualToString:_payNewTextField.text]) {

        [HUD showPromptViewWithToShowStr:XYBString(@"string_nomatch_ps", @"两次新密码输入不一致") autoHide:YES afterDelay:1.0 userInteractionEnabled:YES];
        return;
    }

    if (![Utility isValidateCharStr:_payNewTextField.text]) {
        [HUD showPromptViewWithToShowStr:XYBString(@"string_role_password", @"密码由数字、英文字母或下划线组成") autoHide:YES afterDelay:1.0 userInteractionEnabled:YES];
        return;
    }

    NSDictionary *contentDic = @{
        @"userId" : [UserDefaultsUtil getUser].userId,
        @"password" : _olderTextField.text,
        @"newPassword" : _payNewTextField.text
    };
    [self callUpdateTradePasswordWebService:contentDic];
}

- (void)creatTheHud {

    if (!hud) {
        hud = [[MBProgressHUD alloc] initWithView:self.view];
        hud.square = YES;
        [hud show:YES];
        [self.view addSubview:hud];
    }
}

/*****************************修改登录密码接口**********************************/
- (void)callUpdateTradePasswordWebService:(NSDictionary *)dictionary {

    [self showDataLoading];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:dictionary];
    NSString *urlPath = [RequestURL getRequestURL:UpdateLoginPasswordURL param:params];

    [WebService postRequest:urlPath param:params JSONModelClass:[ResponseModel class] Success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self hideLoading];
        ResponseModel *response = responseObject;
        if (response.resultCode == 1) {

            [HUD showPromptViewWithToShowStr:XYBString(@"string_change_scuess", @"修改成功") autoHide:YES afterDelay:1.0 userInteractionEnabled:YES];
            [self.navigationController popViewControllerAnimated:YES];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
