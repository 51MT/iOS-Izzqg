//
//  TBranchViewController.m
//  Ixyb
//
//  Created by wang on 15/11/20.
//  Copyright © 2015年 xyb. All rights reserved.
//

#import "TBranchViewController.h"

#import "Utility.h"

#import "BankBranchModel.h"
#import "BankBranchViewController.h"
#import "CityModel.h"
#import "ProvinceModel.h"
#import "ProvinceViewController.h"

#define NEXTBTNTAG 2002
@interface TBranchViewController () {
    UIView *branchView;

    AreasModel *provinceModel;
    CityModel *cityModel;
    BranchsModel *branchModel;

    int bankTypeNumber;
    NSString *dustedMoneyStr;
}
@end

@implementation TBranchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self creatTheBranchView];
    [self creatTheNextButtonView];
    bankTypeNumber = [[UserDefaultsUtil getUser].bankType intValue];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadCityData:) name:@"reloadCityData" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadBankBranchData:) name:@"reloadBankBranchData" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloaddustedMoneyTextField:) name:@"dustedMoneyTextField" object:nil];
}

- (void)creatTheBranchView {

    branchView = [[UIView alloc] init];
    branchView.backgroundColor = COLOR_COMMON_WHITE;
    [self.view addSubview:branchView];

    branchView.layer.masksToBounds = YES;
    branchView.layer.borderWidth = Border_Width;
    branchView.layer.borderColor = COLOR_LINE.CGColor;

    [branchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(-1));
        make.right.equalTo(@(1));
        make.top.equalTo(@2);
        make.height.equalTo(@45);
    }];

    UILabel *areaLab = [[UILabel alloc] init];
    areaLab.font = TEXT_FONT_16;
    areaLab.textColor = COLOR_MAIN_GREY;
    areaLab.text = XYBString(@"str_area", @"地区");
    [branchView addSubview:areaLab];

    [areaLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Margin_Length));
        make.top.equalTo(@(Text_Margin_Length));
    }];

    UIImageView *arrow1Image = [[UIImageView alloc] init];
    arrow1Image.image = [UIImage imageNamed:@"cell_arrow"];
    [branchView addSubview:arrow1Image];

    [arrow1Image mas_makeConstraints:^(MASConstraintMaker *make) {
        //        make.top.equalTo(@Margin_Length);
        make.centerY.equalTo(areaLab.mas_centerY);
        make.right.equalTo(branchView.mas_right).offset(-Margin_Length);

    }];

    UILabel *areanameLab = [[UILabel alloc] init];
    areanameLab.font = TEXT_FONT_16;
    areanameLab.textColor = COLOR_AUXILIARY_GREY;
    areanameLab.tag = 1002;
    [branchView addSubview:areanameLab];

    [areanameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(arrow1Image.mas_left).offset(-Text_Margin_Middle);
        make.centerY.equalTo(areaLab.mas_centerY);
    }];

    UIButton *selectareaBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [selectareaBtn addTarget:self action:@selector(clickSelectAreaBtn:) forControlEvents:UIControlEventTouchUpInside];
    [branchView addSubview:selectareaBtn];

    [selectareaBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(Button_Height));
        make.top.equalTo(@0);
        make.left.right.equalTo(branchView);
    }];
}

- (void)creatTheNextButtonView {

    ColorButton *nextButton = [[ColorButton alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth - 30.f, Button_Height) Title:XYBString(@"str_ok", @"确定")  ByGradientType:leftToRight];
    nextButton.isColorEnabled = NO;
    nextButton.tag = NEXTBTNTAG;
    [nextButton addTarget:self action:@selector(clickTheNextButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextButton];

    [nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Margin_Length));
        make.right.equalTo(@(-Margin_Length));
        make.top.equalTo(branchView.mas_bottom).offset(Button_Margin_Length);
        make.height.equalTo(@(Button_Height));
    }];
}

- (void)checkTextFieldChange {
    if (self.delegate && [self.delegate respondsToSelector:@selector(checkDustedMoneyTextFieldChange)]) {
        [self.delegate checkDustedMoneyTextFieldChange];
    }
}

- (void)clickSelectAreaBtn:(id)sender {
    [self checkTextFieldChange];
    ProvinceViewController *provinceViewController = [[ProvinceViewController alloc] init];
    provinceViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:provinceViewController animated:YES];
}

- (void)clickSelectBranchBankBtn:(id)sender {
    [self checkTextFieldChange];
    bankTypeNumber = [[UserDefaultsUtil getUser].bankType intValue];
    if (bankTypeNumber < 1) {
        [HUD showPromptViewWithToShowStr:XYBString(@"str_choose_begin_bank", @"请选择开户银行") autoHide:YES afterDelay:1.0 userInteractionEnabled:YES];
        return;
    }

    if (!cityModel.code) {
        [HUD showPromptViewWithToShowStr:XYBString(@"str_choose_area", @"请选择地区") autoHide:YES afterDelay:1.0 userInteractionEnabled:YES];
        return;
    }

    BankBranchViewController *bankBranchViewController = [[BankBranchViewController alloc] init];
    bankBranchViewController.cityCodeStr = cityModel.code;
    bankBranchViewController.bankTypeNumber = [NSString stringWithFormat:@"%d", bankTypeNumber];
    [self.navigationController pushViewController:bankBranchViewController animated:YES];
}

