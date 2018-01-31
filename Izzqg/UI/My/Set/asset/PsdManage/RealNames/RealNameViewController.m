//
//  RealNameViewController.m
//  Ixyb
//
//  Created by wang on 16/3/31.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import "AuthRealNameResponseModel.h"
#import "RealNameModel.h"
#import "RealNameViewController.h"
#import "RealNamesResponseModel.h"
#import "SaveAuthInfoModel.h"
#import "Utility.h"
#import "WebService.h"
#import "WebviewViewController.h"

@interface RealNameViewController () {
    MBProgressHUD *hud;
}

@property (strong, nonatomic) UIView *realNameBeforeView;

@property (strong, nonatomic) UIView *mainView;
@property (strong, nonatomic) UITextField *nameTextField;
@property (strong, nonatomic) UITextField *identityCardTextField;
@property (strong, nonatomic) ColorButton *realNameButton;

@end

@implementation RealNameViewController

- (void)setNav {
    self.navItem.title = XYBString(@"str_real_name_authentication", @"实名认证");

    self.navItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(clickBackBtn:)];

    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"question_mark"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"question_mark_ed"] forState:UIControlStateHighlighted];
    button.frame = CGRectMake(0.0f, 0.0f, 40.0f, 40.0f);
    [button addTarget:self action:@selector(clickTheRightBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.navBar addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.navBar);
        make.right.equalTo(@(-Margin_Right));
    }];
}

- (void)clickTheRightBtn {
    NSString *titleStr = XYBString(@"string_realname_introductions", @"实名认证说明");
    NSString *urlStr = [RequestURL getNodeJsH5URL:App_AuthName_Explain_URL withIsSign:NO];
    WebviewViewController *realNameWebViewController = [[WebviewViewController alloc] initWithTitle:titleStr webUrlString:urlStr];
    [self.navigationController pushViewController:realNameWebViewController animated:YES];
}

- (void)clickBackBtn:(id)sender {
    //    [_nameTextField resignFirstResponder];
    //    [_identityCardTextField resignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setNav];
    [self setUI];
}

