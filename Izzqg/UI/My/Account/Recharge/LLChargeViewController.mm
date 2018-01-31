//
//  LLChargeViewController.m
//  Ixyb
//
//  Created by wang on 16/1/28.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import "LLChargeViewController.h"
#import <AVFoundation/AVCaptureDevice.h>
#import <AVFoundation/AVMediaFormat.h>

#import "BankCardSdkUtil.h"

#import "BankTypeResponseModel.h"
#import "ChargeValidate.h"
#import "LLChargeCallBackResponseModel.h"
#import "LLFirstChargeResponseModel.h"
#import "RTLabel.h"
#import "Utility.h"
#import "WebService.h"
#import "WebviewViewController.h"
#import "XYCellLine.h"

#import "CCPClipCaremaImage.h"
#import "Utility.h"
#import "WebService.h"
#import "ChargeFailureViewController.h"
#import "ChargeResultStatusViewController.h"

#import <MGBaseKit/MGBaseKit.h>
#import <MGIDCard/MGIDCard.h>

#define INFOVIEWTAG 5003
#define NAMETEXTFIELDTAG 4000
#define IDTEXTFIELDTAG 4001
#define BANKIDTEXTFIELDTAG 4002
#define BANKNAMETAG 3001
#define SINGLE_DEAL_AMOUNT_TAG 3002
#define VIEW_TAG_LOAN_ALEERT_PHONE 3003

@interface LLChargeViewController () <RTLabelDelegate> {
    UIScrollView *mainScroll;
    UIImageView *investBackImage;
    UITextField *dustedMoneyTextField;
    UIView *commonView;
    UIView *chargeBtnView;
    UIButton *chargeBtn;
    ColorButton *chargeButton;
    MBProgressHUD *hud;
    NSDictionary *contentDic;
    UIView *infoView;
    NSDictionary *payDic;
    
    int bankTypeNumber;
    CCPClipCaremaImage *viewCaremal;
    BankTypeResponseModel *bankModel;
}

@property (nonatomic, assign) BOOL identifer;

@end

@implementation LLChargeViewController

-(instancetype)initWithIdentifer:(BOOL)identifer {
    self = [super init];
    if (self) {
        _identifer = identifer;
    }
    
    return self;
}

- (void)setNav {
    self.navItem.title = XYBString(@"string_charge", @"充值");
    
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

- (void)clickBackBtn:(id)sender {
    [dustedMoneyTextField resignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)clickTheRightBtn {
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", [RequestURL getNodeJsH5URL:App_Bank_Limit_URL withIsSign:NO], App_Bank_Tab_Nav1_URL];
    NSString *titleStr = XYBString(@"str_bank_limit", @"充值提现说明");
    WebviewViewController *webView = [[WebviewViewController alloc] initWithTitle:titleStr webUrlString:urlStr];
    [self.navigationController pushViewController:webView animated:YES];
}

- (void)viewDidLoad {
    [self initFaceIDCardService];
    [super viewDidLoad];
    
    [self setNav];
    bankTypeNumber = -1;
    
    [self creatTheMianScroll];
    [self creatTheNoBankSaveNoRealNameView];
    [self creatTheChargeButtonView];
    [self creatTheRemindView];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [viewCaremal stopCamera];
}

- (void)creatTheMianScroll {
    
    mainScroll = [[UIScrollView alloc] init];
    mainScroll.showsVerticalScrollIndicator = NO;
    mainScroll.scrollEnabled = NO;
    [self.view addSubview:mainScroll];
    
    [mainScroll mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navBar.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
    
    UIView *vi = [[UIView alloc] init];
    [self.view addSubview:vi];
    
    [vi mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navBar.mas_bottom);
        make.left.right.equalTo(self.view);
        make.width.equalTo(@(MainScreenWidth));
        make.height.equalTo(@1);
    }];
    
    investBackImage = [[UIImageView alloc] init];
    investBackImage.image = [UIImage imageNamed:@"viewBackImage"];
    investBackImage.userInteractionEnabled = YES;
    [mainScroll addSubview:investBackImage];
    
    [investBackImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(mainScroll);
        make.width.equalTo(vi.mas_width);
        make.top.equalTo(@20);
    }];
    
    UILabel *moneyLab = [[UILabel alloc] init];
    moneyLab.text = XYBString(@"string_amount", @"金额");
    moneyLab.textColor = COLOR_MAIN_GREY;
    moneyLab.font = TEXT_FONT_16;
    [investBackImage addSubview:moneyLab];
    [moneyLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@Margin_Length);
        make.centerY.equalTo(investBackImage.mas_centerY);
    }];
    
    dustedMoneyTextField = [[UITextField alloc] init];
    dustedMoneyTextField.placeholder = XYBString(@"string_suggest_more_than_100", @"建议100元或以上");
    dustedMoneyTextField.textColor = COLOR_MAIN_GREY;
    dustedMoneyTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    dustedMoneyTextField.font = TEXT_FONT_16;
    dustedMoneyTextField.keyboardType = UIKeyboardTypeNumberPad;
    dustedMoneyTextField.text = self.chargeStr;
    //      dustedMoneyTextField.keyboardType = UIKeyboardTypeDecimalPad;
    //    [dustedMoneyTextField becomeFirstResponder];
    dustedMoneyTextField.userInteractionEnabled = NO;
    [investBackImage addSubview:dustedMoneyTextField];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dustedMoneyTextFieldChange) name:UITextFieldTextDidChangeNotification object:dustedMoneyTextField];
    [dustedMoneyTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        //        make.left.equalTo(moneyLab.mas_right).offset(5);
        make.left.equalTo(moneyLab.mas_left).offset(70);
        make.centerY.equalTo(investBackImage.mas_centerY);
        make.height.equalTo(@30);
        //        make.right.equalTo (investBackImage.mas_right);
        make.width.equalTo(@(MainScreenWidth - 100));
    }];
    
    UILabel *unitLab = [[UILabel alloc] init];
    unitLab.text = XYBString(@"string_yuan", @"元");
    unitLab.textColor = COLOR_MAIN_GREY;
    unitLab.font = TEXT_FONT_16;
    [investBackImage addSubview:unitLab];
    [unitLab setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh + 20 forAxis:UILayoutConstraintAxisHorizontal];
    [unitLab setContentHuggingPriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    [unitLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(investBackImage.mas_right).offset(-10);
        make.centerY.equalTo(investBackImage.mas_centerY);
    }];
}

