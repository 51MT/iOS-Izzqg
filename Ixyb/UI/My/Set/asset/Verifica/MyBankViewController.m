//
//  TropismInfoViewController.m
//  Ixyb
//
//  Created by wang on 15/5/21.
//  Copyright (c) 2015年 xyb. All rights reserved.
//

#import "MyBankViewController.h"

#import "BankTypeResponseModel.h"
#import "BindedBankView.h"
#import "BindingBankCardModel.h"
#import "MyBanksResponseModel.h"
#import "Utility.h"
#import "WebService.h"
#import "XYCellLine.h"

@interface MyBankViewController () <UITextFieldDelegate>

@property (nonatomic, strong) UIScrollView *toBindScrollView;

@property (nonatomic, strong) UITextField *cardNoTextFiled;
@property (nonatomic, strong) UIView *cardTypeInfoView;
@property (nonatomic, strong) UIImageView *cardTypeImageView;
@property (nonatomic, strong) UILabel *cardTypeLabel;
@property (nonatomic, strong) MASConstraint *cardTypeInfoViewHeightConstraint;

@property (nonatomic, strong) UIView *bindedView;
@property (nonatomic, strong) BindedBankView *bindedBankView;
@property (nonatomic, strong) NSMutableDictionary *bankInfoDic;
@property (nonatomic, strong) NSArray *bankArr;

@property (nonatomic, strong) ColorButton *commitButton;

@property (nonatomic, strong) NSString *bankId;

@end

@implementation MyBankViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.toBindScrollView layoutIfNeeded];
}

- (void)clickBackBtn:(id)sender {
    [self hideKeyboard];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)hideKeyboard {
    [self.cardNoTextFiled resignFirstResponder];
}

- (void)initBindedScrollView {
    self.bindedView = [[UIView alloc] init];
    self.bindedView.backgroundColor = COLOR_BG;
    [self.view addSubview:self.bindedView];
    [self.bindedView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navBar.mas_bottom);
        make.left.bottom.right.equalTo(self.view);
    }];

    self.bindedBankView = [[BindedBankView alloc] init];
    [self.bindedView addSubview:self.bindedBankView];
    [self.bindedBankView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.bindedView);
        make.height.equalTo(@170);
    }];

    UILabel *tipsLab = [[UILabel alloc] init];
    tipsLab.text = XYBString(@"str_cozy_prompt", @"温馨提示:");
    tipsLab.textColor = COLOR_AUXILIARY_GREY;
    tipsLab.font = TEXT_FONT_12;
    [self.bindedView addSubview:tipsLab];

    [tipsLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@Margin_Length);
        make.top.equalTo(self.bindedBankView.mas_bottom).offset(Margin_Length);
    }];

    UILabel *messageLab = [[UILabel alloc] init];
    messageLab.textColor = COLOR_AUXILIARY_GREY;
    messageLab.text = XYBString(@"str_name_message", @"信用宝不会在任何地方泄露您的个人信息");
    messageLab.font = TEXT_FONT_12;
    [self.bindedView addSubview:messageLab];

    [messageLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(tipsLab.mas_left);
        make.top.equalTo(tipsLab.mas_bottom).offset(8);
    }];

    UILabel *phoneLab = [[UILabel alloc] init];
    phoneLab.textColor = COLOR_MAIN;
    phoneLab.attributedText = [Utility getAttributedstring:XYBString(@"str_contact_custome", @"更换默认卡,请联系客服") tailStr:XYBString(@"str_contact_phone", @" 400-070-7663") labColor:COLOR_AUXILIARY_GREY];
    phoneLab.font = TEXT_FONT_12;
    [self.bindedView addSubview:phoneLab];

    [phoneLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@Margin_Length);
        make.top.equalTo(messageLab.mas_bottom).offset(8);
    }];

    //先在本地加载一下
    User *user = [UserDefaultsUtil getUser];

    for (NSDictionary *bankDic in self.bankArr) {
        int bankType = [[bankDic objectForKey:@"bankType"] intValue];
        if (bankType == [user.bankType intValue]) {
            [self.bankInfoDic setObject:[bankDic objectForKey:@"bankName"] forKey:@"bankName"];
            [self.bankInfoDic setObject:[bankDic objectForKey:@"bankImage"] forKey:@"bankImage"];
            break;
        }
    }
    if (user.accountNumber.length > 4) {
        [self.bankInfoDic setObject:user.accountNumber forKey:@"accountNumber"];
    }
    if (user.bankmobilePhone.length > 8) {
        [self.bankInfoDic setObject:user.bankmobilePhone forKey:@"mobilePhone"];
    }
    self.bindedBankView.bankDic = self.bankInfoDic;
}