- (void)setUI {
    UIScrollView *mainScroll = [[UIScrollView alloc] init];
    [self.view addSubview:mainScroll];

    [mainScroll mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navBar.mas_bottom);
        make.left.bottom.right.equalTo(self.view);
    }];

    User *user = [UserDefaultsUtil getUser];
    //实名认证前
    _realNameBeforeView = [[UIView alloc] init];
    _realNameBeforeView.backgroundColor = COLOR_COMMON_CLEAR;
    [mainScroll addSubview:_realNameBeforeView];
    [_realNameBeforeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(mainScroll);
        make.width.equalTo(@(MainScreenWidth));
    }];

    UIImageView *infoImage = [[UIImageView alloc] init];
    infoImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"icon_info_gray"]];
    [_realNameBeforeView addSubview:infoImage];
    [infoImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_realNameBeforeView.mas_left).offset(Margin_Left);
        make.top.equalTo(_realNameBeforeView.mas_top).offset(Margin_Top);
    }];

    UILabel *infoLabel = [[UILabel alloc] init];
    infoLabel.textColor = COLOR_LIGHT_GREY;
    infoLabel.font = TEXT_FONT_12;
    infoLabel.numberOfLines = 0;
    infoLabel.text = XYBString(@"str_realname_reason", @"为了您的资金和收益安全，请完成实名认证");
    [_realNameBeforeView addSubview:infoLabel];

    [infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(infoImage.mas_right).offset(5);
        make.top.equalTo(infoImage.mas_top);
    }];

    _mainView = [[UIView alloc] init];
    _mainView.backgroundColor = COLOR_COMMON_WHITE;
    _mainView.layer.masksToBounds = YES;
    _mainView.layer.borderColor = COLOR_LINE.CGColor;
    _mainView.layer.borderWidth = Border_Width;
    [_realNameBeforeView addSubview:_mainView];
    [_mainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(infoLabel.mas_bottom).offset(Margin_Length);
        make.left.equalTo(_realNameBeforeView.mas_left).offset(-1);
        make.right.equalTo(_realNameBeforeView.mas_right).offset(1);
    }];

    UILabel *nameLab = [[UILabel alloc] init];
    nameLab.font = TEXT_FONT_16;
    nameLab.text = XYBString(@"str_auth_name", @"姓名");
    nameLab.textColor = COLOR_MAIN_GREY;
    [_mainView addSubview:nameLab];

    [nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Margin_Left));
        make.top.equalTo(@Margin_Length);
        make.width.equalTo(@70);
    }];

    _nameTextField = [[UITextField alloc] init];
    _nameTextField.placeholder = XYBString(@"str_please_input_name", @"请输入姓名");
    _nameTextField.textColor = COLOR_MAIN_GREY;
    _nameTextField.font = TEXT_FONT_16;
    _nameTextField.keyboardType = UIKeyboardTypeDefault;
    if (![user.realName isEqual:[NSNull null]]) {
        _nameTextField.text = user.realName;
    }
    _nameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(nameTextFieldChange) name:UITextFieldTextDidChangeNotification object:_nameTextField];
    [_mainView addSubview:_nameTextField];
    [_nameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nameLab.mas_right).offset(Text_Margin_Middle);
        make.right.equalTo(_mainView.mas_right).offset(-(Margin_Right));
        make.centerY.equalTo(nameLab.mas_centerY);
    }];

    UIView *splitView = [[UIView alloc] init];
    splitView.backgroundColor = COLOR_LINE;
    [_mainView addSubview:splitView];

    [splitView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_nameTextField.mas_bottom).offset(AlertButton_Margin_Top);
        make.height.equalTo(@(Line_Height));
        make.left.equalTo(_mainView.mas_left).offset(Margin_Left);
        make.right.equalTo(_mainView.mas_right);
    }];

    UILabel *identityCardLab = [[UILabel alloc] init];
    identityCardLab.font = TEXT_FONT_16;
    identityCardLab.text = XYBString(@"str_id_number", @"身份证号");
    identityCardLab.textColor = COLOR_MAIN_GREY;
    [_mainView addSubview:identityCardLab];

    [identityCardLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Margin_Left));
        make.top.equalTo(splitView.mas_bottom).offset(14);
        make.width.equalTo(@70);
    }];

    _identityCardTextField = [[UITextField alloc] init];
    _identityCardTextField.placeholder = XYBString(@"string_only_chinese", @"仅支持大陆身份证号");
    _identityCardTextField.textColor = COLOR_MAIN_GREY;
    _identityCardTextField.font = TEXT_FONT_16;
    _identityCardTextField.keyboardType = UIKeyboardTypeASCIICapable;
    _identityCardTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    if (![user.idNumber isEqual:[NSNull null]]) {
        _identityCardTextField.text = user.idNumber;
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(identityCardTextFieldChange) name:UITextFieldTextDidChangeNotification object:_identityCardTextField];
    [_mainView addSubview:_identityCardTextField];

    [_identityCardTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(identityCardLab.mas_right).offset(Text_Margin_Middle);
        make.right.equalTo(_mainView.mas_right).offset(-(Margin_Right));
        make.centerY.equalTo(identityCardLab.mas_centerY);
        make.bottom.equalTo(_mainView.mas_bottom).offset(-(Margin_Right));
    }];

    _realNameButton = [[ColorButton alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth - 30.f, Button_Height) Title:XYBString(@"str_ok", @"确定") ByGradientType:leftToRight];
    [_realNameButton addTarget:self action:@selector(clickRealNameButton:) forControlEvents:UIControlEventTouchUpInside];
    [_realNameBeforeView addSubview:_realNameButton];
    if (_identityCardTextField.text.length > 0 && _nameTextField.text.length > 0) {
        _realNameButton.isColorEnabled = YES;
    } else {
        _realNameButton.isColorEnabled = NO;
    }
    [_realNameButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_mainView.mas_bottom).offset(Cell_Margin_Length);
        make.left.equalTo(_realNameBeforeView.mas_left).offset(Margin_Right);
        make.right.equalTo(_realNameBeforeView.mas_right).offset(-(Margin_Right));
        make.height.equalTo(@(Button_Height));
        make.bottom.equalTo(_realNameBeforeView.mas_bottom);
    }];
}

