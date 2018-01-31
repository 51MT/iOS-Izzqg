//
//  SetNewPaywordViewController.m
//  Ixyb
//
//  Created by dengjian on 16/4/29.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import "SetNewPaywordViewController.h"

#import "Utility.h"
#import "WebService.h"
#import "XYCellLine.h"

@interface SetNewPaywordViewController () <UITextFieldDelegate> {
    MBProgressHUD *hud;
}
@end

@implementation SetNewPaywordViewController

- (void)setNav {
    self.navItem.title = XYBString(@"string_set_tradeps", @"设置交易密码");

    self.navItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(clickBackBtn:)];
}

- (void)clickBackBtn:(id)sender {
    [_payWordText resignFirstResponder];
    [_secondPayWordText resignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setNav];
    [self createMainView];

    _payWordText.delegate = self;
    _secondPayWordText.delegate = self;

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didTextChanged:) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)createMainView {
    
    UILabel *titleLab = [[UILabel alloc] init];
    titleLab.text = @"设置交易密码";
    titleLab.textColor = COLOR_AUXILIARY_GREY;
    titleLab.font = TEXT_FONT_14;
    [self.view addSubview:titleLab];

    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@Margin_Length);
        make.top.equalTo(self.navBar.mas_bottom).offset(Margin_Length);
    }];

    UIView *backView = [[UIView alloc] init];
    backView.backgroundColor = COLOR_COMMON_WHITE;
    [self.view addSubview:backView];

    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.left.equalTo(self.view);
        make.top.equalTo(titleLab.mas_bottom).offset(Margin_Length);
        make.height.equalTo(@(105));
    }];

    self.payWordText = [[UITextField alloc] init];
    self.payWordText.font = TEXT_FONT_16;
    self.payWordText.textColor = COLOR_MAIN_GREY;
    self.payWordText.placeholder = @"6-20位字符，可包含英文数字下划线";
    self.payWordText.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.payWordText.secureTextEntry = YES;
    [backView addSubview:self.payWordText];

    [self.payWordText mas_makeConstraints:^(MASConstraintMaker *make) {
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
        make.centerY.equalTo(self.payWordText.mas_centerY);
        make.right.equalTo(backView.mas_right).offset(-Margin_Length);
    }];

    UIView *greyView = [[UIView alloc] init];
    greyView.backgroundColor = COLOR_BG;
    [backView addSubview:greyView];

    [greyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(backView);
        make.top.equalTo(self.payWordText.mas_bottom).offset(0);
        make.height.equalTo(@Margin_Length);
    }];

    [XYCellLine initWithTopLineAtSuperView:greyView]; //灰色区域部分的上下分别画线
    [XYCellLine initWithBottomLineAtSuperView:greyView];

    self.secondPayWordText = [[UITextField alloc] init];
    self.secondPayWordText.font = TEXT_FONT_16;
    self.secondPayWordText.textColor = COLOR_MAIN_GREY;
    self.secondPayWordText.placeholder = @"请再次输入交易密码";
    self.secondPayWordText.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.secondPayWordText.secureTextEntry = YES;
    [backView addSubview:self.secondPayWordText];

    [self.secondPayWordText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@Margin_Length);
        make.top.equalTo(greyView.mas_bottom).offset(0);
        make.right.equalTo(backView.mas_right).offset(-45);
        make.height.equalTo(@45);
    }];

    UIButton *eyeBtn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [eyeBtn2 setImage:[UIImage imageNamed:@"show_pwd"] forState:UIControlStateNormal];
    [eyeBtn2 setImage:[UIImage imageNamed:@"show_pwd_selected"] forState:UIControlStateSelected];
    [eyeBtn2 addTarget:self action:@selector(showSecondPayWordBtn:) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:eyeBtn2];

    [eyeBtn2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.secondPayWordText.mas_centerY);
        make.right.equalTo(backView.mas_right).offset(-Margin_Length);
    }];

    [XYCellLine initWithTopLineAtSuperView:backView]; //backView的顶部和底部分别画线
    [XYCellLine initWithBottomLineAtSuperView:backView];

  self.finishButton =[[ColorButton alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth - 30.f, Button_Height) Title:@"设置" ByGradientType:leftToRight];
    self.finishButton.isColorEnabled = NO;
    [self.finishButton addTarget:self action:@selector(clickTheFinishBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.finishButton];

    [self.finishButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.left.equalTo(self.view).offset(Margin_Length);
        make.top.equalTo(backView.mas_bottom).offset(20);
        make.height.equalTo(@45);
    }];

    UILabel *bottomLab = [[UILabel alloc] init];
    bottomLab.text = @"信用宝不会在任何地方泄露您的个人信息";
    bottomLab.textColor = COLOR_LIGHT_GREY;
    bottomLab.font = TEXT_FONT_12;
    [self.view addSubview:bottomLab];

    [bottomLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@Margin_Length);
        make.top.equalTo(self.finishButton.mas_bottom).offset(8);
    }];
}