- (void)creatTheNoBankSaveNoRealNameView {
    
    UIView *customerView = nil;
    if (commonView) {
        [commonView removeFromSuperview];
    }
    commonView = [[UIView alloc] init];
    commonView.backgroundColor = COLOR_COMMON_CLEAR;
    [mainScroll addSubview:commonView];
    
    [commonView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(mainScroll);
        make.top.equalTo(investBackImage.mas_bottom).offset(20);
    }];
    
    UILabel *note1Lab = [[UILabel alloc] init];
    note1Lab.font = TEXT_FONT_12;
    note1Lab.textColor = COLOR_AUXILIARY_GREY;
    note1Lab.text = XYBString(@"string_make_sure_yourself_card", @"• 确保储蓄卡为您本人的银行卡");
    [commonView addSubview:note1Lab];
    
    [note1Lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(commonView.mas_left).offset(Margin_Length);
        make.top.equalTo(investBackImage.mas_bottom).offset(Margin_Length);
    }];
    
    UILabel *note2Lab = [[UILabel alloc] init];
    note2Lab.font = TEXT_FONT_12;
    note2Lab.textColor = COLOR_AUXILIARY_GREY;
    note2Lab.text = XYBString(@"string_first_card_is_default", @"• 首次绑定的银行卡将作为信用宝默认卡");
    [commonView addSubview:note2Lab];
    
    [note2Lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(note1Lab.mas_left).offset(0);
        make.top.equalTo(note1Lab.mas_bottom).offset(5);
    }];
    
    infoView = [[UIView alloc] init];
    infoView.backgroundColor = COLOR_COMMON_WHITE;
    infoView.tag = INFOVIEWTAG;
    [commonView addSubview:infoView];
    
    infoView.layer.masksToBounds = YES;
    infoView.layer.borderWidth = Border_Width;
    infoView.layer.borderColor = COLOR_LINE.CGColor;
    
    [infoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(-1));
        make.right.equalTo(@(1));
        make.top.equalTo(note2Lab.mas_bottom).offset(Margin_Length);
    }];
    customerView = infoView;
    
    UILabel *nameTitleLab = [[UILabel alloc] init];
    nameTitleLab.font = TEXT_FONT_16;
    nameTitleLab.textColor = COLOR_MAIN_GREY;
    nameTitleLab.text = XYBString(@"string_card_owner", @"持卡人");
    [infoView addSubview:nameTitleLab];
    
    [nameTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(@(Margin_Length));
    }];
    
    UIButton *butCamera = [UIButton buttonWithType:UIButtonTypeCustom];
    [butCamera setImage:[UIImage imageNamed:@"camera_load"] forState:UIControlStateNormal];
    [butCamera setImage:[UIImage imageNamed:@"camera_select"] forState:UIControlStateSelected];
    [butCamera addTarget:self action:@selector(clickUserNameCameraBtn:) forControlEvents:UIControlEventTouchUpInside];
    [infoView addSubview:butCamera];
    [butCamera mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(infoView.mas_right).offset(-Margin_Right);
        make.centerY.equalTo(nameTitleLab.mas_centerY);
    }];
    
    UITextField *userNameTextField = [[UITextField alloc] init];
    userNameTextField.font = TEXT_FONT_16;
    userNameTextField.placeholder = XYBString(@"undefined_name", @"请输入姓名");
    userNameTextField.textColor = COLOR_MAIN_GREY;
    userNameTextField.tag = NAMETEXTFIELDTAG;
    userNameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dustedMoneyTextFieldChange) name:UITextFieldTextDidChangeNotification object:userNameTextField];
    [infoView addSubview:userNameTextField];
    
    [userNameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nameTitleLab.mas_left).offset(70);
        make.centerY.equalTo(nameTitleLab.mas_centerY);
        make.right.equalTo(butCamera.mas_right).offset(-20);
    }];
    
    UIImageView *verlineImage1 = [[UIImageView alloc] init];
    verlineImage1.image = [UIImage imageNamed:@"onePoint"];
    [infoView addSubview:verlineImage1];
    
    [verlineImage1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Margin_Length));
        make.right.equalTo(@0);
        make.top.equalTo(nameTitleLab.mas_bottom).offset(Margin_Length);
        make.height.equalTo(@1);
    }];
    
    UILabel *userIDLab = [[UILabel alloc] init];
    userIDLab.font = TEXT_FONT_16;
    userIDLab.textColor = COLOR_MAIN_GREY;
    userIDLab.text = XYBString(@"string_identity_number", @"身份证号");
    [infoView addSubview:userIDLab];
    
    [userIDLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Margin_Length));
        make.top.equalTo(verlineImage1.mas_bottom).offset(0);
        make.height.equalTo(@45);
    }];
    
    UITextField *userIDTextField = [[UITextField alloc] init];
    userIDTextField.font = TEXT_FONT_16;
    userIDTextField.placeholder = XYBString(@"string_only_chinese", @"仅支持大陆身份证号");
    userIDTextField.textColor = COLOR_MAIN_GREY;
    userIDTextField.tag = IDTEXTFIELDTAG;
    userIDTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dustedMoneyTextFieldChange) name:UITextFieldTextDidChangeNotification object:userIDTextField];
    [infoView addSubview:userIDTextField];
    
    [userIDTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(userIDLab.mas_left).offset(70);
        make.centerY.equalTo(userIDLab.mas_centerY);
        make.right.equalTo(@(-Margin_Length));
    }];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectZero];
    lineView.backgroundColor = COLOR_LINE;
    [infoView addSubview:lineView];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(infoView.mas_left).offset(Margin_Length);
        make.top.equalTo(userIDTextField.mas_bottom).offset(Margin_Length);
        make.right.equalTo(infoView.mas_right).offset(0);
        make.height.equalTo(@(Line_Height));
    }];
    
    UILabel *bankNumLab = [[UILabel alloc] init];
    bankNumLab.font = TEXT_FONT_16;
    bankNumLab.textColor = COLOR_MAIN_GREY;
    bankNumLab.text = XYBString(@"string_bank_name", @"银行卡号");
    [infoView addSubview:bankNumLab];
    
    [bankNumLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Margin_Length));
        make.top.equalTo(lineView.mas_bottom).offset(Margin_Length);
    }];
    
    UIButton *butNumCamera = [UIButton buttonWithType:UIButtonTypeCustom];
    [butNumCamera setImage:[UIImage imageNamed:@"camera_load"] forState:UIControlStateNormal];
    [butNumCamera setImage:[UIImage imageNamed:@"camera_select"] forState:UIControlStateSelected];
    [butNumCamera addTarget:self action:@selector(clickNumCameraBtn:) forControlEvents:UIControlEventTouchUpInside];
    [infoView addSubview:butNumCamera];
    [butNumCamera mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(infoView.mas_right).offset(-Margin_Right);
        make.centerY.equalTo(bankNumLab.mas_centerY);
    }];
    
    UITextField *bankNumTextField = [[UITextField alloc] init];
    bankNumTextField.font = TEXT_FONT_16;
    bankNumTextField.placeholder = XYBString(@"string_enter_bankcardnum_15-19", @"仅支持大陆借记卡");
    bankNumTextField.textColor = COLOR_MAIN_GREY;
    bankNumTextField.delegate = self;
    bankNumTextField.tag = BANKIDTEXTFIELDTAG;
    bankNumTextField.keyboardType = UIKeyboardTypeNumberPad;
    bankNumTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [infoView addSubview:bankNumTextField];
    
    [bankNumTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bankNumLab.mas_left).offset(70);
        make.centerY.equalTo(bankNumLab.mas_centerY);
        make.right.equalTo(butNumCamera.mas_right).offset(-20);
        make.bottom.equalTo(infoView.mas_bottom).offset((-Margin_Length));
    }];
    
    UILabel *bankName = [[UILabel alloc] init];
    bankName.font = TEXT_FONT_12;
    bankName.textColor = COLOR_MAIN_GREY;
    bankName.tag = BANKNAMETAG;
    [commonView addSubview:bankName];
    
    [bankName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(commonView.mas_left).offset(Margin_Length);
        make.top.equalTo(infoView.mas_bottom).offset(Margin_Length);
        make.bottom.equalTo(commonView.mas_bottom).offset(0);
    }];
    
    UILabel *singleDealAmount = [[UILabel alloc] initWithFrame:CGRectZero];
    singleDealAmount.text = @"";
    singleDealAmount.textColor = COLOR_LIGHT_GREY;
    singleDealAmount.font = TEXT_FONT_12;
    singleDealAmount.tag = SINGLE_DEAL_AMOUNT_TAG;
    [commonView addSubview:singleDealAmount];
    
    [singleDealAmount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bankName.mas_right).offset(8);
        make.centerY.equalTo(bankName.mas_centerY);
    }];
    
    User *user = [UserDefaultsUtil getUser];
    if (user.realName) {
        userNameTextField.text = user.realName;
    }
    
    if (user.idNumber) {
        userIDTextField.text = user.idNumber;
    }
    if ([user.isIdentityAuth boolValue]) {
        userIDTextField.userInteractionEnabled = NO;
        userNameTextField.userInteractionEnabled = NO;
        butCamera.hidden = YES;
    } else {
        userIDTextField.userInteractionEnabled = YES;
        userNameTextField.userInteractionEnabled = YES;
        butCamera.hidden = NO;
    }
    
    if (user.accountNumber) {
        bankNumTextField.text = [Utility firendlyCardString:user.accountNumber];
    }
    
    bankTypeNumber = -1;
    NSString *bankJson = [[NSBundle mainBundle] pathForResource:@"bank" ofType:@"json"];
    NSArray *bankArr = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:bankJson] options:NSJSONReadingMutableContainers error:nil];
    bankTypeNumber = [user.bankType intValue];
    for (NSDictionary *bankDic in bankArr) {
        int bankType = [[bankDic objectForKey:@"bankType"] intValue];
        if (bankType == [user.bankType intValue]) {
            bankName.text = [bankDic objectForKey:@"bankName"];
            break;
        }
    }
}