- (void)reloadCityData:(NSNotification *)note {

    NSDictionary *dic = note.object;
    provinceModel = [dic objectForKey:@"province"];
    cityModel = [dic objectForKey:@"city"];
    UILabel *areaLab = (UILabel *) [self.view viewWithTag:1002];
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
    branchLab.text = branchModel.brabank_name;
    [self checkTheData];
}

- (void)reloaddustedMoneyTextField:(NSNotification *)note {
    dustedMoneyStr = note.object;
    [self checkTheData];
}

- (void)checkTheData {

    ColorButton *btn = (ColorButton *) [self.view viewWithTag:NEXTBTNTAG];
    if (dustedMoneyStr.length != 0 && branchModel != nil && cityModel != nil) {
        btn.isColorEnabled = YES;
    } else {
        btn.isColorEnabled = NO;
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

    return NO;
}

// 银行卡号转正常号 － 去除4位间的空格
- (NSString *)bankNumToNormalNum:(NSString *)bankStr {
    return [bankStr stringByReplacingOccurrencesOfString:@" " withString:@""];
}

- (void)clickTheNextButton:(id)sender {
    ColorButton *btn = (ColorButton *) [self.view viewWithTag:NEXTBTNTAG];
    btn.userInteractionEnabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        btn.userInteractionEnabled = YES;
    });
    [self checkTextFieldChange];
    if (dustedMoneyStr.length == 0) {
        [HUD showPromptViewWithToShowStr:XYBString(@"str_enter_rightAmount", @"请输入正确的提现金额") autoHide:YES afterDelay:1.0 userInteractionEnabled:YES];
        return;
    }
    if (![Utility isValidateNumber:dustedMoneyStr]) {
        [HUD showPromptViewWithToShowStr:XYBString(@"str_error_amount", @"提现金额填写错误") autoHide:YES afterDelay:1.0 userInteractionEnabled:YES];
        return;
    }

    double balanceMoneyNum = [[UserDefaultsUtil getUser].usableAmount doubleValue];
    double dustedMoney = [dustedMoneyStr doubleValue];
    if (dustedMoney > balanceMoneyNum) {
        [HUD showPromptViewWithToShowStr:XYBString(@"str_lessthan_amount", @"提现金额超限") autoHide:YES afterDelay:1.0 userInteractionEnabled:YES];
        return;
    }

    if (dustedMoney < 100) {

        [HUD showPromptViewWithToShowStr:XYBString(@"str_notlessthan_100", @"提现金额不能低于100元") autoHide:YES afterDelay:1.0 userInteractionEnabled:YES];
        return;
    }
    //      double uncollectedAmount = [[UserDefaultsUtil getUser].uncollectedAmount doubleValue];

    //    if (uncollectedAmount >= balanceMoneyNum) {
    //        [HUD showPromptViewWithToShowStr:XYBString(@"string_low_amount",@"本次提现金额上限为0元") autoHide:YES afterDelay:1.0 userInteractionEnabled:YES];
    //        return;
    //    }
    //
    //    if (uncollectedAmount < balanceMoneyNum) {
    //        if (dustedMoney > (balanceMoneyNum-uncollectedAmount)) {
    //            NSString *uncollectedStr = [Utility stringrangeStr:[NSString stringWithFormat:@"%.2f",uncollectedAmount]];
    //            NSString *factStr = [Utility stringrangeStr:[NSString stringWithFormat:@"%.2f",balanceMoneyNum-uncollectedAmount]];
    //            [HUD showPromptViewWithToShowStr:[NSString stringWithFormat:@"您尚有%@元借款未还清,本次提现金额上限为%@元",uncollectedStr,factStr] autoHide:YES afterDelay:1.0 userInteractionEnabled:YES];
    //            return;
    //        }
    //    }

    //    if (dustedMoney > 1000000 ) {
    //
    //        [HUD showPromptViewWithToShowStr:XYBString(@"string_notGreaterthan",@"提现金额不能大于100万元") autoHide:YES afterDelay:1.0 userInteractionEnabled:YES];
    //        return;
    //    }

    if (!cityModel) {
        [HUD showPromptViewWithToShowStr:XYBString(@"str_choose_area", @"请选择地区") autoHide:YES afterDelay:1.0 userInteractionEnabled:YES];
        return;
    }

    if (!branchModel) {
        [HUD showPromptViewWithToShowStr:XYBString(@"str_select_bamkBranch", @"请选择银行支行") autoHide:YES afterDelay:1.0 userInteractionEnabled:YES];
        return;
    }
    NSDictionary *dic = @{
        @"bankName" : branchModel.brabank_name,
        @"provinceName" : provinceModel.name,
        @"provinceCode" : provinceModel.code,
        @"cityCode" : cityModel.code,
        @"cityName" : cityModel.name,
        @"prcptcd" : branchModel.prcptcd
    };

    if (self.delegate && [self.delegate respondsToSelector:@selector(clickTheBankBranch:)]) {
        [self.delegate clickTheBankBranch:dic];
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
