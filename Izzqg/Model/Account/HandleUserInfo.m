//
//  HandleUserInfo.m
//  Ixyb
//
//  Created by wang on 15/8/12.
//  Copyright (c) 2015年 xyb. All rights reserved.
//

#import "HandleUserInfo.h"

@implementation HandleUserInfo

+ (User *)hanedleTheUserInfo:(NSDictionary *)userInfoDic {

    NSString *usableAmount = [[userInfoDic objectForKey:@"accountInfo"] objectForKey:@"usableAmount"];
    NSString *totalAmount = [[userInfoDic objectForKey:@"accountInfo"] objectForKey:@"totalAmount"];
    NSString *depTotalAmount = [[userInfoDic objectForKey:@"accountInfo"] objectForKey:@"depTotalAmount"];

    NSString *depAcctId = [[userInfoDic objectForKey:@"accountInfo"] objectForKey:@"depAcctId"];
    NSString *depBorrowAcctId = [[userInfoDic objectForKey:@"accountInfo"] objectForKey:@"depBorrowAcctId"];

    
    NSString *totalEarnedAmount = [[userInfoDic objectForKey:@"accountInfo"] objectForKey:@"totalEarnedAmount"];
    NSString *yesterdayEarnedAmount = [[userInfoDic objectForKey:@"accountInfo"] objectForKey:@"yesterdayEarnedAmount"];
    NSString *freezedAmount = [[userInfoDic objectForKey:@"accountInfo"] objectForKey:@"freezedAmount"];
    NSString *recommendIncomeStr = [[userInfoDic objectForKey:@"accountInfo"] objectForKey:@"recommendIncome"];
    NSString *investedPrincipalStr = [[userInfoDic objectForKey:@"accountInfo"] objectForKey:@"investedPrincipal"];
    NSString *totalInterest2callback = [[userInfoDic objectForKey:@"accountInfo"] objectForKey:@"totalInterest2callback"]; //代收收益
    NSString *score = [[userInfoDic objectForKey:@"accountInfo"] objectForKey:@"score"];
    NSString *vipLevel = [[userInfoDic objectForKey:@"accountInfo"] objectForKey:@"vipLevel"];
    NSString *rewardAmount = [[userInfoDic objectForKey:@"accountInfo"] objectForKey:@"rewardAmount"];
    NSString *sleepRewordAmount = [[userInfoDic objectForKey:@"accountInfo"] objectForKey:@"sleepRewordAmount"];
    NSString *increaseCardCount = [[userInfoDic objectForKey:@"accountInfo"] objectForKey:@"increaseCardCount"];
    NSString *toReceivePrincipal = [[userInfoDic objectForKey:@"accountInfo"] objectForKey:@"toReceivePrincipal"];
    NSString * freezedAmountDesc = [[userInfoDic objectForKey:@"accountInfo"] objectForKey:@"freezedAmountDesc"];
    NSString *totalLoanedAmount = [[userInfoDic objectForKey:@"accountInfo"] objectForKey:@"totalLoanedAmount"];
    NSString *bbgPrincipal = [[userInfoDic objectForKey:@"accountInfo"] objectForKey:@"bbgPrincipal"];
    NSString * dqbPrincipal = [[userInfoDic objectForKey:@"accountInfo"] objectForKey:@"dqbPrincipal"];
    NSString *xtbPrincipal = [[userInfoDic objectForKey:@"accountInfo"] objectForKey:@"xtbPrincipal"];
    
    NSString *hqbRateOfWeek = [[userInfoDic objectForKey:@"activeAccount"] objectForKey:@"rateOfWeek"];
    NSString *hqbYesterInterest = [[userInfoDic objectForKey:@"activeAccount"] objectForKey:@"yesterInterest"];
    NSString *depositAmount = [[userInfoDic objectForKey:@"activeAccount"] objectForKey:@"depositAmount"];

    User *user = [UserDefaultsUtil getUser];

    //    user.url =  [[userInfoDic objectForKey:@"user"] objectForKey:@"url"];
    user.isIdentityAuth = [[userInfoDic objectForKey:@"user"] objectForKey:@"isIdentityAuth"];
    user.isPhoneAuth = [[userInfoDic objectForKey:@"user"] objectForKey:@"isPhoneAuth"];
    user.isTradePassword = [[userInfoDic objectForKey:@"user"] objectForKey:@"isTradePassword"];
    user.isBankSaved = [[userInfoDic objectForKey:@"user"] objectForKey:@"isBankSaved"];
    user.recommendCode = [[userInfoDic objectForKey:@"user"] objectForKey:@"recommendCode"];
    user.referrerCode = [[userInfoDic objectForKey:@"user"] objectForKey:@"referrerCode"];
    user.roleName = [[userInfoDic objectForKey:@"user"] objectForKey:@"roleName"];
    user.bonusState = [[userInfoDic objectForKey:@"user"] objectForKey:@"bonusState"];
    user.sex  = [[userInfoDic objectForKey:@"user"] objectForKey:@"sex"];
    user.openDep = [[userInfoDic objectForKey:@"user"] objectForKey:@"openDep"];

    user.usableAmount = [Utility stringrangeStr:[NSString stringWithFormat:@"%.2f", [usableAmount doubleValue]]];
    user.totalEarnedAmount = [Utility stringrangeStr:[NSString stringWithFormat:@"%.2f", [totalEarnedAmount doubleValue]]];
    user.totalAmount = [Utility stringrangeStr:[NSString stringWithFormat:@"%.2f", [totalAmount doubleValue]]];
    user.freezedAmount = [Utility stringrangeStr:[NSString stringWithFormat:@"%.2f", [freezedAmount doubleValue]]];
    user.investedPrincipal = [Utility stringrangeStr:[NSString stringWithFormat:@"%.2f", [investedPrincipalStr doubleValue]]];
    user.bbgPrincipal = [Utility stringrangeStr:[NSString stringWithFormat:@"%.2f", [bbgPrincipal doubleValue]]];
    user.dqbPrincipal =  [Utility stringrangeStr:[NSString stringWithFormat:@"%.2f", [dqbPrincipal doubleValue]]];
    user.xtbPrincipal =  [Utility stringrangeStr:[NSString stringWithFormat:@"%.2f", [xtbPrincipal doubleValue]]];
    
    user.recommendIncome = [Utility stringrangeStr:[NSString stringWithFormat:@"%.2f", [recommendIncomeStr doubleValue]]];
    
    user.depTotalAmount  = [Utility stringrangeStr:[NSString stringWithFormat:@"%.2f", [depTotalAmount doubleValue]]];

    user.yesterdayEarnedAmount = [NSString stringWithFormat:@"%.2f", [yesterdayEarnedAmount doubleValue]];
    user.totalInterest2callback = [NSString stringWithFormat:@"%.2f", [totalInterest2callback doubleValue]];

    user.score = [Utility stringrangeStr:[NSString stringWithFormat:@"%.2f", [score doubleValue]]];
    user.rewardAmount = [Utility stringrangeStr:[NSString stringWithFormat:@"%.2f", [rewardAmount doubleValue]]];
    user.sleepRewordAmount = [Utility stringrangeStr:[NSString stringWithFormat:@"%.2f", [sleepRewordAmount doubleValue]]];
    user.vipLevel = [NSString stringWithFormat:@"%@", vipLevel];
    user.freezedAmountDesc = [NSString stringWithFormat:@"%@", freezedAmountDesc];
    
    user.depAcctId = [NSString stringWithFormat:@"%@", depAcctId];
    user.depBorrowAcctId = [NSString stringWithFormat:@"%@", depBorrowAcctId];
    
    user.increaseCardCount = [Utility stringrangeStr:[NSString stringWithFormat:@"%.2f", [increaseCardCount doubleValue]]];
    user.toReceivePrincipal = [Utility stringrangeStr:[NSString stringWithFormat:@"%.2f", [toReceivePrincipal doubleValue]]];
    user.totalLoanedAmount = [Utility stringrangeStr:[NSString stringWithFormat:@"%.2f", [totalLoanedAmount doubleValue]]];
    user.hqbRateOfWeek = [Utility stringrangeStr:[NSString stringWithFormat:@"%.3f", [hqbRateOfWeek doubleValue] * 100]];
    user.hqbYesterInterest = [Utility stringrangeStr:[NSString stringWithFormat:@"%.2f", [hqbYesterInterest doubleValue]]];
    user.depositAmount = [Utility stringrangeStr:[NSString stringWithFormat:@"%.2f", [depositAmount doubleValue]]];

    //    user.bonusState = [userInfoDic objectForKey:@"bonusState"];
    //
    //    //地区
    //    user.province =  [[userInfoDic objectForKey:@"userArea"] objectForKey:@"province"];
    //    user.city =  [[userInfoDic objectForKey:@"userArea"] objectForKey:@"city"];
    //    user.district =  [[userInfoDic objectForKey:@"userArea"] objectForKey:@"district"];
    //
    //    if ([[userInfoDic objectForKey:@"userArea"] objectForKey:@"province"] == NULL) {
    //        user.province = @"";
    //    }
    //
    //    if ([[userInfoDic objectForKey:@"userArea"] objectForKey:@"city"] == NULL) {
    //        user.city = @"";
    //    }
    //
    //    if ([[userInfoDic objectForKey:@"userArea"] objectForKey:@"district"] == NULL) {
    //        user.district = @"";
    //    }
    //
    //    [UserDefaultsUtil setUser:user];

    return user;
}

@end
