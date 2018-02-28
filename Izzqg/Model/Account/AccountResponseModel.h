//
//  AccountResponseModel.h
//  Ixyb
//
//  Created by wang on 16/7/15.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import "ResponseModel.h"

@protocol AccountInfoModel
@end

@interface AccountInfoModel : JSONModel

@property (nonatomic, copy) NSString<Optional> *bbgPrincipal;
@property (nonatomic, copy) NSString<Optional> *dqbPrincipal;
@property (nonatomic, copy) NSString<Optional> *xtbPrincipal;
@property (nonatomic, copy) NSString<Optional> *vipExpired;
@property (nonatomic, copy) NSString<Optional> *freezedAmountDesc;
@property (nonatomic, copy) NSString<Optional> *accountId;
@property (nonatomic, copy) NSString<Optional> *creditScore;
@property (nonatomic, copy) NSString<Optional> *earnedGiveAwayAmount;
@property (nonatomic, copy) NSString<Optional> *freezedAmount;
@property (nonatomic, copy) NSString<Optional> *giveAwayAmount;
@property (nonatomic, copy) NSString<Optional> *increaseCardCount;
@property (nonatomic, copy) NSString<Optional> *investedPrincipal;
@property (nonatomic, copy) NSString<Optional> *recommendIncome;
@property (nonatomic, copy) NSString<Optional> *rewardAmount;
@property (nonatomic, copy) NSString<Optional> *score;
@property (nonatomic, copy) NSString<Optional> *sleepRewordAmount;
@property (nonatomic, copy) NSString<Optional> *toReceivePrincipal;
@property (nonatomic, copy) NSString<Optional> *totalAmount;
@property (nonatomic, copy) NSString<Optional> *totalEarnedAmount;
@property (nonatomic, copy) NSString<Optional> *totalInterest2callback;
@property (nonatomic, copy) NSString<Optional> *totalLoanedAmount;
@property (nonatomic, copy) NSString<Optional> *totalRecharge;
@property (nonatomic, copy) NSString<Optional> *totalWithdraw;
@property (nonatomic, copy) NSString<Optional> *usableAmount;
@property (nonatomic, copy) NSString<Optional> *usedRewardAmount;
@property (nonatomic, copy) NSString<Optional> *vipLevel;
@property (nonatomic, copy) NSString<Optional> *yesterdayEarnedAmount;
@property (nonatomic, copy) NSString<Optional> *depAcctId;         //理财存管账户ID
@property (nonatomic, copy) NSString<Optional> *depBorrowAcctId;   //借款存管账户ID
@property (nonatomic, copy) NSString<Optional> *depTotalAmount;    //存管账户总资产


@end


@protocol UserModel
@end

@interface UserModel : JSONModel

@property (nonatomic, copy) NSString<Optional> *url;
@property (nonatomic, copy) NSString<Optional> *username;
@property (nonatomic, copy) NSString<Optional> *nickName;
@property (nonatomic, copy) NSString<Optional> *bonusState;
@property (nonatomic, copy) NSString<Optional> *isBankSaved;
@property (nonatomic, copy) NSString<Optional> *isEmailAuth;
@property (nonatomic, copy) NSString<Optional> *isHaveAddr;
@property (nonatomic, copy) NSString<Optional> *isIdentityAuth;
@property (nonatomic, copy) NSString<Optional> *isPhoneAuth;
@property (nonatomic, copy) NSString<Optional> *isTradePassword;
@property (nonatomic, copy) NSString<Optional> *recommendCode;
@property (nonatomic, copy) NSString<Optional> *email;
@property (nonatomic, copy) NSString<Optional> *openDep;           //是否开通存管权限 1 已开通 0 未开通
@property (nonatomic, copy) NSString<Optional> *sex;               //"sex":0,//性别 0 男，1 女
@property (nonatomic, copy) NSString<Optional> *realName;         //姓名

@end


@interface AccountResponseModel : ResponseModel

@property (nonatomic,copy) NSString<Optional> *isEvaluation;
@property (nonatomic, strong) AccountInfoModel *accountInfo;
@property (nonatomic, strong) UserModel *user;
@property (nonatomic, copy) NSString<Optional> *reserveCount;

@end
