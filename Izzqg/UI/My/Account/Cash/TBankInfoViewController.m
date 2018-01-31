//
//  TBankInfoViewController.m
//  Ixyb
//
//  Created by wang on 15/11/20.
//  Copyright © 2015年 xyb. All rights reserved.
//

#import <AVFoundation/AVCaptureDevice.h>
#import <AVFoundation/AVMediaFormat.h>
#import "TBankInfoViewController.h"
#import "Utility.h"
#import "WebService.h"

#import "BankCardSdkUtil.h"

#import "BankBranchModel.h"
#import "BankBranchViewController.h"
#import "BankInfoModel.h"
#import "ChangePayPasswordViewController.h"
#import "CityModel.h"
#import "ProvinceModel.h"
#import "ProvinceViewController.h"
#import "CCPClipCaremaImage.h"

#define NEXTBTNTAG 2002

@interface TBankInfoViewController () {
    UIView *unSaveView;

    AreasModel *provinceModel;
    CityModel *cityModel;
    BranchsModel *branchModel;
    payLimitsModel *bankInfo;
    NSString *dustedMoneyStr;
    CCPClipCaremaImage *viewCaremal;
}
@end

@implementation TBankInfoViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = COLOR_COMMON_CLEAR;
    [self creatTheNoBankSaveView];
    [self creatTheNextButtonView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadCityData:) name:@"reloadCityData" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadBankBranchData:) name:@"reloadBankBranchData" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloaddustedMoneyTextField:) name:@"dustedMoneyTextField" object:nil];
}

