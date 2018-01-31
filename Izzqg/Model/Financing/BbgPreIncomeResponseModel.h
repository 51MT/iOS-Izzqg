//
//  BbgPreIncomeResponseModel.h
//  Ixyb
//
//  Created by dengjian on 16/8/18.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import "ResponseModel.h"

@interface BbgPreIncomeResponseModel : ResponseModel

@property (nonatomic, assign) double canInvestAmount;
@property (nonatomic, assign) double income;
@property (nonatomic, assign) double rewardAmount;
@property (nonatomic, assign) double usableAmount;

@end

/*
 canInvestAmount = 57900;
 income = 0;
 rewardAmount = 757;
 resultCode = 1;
 usableAmount = "115600.8";
 */
