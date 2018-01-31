//
//  CcProduct.h
//  Ixyb
//
//  Created by wangjianimac on 15/8/26.
//  Copyright (c) 2015年 xyb. All rights reserved.
//

#import "JSONModel.h"

@interface CcProduct : JSONModel

@property(nonatomic,copy)NSString<Optional>* id;               // 产品id
@property(nonatomic,copy)NSString<Optional>* type;             // 产品类型代码 RXYY
@property(nonatomic,copy)NSString<Optional>* typeStr;          // 产品类型名称 日新月益
@property(nonatomic,copy)NSString<Optional>* amount;           // 发售金额
@property(nonatomic,copy)NSString<Optional>* soldAmount;       // 已售金额
@property(nonatomic,copy)NSString<Optional>* periods;          // 期数
@property(nonatomic,copy)NSString<Optional>* periodsStr;       // 期数字符串
@property(nonatomic,copy)NSString<Optional>* perunit;          // 期数单位D：天 M 月
@property(nonatomic,copy)NSString<Optional>* state;            // 发售状态， 1: 发售中 2：发售完
@property(nonatomic,copy)NSString<Optional>* rate;             // 年化收益
@property(nonatomic,copy)NSString<Optional>* addRate;          // 加送利率
@property(nonatomic,copy)NSString<Optional>* minBidAmount;     // 最小出借金额
@property(nonatomic,copy)NSString<Optional>* refundTypeString; // 还款方式
@property(nonatomic,copy)NSString<Optional>* createdDate;      // 创建时间 "2015-07-17 10:07:56"
@property(nonatomic,copy)NSString<Optional>* sncode;           // 产品期数编号 RXYY0717_NEW
@property(nonatomic,copy)NSString<Optional>* isNew;            // 是否新手标
@property(nonatomic,copy)NSString<Optional>* sort;             // 标的类型，FRESH、和信投宝一样，NORMAL普通标，FRESH新手标，MIAO秒杀标，COMPET竞投标
@property(nonatomic,copy)NSString<Optional>* restAmount;       // 剩余可投金额
@property(nonatomic,copy)NSString<Optional>* interestDay;      // 计息日
@property(nonatomic,copy)NSString<Optional>* interestDate;     // 计息日期
@property(nonatomic,copy)NSString<Optional>* lastRefundDate;   // 最后还款时间
@property(nonatomic,copy)NSString<Optional>* investNumber;     // 出借人数
@property(nonatomic,copy)NSString<Optional>* investProgress;   // 已出借进度
@property(nonatomic,copy)NSString<Optional>* maxBidAmount;     // 用户最大出借额度
@property(nonatomic,copy)NSString<Optional>* restInvestCount;  // 剩余可投次数

@property(nonatomic,copy)NSString<Optional>* zzyDefaultCount;  // 周周盈默认次数

- (id)init;

@end