- (void)creatTheChargeButtonView {
    
    if (chargeBtnView) {
        [chargeBtnView removeFromSuperview];
    }
    chargeBtnView = [[UIView alloc] init];
    chargeBtnView.backgroundColor = COLOR_COMMON_CLEAR;
    [mainScroll addSubview:chargeBtnView];
    
    [chargeBtnView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(mainScroll);
        make.top.equalTo(commonView.mas_bottom).offset(0);
        make.height.equalTo(@(86));
    }];
    

    chargeButton = [[ColorButton alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth - 30, Button_Height) Title:XYBString(@"string_ok", @"确定") ByGradientType:leftToRight];
    [chargeButton addTarget:self action:@selector(clickTheNextButton:) forControlEvents:UIControlEventTouchUpInside];
    [chargeBtnView addSubview:chargeButton];
    
    [chargeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Margin_Length));
        make.right.equalTo(@(-Margin_Length));
        make.height.equalTo(@(Button_Height));
        make.top.equalTo(chargeBtnView.mas_top).offset(20);
    }];
    
    UITextField *nameTextField = (UITextField *) [self.view viewWithTag:NAMETEXTFIELDTAG];
    UITextField *idTextField = (UITextField *) [self.view viewWithTag:IDTEXTFIELDTAG];
    UITextField *bankTextField = (UITextField *) [self.view viewWithTag:BANKIDTEXTFIELDTAG];
    NSString *bankStr = [Utility bankNumToNormalNum:bankTextField.text];
    
    if (dustedMoneyTextField.text.length > 0 && nameTextField.text.length > 0 && idTextField.text.length > 0 && bankStr.length > 0) {
        chargeButton.isColorEnabled = YES;
    } else {
        chargeButton.isColorEnabled = NO;
    }
    
    UIImageView *info_iconView = [[UIImageView alloc] initWithFrame:CGRectZero];
    info_iconView.image = [UIImage imageNamed:@"icon_info_bule"];
    [mainScroll addSubview:info_iconView];
    
    [info_iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(mainScroll.mas_left).offset(Margin_Length);
        make.top.equalTo(chargeButton.mas_bottom).offset(Margin_Length);
    }];
    
    UIButton *bankLimitBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [bankLimitBtn setTitle:@"支持银行及限额" forState:UIControlStateNormal];
    [bankLimitBtn setTitleColor:COLOR_MAIN forState:UIControlStateNormal];
    bankLimitBtn.titleLabel.font = TEXT_FONT_12;
    [bankLimitBtn addTarget:self action:@selector(clickBankLimitBtn) forControlEvents:UIControlEventTouchUpInside];
    [mainScroll addSubview:bankLimitBtn];
    
    [bankLimitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(info_iconView.mas_right).offset(6);
        make.centerY.equalTo(info_iconView.mas_centerY);
        make.bottom.equalTo(mainScroll.mas_bottom).offset(-Margin_Length);
    }];
}

