//
//  IncomeDetail.h
//  Ixyb
//
//  Created by wangjianimac on 15/7/2.
//  Copyright (c) 2015年 xyb. All rights reserved.
//

#import "ResponseModel.h"
#import <Foundation/Foundation.h>
#import <JSONModel.h>

@protocol transDetails
@end
@interface transDetails : JSONModel

@property (assign, nonatomic) int accountActionType;
@property (strong, nonatomic) NSString<Optional> *accountActionTypeString;
@property (assign, nonatomic) double amount;
@property (assign, nonatomic) double balance;
@property (strong, nonatomic) NSString<Optional> *accountId;
@property (assign, nonatomic) bool income;
@property (strong, nonatomic) NSString<Optional> *createdDate;
@property (strong, nonatomic) NSString<Optional> *dateStr;
@end

@interface IncomeDetail : ResponseModel

@property (nonatomic, retain) NSArray<transDetails, Optional> *transDetails;

@end
