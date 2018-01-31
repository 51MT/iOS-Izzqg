//
//  CheckTheInvestMoney.m
//  Ixyb
//
//  Created by wang on 15/11/18.
//  Copyright © 2015年 xyb. All rights reserved.
//

#import "CheckTheInvestMoney.h"

#import "AlertViewShow.h"
#import "Utility.h"

@implementation CheckTheInvestMoney

+ (BOOL)checkTheInvestMoney:(NSString *)moneyStr preInvest:(NSDictionary *)preInvestDic fromTag:(NSString *)fromTag prouduct:(BidProduct *)info ccProuduct:(CcProductModel *)ccinfo {

    NSString *lastStr = [moneyStr substringFromIndex:moneyStr.length - 1];

    if ([lastStr isEqualToString:@"."]) {

        moneyStr = [moneyStr substringToIndex:moneyStr.length - 1];
    }

    if (![Utility isValidateNumber:moneyStr]) {

        [HUD showPromptViewWithToShowStr:XYBString(@"str_financing_wrong_amount", @"出借金额填写错误") autoHide:YES afterDelay:1.0 userInteractionEnabled:YES];
        return NO;
    }

    NSDecimalNumber *usableAmountNum = [NSDecimalNumber decimalNumberWithString:[UserDefaultsUtil getUser].usableAmount]; //账户金额
    NSDecimalNumber *canUseAmount;                                                                                        //可用金额

    if ([preInvestDic objectForKey:@"rewardAmount"]) {
        //礼金
        NSString *rewardAmount = [NSString stringWithFormat:@"%@", [preInvestDic objectForKey:@"rewardAmount"]];
        NSDecimalNumber *rewardAmountNum = [NSDecimalNumber decimalNumberWithString:rewardAmount];

        //可用金额 = 可用金额 + 礼金
        canUseAmount = [rewardAmountNum decimalNumberByAdding:usableAmountNum];
    }

    NSDecimalNumber *enterAmount = [NSDecimalNumber decimalNumberWithString:moneyStr]; //输入金额

    if ([fromTag isEqualToString:XYBString(@"str_common_cc", @"策诚")]) {

        //可投金额
        NSDecimalNumber *permitAmount = [NSDecimalNumber doubleToNSDecimalNumber:[ccinfo.amount doubleValue] - [ccinfo.soldAmount doubleValue]];

        //起投金额
        NSDecimalNumber *minBidAmount = [NSDecimalNumber doubleToNSDecimalNumber:[ccinfo.minBidAmount doubleValue]];

        //用户最大出借额度
        NSDecimalNumber *maxBidAmount = [NSDecimalNumber doubleToNSDecimalNumber:[ccinfo.maxBidAmount doubleValue]];

        /**
         *  可投金额 与 起投金额 作比较
         */
        NSComparisonResult resultCount = [NSDecimalNumber aDecimalNumberWithNumber:permitAmount compareAnotherDecimalNumberWithNumber:minBidAmount];

        /**
         *  输入金额 与 可投金额 作比较
         */
        NSComparisonResult resultCount1 = [NSDecimalNumber aDecimalNumberWithNumber:enterAmount compareAnotherDecimalNumberWithNumber:permitAmount];

        /**
         *  可用金额 与 输入金额 作比较
         */
        NSComparisonResult resultCount2 = [NSDecimalNumber aDecimalNumberWithNumber:canUseAmount compareAnotherDecimalNumberWithNumber:enterAmount];

        /**
         *  输入金额 与 最大出借额度10000 作比较
         */
        NSComparisonResult resultCount3 = [NSDecimalNumber aDecimalNumberWithNumber:enterAmount compareAnotherDecimalNumberWithNumber:maxBidAmount];

        /**
         *  输入金额 与 起投金额 作比较
         */
        NSComparisonResult resultCount4 = [NSDecimalNumber aDecimalNumberWithNumber:enterAmount compareAnotherDecimalNumberWithNumber:minBidAmount];

        /*
         *  1.当可投金额>=起投金额，且输入金额>可投金额时，提示“出借金额不能大于剩余可投金额”；
         *  2.当可投金额>=起投金额，且输入金额=<可投金额时;
         *      输入金额>=起投金额时：
         *          1.若可用金额>=输入金额，分周周盈和其他产品两类判断起投金额；
         *          2.若可用金额<输入金额,提示充值，充值前须判断是否为100的整数倍和周周盈的最大出借金额；
         *      输入金额<起投金额时,提示起投金额；
         *  3.当可投金额<起投金额，且输入金额> <可投金额时，提示“当前可投金额”
         *    当可投金额<起投金额，且输入金额=可投金额时,若可用金额>=输入金额,return YES；若可用金额<输入金额时，提示充值
         */
        if (resultCount == 0 || resultCount == 1) {
            if (resultCount1 == 1) {
                [HUD showPromptViewWithToShowStr:XYBString(@"str_financing_investNoMoreThanCanInvest", @"出借金额不能大于剩余可投金额") autoHide:YES afterDelay:1.0 userInteractionEnabled:YES];
                return NO;
            }

            if (resultCount1 == 0 || resultCount1 == -1) {
                if (resultCount4 == 1 || resultCount4 == 0) {

                    if (resultCount2 == 1 || resultCount2 == 0) {
                        if ([ccinfo.type isEqualToString:@"ZZY"]) {
                            if (resultCount3 == 1) {
                                [HUD showPromptViewWithToShowStr:XYBString(@"str_financing_singleAmount10WMost", @"单笔出借最高10万元") autoHide:YES afterDelay:1.0 userInteractionEnabled:YES];
                                return NO;
                            }

                            if (resultCount3 == 0 || resultCount3 == -1) {
                                //输入金额取整且为100的倍数
                                if ([enterAmount integerValue] % 100) {
                                    [HUD showPromptViewWithToShowStr:XYBString(@"str_financing_investAmountXW100BS", @"出借金额须为100元的正整数倍") autoHide:YES afterDelay:1.0 userInteractionEnabled:YES];
                                    return NO;
                                } else {
                                    return YES;
                                }
                            }
                        }

                        if (![ccinfo.type isEqualToString:@"ZZY"]) {
                            //输入金额取整且为100的倍数
                            if ([enterAmount integerValue] % 100) {
                                [HUD showPromptViewWithToShowStr:XYBString(@"str_financing_investAmountXW100BS", @"出借金额须为100元的正整数倍") autoHide:YES afterDelay:1.0 userInteractionEnabled:YES];
                                return NO;
                            } else {
                                return YES;
                            }
                        }
                    }

                    if (resultCount2 == -1) {

                        if ([enterAmount doubleValue] - [enterAmount integerValue] == 0) {
                            //输入金额取整且为100的倍数
                            if ([enterAmount integerValue] % 100) {
                                [HUD showPromptViewWithToShowStr:XYBString(@"str_financing_investAmountXW100BS", @"出借金额须为100元的正整数倍") autoHide:YES afterDelay:1.0 userInteractionEnabled:YES];
                                return NO;
                            }

                            if ([ccinfo.type isEqualToString:@"ZZY"]) {
                                if (resultCount3 == 1) {
                                    [HUD showPromptViewWithToShowStr:XYBString(@"str_financing_singleAmount10WMost", @"单笔出借最高10万元") autoHide:YES afterDelay:1.0 userInteractionEnabled:YES];
                                    return NO;
                                }
                            }
                        }

                        if ([enterAmount doubleValue] - [enterAmount intValue] != 0) {
                            [HUD showPromptViewWithToShowStr:XYBString(@"string_invest_should_be_zheng", @"出借金额须为100元的正整数倍") autoHide:YES afterDelay:1.0 userInteractionEnabled:YES];
                            return NO;
                        }

                        AppDelegate *delegate = (AppDelegate *) [UIApplication sharedApplication].delegate;
                        AlertViewShow *alertView = [[AlertViewShow alloc] initWithFrame:delegate.window.bounds];

                        NSDecimalNumber *chargeMoney = [NSDecimalNumber aDecimalNumberWithNumber:enterAmount type:subtract anotherDecimalNumberWithNumber:canUseAmount];
                        NSString *chargeMoneyStr = [CheckTheInvestMoney notRounding:chargeMoney afterPoint:2];

                        alertView.moneyLab.text = [Utility replaceTheNumberForNSNumberFormatter:chargeMoneyStr];
                        [delegate.window addSubview:alertView];
                        [delegate.window bringSubviewToFront:alertView];

                        __weak AlertViewShow *weakAlert = alertView;
                        alertView.chargeBlock = ^(UIViewController *VC) {
                            [weakAlert removeFromSuperview];
                            [[NSNotificationCenter defaultCenter] postNotificationName:@"CHARGE" object:nil];
                        };

                        return NO;
                    }
                }

                if (resultCount4 == -1) {
                    [HUD showPromptViewWithToShowStr:XYBString(@"str_financing_investAmount100YuanAtLeast", @"出借金额须100元起投") autoHide:YES afterDelay:1.0 userInteractionEnabled:YES];
                    return NO;
                }
            }
        }

        if (resultCount == -1) {
            if (resultCount1 == 1 || resultCount1 == -1) {
                [HUD showPromptViewWithToShowStr:[NSString stringWithFormat:XYBString(@"str_financing_investAmountNow", @"您当前可投金额为%@元"), permitAmount] autoHide:YES afterDelay:1.0 userInteractionEnabled:YES];
                return NO;
            }

            if (resultCount1 == 0) {
                if (resultCount2 == 1 || resultCount2 == 0) {
                    return YES;
                }

                if (resultCount2 == -1) {
                    AppDelegate *delegate = (AppDelegate *) [UIApplication sharedApplication].delegate;
                    AlertViewShow *alertView = [[AlertViewShow alloc] initWithFrame:delegate.window.bounds];

                    NSDecimalNumber *chargeMoney = [NSDecimalNumber aDecimalNumberWithNumber:enterAmount type:subtract anotherDecimalNumberWithNumber:canUseAmount];
                    NSString *chargeMoneyStr = [CheckTheInvestMoney notRounding:chargeMoney afterPoint:2];

                    alertView.moneyLab.text = [Utility replaceTheNumberForNSNumberFormatter:chargeMoneyStr];
                    [delegate.window addSubview:alertView];
                    [delegate.window bringSubviewToFront:alertView];

                    __weak AlertViewShow *weakAlert = alertView;
                    alertView.chargeBlock = ^(UIViewController *VC) {
                        [weakAlert removeFromSuperview];
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"CHARGE" object:nil];
                    };

                    return NO;
                }
            }
        }
    }

    if ([fromTag isEqualToString:XYBString(@"str_common_xtb", @"信投宝")]) {

        //可投金额
        NSDecimalNumber *permitAmount = [NSDecimalNumber doubleToNSDecimalNumber:[info.bidRequestBal doubleValue]];

        //起投金额
        NSDecimalNumber *minBidAmount = [NSDecimalNumber doubleToNSDecimalNumber:[info.minBidAmount doubleValue]];

        /**
         *  可投金额 与 起投金额 作比较
         */
        NSComparisonResult resultCount = [NSDecimalNumber aDecimalNumberWithNumber:permitAmount compareAnotherDecimalNumberWithNumber:minBidAmount];

        /**
         *  输入金额 与 可投金额 作比较
         */
        NSComparisonResult resultCount1 = [NSDecimalNumber aDecimalNumberWithNumber:enterAmount compareAnotherDecimalNumberWithNumber:permitAmount];

        /**
         *  可用金额 与 输入金额 作比较
         */
        NSComparisonResult resultCount2 = [NSDecimalNumber aDecimalNumberWithNumber:canUseAmount compareAnotherDecimalNumberWithNumber:enterAmount];

        /**
         *  输入金额 与 起投金额 作比较
         */
        NSComparisonResult resultCount3 = [NSDecimalNumber aDecimalNumberWithNumber:enterAmount compareAnotherDecimalNumberWithNumber:minBidAmount];

        /**
         *  当信投宝的可投金额 >= 起投金额(50元)时，分三种情况分析判断：
         *        1.输入金额>可投金额时，直接提示“出借金额不可大于剩余可投金额”
         *        2.输入金额<可投金额时，分两种情况判断：
         *           2.1 输入金额>=起投金额时，(可用金额》=输入金额时，return yes 和 可用金额《输入金额时，充值)
         *           2.2 输入金额<起投金额时，提示最小起投金额；
         *        3.输入金额=可投金额时，分两种情况判断：
         *           3.1 可用金额>=输入金额时，return yes
         *           3.2 可用金额<输入金额时，充值
         */

        if (resultCount == 1 || resultCount == 0) {
            if (resultCount1 == 1) {
                [HUD showPromptViewWithToShowStr:XYBString(@"str_financing_investNoMoreThanCanInvest", @"出借金额不能大于剩余可投金额") autoHide:YES afterDelay:1.0 userInteractionEnabled:YES];
                return NO;
            }

            if (resultCount1 == -1) {
                if (resultCount3 == 1 || resultCount3 == 0) {
                    if (resultCount2 == 1 || resultCount2 == 0) {
                        return YES;
                    }

                    if (resultCount2 == -1) {

                        AppDelegate *delegate = (AppDelegate *) [UIApplication sharedApplication].delegate;
                        AlertViewShow *alertView = [[AlertViewShow alloc] initWithFrame:delegate.window.bounds];

                        NSDecimalNumber *chargeMoney = [NSDecimalNumber aDecimalNumberWithNumber:enterAmount type:subtract anotherDecimalNumberWithNumber:canUseAmount];
                        NSString *chargeMoneyStr = [CheckTheInvestMoney notRounding:chargeMoney afterPoint:2];

                        alertView.moneyLab.text = [Utility replaceTheNumberForNSNumberFormatter:chargeMoneyStr];
                        [delegate.window addSubview:alertView];
                        [delegate.window bringSubviewToFront:alertView];

                        __weak AlertViewShow *weakAlert = alertView;
                        alertView.chargeBlock = ^(UIViewController *VC) {
                            [weakAlert removeFromSuperview];
                            [[NSNotificationCenter defaultCenter] postNotificationName:@"CHARGE" object:nil];
                        };

                        return NO;
                    }
                }

                if (resultCount3 == -1) {
                    [HUD showPromptViewWithToShowStr:XYBString(@"str_financing_investAmount50YuanAtLeast", @"出借金额须50元起投") autoHide:YES afterDelay:1.0 userInteractionEnabled:YES];
                    return NO;
                }
            }

            if (resultCount1 == 0) {
                if (resultCount2 == 1 || resultCount2 == 0) {
                    return YES;
                }
                if (resultCount2 == -1) {
                    AppDelegate *delegate = (AppDelegate *) [UIApplication sharedApplication].delegate;
                    AlertViewShow *alertView = [[AlertViewShow alloc] initWithFrame:delegate.window.bounds];

                    NSDecimalNumber *chargeMoney = [NSDecimalNumber aDecimalNumberWithNumber:enterAmount type:subtract anotherDecimalNumberWithNumber:canUseAmount];
                    NSString *chargeMoneyStr = [CheckTheInvestMoney notRounding:chargeMoney afterPoint:2];

                    alertView.moneyLab.text = [Utility replaceTheNumberForNSNumberFormatter:chargeMoneyStr];
                    [delegate.window addSubview:alertView];
                    [delegate.window bringSubviewToFront:alertView];

                    __weak AlertViewShow *weakAlert = alertView;
                    alertView.chargeBlock = ^(UIViewController *VC) {
                        [weakAlert removeFromSuperview];
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"CHARGE" object:nil];
                    };

                    return NO;
                }
            }
        }

        /**
         *  当信投宝可投金额 < 最小起投金额时，分三种情况分析判断：
         *      1.1 当输入金额 > 可投金额时，提示“出借金额不能大于可投金额”
         *      1.2 当输入金额 = 可投金额时，可用金额>=输入金额，return YES;
         *      1.3 当输入金额 < 可投金额时，提示当前可投金额
         */
        if (resultCount == -1) {
            if (resultCount1 == -1 || resultCount1 == 1) {
                [HUD showPromptViewWithToShowStr:[NSString stringWithFormat:XYBString(@"str_financing_investAmountNow", @"您当前可投金额为%@元"), permitAmount] autoHide:YES afterDelay:1.0 userInteractionEnabled:YES];
                return NO;
            }

            if (resultCount1 == 0) {
                if (resultCount2 == 1 || resultCount2 == 0) {
                    return YES;
                }

                if (resultCount2 == -1) {
                    AppDelegate *delegate = (AppDelegate *) [UIApplication sharedApplication].delegate;
                    AlertViewShow *alertView = [[AlertViewShow alloc] initWithFrame:delegate.window.bounds];

                    NSDecimalNumber *chargeMoney = [NSDecimalNumber aDecimalNumberWithNumber:enterAmount type:subtract anotherDecimalNumberWithNumber:canUseAmount];
                    NSString *chargeMoneyStr = [CheckTheInvestMoney notRounding:chargeMoney afterPoint:2];

                    alertView.moneyLab.text = [Utility replaceTheNumberForNSNumberFormatter:chargeMoneyStr];
                    [delegate.window addSubview:alertView];
                    [delegate.window bringSubviewToFront:alertView];

                    __weak AlertViewShow *weakAlert = alertView;
                    alertView.chargeBlock = ^(UIViewController *VC) {
                        [weakAlert removeFromSuperview];
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"CHARGE" object:nil];
                    };
                    return NO;
                }
            }
        }
    }

    if ([fromTag isEqualToString:@"ZQZR"]) {

        //预付利息
        NSDecimalNumber *prepayAmount;
        if ([preInvestDic objectForKey:@"prepayInterest"]) {
            double prepayMoney = [[preInvestDic objectForKey:@"prepayInterest"] doubleValue];
            prepayAmount = [NSDecimalNumber doubleToNSDecimalNumber:fabs(prepayMoney)];
        }

        //可投金额
        NSDecimalNumber *permitAmount = [NSDecimalNumber doubleToNSDecimalNumber:[info.bidRequestBal doubleValue]];

        //起投金额
        NSDecimalNumber *minBidAmount = [NSDecimalNumber doubleToNSDecimalNumber:[info.minBidAmount doubleValue]];

        /**
         *  支付总金额 = 输入金额 + 预付利息
         */
        NSDecimalNumber *totalAmount = [NSDecimalNumber aDecimalNumberWithNumber:enterAmount type:Add anotherDecimalNumberWithNumber:prepayAmount];

        /**
         *  可投金额 与 起投金额 作比较
         */
        NSComparisonResult resultCount = [NSDecimalNumber aDecimalNumberWithNumber:permitAmount compareAnotherDecimalNumberWithNumber:minBidAmount];

        /**
         *  输入金额 与 可投金额 作比较
         */
        NSComparisonResult resultCount1 = [NSDecimalNumber aDecimalNumberWithNumber:enterAmount compareAnotherDecimalNumberWithNumber:permitAmount];

        /**
         *  输入金额 与 起投金额 作比较
         */
        NSComparisonResult resultCount2 = [NSDecimalNumber aDecimalNumberWithNumber:enterAmount compareAnotherDecimalNumberWithNumber:minBidAmount];

        /**
         *  支付总金额 与 可用金额 作比较
         */
        NSComparisonResult resultCount3 = [NSDecimalNumber aDecimalNumberWithNumber:totalAmount compareAnotherDecimalNumberWithNumber:canUseAmount];
        /**
         *  当债权转让的可投金额 >= 起投金额(100元)时，分三种情况分析判断：
         *        1.输入金额>起投金额时，直接提示“出借金额须100元起投”；
         *        2.输入金额<起投金额时，分两种情况判断：
         *           2.1 输入金额>=起投金额时，(可用金额》=输入金额+预付利息时，return yes 和 可用金额《输入金额+预付利息时，充值)
         *           2.2 输入金额<起投金额时，提示最小起投金额；
         *        3.输入金额=可投金额时，分两种情况判断：
         *           3.1 可用金额>=输入金额+预付利息时，return yes
         *           3.2 可用金额<输入金额+预付利息时，充值
         */

        if (resultCount == 0 || resultCount == 1) {
            if (resultCount2 == -1) {
                [HUD showPromptViewWithToShowStr:XYBString(@"str_financing_investAmount100YuanAtLeast", @"出借金额须100元起投") autoHide:YES afterDelay:1.0 userInteractionEnabled:YES];
                return NO;
            }

            if (resultCount2 == 0 || resultCount2 == 1) {
                if (resultCount1 == 1) {
                    [HUD showPromptViewWithToShowStr:XYBString(@"str_financing_investAmountXXYSYKTJE", @"出借金额须小于等于剩余可投金额") autoHide:YES afterDelay:1.0 userInteractionEnabled:YES];
                    return NO;
                }

                if (resultCount1 == 0 || resultCount1 == -1) {

                    if (resultCount3 == 1) {
                        AppDelegate *delegate = (AppDelegate *) [UIApplication sharedApplication].delegate;
                        AlertViewShow *alertView = [[AlertViewShow alloc] initWithFrame:delegate.window.bounds];

                        /**
                         *  充值金额 = 总金额 - 可用金额
                         */
                        NSDecimalNumber *chargeNum = [NSDecimalNumber aDecimalNumberWithNumber:totalAmount type:subtract anotherDecimalNumberWithNumber:canUseAmount];
                        NSString *chargeMoneyStr = [CheckTheInvestMoney notRounding:chargeNum afterPoint:2];

                        alertView.moneyLab.text = [Utility replaceTheNumberForNSNumberFormatter:chargeMoneyStr];
                        [delegate.window addSubview:alertView];
                        [delegate.window bringSubviewToFront:alertView];

                        __weak AlertViewShow *weakAlert = alertView;
                        alertView.chargeBlock = ^(UIViewController *VC) {
                            [weakAlert removeFromSuperview];
                            [[NSNotificationCenter defaultCenter] postNotificationName:@"ZQZRCHARGE" object:nil];
                        };

                        return NO;
                    }

                    if (resultCount3 == 0 || resultCount3 == -1) {
                        return YES;
                    }
                }
            }
        }

        if (resultCount == -1) {

            if (resultCount1 == 0) {
                if (resultCount3 == 0 || resultCount3 == 1) {
                    AppDelegate *delegate = (AppDelegate *) [UIApplication sharedApplication].delegate;
                    AlertViewShow *alertView = [[AlertViewShow alloc] initWithFrame:delegate.window.bounds];

                    /**
                     *  充值金额 = 总金额 - 可用金额
                     */
                    NSDecimalNumber *chargeNum = [NSDecimalNumber aDecimalNumberWithNumber:totalAmount type:subtract anotherDecimalNumberWithNumber:canUseAmount];
                    NSString *chargeMoneyStr = [CheckTheInvestMoney notRounding:chargeNum afterPoint:2];

                    alertView.moneyLab.text = [Utility replaceTheNumberForNSNumberFormatter:chargeMoneyStr];
                    [delegate.window addSubview:alertView];
                    [delegate.window bringSubviewToFront:alertView];

                    __weak AlertViewShow *weakAlert = alertView;
                    alertView.chargeBlock = ^(UIViewController *VC) {
                        [weakAlert removeFromSuperview];
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"ZQZRCHARGE" object:nil];
                    };

                    return NO;
                }

                if (resultCount3 == -1) {
                    return YES;
                }
            }

            if (resultCount1 == 1 || resultCount1 == -1) {
                [HUD showPromptViewWithToShowStr:XYBString(@"str_financing_investAmountXDYCanInvestAmount", @"出借金额须等于可投金额") autoHide:YES afterDelay:1.0 userInteractionEnabled:YES];
                return NO;
            }
        }
    }

    return YES;
}