- (void)clickBankLimitBtn {
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", [RequestURL getNodeJsH5URL:App_Bank_Limit_URL withIsSign:NO], App_Bank_Tab_Nav3_URL];
    NSString *titleStr = XYBString(@"str_bank_limit", @"充值提现说明");
    WebviewViewController *webView = [[WebviewViewController alloc] initWithTitle:titleStr webUrlString:urlStr];
    [self.navigationController pushViewController:webView animated:YES];
}

- (void)dustedMoneyTextFieldChange {
    if ([dustedMoneyTextField.text isEqualToString:@"\n"]) {
        //禁止输入换行
        [dustedMoneyTextField resignFirstResponder];
        return;
    }
    
    if (dustedMoneyTextField.text.length > 7) {
        dustedMoneyTextField.text = [dustedMoneyTextField.text substringToIndex:7];
    }
    
    UITextField *nameTextField = (UITextField *) [self.view viewWithTag:NAMETEXTFIELDTAG];
    UITextField *idTextField = (UITextField *) [self.view viewWithTag:IDTEXTFIELDTAG];
    UITextField *bankTextField = (UITextField *) [self.view viewWithTag:BANKIDTEXTFIELDTAG];
    
    if (dustedMoneyTextField.text.length > 0 && nameTextField.text.length > 0 && idTextField.text.length > 0 && bankTextField.text.length > 0) {
        chargeButton.isColorEnabled = YES;
    } else {
        chargeButton.isColorEnabled = NO;
    }
}