- (void)didTextChanged:(NSNotification *)notification {

    if (_payWordText.text.length > 0 && _secondPayWordText.text.length > 0) {
        _finishButton.isColorEnabled = YES;
    } else {
        _finishButton.isColorEnabled = NO;
    }
}

- (void)showPayWordBtn:(UIButton *)sender {
    UIButton *btn = (UIButton *) sender;
    btn.selected = !btn.selected;
    _payWordText.secureTextEntry = !_payWordText.secureTextEntry;
}

- (void)showSecondPayWordBtn:(UIButton *)sender {
    UIButton *btn = (UIButton *) sender;
    btn.selected = !btn.selected;
    _secondPayWordText.secureTextEntry = !_secondPayWordText.secureTextEntry;
}

- (void)clickTheFinishBtn:(XYButton *)sender {
    [_payWordText resignFirstResponder];
    [_secondPayWordText resignFirstResponder];

    if (_payWordText.text.length == 0) {

        [HUD showPromptViewWithToShowStr:XYBString(@"string_pleaseEnter_password", @"请输入交易密码") autoHide:YES afterDelay:1.0 userInteractionEnabled:YES];
        return;
    }

    if (![Utility isValidatePassword:_payWordText.text]) {

        [HUD showPromptViewWithToShowStr:XYBString(@"string_length_password", @"请输入6-20位字符的密码") autoHide:YES afterDelay:1.0 userInteractionEnabled:YES];
        return;
    }

    if (![Utility checkThenullStringBystring:_payWordText.text]) {
        [HUD showPromptViewWithToShowStr:XYBString(@"string_nohave_space", @"交易密码中不能包含空格") autoHide:YES afterDelay:1.0 userInteractionEnabled:YES];
        return;
    }

    if (_secondPayWordText.text.length == 0) {
        [HUD showPromptViewWithToShowStr:XYBString(@"string_inputagain_password", @"请再次输入交易密码") autoHide:YES afterDelay:1.0 userInteractionEnabled:YES];
        return;
    }

    if (![_payWordText.text isEqualToString:_secondPayWordText.text]) {
        [HUD showPromptViewWithToShowStr:XYBString(@"string_notmatch_password", @"两次交易密码不一致") autoHide:YES afterDelay:1.0 userInteractionEnabled:YES];
        return;
    }

    if (![Utility isValidateCharStr:_payWordText.text]) {
        [HUD showPromptViewWithToShowStr:XYBString(@"string_role_password", @"密码由数字、英文字母或下划线组成") autoHide:YES afterDelay:1.0 userInteractionEnabled:YES];
        return;
    }

    NSDictionary *contentDic = @{
        @"userId" : [UserDefaultsUtil getUser].userId,
        @"password" : _payWordText.text
    };

    [self callTradePasswordWebService:contentDic];
}

- (void)creatTheHud {

    if (!hud) {
        hud = [[MBProgressHUD alloc] initWithView:self.view];
        hud.square = YES;
        [hud show:YES];
        [self.view addSubview:hud];
    }
}

/*****************************交易密码接口**********************************/
- (void)callTradePasswordWebService:(NSDictionary *)dictionary {

    [self showDataLoading];

    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:dictionary];
    NSString *urlPath = [RequestURL getRequestURL:SetTradePasswordURL param:params];

    [WebService postRequest:urlPath param:params JSONModelClass:[ResponseModel class] Success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self hideLoading];
        ResponseModel *response = responseObject;
        if (response.resultCode == 1) {
            User *user = [UserDefaultsUtil getUser];
            user.isTradePassword = @"1";
            [UserDefaultsUtil setUser:user];

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
