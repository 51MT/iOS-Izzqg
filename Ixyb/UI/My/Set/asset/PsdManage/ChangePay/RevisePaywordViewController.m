//
//  RevisePaywordViewController.m
//  Ixyb
//
//  Created by dengjian on 16/4/29.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import "RevisePaywordViewController.h"

#import "AccountSafeSetViewController.h"
#import "CreditAssignmentDescriptionViewController.h"
#import "Utility.h"
#import "WebService.h"
#import "XYCellLine.h"

@interface RevisePaywordViewController () {
    MBProgressHUD *hud;
}
@end

@implementation RevisePaywordViewController

- (void)setNav {
    self.navItem.title = XYBString(@"string_change_trans_pwd", @"修改交易密码");

    self.navItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(clickBackBtn:)];
}

- (void)clickBackBtn:(id)sender {

    [_payNewTextField resignFirstResponder];
    [_payPasswordTextField resignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setNav];
    [self creatMainView];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didTextChanged:) name:UITextFieldTextDidChangeNotification object:nil];

    if (self.payPasswordTextField.text.length > 0 && self.payNewTextField.text.length > 0) {
        self.reviseButton.isColorEnabled = YES;
    } else {
        self.reviseButton.isColorEnabled = NO;
    }
}

- (void)creatMainView {
    UIView *backView = [[UIView alloc] init];
    backView.backgroundColor = COLOR_COMMON_WHITE;
    [self.view addSubview:backView];

    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.left.equalTo(self.view);
        make.top.equalTo(self.navBar.mas_bottom).offset(Margin_Length);
        make.height.equalTo(@(90));
    }];

    self.payNewTextField = [[UITextField alloc] init];
    self.payNewTextField.font = TEXT_FONT_16;
    self.payNewTextField.textColor = COLOR_MAIN_GREY;
    self.payNewTextField.placeholder = @"请输入新交易密码";
    self.payNewTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.payNewTextField.secureTextEntry = YES;
    [backView addSubview:self.payNewTextField];

    [self.payNewTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@Margin_Length);
        make.top.equalTo(backView.mas_top).offset(Line_Height);
        make.right.equalTo(backView.mas_right).offset(-45);
        make.height.equalTo(@44);
    }];

    UIButton *eyeBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [eyeBtn1 setImage:[UIImage imageNamed:@"show_pwd"] forState:UIControlStateNormal];
    [eyeBtn1 setImage:[UIImage imageNamed:@"show_pwd_selected"] forState:UIControlStateSelected];
    [eyeBtn1 addTarget:self action:@selector(showNewWord:) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:eyeBtn1];

    [eyeBtn1 mas_makeConstraints:^(MASConstraintMaker *make) {
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
    self.payPasswordTextField.placeholder = @"请再次输入新交易密码";
    self.payPasswordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.payPasswordTextField.secureTextEntry = YES;
    [backView addSubview:self.payPasswordTextField];

    [self.payPasswordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@Margin_Length);
        make.top.equalTo(lineView.mas_bottom).offset(0);
        make.right.equalTo(@(-45));
        make.height.equalTo(@44);
    }];

    UIButton *eyeBtn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [eyeBtn2 setImage:[UIImage imageNamed:@"show_pwd"] forState:UIControlStateNormal];
    [eyeBtn2 setImage:[UIImage imageNamed:@"show_pwd_selected"] forState:UIControlStateSelected];
    [eyeBtn2 addTarget:self action:@selector(showNewWordAgain:) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:eyeBtn2];

    [eyeBtn2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.payPasswordTextField.mas_centerY);
        make.right.equalTo(backView.mas_right).offset(-Margin_Length);
    }];

  
    self.reviseButton  = [[ColorButton alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth - 30.f, Button_Height) Title:@"修改"ByGradientType:leftToRight];
    [self.reviseButton addTarget:self action:@selector(reviseTheButton:) forControlEvents:UIControlEventTouchUpInside];
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

- (void)didTextChanged:(NSNotification *)notification {

    if (self.payPasswordTextField.text.length > 0 && self.payNewTextField.text.length > 0) {
        self.reviseButton.isColorEnabled = YES;
    } else {
        self.reviseButton.isColorEnabled = NO;
    }
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

- (void)reviseTheButton:(XYButton *)sender {

    [_payNewTextField resignFirstResponder];
    [_payPasswordTextField resignFirstResponder];

    if (_payPasswordTextField.text.length == 0) {

        [HUD showPromptViewWithToShowStr:XYBString(@"string_input_newps", @"请输入新密码") autoHide:YES afterDelay:1.0 userInteractionEnabled:YES];
        return;
    }

    if (![Utility isValidatePassword:_payPasswordTextField.text]) {

        [HUD showPromptViewWithToShowStr:XYBString(@"string_length_ps", @"请输入6-20位字符的密码") autoHide:YES afterDelay:1.0 userInteractionEnabled:YES];
        return;
    }

    if (![Utility checkThenullStringBystring:_payPasswordTextField.text]) {
        [HUD showPromptViewWithToShowStr:XYBString(@"string_nohave_space", @"交易密码中不能包含空格") autoHide:YES afterDelay:1.0 userInteractionEnabled:YES];
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

    if (![Utility isValidateCharStr:_payPasswordTextField.text]) {
        [HUD showPromptViewWithToShowStr:XYBString(@"string_role_password", @"密码由数字、英文字母或下划线组成") autoHide:YES afterDelay:1.0 userInteractionEnabled:YES];
        return;
    }

    NSDictionary *contentDic = @{
        @"userId" : [UserDefaultsUtil getUser].userId,
        @"newPassword" : _payNewTextField.text,
        @"code" : _codeStr
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

/*****************************修改交易密码接口**********************************/
- (void)callUpdateTradePasswordWebService:(NSDictionary *)dictionary {

    [self showDataLoading];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:dictionary];
    NSString *urlPath = [RequestURL getRequestURL:UpdateTradePasswordURL param:params];

    [WebService postRequest:urlPath param:params JSONModelClass:[ResponseModel class] Success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self hideLoading];
        ResponseModel *response = responseObject;
        if (response.resultCode == 1) {

            [HUD showPromptViewWithToShowStr:XYBString(@"string_change_scuess", @"修改成功") autoHide:YES afterDelay:1.0 userInteractionEnabled:YES];
            //            [self.navigationController popViewControllerAnimated:YES];
            NSArray *arr = self.navigationController.viewControllers;
            // TODO: 修改成功后要跳转到相应页面. 下次重构的时候,需要重新设计.
            for (UIViewController *controller in arr) {
                if ([controller isKindOfClass:[AccountSafeSetViewController class]]) {

                    [self.navigationController popToViewController:controller animated:YES];
                    return;
                }

                if ([controller isKindOfClass:[CreditAssignmentDescriptionViewController class]]) {
                    [self.navigationController popToViewController:controller animated:YES];
                    return;
                }
            }

            [self.navigationController popToViewController:[arr objectAtIndex:arr.count - 3] animated:YES];
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
