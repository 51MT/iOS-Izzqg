//
//  RechargeRecord.h
//  Ixyb
//
//  Created by wangjianimac on 15/7/2.
//  Copyright (c) 2015年 xyb. All rights reserved.
//

#import "ResponseModel.h"
#import <Foundation/Foundation.h>
#import <JSONModel.h>

/**
 *  充值记录
 */
@protocol RechargeListRecord
@end
@interface RechargeListRecord : JSONModel

@property (assign, nonatomic) double amount;
@property (strong, nonatomic) NSString<Optional> *createdDate;
@property (strong, nonatomic) NSString<Optional> *dateStr;
@property (strong, nonatomic) NSString<Optional> *stateStr;
@property (assign, nonatomic) int state;

@end

@interface RechargeRecord : ResponseModel

@property (nonatomic, retain) NSArray<RechargeListRecord, Optional> *rechargeList;

@end