/**
 *    @brief    截取指定小数位的值
 *
 *    @param     price     需要转化的数据
 *    @param     position     有效小数位
 *
 *    @return    截取后数据
 */
+ (NSString *)notRounding:(NSDecimalNumber *)price afterPoint:(NSInteger)position {
    NSDecimalNumberHandler *roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundPlain scale:position raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
    NSDecimalNumber *roundedOunces;
    roundedOunces = [price decimalNumberByRoundingAccordingToBehavior:roundingBehavior];

    return [NSString stringWithFormat:@"%@", roundedOunces];
}

+ (NSString *)allInvestMoneyPreInvest:(NSDictionary *)preInvestDic fromTag:(NSString *)fromTag prouduct:(BidProduct *)info ccProuduct:(CcProductModel *)ccInfo {

    double canUseAmount = [[UserDefaultsUtil getUser].usableAmount doubleValue]; //可用金额

    if ([preInvestDic objectForKey:@"rewardAmount"]) {
        canUseAmount = canUseAmount + [[preInvestDic objectForKey:@"rewardAmount"] doubleValue]; //可用金额+礼金
    }

    double permitAmount = [info.bidRequestBal doubleValue]; //可投金额

    NSString *dustedMoneyStr = nil;
    if ([fromTag isEqualToString:XYBString(@"str_common_cc", @"策诚")]) {
        permitAmount = [ccInfo.amount doubleValue] - [ccInfo.soldAmount doubleValue];

        if (permitAmount >= [ccInfo.minBidAmount doubleValue]) {
            if (canUseAmount >= permitAmount) {
                dustedMoneyStr = [NSString stringWithFormat:@"%d", (int) permitAmount / 100 * 100];

                if ([ccInfo.type isEqualToString:@"ZZY"]) {
                    if ([dustedMoneyStr doubleValue] > 100000) {
                        return [NSString stringWithFormat:@"%zi", 100000];
                    } else {
                        return dustedMoneyStr;
                    }
                }

                return dustedMoneyStr;
            }

            if (canUseAmount < permitAmount) {
                if (canUseAmount >= [ccInfo.minBidAmount doubleValue]) {
                    dustedMoneyStr = [NSString stringWithFormat:@"%d", (int) canUseAmount / 100 * 100];

                    if ([ccInfo.type isEqualToString:@"ZZY"]) {
                        if ([dustedMoneyStr doubleValue] > 100000) {
                            return [NSString stringWithFormat:@"%zi", 100000];
                        } else {
                            return dustedMoneyStr;
                        }
                    }

                    return dustedMoneyStr;
                }

                if (canUseAmount < [ccInfo.minBidAmount doubleValue]) {
                    dustedMoneyStr = @"0.00";
                    return dustedMoneyStr;
                }
            }
        }

        if (permitAmount < [ccInfo.minBidAmount doubleValue]) {
            if (canUseAmount < permitAmount) {
                dustedMoneyStr = @"0.00";
                return dustedMoneyStr;
            }

            if (canUseAmount >= permitAmount) {
                dustedMoneyStr = [Utility stringrangeStr:[NSString stringWithFormat:@"%.2f", permitAmount]];
                return dustedMoneyStr;
            }
        }
    }

    if ([fromTag isEqualToString:XYBString(@"str_common_xtb", @"信投宝")]) {

        if (permitAmount >= [ccInfo.minBidAmount doubleValue]) {
            if (canUseAmount >= permitAmount) {
                dustedMoneyStr = [Utility stringrangeStr:[NSString stringWithFormat:@"%.2f", permitAmount]];
                return dustedMoneyStr;
            }

            if (canUseAmount < permitAmount) {
                if (canUseAmount >= [info.minBidAmount doubleValue]) {
                    dustedMoneyStr = [Utility stringrangeStr:[NSString stringWithFormat:@"%.2f", canUseAmount]];
                    return dustedMoneyStr;
                }

                if (canUseAmount < [info.minBidAmount doubleValue]) {
                    dustedMoneyStr = XYBString(@"str_financing_zero", @"0.00");
                    return dustedMoneyStr;
                }
            }
        }

        if (permitAmount < [ccInfo.minBidAmount doubleValue]) {
            if (canUseAmount >= permitAmount) {
                dustedMoneyStr = [Utility stringrangeStr:[NSString stringWithFormat:@"%.2f", permitAmount]];
                return dustedMoneyStr;
            }

            if (canUseAmount < permitAmount) {
                dustedMoneyStr = XYBString(@"str_financing_zero", @"0.00");
                return dustedMoneyStr;
            }
        }
    }

    return dustedMoneyStr;
}