/*
 * @breaf face++身份证识别：初始化
 */
- (void)initFaceIDCardService {
    //    self.versionView.text = [MGIDCardManager IDCardVersion];
    
    [MGLicenseManager licenseForNetWokrFinish:^(bool License) {
        if (License) {
            NSLog(@"授权成功");
        }else{
            NSLog(@"授权失败");
        }
    }];
}

/*!
 *  @author JiangJJ, 16-12-19 15:12:34
 *
 *  身份证
 *
 *  @param sender
 */
- (void)clickUserNameCameraBtn:(id)sender {
    
    NSString *mediaType = AVMediaTypeVideo;
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    if (authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"请在iPhone的 设置-隐私-相机 选项中,允许信用宝访问你的相机" delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    __unsafe_unretained LLChargeViewController *weakSelf = self;
    BOOL idcard = [MGIDCardManager getLicense];
    
    if (!idcard) {
        [[[UIAlertView alloc] initWithTitle:@"提示" message:@"SDK授权失败，请检查" delegate:self cancelButtonTitle:@"完成" otherButtonTitles:nil, nil] show];
        return;
    }
    
    MGIDCardManager *cardManager = [[MGIDCardManager alloc] init];
    
    [cardManager IDCardStartDetection:self IdCardSide:IDCARD_SIDE_FRONT
                               finish:^(MGIDCardModel *model) {
                                   //                                   weakSelf.cardView.image = [model croppedImageOfIDCard];
                                   NSMutableDictionary *paramsDic = [[NSMutableDictionary alloc] init];
                                   [paramsDic setObject:[Constant sharedConstant].isEnvDevMode == YES ? FaceIdEnvAppKEY:FaceIdProAppKEY forKey:@"api_key"];
                                   [paramsDic setObject:[Constant sharedConstant].isEnvDevMode == YES ? FaceIdEnvAppSecret:FaceIdProAppSecret forKey:@"api_secret"];
                                   //                                           [paramsDic setObject:@"format" forKey:@"legality"];//legality 返回身份证照片合法性检查结果，值只取“0”或“1”。“1”：返回； “0”：不返回。默认“0”。
                                   [weakSelf ocrIdCardRequestWebServiceWithParam:paramsDic andImage:[model croppedImageOfIDCard]];
                               }
                                 errr:^(MGIDCardError) {
                                     //                                     weakSelf.cardView.image = nil;
                                 }];
    
}

/*!
 *  @author JiangJJ, 16-12-19 15:12:27
 *
 *  银行卡点击
 */
- (void)clickNumCameraBtn:(id)sender {
    
    NSString *mediaType = AVMediaTypeVideo;
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    if (authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"请在iPhone的 设置-隐私-相机 选项中,允许信用宝访问你的相机" delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    UITextField *bankTextField = (UITextField *) [self.view viewWithTag:BANKIDTEXTFIELDTAG];
    [[BankCardSdkUtil shareInstance] initBankCardSdkUtilWithParams:^(NSString *bankCard) {
        bankTextField.text =  [Utility firendlyCardString:bankCard];;
        [self dustedMoneyTextFieldChange];
    } controller:self];
}

- (void)bankNumTextFieldChange {
}

- (void)clickTheNextButton:(id)sender {
    
    [dustedMoneyTextField resignFirstResponder];
    
    if (![ChargeValidate checkTheChargeDustedMoneyStr:dustedMoneyTextField.text]) {
        return;
    }
    
    UITextField *nameTextField = (UITextField *) [self.view viewWithTag:NAMETEXTFIELDTAG];
    UITextField *idTextField = (UITextField *) [self.view viewWithTag:IDTEXTFIELDTAG];
    UITextField *bankTextField = (UITextField *) [self.view viewWithTag:BANKIDTEXTFIELDTAG];
    for (UITextField *tx in self.view.subviews) {
        [tx resignFirstResponder];
    }
    BOOL success = [ChargeValidate checkTheChargebankTypeNumber:bankTypeNumber bankNumStr:bankTextField.text phone:nil nameStr:nameTextField.text idStr:idTextField.text];
    if (success) {
        NSString *bankStr = [Utility bankNumToNormalNum:bankTextField.text];
        
        contentDic = @{
                       @"userId" : [UserDefaultsUtil getUser].userId,
                       @"money_order" : dustedMoneyTextField.text,
                       @"card_no" : bankStr,
                       @"bankType" : bankTypeNumber > 0 ? [NSNumber numberWithInt:bankTypeNumber] : @"",
                       @"app_request" : @"2",
                       @"id_no" : idTextField.text,
                       @"acct_name" : nameTextField.text
                       };
        [self requestLLRechargeWebServiceWithParam:contentDic];
    }
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
    
    if (newString.length >= 26) {
        return NO;
    }
    
    [textField setText:newString];
    
    UITextField *nameTextField = (UITextField *) [self.view viewWithTag:NAMETEXTFIELDTAG];
    UITextField *idTextField = (UITextField *) [self.view viewWithTag:IDTEXTFIELDTAG];
    UITextField *bankTextField = (UITextField *) [self.view viewWithTag:BANKIDTEXTFIELDTAG];
    
    if (dustedMoneyTextField.text.length > 0 && nameTextField.text.length > 0 && idTextField.text.length > 0 && bankTextField.text.length > 0) {
        chargeButton.isColorEnabled = YES;
    } else {
        chargeButton.isColorEnabled = NO;
    }
    
    NSString *numStr = [newString stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (numStr.length == 6) {
        numStr = [numStr substringToIndex:6];
        [self requestBankPrefixWebServiceWithParam:@{
                                                     @"accountNumber" : numStr
                                                     }];
    }
    if (numStr.length < 6) {
        UILabel *bankName = [self.view viewWithTag:BANKNAMETAG];
        UILabel *singleDealAmount = [self.view viewWithTag:SINGLE_DEAL_AMOUNT_TAG];
        bankName.text = @" ";
        singleDealAmount.text = @" ";
        [bankName mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(infoView.mas_bottom).offset(0);
            make.height.equalTo(@(0));
        }];
        
        [singleDealAmount mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(0));
        }];
    }
    return NO;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    if (textField.text.length != 0) {
        chargeButton.isColorEnabled = NO;
        UILabel *bankName = [self.view viewWithTag:BANKNAMETAG];
        UILabel *singleDealAmount = [self.view viewWithTag:SINGLE_DEAL_AMOUNT_TAG];
        bankName.text = nil;
        singleDealAmount.text = nil;
        [bankName mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(infoView.mas_bottom).offset(0);
            make.height.equalTo(@(0));
        }];
        
        [singleDealAmount mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(0));
        }];
        
        return YES;
    }
    return YES;
}