- (void)nameTextFieldChange {
    if (_identityCardTextField.text.length > 0 && _nameTextField.text.length > 0) {
        _realNameButton.isColorEnabled = YES;
    } else {
        _realNameButton.isColorEnabled = NO;
    }
}

- (void)identityCardTextFieldChange {
    if (_identityCardTextField.text.length > 0 && _nameTextField.text.length > 0) {
        _realNameButton.isColorEnabled = YES;
    } else {
        _realNameButton.isColorEnabled = NO;
    }
}

- (void)clickRealNameButton:(id)sender {

    if (_nameTextField.text.length == 0) {

        [HUD showPromptViewWithToShowStr:XYBString(@"str_enter_realName", @"请输入真实姓名") autoHide:YES afterDelay:1.0 userInteractionEnabled:YES];
        //        return;
    }

    if (_identityCardTextField.text.length == 0) {

        [HUD showPromptViewWithToShowStr:XYBString(@"str_enter_id_number", @"请输入身份证号") autoHide:YES afterDelay:1.0 userInteractionEnabled:YES];
        //        return;
    }
    if (![self onClickButton:_identityCardTextField.text]) {
        //        return;
    }
    [_nameTextField resignFirstResponder];
    [_identityCardTextField resignFirstResponder];

    User *user = [UserDefaultsUtil getUser];

    [self requestRealNameWebServiceWithParam:@{ @"userId" : user.userId,
                                                @"realName" : _nameTextField.text,
                                                @"idNumber" : _identityCardTextField.text }];
}

- (BOOL)onClickButton:(NSString *)field3Str {

    if (field3Str.length == 15 || field3Str.length == 18) {
        NSString *emailRegex = @"^[0-9]*$";
        NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
        bool sfzNo = [emailTest evaluateWithObject:[field3Str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];

        if (field3Str.length == 15) {
            if (!sfzNo) {
                [HUD showPromptViewWithToShowStr:XYBString(@"str_id_number_length", @"身份证为18位字母或数字") autoHide:YES afterDelay:1.0 userInteractionEnabled:YES];
                return NO;
            }
        } else if (field3Str.length == 18) {
            bool sfz18NO = [self checkIdentityCardNo:field3Str];
            if (!sfz18NO) {
                [HUD showPromptViewWithToShowStr:XYBString(@"str_id_number_invalid", @"身份证无效") autoHide:YES afterDelay:1.0 userInteractionEnabled:YES];
                return NO;
            }
        }
    } else {
        [HUD showPromptViewWithToShowStr:XYBString(@"str_id_number_length", @"身份证为18位字母或数字") autoHide:YES afterDelay:1.0 userInteractionEnabled:YES];
        return NO;
    }
    return YES;
}

#pragma mark - 身份证识别

- (BOOL)checkIdentityCardNo:(NSString *)cardNo {
    
    if (cardNo.length != 18) {
        return NO;
    }

    NSArray *codeArray = [NSArray arrayWithObjects:@"7", @"9", @"10", @"5", @"8", @"4", @"2", @"1", @"6", @"3", @"7", @"9", @"10", @"5", @"8", @"4", @"2", nil];
    NSDictionary *checkCodeDic = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"1", @"0", @"X", @"9", @"8", @"7", @"6", @"5", @"4", @"3", @"2", nil] forKeys:[NSArray arrayWithObjects:@"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", nil]];

    NSScanner *scan = [NSScanner scannerWithString:[cardNo substringToIndex:17]];

    int val;
    BOOL isNum = [scan scanInt:&val] && [scan isAtEnd];
    if (!isNum) {
        return NO;
    }
    
    int sumValue = 0;
    for (int i = 0; i < 17; i++) {
        sumValue += [[cardNo substringWithRange:NSMakeRange(i, 1)] intValue] * [[codeArray objectAtIndex:i] intValue];
    }

    NSString *strlast = [checkCodeDic objectForKey:[NSString stringWithFormat:@"%d", sumValue % 11]];

    if ([strlast isEqualToString:[[cardNo substringWithRange:NSMakeRange(17, 1)] uppercaseString]]) {
        return YES;
    }
    
    return NO;
}