- (void)initToBindScrollView {
    self.toBindScrollView = [[UIScrollView alloc] init];
    [self.view addSubview:self.toBindScrollView];
    [self.toBindScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navBar.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];

    UIImageView *iconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_info_gray"]];
    [iconImageView setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
    [self.toBindScrollView addSubview:iconImageView];
    [iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@Margin_Length);
        make.top.equalTo(@20);
    }];

    UILabel *tipLabel = [[UILabel alloc] init];
    tipLabel.numberOfLines = 0;
    tipLabel.text = XYBString(@"str_charge_tip", @"请确保储蓄卡为您本人的银行卡,仅支持大陆借记卡。\n首次绑定的银行卡将作为信用宝默认卡。\n此处填写仅作为信息保存。");
    [Utility modifyLabel:tipLabel color:COLOR_AUXILIARY_GREY font:TEXT_FONT_14 space:6.0f];
    [self.toBindScrollView addSubview:tipLabel];
    [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(iconImageView.mas_right).offset(5);
        make.top.equalTo(iconImageView.mas_top).offset(-2); //向上偏移两个像素以后刚好同左边的iconImageView看起来在同一条线上
        make.right.equalTo(@-20);
    }];

    UIView *inputView = [[UIView alloc] init];
    [self.toBindScrollView addSubview:inputView];
    inputView.backgroundColor = COLOR_COMMON_WHITE;
    [inputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(@0);
        make.top.equalTo(tipLabel.mas_bottom).offset(Margin_Length);
        make.height.equalTo(@45);
        make.width.equalTo(@(MainScreenWidth));
    }];

    [XYCellLine initWithTopLineAtSuperView:inputView];
    [XYCellLine initWithBottomLineAtSuperView:inputView];

    UILabel *tipInputLabel = [[UILabel alloc] init];
    tipInputLabel.font = TEXT_FONT_16;
    tipInputLabel.textColor = COLOR_MAIN_GREY;
    tipInputLabel.text = XYBString(@"str_bank_card_id", @"银行卡号");
    [inputView addSubview:tipInputLabel];
    [tipInputLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(@0);
        make.left.equalTo(@Margin_Length);
    }];

    User *user = [UserDefaultsUtil getUser];
    self.cardNoTextFiled = [[UITextField alloc] init];
    self.cardNoTextFiled.delegate = self;
    self.cardNoTextFiled.font = TEXT_FONT_16;
    self.cardNoTextFiled.textColor = COLOR_MAIN_GREY;
    self.cardNoTextFiled.placeholder = XYBString(@"str_pls_input_bank_no", @"仅支持大陆借记卡");
    self.cardNoTextFiled.text = [Utility firendlyCardString:user.accountNumber];
    self.cardNoTextFiled.clearButtonMode = UITextFieldViewModeWhileEditing;
    [inputView addSubview:self.cardNoTextFiled];
    [self.cardNoTextFiled mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(@0);
        make.left.equalTo(tipInputLabel.mas_right).offset(10);
        make.right.equalTo(@-10);
    }];

    self.cardTypeInfoView = [[UIView alloc] init];
    self.cardTypeInfoView.clipsToBounds = YES;
    [self.toBindScrollView addSubview:self.cardTypeInfoView];
    [self.cardTypeInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(@0);
        make.top.equalTo(inputView.mas_bottom).offset(10);
        self.cardTypeInfoViewHeightConstraint = make.height.equalTo(@0);
    }];

    self.cardTypeImageView = [[UIImageView alloc] init];
    [self.cardTypeInfoView addSubview:self.cardTypeImageView];
    [self.cardTypeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@Margin_Length);
        make.centerY.equalTo(@0);
    }];

    self.cardTypeLabel = [[UILabel alloc] init];
    self.cardTypeLabel.font = TEXT_FONT_14;
    self.cardTypeLabel.textColor = COLOR_MAIN_GREY;
    [self.cardTypeInfoView addSubview:self.cardTypeLabel];
    [self.cardTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.cardTypeImageView.mas_right).offset(10);
        make.centerY.equalTo(@0);
    }];

   
    self.commitButton  = [[ColorButton alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth - 30, Button_Height) Title:XYBString(@"str_person_save", @"保存")ByGradientType:leftToRight];
    [self.commitButton addTarget:self action:@selector(clickCommitButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.toBindScrollView addSubview:self.commitButton];

    [self.commitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.cardTypeInfoView.mas_bottom).offset(10);
        make.left.equalTo(@Margin_Length);
        make.right.equalTo(@-Margin_Length);
        make.height.equalTo(@45);
        make.bottom.equalTo(@0);

    }];

    if ([[Utility firendlyCardString:user.accountNumber] length] > 0) {
        self.commitButton.isColorEnabled = YES;
    } else {
        self.commitButton.isColorEnabled = NO;
    }

    NSString *bankNumber = [self bankNumToNormalNum:self.cardNoTextFiled.text];
    if (bankNumber.length >= 6) {
        //        [self requestBankInfo:bankNumber];
        [self requestBankPrefixWebServiceWithBankNumber:bankNumber];
    }
}
#pragma mark - 根据银行卡前6位查询银行类型

