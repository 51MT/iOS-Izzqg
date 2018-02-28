//
//  CashRecord.h
//  Ixyb
//
//  Created by wangjianimac on 15/7/2.
//  Copyright (c) 2015年 xyb. All rights reserved.
//

#import "ResponseModel.h"
#import <Foundation/Foundation.h>
#import <JSONModel.h>

/**
 *  提现记录
 */
@protocol WithdrawalsRecord

@end

@interface WithdrawalsRecord : JSONModel

@property (assign, nonatomic) double moneyAmount;
@property (assign, nonatomic) int moneyWithdrawState;
@property (assign, nonatomic) int isCancel;
@property (strong, nonatomic) NSString<Optional> *moneyWithdrawStateString;
@property (strong, nonatomic) NSString<Optional> *createdDate;
@property (strong, nonatomic) NSString<Optional> *dateStr;
@property (nonatomic, assign) NSInteger id;

@end

@interface CashRecord : ResponseModel
@property (nonatomic, retain) NSArray<WithdrawalsRecord, Optional> *withdrawals;
@end