- (void)creatTheHud {

    if (!hud) {
        hud = [[MBProgressHUD alloc] initWithView:self.view];
        hud.square = YES;
        [hud show:YES];
        [self.view addSubview:hud];
    }
}

/*****************************实名认证接口**********************************/
- (void)callRealNameWebService:(NSDictionary *)dictionary {
    NSString *requestURL = [RequestURL getRequestURL:RealNameAuthURL param:dictionary];

    [self showDataLoading];
    [WebService postRequest:requestURL param:dictionary JSONModelClass:[RealNameModel class] Success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self hideLoading];
        RealNameModel *responseModel = responseObject;

        if (responseModel.resultCode == 1) {

            User *user = [UserDefaultsUtil getUser];
            //user.realName = _nameTextField.text;
            user.isIdentityAuth = @"1";
            user.realName = responseModel.realName;
            user.idNumber = responseModel.idNumber;
            [UserDefaultsUtil setUser:user];

     
        }

    }
        fail:^(AFHTTPRequestOperation *operation, NSString *errorMessage) {
            [self hideLoading];

            if (operation.response.statusCode == 400) {
                [self callSaveRealNameWebService:@{
                    @"userId" : [UserDefaultsUtil getUser].userId,
                    @"realName" : _nameTextField.text,
                    @"idNumber" : _identityCardTextField.text
                }];
            }
            [self showPromptTip:errorMessage];
        }];
}

- (void)requestRealNameWebServiceWithParam:(NSDictionary *)param {
    NSString *requestURL = [RequestURL getRequestURL:RealNameAuthURL param:param];

    [self showDataLoading];
    [WebService postRequest:requestURL param:param JSONModelClass:[RealNamesResponseModel class] Success:^(AFHTTPRequestOperation *operation, id responseObject) {

        [self hideLoading];
        RealNamesResponseModel *responseModel = responseObject;

        User *user = [UserDefaultsUtil getUser];
        user.isIdentityAuth = @"1";
        user.realName = responseModel.realName;
        user.idNumber = responseModel.idNumber;
        [UserDefaultsUtil setUser:user];

     

    }
        fail:^(AFHTTPRequestOperation *operation, NSString *errorMessage) {
            [self hideLoading];

            if (operation.response.statusCode == 400) {

                [self requestSaveRealNameWebServiceWithParam:@{
                    @"userId" : [UserDefaultsUtil getUser].userId,
                    @"realName" : _nameTextField.text,
                    @"idNumber" : _identityCardTextField.text
                }];
            }
            [self showPromptTip:errorMessage];
        }];
}

/*****************************保存实名认证接口**********************************/
- (void)callSaveRealNameWebService:(NSDictionary *)dictionary {

    NSString *requestURL = [RequestURL getRequestURL:UserSaveAuthInfoURL param:dictionary];

    [self showDataLoading];
    [WebService postRequest:requestURL param:dictionary JSONModelClass:[SaveAuthInfoModel class] Success:^(AFHTTPRequestOperation *operation, id responseObject) {

        [self hideLoading];
        SaveAuthInfoModel *responseModel = responseObject;
        if (responseModel.resultCode == 1) {
            User *user = [UserDefaultsUtil getUser];
            user.realName = responseModel.realName;
            user.idNumber = responseModel.idNumber;
            [UserDefaultsUtil setUser:user];
        }

    }
        fail:^(AFHTTPRequestOperation *operation, NSString *errorMessage) {
            [self hideLoading];
            [self showPromptTip:errorMessage];
        }];
}

- (void)requestSaveRealNameWebServiceWithParam:(NSDictionary *)param {
    NSString *requestURL = [RequestURL getRequestURL:SaveRealNameAuthURL param:param];

    [self showDataLoading];
    [WebService postRequest:requestURL param:param JSONModelClass:[AuthRealNameResponseModel class]

        Success:^(AFHTTPRequestOperation *operation, id responseObject) {

            [self hideLoading];
            AuthRealNameResponseModel *responseModel = responseObject;
            if (responseModel.isIdentityAuth) {
                User *user = [UserDefaultsUtil getUser];
                user.realName = responseModel.realName;
                user.idNumber = responseModel.idNumber;
                [UserDefaultsUtil setUser:user];
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
}

@end