- (void)requestBankPrefixWebServiceWithBankNumber:(NSString *)bankNumber {
    static BOOL s_hasSend = NO;
    if (s_hasSend == YES) {
        return;
    }
    NSDictionary *param = @{
        @"accountNumber" : bankNumber
    };

    NSString *requestURL = [RequestURL getRequestURL:CheckBankTypeURL param:param];
    [WebService postRequest:requestURL param:param JSONModelClass:[BankTypeResponseModel class] Success:^(AFHTTPRequestOperation *operation, id responseObject) {

        s_hasSend = NO;
        BankTypeResponseModel *responseModel = responseObject;
        NSDictionary *bankInfo = [Utility findBankInfoByType:(int) responseModel.bankType];
        if (bankInfo) {
            self.cardTypeImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@", [bankInfo objectForKey:@"bankImage"]]];
            self.cardTypeLabel.text = [bankInfo objectForKey:@"bankName"];
            [self.cardTypeInfoViewHeightConstraint uninstall];
            [self.cardTypeInfoView mas_updateConstraints:^(MASConstraintMaker *make) {
                self.cardTypeInfoViewHeightConstraint = make.height.equalTo(@30);
            }];
        }

    }
        fail:^(AFHTTPRequestOperation *operation, NSString *errorMessage) {
            [self hideLoading];
            [self showPromptTip:errorMessage];
        }];
}

// 银行卡号转正常号 － 去除4位间的空格
- (NSString *)bankNumToNormalNum:(NSString *)bankStr {
    NSString *str = [NSString stringWithString:bankStr];
    return [str stringByReplacingOccurrencesOfString:@" " withString:@""];
}

- (void)clickCommitButton:(id)sender {

    [self hideKeyboard];

    if (self.cardNoTextFiled.text.length == 0) {
        [self showPromptTip:XYBString(@"str_please_input_bank_card_id", @"请输入银行卡号")];
        return;
    }

    NSString *bankStr = [self bankNumToNormalNum:self.cardNoTextFiled.text];

    if (![Utility validateBankCardNumber:bankStr]) {
        [self showPromptTip:XYBString(@"str_card_not_correct", @"请输入正确的储蓄卡号")];
        return;
    }

    //保存卡号到本地
    User *user = [UserDefaultsUtil getUser];
    //    user.accountNumber = bankStr;
    //    [UserDefaultsUtil setUser:user];
    //    [self showPromptTip:XYBString(@"string_key_saved_card", @"已保存")];

    //    NSDictionary * param = @{@"userId":user.userId,
    //                             @"accountNumber":bankStr};

    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithCapacity:5];
    if (user.userId) {
        [param setObject:user.userId forKey:@"userId"];
    }
    if (bankStr) {
        [param setObject:bankStr forKey:@"accountNumber"];
    }
    if (self.bankId) {
        [param setObject:self.bankId forKey:@"id"];
    }
    NSString *urlPath = [RequestURL getRequestURL:UserBankAddURL param:param];
    [WebService postRequest:urlPath param:param JSONModelClass:[BindingBankCardModel class] Success:^(AFHTTPRequestOperation *operation, id responseObject) {
        BindingBankCardModel *myBankResponse = responseObject;
        if (myBankResponse.resultCode == 1) {
            NSDictionary *bankDic = myBankResponse.bank.toDictionary;
            [self.bankInfoDic addEntriesFromDictionary:bankDic];
            User *user = [UserDefaultsUtil getUser];
            user.accountNumber = [bankDic objectForKey:@"accountNumber"];
            user.bankName = [bankDic objectForKey:@"bankName"];
            user.bankType = [bankDic objectForKey:@"bankType"];
            user.bankmobilePhone = [bankDic objectForKey:@"mobilePhone"];
            user.bankId = [bankDic objectForKey:@"id"];
            self.bankId = user.bankId;
            [UserDefaultsUtil setUser:user];
            [self showPromptTip:XYBString(@"string_connect_time_out", @"保存成功!")];
            [self.navigationController popViewControllerAnimated:YES];
        }

    }
        fail:^(AFHTTPRequestOperation *operation, NSString *errorMessage) {
            [self showPromptTip:errorMessage];
        }];
}

