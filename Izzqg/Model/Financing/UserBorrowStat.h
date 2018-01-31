//
//  UserBorrowStat.h
//  Ixyb
//
//  Created by wang on 15/6/11.
//  Copyright (c) 2015年 xyb. All rights reserved.
//

#import "JSONModel.h"

@interface UserBorrowStat : JSONModel

@property (nonatomic, copy) NSString<Optional> *borrowCount;
@property (nonatomic, copy) NSString<Optional> *borrowSuccessCount;
@property (nonatomic, copy) NSString<Optional> *refundCount;
@property (nonatomic, copy) NSString<Optional> *expiryCount;
@property (nonatomic, copy) NSString<Optional> *seriousExpiryCount;
@property (nonatomic, copy) NSString<Optional> *totalBorrowedAmount;
@property (nonatomic, copy) NSString<Optional> *totalToPayReturn;
@property (nonatomic, copy) NSString<Optional> *expiryAmount;

@end

/*
 "userBorrowStat" : {
 "borrowCount" : 借款数,
 "borrowSuccessCount" : 成功借款数,
 "refundCount" : 还清笔数,
 "expiryCount" : 逾期次数,
 "seriousExpiryCount" : 严重逾期次数,
 "totalBorrowedAmount" : 总计借入金额,
 "totalToPayReturn" : 待还金额,
 "expiryAmount" : 逾期金额
 },
 
 */