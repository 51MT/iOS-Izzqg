//
//  UserDetailRealNamesViewController.m
//  Ixyb
//
//  Created by wang on 15/5/20.
//  Copyright (c) 2015年 xyb. All rights reserved.
//

#import "MyAlertView.h"
#import "RealNamesResponseModel.h"
#import "SaveAuthInfoModel.h"
#import "UserDetailRealNamesViewController.h"
#import "Utility.h"
#import "WebService.h"
#import "WebviewViewController.h"
#import "UMengAnalyticsUtil.h"
#import "XYCellLine.h"

@interface UserDetailRealNamesViewController () {
    MBProgressHUD *hud;
}

@property (strong, nonatomic) UIView *realNameBeforeView;

@property (strong, nonatomic) UIView *mainView;
@property (strong, nonatomic) UITextField *nameTextField;
@property (strong, nonatomic) UITextField *identityCardTextField;
@property (strong, nonatomic) ColorButton *realNameButton;

@property (strong, nonatomic) UIView *realView;
@property (strong, nonatomic) UILabel *userNameLabel;
@property (strong, nonatomic) UILabel *idCardLabel;

@end

@implementation UserDetailRealNamesViewController

- (void)setNav {

    self.navItem.title = XYBString(@"realNameAuthentication", @"实名认证");

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
    [_nameTextField resignFirstResponder];
    [_identityCardTextField resignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setNav];

    User *user = [UserDefaultsUtil getUser];

    UIScrollView *mainScroll = [[UIScrollView alloc] init];
    [self.view addSubview:mainScroll];

    [mainScroll mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navBar.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
        make.width.equalTo(@(MainScreenWidth));
    }];

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
        make.left.equalTo(_realNameBeforeView.mas_left).offset(Margin_Length);
        make.top.equalTo(_realNameBeforeView.mas_top).offset(Margin_Length + 5);
    }];

    UILabel *infoLabel = [[UILabel alloc] init];
    infoLabel.textColor = COLOR_AUXILIARY_GREY;
    infoLabel.font = TEXT_FONT_12;
    infoLabel.numberOfLines = 0;
    infoLabel.text = XYBString(@"string_realname_reason", @"为了您的资金和收益安全，请完成实名认证.\n此处填写仅作为信息保存");

    [_realNameBeforeView addSubview:infoLabel];
    [infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(infoImage.mas_right).offset(5);
        make.centerY.equalTo(infoImage.mas_centerY);
    }];

    _mainView = [[UIView alloc] init];
    _mainView.backgroundColor = COLOR_COMMON_WHITE;
    [_realNameBeforeView addSubview:_mainView];
    [_mainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(infoImage.mas_bottom).offset(Margin_Length + 5);
        make.left.equalTo(_realNameBeforeView.mas_left);
        make.right.equalTo(_realNameBeforeView.mas_right);
        make.height.equalTo(@(Cell_Height * 2));
    }];

    _nameTextField = [[UITextField alloc] init];
    _nameTextField.placeholder = XYBString(@"string_realname", @"真实姓名");
    _nameTextField.textColor = COLOR_MAIN_GREY;
    _nameTextField.font = TEXT_FONT_16;
    _nameTextField.keyboardType = UIKeyboardTypeDefault;
    if (![user.realName isEqual:[NSNull null]]) {
        _nameTextField.text = user.realName;
    }
    _nameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [_mainView addSubview:_nameTextField];

    [_nameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_mainView.mas_left).offset(Margin_Length);
        make.right.equalTo(_mainView.mas_right).offset(-Margin_Length);
        make.top.equalTo(_mainView.mas_top);
        make.height.equalTo(@(Cell_Height));
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

    [_mainView addSubview:_identityCardTextField];
    [_identityCardTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_mainView.mas_left).offset(Margin_Length);
        make.right.equalTo(_mainView.mas_right).offset(-Margin_Length);
        make.bottom.equalTo(_mainView.mas_bottom);
        make.height.equalTo(@(Cell_Height));
    }];

    _realNameButton = [[ColorButton alloc]initWithFrame:CGRectMake(0, 0, MainScreenWidth - 30, Cell_Height) Title:@"保存" ByGradientType:leftToRight];
    [_realNameButton addTarget:self action:@selector(clickTheRealNameButton:) forControlEvents:UIControlEventTouchUpInside];
    if (_identityCardTextField.text.length > 0 && _nameTextField.text.length > 0) {
        _realNameButton.isColorEnabled = YES;
    } else {
        _realNameButton.isColorEnabled = NO;
    }
    [_realNameButton addTarget:self action:@selector(clickTheRealNameButton:) forControlEvents:UIControlEventTouchUpInside];
    [_realNameBeforeView addSubview:_realNameButton];

    [_realNameButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_mainView.mas_bottom).offset(20);
        make.left.equalTo(_realNameBeforeView.mas_left).offset(Margin_Length);
        make.right.equalTo(_realNameBeforeView.mas_right).offset(-Margin_Length);
        make.height.equalTo(@(Cell_Height));
        make.bottom.equalTo(_realNameBeforeView.mas_bottom);
    }];