- (BOOL)isCardBinded {
    //目前取本地
    User *user = [UserDefaultsUtil getUser];
    return [user.isBankSaved boolValue];
}

- (void)initUI {

    self.navItem.title = XYBString(@"str_bank_card_my", @"我的银行卡");
    self.navItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(clickBackBtn:)];

    if ([self isCardBinded]) {
        [self initBindedScrollView];
    } else {
        [self initToBindScrollView];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.bankInfoDic = [NSMutableDictionary dictionaryWithCapacity:10];
    NSString *bankJson = [[NSBundle mainBundle] pathForResource:@"bank" ofType:@"json"];
    self.bankArr = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:bankJson] options:NSJSONReadingMutableContainers error:nil];
    [self initUI];
    [self requestCheckBankBind];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {

    NSString *text = [textField text];

    NSCharacterSet *characterSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789\b"];
    string = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
    if ([string rangeOfCharacterFromSet:[characterSet invertedSet]].location != NSNotFound) {
        return NO;
    }

    text = [text stringByReplacingCharactersInRange:range withString:string];
    text = [text stringByReplacingOccurrencesOfString:@" " withString:@""];

    NSString *newString = @"";
    while (text.length > 0) {
        NSString *subString = [text substringToIndex:MIN(text.length, 4)];
        newString = [newString stringByAppendingString:subString];
        if (subString.length == 4) {
            newString = [newString stringByAppendingString:@" "];
        }
        text = [text substringFromIndex:MIN(text.length, 4)];
    }

    newString = [newString stringByTrimmingCharactersInSet:[characterSet invertedSet]];

    if (newString.length >= 25) {
        return NO;
    }

    [textField setText:newString];

    NSString *bankNumber = [self bankNumToNormalNum:self.cardNoTextFiled.text];
    if (bankNumber.length >= 6) {
        //        [self requestBankInfo:bankNumber];
        [self requestBankPrefixWebServiceWithBankNumber:bankNumber];
        self.commitButton.isColorEnabled = YES;
    } else {
        [self.cardTypeInfoViewHeightConstraint uninstall];
        [self.cardTypeInfoView mas_updateConstraints:^(MASConstraintMaker *make) {
            self.cardTypeInfoViewHeightConstraint = make.height.equalTo(@0);
        }];
        self.commitButton.isColorEnabled = NO;
    }

    return NO;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    if (textField.text.length != 0) {
        self.commitButton.isColorEnabled = NO;
        [self.cardTypeInfoViewHeightConstraint uninstall];
        [self.cardTypeInfoView mas_updateConstraints:^(MASConstraintMaker *make) {
            self.cardTypeInfoViewHeightConstraint = make.height.equalTo(@0);
        }];
        return YES;
    }
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

///*****************************检测银行卡绑定接口**********************************/
- (void)requestCheckBankBind {

    NSDictionary *param = @{ @"userId" : [UserDefaultsUtil getUser].userId };
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:param];
    NSString *urlPath = [RequestURL getRequestURL:BankURL param:params];
    [WebService postRequest:urlPath param:params JSONModelClass:[MyBanksResponseModel class] Success:^(AFHTTPRequestOperation *operation, id responseObject) {
        MyBanksResponseModel *myBankResponse = responseObject;
        [self.bankInfoDic addEntriesFromDictionary:myBankResponse.bank.toDictionary];
        User *user = [UserDefaultsUtil getUser];
        user.accountNumber = myBankResponse.bank.accountNumber;
        user.bankName = myBankResponse.bank.bankName;
        user.bankType = myBankResponse.bank.bankType;
        user.bankmobilePhone = myBankResponse.bank.mobilePhone;
        user.bankId = myBankResponse.bank.bankId;
        self.bankId = user.bankId;
        [UserDefaultsUtil setUser:user];
        for (NSDictionary *dic in self.bankArr) {
            int bankType = [[dic objectForKey:@"bankType"] intValue];
            if (bankType == [user.bankType intValue]) {
                [self.bankInfoDic setObject:user.bankType forKey:@"bankImage"];
                [self.bankInfoDic setObject:[dic objectForKey:@"bankName"] forKey:@"bankName"];
                break;
            }
        }
        self.bindedBankView.bankDic = self.bankInfoDic;

        if (self.cardNoTextFiled) {
            self.cardNoTextFiled.text = [Utility firendlyCardString:user.accountNumber];
        }

    }
        fail:^(AFHTTPRequestOperation *operation, NSString *errorMessage) {
            [self showPromptTip:errorMessage];
        }];
}

@end