//步步高出借逻辑
+ (BOOL)checkTheBbgInvestMoney:(NSString *)moneyStr preInvest:(NSDictionary *)preInvestDic prouduct:(BbgProductModel *)info {

    moneyStr = [[moneyStr componentsSeparatedByString:@"."] objectAtIndex:0];

    if (![Utility isValidateNumber:moneyStr]) {

        [HUD showPromptViewWithToShowStr:XYBString(@"str_financing_wrong_amount", @"出借金额填写错误") autoHide:YES afterDelay:1.0 userInteractionEnabled:YES];
        return NO;
    }

    //可用余额
    NSDecimalNumber *canUseAmount = [NSDecimalNumber decimalNumberWithString:[UserDefaultsUtil getUser].usableAmount];

    if ([preInvestDic objectForKey:@"rewardAmount"]) {
        NSString *rewardAmount = [NSString stringWithFormat:@"%@", [preInvestDic objectForKey:@"rewardAmount"]]; //礼金
        NSDecimalNumber *multiplicandNumber = [NSDecimalNumber decimalNumberWithString:rewardAmount];

        //可用金额 = 可用金额+礼金
        canUseAmount = [canUseAmount decimalNumberByAdding:multiplicandNumber];
    }

    /**
     *  输入金额
     */
    NSDecimalNumber *enterAmount = [NSDecimalNumber decimalNumberWithString:moneyStr];

    /**
     *  可投金额
     */
    NSDecimalNumber *permitAmount = [NSDecimalNumber doubleToNSDecimalNumber:[info.restAmount doubleValue]];

    /**
     *  最小起投金额
     */
    NSDecimalNumber *minBidAmount = [NSDecimalNumber decimalNumberWithString:@"100"];

    /**
     *  可投金额与最小起投金额做比较
     */
    NSComparisonResult resultCount1 = [NSDecimalNumber aDecimalNumberWithNumber:permitAmount compareAnotherDecimalNumberWithNumber:minBidAmount];

    /**
     *  输入金额与可投金额做比较
     */
    NSComparisonResult resultCount2 = [NSDecimalNumber aDecimalNumberWithNumber:enterAmount compareAnotherDecimalNumberWithNumber:permitAmount];

    /**
     *  可用金额（可用金额+礼金）与输入金额作比较
     */
    NSComparisonResult resultCount3 = [NSDecimalNumber aDecimalNumberWithNumber:canUseAmount compareAnotherDecimalNumberWithNumber:enterAmount];

    /**
     *  输入金额与最小起投金额做比较
     */
    NSComparisonResult resultCount4 = [NSDecimalNumber aDecimalNumberWithNumber:enterAmount compareAnotherDecimalNumberWithNumber:minBidAmount];

    /*
     当可投金额 < 100时，分三种情况判断：
        1.输入金额 < 可投金额时，提示“剩余可投金额<100时,必须一次性投完”；
        2.输入金额 = 可投金额时(2.1 可用金额小于输入金额时充值 2.2反之，直接交易)；
        3.输入金额 > 可投金额时，提示“出借金额大于可投金额”
     */

    if (resultCount1 == -1) {

        if (resultCount2 == -1) {
            [HUD showPromptViewWithToShowStr:[NSString stringWithFormat:XYBString(@"str_financing_investAmountNow", @"您当前可投金额为%@元"), permitAmount] autoHide:YES afterDelay:1.0 userInteractionEnabled:YES];
            return NO;
        }

        if (resultCount2 == 0) {
            if (resultCount3 == 1 || resultCount3 == 0) {
                return YES;
            }

            if (resultCount3 == -1) {
                AppDelegate *delegate = (AppDelegate *) [UIApplication sharedApplication].delegate;
                AlertViewShow *alertView = [[AlertViewShow alloc] initWithFrame:delegate.window.bounds];

                NSDecimalNumber *chargeMoney = [NSDecimalNumber aDecimalNumberWithNumber:enterAmount type:subtract anotherDecimalNumberWithNumber:canUseAmount];
                alertView.moneyLab.text = [Utility replaceTheNumberForNSNumberFormatter:[self notRounding:chargeMoney afterPoint:2]];
                [delegate.window addSubview:alertView];
                [delegate.window bringSubviewToFront:alertView];

                __weak AlertViewShow *weakAlert = alertView;
                alertView.chargeBlock = ^(UIViewController *VC) {
                    [weakAlert removeFromSuperview];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"BBG" object:nil];
                };
                return NO;
            }
        }

        if (resultCount2 == 1) {
            [HUD showPromptViewWithToShowStr:XYBString(@"str_financing_investAmountXXYSYKTJE", @"出借金额须小于等于剩余可投金额") autoHide:YES afterDelay:1.0 userInteractionEnabled:YES];
            return NO;
        }
    }

    /**
     *  当可投金额>=100时，分两种情况分析判断：
     *      1.输入金额<=可投金额时()
     *          输入金额 >100; 1.1 可用金额>=输入金额，且出借必须是100的整数倍；1.2 可用金额<输入金额，充值弹窗
     *          输入金额 <100; 直接弹窗提示最小起投金额
     *      2.输入金额>可投金额时(toast提示“出借金额不能大于可投金额”)
     */
    if (resultCount1 == 1 || resultCount1 == 0) {
        if (resultCount2 == 0 || resultCount2 == -1) {
            if (resultCount4 == -1) {
                [HUD showPromptViewWithToShowStr:XYBString(@"str_financing_bbg_investAmount_100", @"步步高出借100元起") autoHide:YES afterDelay:1.0 userInteractionEnabled:YES];
                return NO;
            }

            if (resultCount4 == 0 || resultCount4 == 1) {
                if (resultCount3 == 0 || resultCount3 == 1) {
                    if ([enterAmount doubleValue] - [enterAmount integerValue] == 0) {
                        if ([enterAmount integerValue] % 100) {
                            [HUD showPromptViewWithToShowStr:XYBString(@"str_financing_investAmountXW100BS", @"出借金额须为100元的正整数倍") autoHide:YES afterDelay:1.0 userInteractionEnabled:YES];
                            return NO;
                        }

                        if (!([enterAmount integerValue] % 100)) {
                            return YES;
                        }
                    }

                    if ([enterAmount doubleValue] - [enterAmount integerValue] != 0) {
                        [HUD showPromptViewWithToShowStr:XYBString(@"str_financing_investAmountXW100BS", @"出借金额须为100元的正整数倍") autoHide:YES afterDelay:1.0 userInteractionEnabled:YES];
                        return NO;
                    }
                }

                if (resultCount3 == -1) {

                    if ([enterAmount doubleValue] - [enterAmount integerValue] == 0) {
                        if ([enterAmount integerValue] % 100) {
                            [HUD showPromptViewWithToShowStr:XYBString(@"str_financing_investAmountXW100BS", @"出借金额须为100元的正整数倍") autoHide:YES afterDelay:1.0 userInteractionEnabled:YES];
                            return NO;
                        }
                    }

                    if ([enterAmount doubleValue] - [enterAmount integerValue] != 0) {
                        [HUD showPromptViewWithToShowStr:XYBString(@"str_financing_investAmountXW100BS", @"出借金额须为100元的正整数倍") autoHide:YES afterDelay:1.0 userInteractionEnabled:YES];
                        return NO;
                    }

                    AppDelegate *delegate = (AppDelegate *) [UIApplication sharedApplication].delegate;
                    AlertViewShow *alertView = [[AlertViewShow alloc] initWithFrame:delegate.window.bounds];

                    NSDecimalNumber *chargeMoney = [NSDecimalNumber aDecimalNumberWithNumber:enterAmount type:subtract anotherDecimalNumberWithNumber:canUseAmount];
                    alertView.moneyLab.text = [self notRounding:chargeMoney afterPoint:2];
                    [delegate.window addSubview:alertView];
                    [delegate.window bringSubviewToFront:alertView];

                    __weak AlertViewShow *weakAlert = alertView;
                    alertView.chargeBlock = ^(UIViewController *VC) {
                        [weakAlert removeFromSuperview];
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"BBG" object:nil];
                    };
                    return NO;
                }
            }
        }

        if (resultCount2) {
            [HUD showPromptViewWithToShowStr:XYBString(@"str_financing_investAmountXXYSYKTJE", @"出借金额须小于等于剩余可投金额") autoHide:YES afterDelay:1.0 userInteractionEnabled:YES];
            return NO;
        }
    }
    return YES;
}