#pragma mark-- 画线
    [XYCellLine initWithTopLineAtSuperView:_mainView];    //顶部画线
    [XYCellLine initWithMiddleLineAtSuperView:_mainView]; //中间画线
    [XYCellLine initWithBottomLineAtSuperView:_mainView]; //底部画线

    //实名认证成功
    _realView = [[UIView alloc] init];
    _realView.backgroundColor = COLOR_COMMON_WHITE;
    [_realView.layer setMasksToBounds:YES];
    [_realView.layer setCornerRadius:4.0];
    _realView.clipsToBounds = YES;
    [self.view addSubview:_realView];
    [_realView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navBar.mas_bottom).offset(20);
        make.left.equalTo(self.view.mas_left).offset(Margin_Length);
        make.right.equalTo(self.view.mas_right).offset(-Margin_Length);
        make.height.equalTo(@90);
    }];

    UILabel *tip1Label = [[UILabel alloc] init];
    tip1Label.text = XYBString(@"string_realname", @"真实姓名");
    tip1Label.font = TEXT_FONT_16;
    tip1Label.textColor = COLOR_MAIN_GREY;
    [_realView addSubview:tip1Label];
    [tip1Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_realView.mas_left).offset(Margin_Length);
        make.bottom.equalTo(_realView.mas_centerY).offset(-8);
        make.height.equalTo(@30);
    }];

    _userNameLabel = [[UILabel alloc] init];
    _userNameLabel.textColor = COLOR_AUXILIARY_GREY;
    _userNameLabel.font = TEXT_FONT_16;
    _userNameLabel.text = XYBString(@"string_realname", @"真实姓名");
    [_realView addSubview:_userNameLabel];
    [_userNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_realView.mas_right).offset(-Margin_Length);
        make.bottom.equalTo(_realView.mas_centerY).offset(-8);
        make.height.equalTo(@30);
    }];

    [XYCellLine initWithHalfMiddleLineAtSuperView:_realView]; //真实姓名和身份证号码之间画线

    UILabel *tip2Label = [[UILabel alloc] init];
    tip2Label.text = XYBString(@"string_address_id", @"身份证号");
    tip2Label.font = TEXT_FONT_16;
    tip2Label.textColor = COLOR_MAIN_GREY;
    [_realView addSubview:tip2Label];
    [tip2Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_realView.mas_left).offset(Margin_Length);
        make.top.equalTo(_realView.mas_centerY).offset(8);
        make.height.equalTo(@30);
    }];

    _idCardLabel = [[UILabel alloc] init];
    _idCardLabel.textColor = COLOR_AUXILIARY_GREY;
    _idCardLabel.font = TEXT_FONT_16;
    _idCardLabel.text = XYBString(@"string_address_id", @"身份证号");
    [_realView addSubview:_idCardLabel];
    [_idCardLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_realView.mas_right).offset(-Margin_Length);
        make.top.equalTo(_realView.mas_centerY).offset(8);
        make.height.equalTo(@30);
    }];

    UILabel *tipsLab = [[UILabel alloc] init];
    tipsLab.text = XYBString(@"string_safe_tip", @"温馨提示:");
    tipsLab.textColor = COLOR_AUXILIARY_GREY;
    tipsLab.font = TEXT_FONT_12;
    [self.view addSubview:tipsLab];

    [tipsLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@17);
        make.top.equalTo(_realView.mas_bottom).offset(Margin_Length);
    }];

    UILabel *messageLab = [[UILabel alloc] init];
    messageLab.textColor = COLOR_AUXILIARY_GREY;
    messageLab.text = XYBString(@"string_safe_Message", @"实名认证信息不能修改");
    messageLab.font = TEXT_FONT_12;
    [self.view addSubview:messageLab];

    [messageLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@17);
        make.top.equalTo(tipsLab.mas_bottom).offset(8);
    }];

    UILabel *phoneLab = [[UILabel alloc] init];
    phoneLab.textColor = COLOR_MAIN;
    phoneLab.attributedText = [Utility getAttributedstring:XYBString(@"str_contact_custome", @"更换默认卡,请联系客服") tailStr:XYBString(@"str_contact_phone", @" 400-070-7663") labColor:COLOR_AUXILIARY_GREY];
    phoneLab.font = TEXT_FONT_12;
    [self.view addSubview:phoneLab];

    [phoneLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@17);
        make.top.equalTo(messageLab.mas_bottom).offset(8);
    }];

    if ([[UserDefaultsUtil getUser].isIdentityAuth boolValue]) {
        _realNameBeforeView.hidden = YES;
        _realView.hidden = NO;
        tipsLab.hidden = NO;
        messageLab.hidden = NO;
        phoneLab.hidden = NO;
    } else {
        _realNameBeforeView.hidden = NO;
        _realView.hidden = YES;
        tipsLab.hidden = YES;
        messageLab.hidden = YES;
        phoneLab.hidden = YES;
    }

    [self callRealNameInfoWebService:@{ @"userId" : [UserDefaultsUtil getUser].userId }];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChange) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)textFieldDidChange {
    if (_nameTextField.text.length > 0 && _identityCardTextField.text.length > 0) {
        _realNameButton.isColorEnabled = YES;
    } else {
        _realNameButton.isColorEnabled = NO;
    }
}