#pragma mark - 根据银行卡前6位查询银行类型

- (void)requestBankPrefixWebServiceWithParam:(NSDictionary *)params {
    NSString *requestURL = [RequestURL getRequestURL:CheckBankTypeURL param:params];
    [self showDataLoading];
    [WebService postRequest:requestURL param:params JSONModelClass:[BankTypeResponseModel class] Success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [self hideLoading];
        BankTypeResponseModel *responseModel = responseObject;
        bankModel = responseModel;
        if (![StrUtil isEmptyString:responseModel.singleLimit] && ![StrUtil isEmptyString:responseModel.dayLimit] && ![StrUtil isEmptyString:responseModel.monthLimit]) {
            
            UILabel *bankName = [self.view viewWithTag:BANKNAMETAG];
            UILabel *singleDealAmount = [self.view viewWithTag:SINGLE_DEAL_AMOUNT_TAG];
            
            bankName.text = responseModel.bankName;
            [bankName mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(infoView.mas_bottom).offset(Margin_Length);
                make.height.equalTo(@(12));
            }];
            
            bankTypeNumber = [responseModel.bankType intValue];
            singleDealAmount.text = [NSString stringWithFormat:@"单笔:%@ | 日:%@ | 月:%@", responseModel.singleLimit, responseModel.dayLimit, responseModel.monthLimit];
            [singleDealAmount mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@(12));
            }];
        }
    }
                       fail:^(AFHTTPRequestOperation *operation, NSString *errorMessage) {
                           [self hideLoading];
                           [self showPromptTip:errorMessage];
                       }];
}

#pragma mark - 连连首充接口

- (void)requestLLRechargeWebServiceWithParam:(NSDictionary *)params {
    NSString *requestURL = [RequestURL getRequestURL:RechargeURL param:params];
    [self showTradeLoadingOnAlertView];
    [WebService postRequest:requestURL param:params JSONModelClass:[LLFirstChargeResponseModel class] Success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [self hideLoading];
        LLFirstChargeResponseModel *responseModel = responseObject;
        if (responseModel.supportCard == NO) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"暂不支持该行银行卡" delegate:self cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
            [alertView show];
            return;
        }
        if (responseModel.resultData != nil) {
            payDic = [NSDictionary dictionaryWithDictionary:[responseModel.resultData toDictionary]];
        }
        
        [LLPaySdk sharedSdk].sdkDelegate = self;
        //接入什么产品就传什么LLPayType
        [[LLPaySdk sharedSdk] presentLLPaySDKInViewController:self
                                                  withPayType:LLPayTypeVerify
                                                andTraderInfo:payDic];
        
    }
                       fail:^(AFHTTPRequestOperation *operation, NSString *errorMessage) {
                           [self hideLoading];
                           [self showPromptTip:errorMessage];
                       }];
}

#pragma mark 连连充值成功后将支付信息发送给后台的接口(新接口)