+ (NSString *)np_allInvestMoneyPreInvest:(NSDictionary *)preInvestDic nProuduct:(NProductModel *)info {

    //可用金额
    double canUseAmount = [[UserDefaultsUtil getUser].usableAmount doubleValue];
    
    //可投金额
    double permitAmount = [info.restAmount doubleValue];
    
    //最大出借上限
    double maxInvestAmount = [info.maxInvestAmount doubleValue];

    NSString *dustedMoneyStr = nil;

    if (permitAmount >= [info.minInvestAmount doubleValue]) {

        if (canUseAmount >= permitAmount) {
            dustedMoneyStr = [NSString stringWithFormat:@"%d", (int) permitAmount];
            
            //可投 > 起投
            if ([dustedMoneyStr doubleValue] > maxInvestAmount) {
                return [NSString stringWithFormat:@"%zi", maxInvestAmount];
            } else {
                return dustedMoneyStr;
            }
        }

        if (canUseAmount < permitAmount) {

            if (canUseAmount >= [info.minInvestAmount doubleValue]) {
                dustedMoneyStr = [NSString stringWithFormat:@"%d", (int) canUseAmount];

                if ([dustedMoneyStr doubleValue] > maxInvestAmount) {
                    return [NSString stringWithFormat:@"%zi", maxInvestAmount];
                } else {
                    return dustedMoneyStr;
                }
            }

            if (canUseAmount < [info.minInvestAmount doubleValue]) {
                dustedMoneyStr = @"0.00";
                return dustedMoneyStr;
            }
        }
    }

    if (permitAmount < [info.minInvestAmount doubleValue]) {
        if (canUseAmount < permitAmount) {
            dustedMoneyStr = @"0.00";
            return dustedMoneyStr;
        }else{
            dustedMoneyStr = [Utility stringrangeStr:[NSString stringWithFormat:@"%.2f", permitAmount]];
            return dustedMoneyStr;
        }
    }

    return dustedMoneyStr;
}