- (void)creatTheNoBankSaveView {

    unSaveView = [[UIView alloc] init];
    [self.view addSubview:unSaveView];

    [unSaveView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(-1));
        make.right.equalTo(@(1));
        make.top.equalTo(@1);
        //        make.height.equalTo(@260);
    }];

    UIView *saveBankView = [[UIView alloc] init];
    saveBankView.backgroundColor = COLOR_COMMON_WHITE;
    [unSaveView addSubview:saveBankView];

    saveBankView.layer.masksToBounds = YES;
    saveBankView.layer.borderWidth = Border_Width;
    saveBankView.layer.borderColor = COLOR_LINE.CGColor;

    [saveBankView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(-1));
        make.right.equalTo(@(1));
        make.top.equalTo(@2);
    }];

    UILabel *bankNumLab = [[UILabel alloc] init];
    bankNumLab.font = TEXT_FONT_16;
    bankNumLab.textColor = COLOR_MAIN_GREY;
    bankNumLab.text = XYBString(@"str_bank_name", @"银行卡号");
    [saveBankView addSubview:bankNumLab];
    
    CGSize  nameWidth = [ToolUtil getLabelSizeWithLabelStr:bankNumLab.text andLabelFont:TEXT_FONT_16];
    [bankNumLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Margin_Length));
        make.width.equalTo(@(nameWidth.width + 1));
        make.top.equalTo(@(Margin_Length));
    }];
    
    UIButton *butNumCamera = [UIButton buttonWithType:UIButtonTypeCustom];
    [butNumCamera setImage:[UIImage imageNamed:@"camera_load"] forState:UIControlStateNormal];
    [butNumCamera setImage:[UIImage imageNamed:@"camera_select"] forState:UIControlStateSelected];
    [butNumCamera addTarget:self action:@selector(clickNumCameraBtn:) forControlEvents:UIControlEventTouchUpInside];
    [saveBankView addSubview:butNumCamera];
    [butNumCamera mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(saveBankView.mas_right).offset(-Margin_Right);
        make.centerY.equalTo(bankNumLab.mas_centerY);
    }];

    UITextField *bankNumTextField = [[UITextField alloc] init];
    bankNumTextField.font = TEXT_FONT_16;
    bankNumTextField.placeholder = XYBString(@"str_enter_bankcardnum", @"仅支持大陆借记卡");
    bankNumTextField.textColor = COLOR_MAIN_GREY;
    bankNumTextField.delegate = self;
    bankNumTextField.tag = 1005;
    bankNumTextField.keyboardType = UIKeyboardTypeNumberPad;
    bankNumTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkTextFieldChange) name:UITextFieldTextDidChangeNotification object:bankNumTextField];
    [saveBankView addSubview:bankNumTextField];

    [bankNumTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        if (IS_IPHONE_5_OR_LESS) {
              make.left.equalTo(bankNumLab.mas_right).offset(10);
        }else
        {
            make.left.equalTo(bankNumLab.mas_right).offset(40);
        }
        make.centerY.equalTo(bankNumLab.mas_centerY);
         make.right.equalTo(butNumCamera.mas_right).offset(-20);
    }];


    
    if ([UserDefaultsUtil getUser].accountNumber) {
        bankNumTextField.text = [Utility firendlyCardString:[UserDefaultsUtil getUser].accountNumber];
    }

    UIImageView *saveBankVerlineImage2 = [[UIImageView alloc] init];
    saveBankVerlineImage2.image = [UIImage imageNamed:@"onePoint"];
    [saveBankView addSubview:saveBankVerlineImage2];

    [saveBankVerlineImage2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Margin_Length));
        make.right.equalTo(@0);
        make.top.equalTo(@45);
        make.height.equalTo(@1);
    }];

    UILabel *phoneBankLab = [[UILabel alloc] init];
    phoneBankLab.font = TEXT_FONT_16;
    phoneBankLab.textColor = COLOR_MAIN_GREY;
    phoneBankLab.text = XYBString(@"str_phone", @"手机号");
    [saveBankView addSubview:phoneBankLab];

    [phoneBankLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Margin_Length));
        make.width.equalTo(bankNumLab.mas_width);
        make.top.equalTo(saveBankVerlineImage2.mas_bottom).offset(Text_Margin_Length);
        make.bottom.equalTo(saveBankView.mas_bottom).offset(-Margin_Length);
    }];

    UITextField *phoneBankTextField = [[UITextField alloc] init];
    phoneBankTextField.font = TEXT_FONT_16;
    phoneBankTextField.placeholder = XYBString(@"str_bank_phone_no", @"银行预留手机号");
    phoneBankTextField.textColor = COLOR_MAIN_GREY;
    phoneBankTextField.tag = 1006;
    phoneBankTextField.keyboardType = UIKeyboardTypeNumberPad;
    phoneBankTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkTextFieldChange) name:UITextFieldTextDidChangeNotification object:phoneBankTextField];
    [saveBankView addSubview:phoneBankTextField];

    [phoneBankTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        if (IS_IPHONE_5_OR_LESS) {
            make.left.equalTo(phoneBankLab.mas_right).offset(10);
        }else
        {
            make.left.equalTo(phoneBankLab.mas_right).offset(40);
        }
        make.centerY.equalTo(phoneBankLab.mas_centerY);
        make.width.equalTo(@(MainScreenWidth - 125));
    }];

    UIImageView *viewImageView = [[UIImageView alloc] init];
    viewImageView.image = [UIImage imageNamed:@"icon_info_gray"];
    [unSaveView addSubview:viewImageView];
    [viewImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(saveBankView.mas_bottom).offset(Text_Margin_Length);
        make.left.equalTo(@(Margin_Length));
        make.width.height.equalTo(@(13));
    }];

    UILabel *note1Lab = [[UILabel alloc] init];
    note1Lab.font = TEXT_FONT_12;
    note1Lab.textColor = COLOR_AUXILIARY_GREY;
    note1Lab.numberOfLines = 0;
    note1Lab.text = XYBString(@"str_make_sure_yourself_card", @"请绑定持卡人本人的银行卡，信用宝在您提现成功后完成银行卡绑定。");
    [unSaveView addSubview:note1Lab];

    [note1Lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(viewImageView.mas_right).offset(2);
        make.top.equalTo(viewImageView.mas_top);
        make.right.equalTo(self.view.mas_right).offset(-Margin_Right);
        make.bottom.equalTo(unSaveView.mas_bottom).offset(-6);
    }];
}