- (void)requestLLChargeReturnWebServiceWithParam:(NSDictionary *)param {
    NSString *requstURL = [RequestURL getRequestURL:LLChargeReturnURL param:param];
    [WebService postRequest:requstURL param:param JSONModelClass:[LLChargeCallBackResponseModel class] Success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        LLChargeCallBackResponseModel *responseModel = responseObject;
        //resultCode, 1:充值成功 0：获取数据失败 -1：充值失败上传
        if (responseModel.resultCode == 1) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"realNameVerifyNotificaton" object:nil];
            if ([responseModel.firstSleepReward doubleValue] > 0) {
                ChargeResultStatusViewController *chargeResultStatusVC = [[ChargeResultStatusViewController alloc] init];
                chargeResultStatusVC.firstSleepReward = [responseModel.firstSleepReward doubleValue];
                [self.navigationController pushViewController:chargeResultStatusVC animated:YES];
                
            } else {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"chargeSuccessNotification" object:nil];
                if (self.fromType ==  FromTypeTheHome) {//新手任务
                    [self.navigationController popToRootViewControllerAnimated:YES];
                } else {
                    if (_identifer == YES) {
                        NSArray *arr = self.navigationController.viewControllers;
                        [self.navigationController popToViewController:[arr objectAtIndex:arr.count - 4] animated:YES];
                    }else{
                        NSArray *arr = self.navigationController.viewControllers;
                        [self.navigationController popToViewController:[arr objectAtIndex:arr.count - 3] animated:YES];
                    }
                }
            }
        }
    }
                       fail:^(AFHTTPRequestOperation *operation, NSString *errorMessage) {
                           [self showPromptTip:errorMessage];
                       }];
}

#pragma - mark 支付结果 LLPaySdkDelegate
// 订单支付结果返回，主要是异常和成功的不同状态
- (void)paymentEnd:(LLPayResult)resultCode withResultDic:(NSDictionary *)dic {
    
    NSString *msg = XYBString(@"string_pay_error", @"支付异常");
    switch (resultCode) {
        case kLLPayResultSuccess: {
            msg = XYBString(@"string_pay_success", @"支付成功");
            
            NSString *result_pay = dic[@"result_pay"];
            if ([result_pay isEqualToString:@"SUCCESS"]) {
                User *user = [UserDefaultsUtil getUser];
                if (![user.isIdentityAuth boolValue]) {
                    user.isIdentityAuth = @"1";
                }
                [UserDefaultsUtil setUser:user];
                //成功时不需要返回错误码ret_code和错误描述ret_msg，其余情况需要
                NSDictionary *codntentDic = @{
                                              @"dt_order" : [dic objectForKey:@"dt_order"],
                                              @"money_order" : [dic objectForKey:@"money_order"],
                                              @"no_order" : [dic objectForKey:@"no_order"],
                                              @"oid_partner" : [dic objectForKey:@"oid_partner"],
                                              @"oid_paybill" : [dic objectForKey:@"oid_paybill"],
                                              @"result_pay" : [dic objectForKey:@"result_pay"],
                                              @"settle_date" : [dic objectForKey:@"settle_date"],
                                              @"sign" : [dic objectForKey:@"sign"],
                                              @"sign_type" : [dic objectForKey:@"sign_type"],
                                              @"userId" : [UserDefaultsUtil getUser].userId,
                                              @"card_no" : [contentDic objectForKey:@"card_no"],
                                              @"bankType" : bankTypeNumber > 0 ? [contentDic objectForKey:@"bankType"] : @""
                                              };
                //充值成功后，将支付结果数据传输给后台
                [self requestLLChargeReturnWebServiceWithParam:codntentDic];
                return;
                
            } else if ([result_pay isEqualToString:@"PROCESSING"]) {
                msg = XYBString(@"string_charege_dealing", @"支付单处理中");
                [self alertShow:msg];
                
            } else if ([result_pay isEqualToString:@"FAILURE"]) {
                msg = XYBString(@"string_charege_fail", @"支付单失败");
                [self alertShow:msg];
                
            } else if ([result_pay isEqualToString:@"REFUND"]) {
                msg = XYBString(@"string_charge_back", @"支付单已退款");
                [self alertShow:msg];
            }
        }
            break;
            
        case kLLPayResultFail: {
            msg = XYBString(@"string_charge_failure", @"支付失败");
            
            if (![StrUtil isEmptyString:bankModel.dayLimit] && ![StrUtil isEmptyString:bankModel.monthLimit] && ![StrUtil isEmptyString:bankModel.singleLimit]) {
                NSString *bankName = [NSString stringWithFormat:@"%@", bankModel.bankName];
                NSString *singleLimStr = [NSString stringWithFormat:@"%@", bankModel.singleLimit];
                NSString *dayLimStr = [NSString stringWithFormat:@"%@", bankModel.dayLimit];
                NSString *monthLimStr = [NSString stringWithFormat:@"%@", bankModel.monthLimit];
                ChargeFailureViewController *failureVC = [[ChargeFailureViewController alloc] initWithObject:@[bankName,singleLimStr,dayLimStr,monthLimStr]];
                [self.navigationController pushViewController:failureVC animated:YES];
            }
            [self alertShow:msg];
        }
            break;
            
        case kLLPayResultCancel: {
            msg = XYBString(@"string_charge_cancel", @"支付取消");
            [self alertShow:msg];
        }
            break;
            
        case kLLPayResultInitError: {
            msg = XYBString(@"string_sdk_init_failure", @"sdk初始化异常");
            [self alertShow:msg];
        }
            break;
            
        case kLLPayResultInitParamError: {
            msg = dic[@"ret_msg"];
            [self alertShow:msg];
        }
            break;
            
        default:
            break;
    }
    
    msg = [NSString stringWithFormat:@"LL:%@", msg];
    if (![msg isEqualToString:XYBString(@"string_pay_LLsuccess", @"LL:支付成功")]) {
        [self postResultDicToBackGround:dic Message:msg];
    }
}

