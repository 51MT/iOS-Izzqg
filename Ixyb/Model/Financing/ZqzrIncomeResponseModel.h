//
//  ZqzrIncomeResponseModel.h
//  Ixyb
//
//  Created by dengjian on 16/9/8.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import "ResponseModel.h"

@interface ZqzrIncomeResponseModel : ResponseModel

@property (nonatomic, copy) NSString<Optional>* income;
@property (nonatomic, copy) NSString<Optional>* realMoney;
@property (nonatomic, copy) NSString<Optional>* canInvestAmount;
@property (nonatomic, copy) NSString<Optional>* usableAmount;
@property (nonatomic, copy) NSString<Optional>* rewardAmount;
@property (nonatomic, copy) NSString<Optional>* prepayInterest;
@property (nonatomic, copy) NSString<Optional>* addIncome;
@property (nonatomic, copy) NSString<Optional>* usableCard;  //是否有可用的优惠券

@end

/*
 "income": 39.82,//预期收益
 "realMoney": 1005.66,// 实际支付
 "canInvestAmount": 2977.58,//剩余可投
 "usableAmount": 84039.235950,//可用余额
 "rewardAmount": 7.50,//礼金
 "resultCode": 1,
 "prepayInterest": 5.66//预付利息
 "addIncome ":12//加息收益
 */