- (void)checkTextFieldChange {
    if (self.delegate && [self.delegate respondsToSelector:@selector(checkDustedMoneyTextFieldChange)]) {
        [self.delegate checkDustedMoneyTextFieldChange];
    }
    [self checkTheData];
}

- (void)creatTheNextButtonView {

    ColorButton *nextButton = [[ColorButton alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth - 30, Button_Height) Title:XYBString(@"str_ok", @"确定") ByGradientType:leftToRight];
    nextButton.isColorEnabled = NO;
    nextButton.tag = NEXTBTNTAG;
    [nextButton addTarget:self action:@selector(clickTheNextButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextButton];

    [nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Margin_Length));
        make.right.equalTo(@(-Margin_Length));
        make.top.equalTo(unSaveView.mas_bottom).offset(Button_Margin_Length);
        make.height.equalTo(@(Button_Height));
    }];
    
    UILabel *tipLab = [[UILabel alloc] init];
    tipLab.font = TEXT_FONT_12;
    tipLab.textColor = COLOR_MAIN_GREY;
    tipLab.text = XYBString(@"str_cash_tip", @"温馨提示：若申请提现T+1个工作日后仍未到账，可能是银行卡信息异常，请及时联系客服400-070-7663。");
    tipLab.numberOfLines = 2;
    [self.view addSubview:tipLab];
    
    NSMutableParagraphStyle *mutableParagraphStyle = [[NSMutableParagraphStyle alloc] init];
    mutableParagraphStyle.lineSpacing = 5;
    mutableParagraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
    NSMutableAttributedString *mutableAttributedString = [[NSMutableAttributedString alloc]
                                                          initWithString:XYBString(@"str_cash_tip", @"温馨提示：若申请提现T+1个工作日后仍未到账，可能是银行卡信息异常，请及时联系客服400-070-7663。")
                                                          attributes : @{NSForegroundColorAttributeName : COLOR_AUXILIARY_GREY,
                                                                         NSFontAttributeName  : TEXT_FONT_12,
                                                                         NSParagraphStyleAttributeName:mutableParagraphStyle
                                                                         }];
    tipLab.attributedText = mutableAttributedString;
    
    
    [tipLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nextButton.mas_bottom).offset(Margin_Length);
        make.left.equalTo(@(Margin_Length));
        make.right.equalTo(@(-Margin_Length));
    }];
}


- (void)reloadCityData:(NSNotification *)note {

    NSDictionary *dic = note.object;
    provinceModel = [dic objectForKey:@"province"];
    cityModel = [dic objectForKey:@"city"];
    UILabel *areaLab = (UILabel *) [self.view viewWithTag:1002];
    areaLab.textAlignment = NSTextAlignmentLeft;
    NSString *areaStr = [NSString stringWithFormat:@"%@  %@", provinceModel.name, cityModel.name];
    areaLab.text = areaStr;
    UILabel *branchLab = (UILabel *) [self.view viewWithTag:1003];
    branchLab.text = @"";
    branchModel = nil;
    [self checkTheData];
}

- (void)reloadBankBranchData:(NSNotification *)note {
    NSDictionary *dic = note.object;
    branchModel = [dic objectForKey:@"bankBranch"];
    UILabel *branchLab = (UILabel *) [self.view viewWithTag:1003];
    branchLab.textAlignment = NSTextAlignmentLeft;
    branchLab.text = branchModel.brabank_name;
    [self checkTheData];
}

- (void)reloaddustedMoneyTextField:(NSNotification *)note {
    dustedMoneyStr = note.object;
    [self checkTheData];
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
    [self checkTheData];
    if (newString.length >= 26) {
        return NO;
    }

    [textField setText:newString];

    return NO;
}