- (void)alertShow:(NSString *)message {
    [[[UIAlertView alloc] initWithTitle:XYBString(@"stirng_result", @"结果")
                                message:message
                               delegate:nil
                      cancelButtonTitle:XYBString(@"string_ok", @"确定")
                      otherButtonTitles:nil] show];
}

/*****************************ORC识别接口**********************************/
- (void)ocrIdCardRequestWebServiceWithParam:(NSDictionary *)paramsDic andImage:(UIImage *)img {
    UITextField *nameTextField = (UITextField *) [self.view viewWithTag:NAMETEXTFIELDTAG];
    UITextField *idTextField = (UITextField *) [self.view viewWithTag:IDTEXTFIELDTAG];
    [self showDataLoading];
    [WebService postThirdPartyRequest:FaceI_URL param:paramsDic uploadImage:img
     
                              Success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                  [self hideLoading];
                                  //识别结果
                                  nameTextField.text = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"name"]];
                                  idTextField.text =[NSString stringWithFormat:@"%@",[responseObject objectForKey:@"id_card_number"]];
                                  [self dustedMoneyTextFieldChange];
                              }
                                 fail:^(AFHTTPRequestOperation *operation, NSString *errorMessage) {
                                     
                                     [self hideLoading];
                                     [self showPromptTip:errorMessage];
                                     
                                 }
     
     ];
}

/**
 *  @author xyb, 16-11-21 18:11:56
 *
 *  @brief 支付没有成功时，上传订单信息
 *
 *  @param dic 返回字典
 *  @param msg 支付失败描述
 */
- (void)postResultDicToBackGround:(NSDictionary *)dic Message:(NSString *)msg {
    //将连连支付的错误码ret_code和错误描述ret_msg传给后台，BI做统计用
    NSDictionary *resultDic = @{
                                @"dt_order" : [payDic objectForKey:@"dt_order"],
                                @"money_order" : [payDic objectForKey:@"money_order"],
                                @"no_order" : [payDic objectForKey:@"no_order"],
                                @"oid_partner" : [payDic objectForKey:@"oid_partner"],
                                @"oid_paybill" : [dic objectForKey:@"oid_paybill"] != nil ? [dic objectForKey:@"oid_paybill"] : @"",
                                @"result_pay" : [dic objectForKey:@"result_pay"] != nil ? [dic objectForKey:@"result_pay"] : @"",
                                @"settle_date" : [dic objectForKey:@"settle_date"] != nil ? [dic objectForKey:@"settle_date"] : @"",
                                @"sign" : [dic objectForKey:@"sign"] ? [dic objectForKey:@"sign"]:@"",
                                @"sign_type" : [dic objectForKey:@"sign_type"] ? [dic objectForKey:@"sign_type"]:@"",
                                @"ret_code" : [dic objectForKey:@"ret_code"] ? [dic objectForKey:@"ret_code"] : @"",
                                @"errorDesc" : msg,
                                @"userId" : [UserDefaultsUtil getUser].userId,
                                @"card_no" : [payDic objectForKey:@"card_no"],
                                @"bankType" :  [payDic objectForKey:@"bankType"] != nil ? [payDic objectForKey:@"bankType"] : @""
                                };
    //充值成功后，将支付结果数据传输给后台
    [self requestLLChargeReturnWebServiceWithParam:resultDic];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

/**
 *  页面底部的提示
 */
- (void)creatTheRemindView {
    RTLabel *remindLab = [[RTLabel alloc] init];
    remindLab.font = TEXT_FONT_12;
    remindLab.delegate = self;
    NSString *remindStr = @"[非大陆用户]联系客服 <font color='#0ab0ef' ><u color=clear><a href='400-070-7663'>400-070-7663</a></u></font>完成认证";
    remindLab.text = remindStr;
    remindLab.textColor = COLOR_AUXILIARY_GREY;
    [self.view addSubview:remindLab];
    
    [remindLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(18));
        make.width.equalTo(@(MainScreenWidth));
        make.left.equalTo(self.view.mas_left).offset(Margin_Length);
        make.right.equalTo(self.view.mas_right).offset(-Margin_Length);
        if (IS_IPHONE_4_OR_LESS) {
            make.bottom.equalTo(self.view.mas_bottom).offset(-6.5);
        } else {
            make.bottom.equalTo(self.view.mas_bottom).offset(-12.5);
        }
    }];
}

- (void)rtLabel:(id)rtLabel didSelectLinkWithURL:(NSURL *)url {
    
    UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:XYBString(@"string_xyb_tellphone", @"拨打电话: 400-070-7663")
                                                        message:XYBString(@"string_xyb_tel", @"(服务时间)\n 工作日9:00-22:00 \n 节假日9:00-18:00")
                                                       delegate:self
                                              cancelButtonTitle:XYBString(@"string_cancel", @"取消")
                                              otherButtonTitles:XYBString(@"string_ok", @"拨打"), nil];
    alertview.tag = VIEW_TAG_LOAN_ALEERT_PHONE;
    [alertview show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (alertView.tag == VIEW_TAG_LOAN_ALEERT_PHONE) {
        if (buttonIndex == 1) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://400-070-7663"]];
        }
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