- (void)clickTheRealNameButton:(id)sender {

    if (_nameTextField.text.length == 0) {

        [HUD showPromptViewWithToShowStr:XYBString(@"string_enter_realName", @"请输入真实姓名") autoHide:YES afterDelay:1.0 userInteractionEnabled:YES];
        return;
    }

    if (_identityCardTextField.text.length == 0) {

        [HUD showPromptViewWithToShowStr:XYBString(@"string_enter_addressId", @"请输入身份证号") autoHide:YES afterDelay:1.0 userInteractionEnabled:YES];
        return;
    }

    if (![self onClickButton:_identityCardTextField.text]) {
        return;
    }

    [_nameTextField resignFirstResponder];
    [_identityCardTextField resignFirstResponder];

    User *user = [UserDefaultsUtil getUser];

    [self callRealNameWebService:@{ @"userId" : user.userId,
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
                [HUD showPromptViewWithToShowStr:XYBString(@"string_length_addressId", @"身份证为18位字母或数字") autoHide:YES afterDelay:1.0 userInteractionEnabled:YES];
                return NO;
            }

        } else if (field3Str.length == 18) {

            bool sfz18NO = [self checkIdentityCardNo:field3Str];

            if (!sfz18NO) {
                [HUD showPromptViewWithToShowStr:XYBString(@"string_error_addressId", @"身份证无效") autoHide:YES afterDelay:1.0 userInteractionEnabled:YES];
                return NO;
            }
        }

    } else {

        [HUD showPromptViewWithToShowStr:XYBString(@"string_length_addressId", @"身份证为18位字母或数字") autoHide:YES afterDelay:1.0 userInteractionEnabled:YES];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

/*****************************保存实名认证接口**********************************/
- (void)callRealNameWebService:(NSDictionary *)dictionary {

    NSString *requestURL = [RequestURL getRequestURL:UserSaveAuthInfoURL param:dictionary];

    [self showDataLoading];
    [WebService postRequest:requestURL param:dictionary JSONModelClass:[SaveAuthInfoModel class]

        Success:^(AFHTTPRequestOperation *operation, id responseObject) {

            [self hideLoading];
            SaveAuthInfoModel *responseModel = responseObject;
            if (responseModel.resultCode == 1) {

                User *user = [UserDefaultsUtil getUser];
                user.realName = responseModel.realName;
                user.idNumber = responseModel.idNumber;
                [UserDefaultsUtil setUser:user];

                [HUD showPromptViewWithToShowStr:XYBString(@"string_sucess_realname", @"保存成功") autoHide:YES afterDelay:1.0 userInteractionEnabled:YES];
                [self.navigationController popViewControllerAnimated:YES];
            }

        }

        fail:^(AFHTTPRequestOperation *operation, NSString *errorMessage) {
            [self hideLoading];
            [self showPromptTip:errorMessage];
        }

    ];
}

/*****************************查询实名认证信息**********************************/
- (void)callRealNameInfoWebService:(NSDictionary *)dictionary {

    [self showDataLoading];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:dictionary];
    NSString *urlPath = [RequestURL getRequestURL:AuthRealNameURL param:params];
    [WebService postRequest:urlPath param:params JSONModelClass:[RealNamesResponseModel class]

        Success:^(AFHTTPRequestOperation *operation, id responseObject) {

            [self hideLoading];
            RealNamesResponseModel *RealNames = responseObject;
            if (RealNames.resultCode == 1) {
                if (![RealNames.realName isEqual:[NSNull null]] && ![RealNames.idNumber isEqual:[NSNull null]]) {

                    NSString *name = RealNames.realName;
                    NSString *idCard = RealNames.idNumber;

                    User *user = [UserDefaultsUtil getUser];
                    user.realName = name;
                    user.idNumber = idCard;
                    [UserDefaultsUtil setUser:user];

                    NSString *nameStr = @"";
                    //                            NSString * idCardStr = @"";
                    if (name.length > 1) {
                        if (name.length > 2) {
                            nameStr = [NSString stringWithFormat:@"%@*%@", [name substringToIndex:1], [name substringFromIndex:name.length - 1]];
                        } else {
                            nameStr = [NSString stringWithFormat:@"*%@", [name substringFromIndex:name.length - 1]];
                        }
                    }
                    //            if (idCard.length>3) {
                    //                idCardStr = [NSString stringWithFormat:@"%@************%@",[idCard substringToIndex:3],[idCard substringWithRange:NSMakeRange(idCard.length-3, 3)]];
                    //            }

                    if ([[UserDefaultsUtil getUser].isIdentityAuth boolValue]) {
                        _userNameLabel.text = name;
                        _idCardLabel.text = idCard;
                    } else {
                        self.nameTextField.text = name;
                        self.identityCardTextField.text = idCard;
                    }
                }
            }

        }

        fail:^(AFHTTPRequestOperation *operation, NSString *errorMessage) {

            [self hideLoading];
            [self showPromptTip:errorMessage];

        }

    ];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
