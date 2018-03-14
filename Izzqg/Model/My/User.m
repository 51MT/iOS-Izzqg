//
//  User.m
//  Ixyb
//
//  Created by wang on 15/5/4.
//  Copyright (c) 2015年 xyb. All rights reserved.
//

#import "User.h"

@implementation User

- (id)initWithCoder:(NSCoder *)coder {

    if (self = [super init]) {

        self.userId = [coder decodeObjectForKey:@"userId"];
        self.from = [coder decodeObjectForKey:@"from"];
        self.userName = [coder decodeObjectForKey:@"username"];
        self.email = [coder decodeObjectForKey:@"email"];
        self.tel = [coder decodeObjectForKey:@"tel"];
        self.sex = [coder decodeObjectForKey:@"sex"];
        self.sexStr = [coder decodeObjectForKey:@"sexStr"];
        self.url = [coder decodeObjectForKey:@"url"];
        self.roleName = [coder decodeObjectForKey:@"roleName"];
        self.birthDate = [coder decodeObjectForKey:@"birthDate"];
        self.nickName = [coder decodeObjectForKey:@"nickName"];
        self.isHaveAddr = [coder decodeBoolForKey:@"isHaveAddr"];
        self.loginToken = [coder decodeObjectForKey:@"loginToken"];
        
        self.depAcctId = [coder decodeObjectForKey:@"depAcctId"];
        self.depTotalAmount = [coder decodeObjectForKey:@"depTotalAmount"];
        self.depBorrowAcctId = [coder decodeObjectForKey:@"depBorrowAcctId"];

        self.isIdentityAuth = [coder decodeObjectForKey:@"isIdentityAuth"];
        self.isPhoneAuth = [coder decodeObjectForKey:@"isPhoneAuth"];
        self.isTradePassword = [coder decodeObjectForKey:@"isTradePassword"];
        self.isBankSaved = [coder decodeObjectForKey:@"isBankSaved"];
        self.isWithdrawMoney = [coder decodeObjectForKey:@"isWithdrawMoney"];
        self.accountNumber = [coder decodeObjectForKey:@"accountNumber"];
        self.bankName = [coder decodeObjectForKey:@"bankName"];
        self.bankType = [coder decodeObjectForKey:@"bankType"];
        self.bankmobilePhone = [coder decodeObjectForKey:@"bankmobilePhone"];
        self.bankId = [coder decodeObjectForKey:@"bankId"];

        self.recommendCode = [coder decodeObjectForKey:@"recommendCode"];
        self.referrerCode = [coder decodeObjectForKey:@"referrerCode"];

        self.usableAmount = [coder decodeObjectForKey:@"usableAmount"];
        self.totalAmount = [coder decodeObjectForKey:@"totalAmount"];
        self.totalEarnedAmount = [coder decodeObjectForKey:@"totalEarnedAmount"];
        self.freezedAmount = [coder decodeObjectForKey:@"freezedAmount"];
        self.realName = [coder decodeObjectForKey:@"realName"];
        self.idNumber = [coder decodeObjectForKey:@"idNumber"];
        self.idNumbers = [coder decodeObjectForKey:@"idNumbers"];
        self.creditScore = [coder decodeObjectForKey:@"creditScore"];
        self.recommendIncome = [coder decodeObjectForKey:@"recommendIncome"];
        self.totalInterest2callback = [coder decodeObjectForKey:@"totalInterest2callback"];

        self.uncollectedAmount = [coder decodeObjectForKey:@"uncollectedAmount"];

        self.score = [coder decodeObjectForKey:@"score"];
        self.vipLevel = [coder decodeObjectForKey:@"vipLevel"];
        self.rewardAmount = [coder decodeObjectForKey:@"rewardAmount"];
        self.sleepRewordAmount = [coder decodeObjectForKey:@"sleepRewordAmount"];
        self.increaseCardCount = [coder decodeObjectForKey:@"increaseCardCount"];
        self.toReceivePrincipal = [coder decodeObjectForKey:@"toReceivePrincipal"];

        self.province = [coder decodeObjectForKey:@"province"];
        self.city = [coder decodeObjectForKey:@"city"];
        self.district = [coder decodeObjectForKey:@"district"];
        self.evaluatingResult = [coder decodeObjectForKey:@"evaluatingResult"];

        self.gestureUnlock = [coder decodeObjectForKey:@"gestureUnlock"];
        self.gestureUnlockNumber = [coder decodeObjectForKey:@"gestureUnlockNumber"];

        self.isNewUser = [coder decodeObjectForKey:@"isNewUser"];

        self.bonusState = [coder decodeObjectForKey:@"bonusState"]; // [NSNumber numberWithInteger:[coder decodeObjectForKey:@"bonusState"]];

        self.totalLoanedAmount = [coder decodeObjectForKey:@"totalLoanedAmount"]; //累计出借金额
        self.investedPrincipal = [coder decodeObjectForKey:@"investedPrincipal"];
        self.bbgPrincipal = [coder decodeObjectForKey:@"bbgPrincipal"];
        self.dqbPrincipal = [coder decodeObjectForKey:@"dqbPrincipal"];
        self.xtbPrincipal = [coder decodeObjectForKey:@"xtbPrincipal"];
        self.hqbRateOfWeek = [coder decodeObjectForKey:@"hqbRateOfWeek"];         //活期宝7日年化收益率
        self.hqbYesterInterest = [coder decodeObjectForKey:@"hqbYesterInterest"]; //活期宝昨日收益
        self.depositAmount = [coder decodeObjectForKey:@"depositAmount"];

        self.isEmailAuth = [coder decodeBoolForKey:@"isEmailAuth"]; //邮箱是否激活
        self.openDep    =  [coder decodeObjectForKey:@"openDep"];     //是否开通存管账户
        self.vipExpired = [coder decodeObjectForKey:@"vipExpired"];///vip是否过期0未过期，1已过期
        self.cgUsableAmount = [coder decodeObjectForKey:@"cgUsableAmount"];
        self.cgTotalAsset = [coder decodeObjectForKey:@"cgTotalAsset"];
        self.cashOrderPrinAmountTotal = [coder decodeObjectForKey:@"cashOrderPrinAmountTotal"];
        
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    
    [coder encodeObject:_userId forKey:@"userId"];
    [coder encodeObject:_from forKey:@"from"];
    [coder encodeObject:_userName forKey:@"username"];
    [coder encodeObject:_email forKey:@"email"];
    [coder encodeObject:_tel forKey:@"tel"];
    [coder encodeObject:_sex forKey:@"sex"];
    [coder encodeObject:_sexStr forKey:@"sexStr"];
    [coder encodeObject:_url forKey:@"url"];
    [coder encodeObject:_roleName forKey:@"roleName"];
    [coder encodeObject:_nickName forKey:@"nickName"];
    [coder encodeObject:_birthDate forKey:@"birthDate"];
    [coder encodeBool:_isHaveAddr forKey:@"isHaveAddr"];
    [coder encodeObject:_loginToken forKey:@"loginToken"];

    [coder encodeObject:_isIdentityAuth forKey:@"isIdentityAuth"];
    [coder encodeObject:_isPhoneAuth forKey:@"isPhoneAuth"];
    [coder encodeObject:_isTradePassword forKey:@"isTradePassword"];
    [coder encodeObject:_isBankSaved forKey:@"isBankSaved"];
    [coder encodeObject:_isWithdrawMoney forKey:@"isWithdrawMoney"];
    [coder encodeObject:_accountNumber forKey:@"accountNumber"];
    [coder encodeObject:_bankType forKey:@"bankType"];
    [coder encodeObject:_bankmobilePhone forKey:@"bankmobilePhone"];
    [coder encodeObject:_bankName forKey:@"bankName"];
    [coder encodeObject:_bankId forKey:@"bankId"];

    [coder encodeObject:_recommendCode forKey:@"recommendCode"];
    [coder encodeObject:_referrerCode forKey:@"referrerCode"];

    [coder encodeObject:_usableAmount forKey:@"usableAmount"];
    [coder encodeObject:_totalAmount forKey:@"totalAmount"];
    [coder encodeObject:_totalEarnedAmount forKey:@"totalEarnedAmount"];
    [coder encodeObject:_freezedAmount forKey:@"freezedAmount"];
    [coder encodeObject:_realName forKey:@"realName"];
    [coder encodeObject:_idNumber forKey:@"idNumber"];
    [coder encodeObject:_idNumbers forKey:@"idNumbers"];
    [coder encodeObject:_creditScore forKey:@"creditScore"];
    [coder encodeObject:_recommendIncome forKey:@"recommendIncome"];
    [coder encodeObject:_totalInterest2callback forKey:@"totalInterest2callback"];

    [coder encodeObject:_uncollectedAmount forKey:@"uncollectedAmount"];
    [coder encodeObject:_evaluatingResult forKey:@"evaluatingResult"];

    [coder encodeObject:_score forKey:@"score"];
    [coder encodeObject:_vipLevel forKey:@"vipLevel"];
    [coder encodeObject:_rewardAmount forKey:@"rewardAmount"];
    [coder encodeObject:_sleepRewordAmount forKey:@"sleepRewordAmount"];
    [coder encodeObject:_increaseCardCount forKey:@"increaseCardCount"];
    [coder encodeObject:_toReceivePrincipal forKey:@"toReceivePrincipal"];

    [coder encodeObject:_province forKey:@"province"];
    [coder encodeObject:_city forKey:@"city"];
    [coder encodeObject:_district forKey:@"district"];
    [coder encodeObject:_gestureUnlock forKey:@"gestureUnlock"];
    [coder encodeObject:_gestureUnlockNumber forKey:@"gestureUnlockNumber"];

    [coder encodeObject:_isNewUser forKey:@"isNewUser"];

    [coder encodeObject:_bonusState forKey:@"bonusState"];

    [coder encodeObject:_totalLoanedAmount forKey:@"totalLoanedAmount"];
    [coder encodeObject:_investedPrincipal forKey:@"investedPrincipal"];
    [coder encodeObject:_bbgPrincipal forKey:@"bbgPrincipal"];
    [coder encodeObject:_dqbPrincipal  forKey:@"dqbPrincipal"];
    [coder encodeObject:_xtbPrincipal forKey:@"xtbPrincipal"];
    [coder encodeObject:_hqbRateOfWeek forKey:@"hqbRateOfWeek"];
    [coder encodeObject:_hqbYesterInterest forKey:@"hqbYesterInterest"];
    [coder encodeObject:_depositAmount forKey:@"depositAmount"];

    [coder encodeBool:_isEmailAuth forKey:@"isEmailAuth"];
    [coder encodeObject:_vipExpired forKey:@"vipExpired"];
    
    [coder encodeObject:_depAcctId forKey:@"depAcctId"];
    [coder encodeObject:_openDep forKey:@"openDep"];
    [coder encodeObject:_depTotalAmount forKey:@"depTotalAmount"];
    [coder encodeObject:_depBorrowAcctId forKey:@"depBorrowAcctId"];
    [coder encodeObject:_cgUsableAmount forKey:@"cgUsableAmount"];
    [coder encodeObject:_cgTotalAsset forKey:@"cgTotalAsset"];
    [coder encodeObject:_cashOrderPrinAmountTotal forKey:@"cashOrderPrinAmountTotal"];

}

@end