- (void)checkTheData {

    ColorButton *btn = (ColorButton *) [self.view viewWithTag:NEXTBTNTAG];
    UITextField *bankNumberField = (UITextField *) [self.view viewWithTag:1005];
    UITextField *phoneTextField = (UITextField *) [self.view viewWithTag:1006];
    if (dustedMoneyStr.length != 0 && bankNumberField.text.length != 0 && phoneTextField.text.length != 0) {
        btn.isColorEnabled = YES;
    } else {
        btn.isColorEnabled = NO;
    }
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
    
        UITextField *bankTextField = (UITextField *) [self.view viewWithTag:1005];
        [[BankCardSdkUtil shareInstance] initBankCardSdkUtilWithParams:^(NSString *bankCard) {
                bankTextField.text =  [Utility firendlyCardString:bankCard];;
        } controller:self];
}


//// 银行卡号转正常号 － 去除4位间的空格
//-(NSString *)bankNumToNormalNum:(NSString *)bankStr
//{
//    return [bankStr stringByReplacingOccurrencesOfString:@" " withString:@""];
//}

- (void)clickTheNextButton:(id)sender {
    ColorButton *btn = (ColorButton *) [self.view viewWithTag:NEXTBTNTAG];
    btn.userInteractionEnabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        btn.userInteractionEnabled = YES;
    });
    if (dustedMoneyStr.length == 0) {
        [HUD showPromptViewWithToShowStr:XYBString(@"str_enter_rightAmount", @"请输入正确的提现金额") autoHide:YES afterDelay:1.0 userInteractionEnabled:YES];
        return;
    }
    if (![Utility isValidateNumber:dustedMoneyStr]) {
        [HUD showPromptViewWithToShowStr:XYBString(@"str_error_amount", @"提现金额填写错误") autoHide:YES afterDelay:1.0 userInteractionEnabled:YES];
        return;
    }
    double dustedMoney = [dustedMoneyStr doubleValue];
    double balanceMoneyNum = [[UserDefaultsUtil getUser].usableAmount doubleValue];
    if (dustedMoney > balanceMoneyNum) {
        [HUD showPromptViewWithToShowStr:XYBString(@"str_lessthan_amount", @"提现金额超限") autoHide:YES afterDelay:1.0 userInteractionEnabled:YES];
        return;
    }

    if (dustedMoney < 100) {

        [HUD showPromptViewWithToShowStr:XYBString(@"str_notlessthan_100", @"提现金额不能低于100元") autoHide:YES afterDelay:1.0 userInteractionEnabled:YES];
        return;
    }
    [self checkTextFieldChange];

    UITextField *bankNumberField = (UITextField *) [self.view viewWithTag:1005];
    UITextField *phoneTextField = (UITextField *) [self.view viewWithTag:1006];
    [bankNumberField resignFirstResponder];
    [phoneTextField resignFirstResponder];

    if (bankNumberField.text.length == 0) {
        [HUD showPromptViewWithToShowStr:XYBString(@"str_please_input_card_no", @"请输入银行卡号") autoHide:YES afterDelay:1.0 userInteractionEnabled:YES];
        return;
    }
    NSString *bankStr = [Utility bankNumToNormalNum:bankNumberField.text];

    if (![Utility validateBankCardNumber:bankStr]) {
        [HUD showPromptViewWithToShowStr:XYBString(@"str_card_not_correct", @"银行卡号不正确") autoHide:YES afterDelay:1.0 userInteractionEnabled:YES];
        return;
    }
    if (phoneTextField.text.length == 0) {
        [HUD showPromptViewWithToShowStr:XYBString(@"str_please_input_bank_phone_number", @"请输入银行预留手机号") autoHide:YES afterDelay:1.0 userInteractionEnabled:YES];
        return;
    }

    if (![Utility isValidateMobile:phoneTextField.text]) {

        [HUD showPromptViewWithToShowStr:XYBString(@"str_input_correct_phone_number", @"请输入正确的手机号") autoHide:YES afterDelay:1.0 userInteractionEnabled:YES];
        return;
    }

    NSDictionary *dic = @{
        @"accountNumber" : bankStr,
        @"mobilePhone" : phoneTextField.text,
    };
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickTheBtnForAddBank:)]) {
        [self.delegate clickTheBtnForAddBank:dic];
        return;
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