+ (BOOL)checkTheNProductInvestMoney:(NSString *)moneyStr preInvest:(NSDictionary *)preInvestDic prouduct:(NProductModel *)info {
    
    moneyStr = [[moneyStr componentsSeparatedByString:@"."] objectAtIndex:0];
    
    if (![Utility isValidateNumber:moneyStr]) {
        
        [HUD showPromptViewWithToShowStr:XYBString(@"str_financing_wrong_amount", @"出借金额填写错误") autoHide:YES afterDelay:1.0 userInteractionEnabled:YES];
        return NO;
    }
    
    //可用余额
    NSDecimalNumber *canUseAmount = [NSDecimalNumber decimalNumberWithString:[UserDefaultsUtil getUser].usableAmount];
    
    /**
     *  输入金额
     */
    NSDecimalNumber *enterAmount = [NSDecimalNumber decimalNumberWithString:moneyStr];
    
    /**
     *  可投金额
     */
    NSDecimalNumber *permitAmount = [NSDecimalNumber doubleToNSDecimalNumber:[info.restAmount doubleValue]];
    
    /**
     *  最小起投金额
     */
    NSDecimalNumber *minBidAmount = [NSDecimalNumber doubleToNSDecimalNumber:[info.minInvestAmount doubleValue]];
    
    /**
     *  可投金额与最小起投金额做比较
     */
    NSComparisonResult resultCount1 = [NSDecimalNumber aDecimalNumberWithNumber:permitAmount compareAnotherDecimalNumberWithNumber:minBidAmount];
    
    /**
     *  输入金额与可投金额做比较
     */
    NSComparisonResult resultCount2 = [NSDecimalNumber aDecimalNumberWithNumber:enterAmount compareAnotherDecimalNumberWithNumber:permitAmount];
    
    /**
     *  可用金额（可用金额+礼金）与输入金额作比较
     */
    NSComparisonResult resultCount3 = [NSDecimalNumber aDecimalNumberWithNumber:canUseAmount compareAnotherDecimalNumberWithNumber:enterAmount];
    
    /**
     *  输入金额与最小起投金额做比较
     */
    NSComparisonResult resultCount4 = [NSDecimalNumber aDecimalNumberWithNumber:enterAmount compareAnotherDecimalNumberWithNumber:minBidAmount];
    
    /*
     当可投金额 < 100时，提示“一键出借100元起投”
     */
    if (resultCount1 == -1) {
        [HUD showPromptViewWithToShowStr:XYBString(@"str_financing_yjcj_investAmount_100", @"一键出借100元起投") autoHide:YES afterDelay:1.0 userInteractionEnabled:YES];
        return NO;
    }
    
    /**
     当可投金额>=100时，分两种情况分析判断：
     1.输入金额<=可投金额时:
        1.1 输入金额 >100:
            1) 可用金额>=输入金额，输入金额是整数，return YES，输入金额是小数，提示“出借金额须为100以上的整数”；
            2) 可用金额<输入金额，充值弹窗
        1.2 输入金额 <100; 直接弹窗提示最小起投金额
     2.输入金额>可投金额时(toast提示“出借金额不能大于可投金额”)
     */
    if (resultCount1 == 1 || resultCount1 == 0) {
        
        //输入金额 <= 可投金额时
        if (resultCount2 == 0 || resultCount2 == -1) {
            
            //2.1 输入金额 < 100
            if (resultCount4 == -1) {
                [HUD showPromptViewWithToShowStr:XYBString(@"str_financing_yjcj_investAmount_100", @"一键出借100元起投") autoHide:YES afterDelay:1.0 userInteractionEnabled:YES];
                return NO;
            }
            
            //2.2 输入金额 >= 100
            if (resultCount4 == 0 || resultCount4 == 1) {
                
                //可用金额 >= 输入金额
                if (resultCount3 == 0 || resultCount3 == 1) {
                    
                    //输入金额是否是整数
                    if ([enterAmount doubleValue] - [enterAmount integerValue] == 0) {
                        return YES;
                    }
                    
                    if ([enterAmount doubleValue] - [enterAmount integerValue] != 0) {
                        [HUD showPromptViewWithToShowStr:XYBString(@"str_financing_yjcj_investAmountXW100YSDZS", @"出借金额须为100以上的整数") autoHide:YES afterDelay:1.0 userInteractionEnabled:YES];
                        return NO;
                    }
                }
                
                //可用金额 < 输入金额
                if (resultCount3 == -1) {
                    
                    if ([enterAmount doubleValue] - [enterAmount integerValue] != 0) {
                        [HUD showPromptViewWithToShowStr:XYBString(@"str_financing_yjcj_investAmountXW100YSDZS", @"出借金额须为100以上的整数") autoHide:YES afterDelay:1.0 userInteractionEnabled:YES];
                        return NO;
                    }
                    
                    AppDelegate *delegate = (AppDelegate *) [UIApplication sharedApplication].delegate;
                    AlertViewShow *alertView = [[AlertViewShow alloc] initWithFrame:delegate.window.bounds];
                    
                    NSDecimalNumber *chargeMoney = [NSDecimalNumber aDecimalNumberWithNumber:enterAmount type:subtract anotherDecimalNumberWithNumber:canUseAmount];
                    alertView.moneyLab.text = [self notRounding:chargeMoney afterPoint:2];
                    [delegate.window addSubview:alertView];
                    [delegate.window bringSubviewToFront:alertView];
                    
                    __weak AlertViewShow *weakAlert = alertView;
                    alertView.chargeBlock = ^(UIViewController *VC) {
                        [weakAlert removeFromSuperview];
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"YJCJ" object:nil];
                    };
                    return NO;
                }
            }
        }
        
        if (resultCount2) {
            [HUD showPromptViewWithToShowStr:XYBString(@"str_financing_investAmountXXYSYKTJE", @"出借金额须小于等于剩余可投金额") autoHide:YES afterDelay:1.0 userInteractionEnabled:YES];
            return NO;
        }
    }
    
    return YES;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
