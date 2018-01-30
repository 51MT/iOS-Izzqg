//
//  MyBanksResponseModel.h
//  Ixyb
//
//  Created by wang on 16/7/18.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import "ResponseModel.h"

@protocol BankModel
@end

@interface BankModel : JSONModel

@property (nonatomic, copy) NSString<Optional> *accountNumber;
@property (nonatomic, copy) NSString<Optional> *bankName; //银行名称详情（支行）
@property (nonatomic, copy) NSString<Optional> *bankType;
@property (nonatomic, copy) NSString<Optional> *bankTypeName; //银行名称简写
@property (nonatomic, copy) NSString<Optional> *cityName;
@property (nonatomic, copy) NSString<Optional> *code;
@property (nonatomic, copy) NSString<Optional> *bankId;
@property (nonatomic, copy) NSString<Optional> *mobilePhone;
@property (nonatomic, copy) NSString<Optional> *prcptcd;
@property (nonatomic, copy) NSString<Optional> *provinceName;
@property (nonatomic, copy) NSString<Optional> *dayLimit;
@property (nonatomic, copy) NSString<Optional> *monthLimit;
@property (nonatomic, copy) NSString<Optional> *singleLimit;

@end

@protocol UserBankModel
@end

@interface UserBankModel : JSONModel

@property (nonatomic, copy) NSString<Optional> *idNumber;
@property (nonatomic, copy) NSString<Optional> *realName;

@end

@interface MyBanksResponseModel : ResponseModel

@property (nonatomic, copy) NSString<Optional> *isBankSaved;
@property (nonatomic, copy) NSString<Optional> *isIdentityAuth;
@property (nonatomic, copy) NSString<Optional> *isWithdrawMoney;
@property (nonatomic, copy) NSString<Optional> *minRechargeAmount;
@property (nonatomic, copy) NSString<Optional> *minWithdrawAmount;
@property (nonatomic, copy) NSString<Optional> *openMpos;
@property (nonatomic, strong) UserBankModel *user;
@property (nonatomic, strong) BankModel *bank;

@end
