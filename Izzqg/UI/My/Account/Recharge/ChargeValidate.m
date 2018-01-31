//
//  ChargeValidate.m
//  Ixyb
//
//  Created by wang on 15/11/20.
//  Copyright © 2015年 xyb. All rights reserved.
//

#import "ChargeValidate.h"

#import "Utility.h"

@implementation ChargeValidate

+ (BOOL)checkTheChargebankTypeNumber:(int)bankTypeNumber bankNumStr:(NSString *)bankNumStr phone:(NSString *)phoneStr nameStr:(NSString *)nameStr idStr:(NSString *)idStr {

    if (nameStr.length == 0) {
        [HUD showPromptViewWithToShowStr:XYBString(@"string_name_str", @"请输入持卡人姓名") autoHide:YES afterDelay:1.0 userInteractionEnabled:YES];
        return NO;
    }

    if (idStr.length == 0) {
        [HUD showPromptViewWithToShowStr:XYBString(@"string_id_str", @"请输入持卡人身份证号") autoHide:YES afterDelay:1.0 userInteractionEnabled:YES];
        return NO;
    }
    if (idStr.length < 15 || idStr.length > 18) {
        [HUD showPromptViewWithToShowStr:XYBString(@"string_idnum_str", @"请输入正确的身份证号") autoHide:YES afterDelay:1.0 userInteractionEnabled:YES];
        return NO;
    }

    //    if (bankTypeNumber<1) {
    //        [HUD showPromptViewWithToShowStr:XYBString(@"string_choose_begin_bank",@"请选择开户银行") autoHide:YES afterDelay:1.0 userInteractionEnabled:YES];
    //        return NO;
    //    }

    if (bankNumStr.length == 0) {
        [HUD showPromptViewWithToShowStr:XYBString(@"string_please_input_card_no", @"请输入银行卡号") autoHide:YES afterDelay:1.0 userInteractionEnabled:YES];
        return NO;
    }
    NSString *bankStr = [bankNumStr stringByReplacingOccurrencesOfString:@" " withString:@""];

    if (![Utility validateBankCardNumber:bankStr]) {
        [HUD showPromptViewWithToShowStr:XYBString(@"string_please_input_card_no_15_19", @"请输入正确的银行卡号") autoHide:YES afterDelay:1.0 userInteractionEnabled:YES];
        return NO;
    }

    //    if (phoneStr.length==0) {
    //        [HUD showPromptViewWithToShowStr:XYBString(@"string_please_input_bank_phone_number",@"请输入银行预留手机号") autoHide:YES afterDelay:1.0 userInteractionEnabled:YES];
    //        return NO;
    //    }
    //
    //    if (![Utility isValidateMobile:phoneStr]){
    //
    //        [HUD showPromptViewWithToShowStr:XYBString(@"string_input_correct_phone_number",@"请输入正确的手机号") autoHide:YES afterDelay:1.0 userInteractionEnabled:YES];
    //        return NO;
    //    }
    //

    return YES;
}

+ (BOOL)checkTheChargebankTypeNumber:(int)bankTypeNumber bankNumStr:(NSString *)bankNumStr phone:(NSString *)phoneStr {

    if (bankTypeNumber < 1) {
        [HUD showPromptViewWithToShowStr:XYBString(@"string_choose_begin_bank", @"请选择开户银行") autoHide:YES afterDelay:1.0 userInteractionEnabled:YES];
        return NO;
    }

    if (bankNumStr.length == 0) {
        [HUD showPromptViewWithToShowStr:XYBString(@"string_please_input_card_no", @"请输入银行卡号") autoHide:YES afterDelay:1.0 userInteractionEnabled:YES];
        return NO;
    }
    NSString *bankStr = [bankNumStr stringByReplacingOccurrencesOfString:@" " withString:@""];

    if (![Utility validateBankCardNumber:bankStr]) {
        [HUD showPromptViewWithToShowStr:XYBString(@"string_card_not_correct", @"银行卡号不正确") autoHide:YES afterDelay:1.0 userInteractionEnabled:YES];
        return NO;
    }

    if (phoneStr.length == 0) {
        [HUD showPromptViewWithToShowStr:XYBString(@"string_please_input_bank_phone_number", @"请输入银行预留手机号") autoHide:YES afterDelay:1.0 userInteractionEnabled:YES];
        return NO;
    }

    if (![Utility isValidateMobile:phoneStr]) {

        [HUD showPromptViewWithToShowStr:XYBString(@"string_input_correct_phone_number", @"请输入正确的手机号") autoHide:YES afterDelay:1.0 userInteractionEnabled:YES];
        return NO;
    }

    return YES;
}

+ (BOOL)checkTheChargeDustedMoneyStr:(NSString *)dustedMoney {

    if (dustedMoney.length == 0) {

        [HUD showPromptViewWithToShowStr:XYBString(@"string_please_input_charge_amount", @"请输入充值金额") autoHide:YES afterDelay:1.0 userInteractionEnabled:YES];
        return NO;
    }

    if (![Utility isValidateNumber:dustedMoney]) {

        [HUD showPromptViewWithToShowStr:XYBString(@"string_wrong_charge_amount", @"充值金额填写错误") autoHide:YES afterDelay:1.0 userInteractionEnabled:YES];
        return NO;
    }
    double money = [dustedMoney doubleValue];

    if (money < 100) {
        [HUD showPromptViewWithToShowStr:XYBString(@"string_number_must_be_zheng", @"充值金额不能低于100元") autoHide:YES afterDelay:1.0 userInteractionEnabled:YES];
        return NO;
    }

    NSString *str = [Utility stringrangeStr:[NSString stringWithFormat:@"%.2f", money]];
    if (![StrUtil isPureInt:str]) {
        [HUD showPromptViewWithToShowStr:XYBString(@"string_charge_num_error", @"充值金额填写错误") autoHide:YES afterDelay:1.0 userInteractionEnabled:YES];
        return NO;
    }

    return YES;
}

@end
