//
//  CcProductModel.h
//  Ixyb
//
//  Created by 董镇华 on 16/7/18.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import "ResponseModel.h"

@interface CcProductModel : JSONModel

@property(nonatomic,copy)NSString<Optional>* ccId;                  // 产品id
@property(nonatomic,copy)NSString<Optional>* type;                  // 产品类型代码 RXYY
@property(nonatomic,copy)NSString<Optional>* typeStr;               // 产品类型名称 日新月益
@property(nonatomic,copy)NSString<Optional>* amount;                // 发售金额
@property(nonatomic,copy)NSString<Optional>* soldAmount;            // 已售金额
@property(nonatomic,copy)NSString<Optional>* perunit;               // 期数单位D：天 M 月
@property(nonatomic,copy)NSString<Optional>* periods;               // 期数
@property(nonatomic,copy)NSString<Optional>* periodsStr;            // 期数字符串
@property(nonatomic,copy)NSString<Optional>* state;                 // 发售状态， 1: 发售中 2：发售完
@property(nonatomic,copy)NSString<Optional>* rate;                  // 年化收益
@property(nonatomic,copy)NSString<Optional>* addRate;               // 加送利率
@property(nonatomic,copy)NSString<Optional>* minBidAmount;          // 最小出借金额
@property(nonatomic,copy)NSString<Optional>* maxBidAmount;          // 用户最大出借额度
@property(nonatomic,copy)NSString<Optional>* refundTypeString;      // 还款方式
@property(nonatomic,copy)NSString<Optional>* sncode;                // 产品期数编号 RXYY0717_NEW
@property(nonatomic,copy)NSString<Optional>* isNew;                 // 是否新手标
@property(nonatomic,copy)NSString<Optional>* interestDay;           // 计息日
@property(nonatomic,copy)NSString<Optional>* restAmount;            // 剩余可投金额
@property(nonatomic,copy)NSString<Optional>* investNumber;          // 出借人数
@property(nonatomic,copy)NSString<Optional>* investProgress;        // 已出借进度
@property(nonatomic,copy)NSString<Optional>* restInvestCount;       // 剩余可投次数

@property(nonatomic,copy)NSString<Optional>* zzyDefaultCount;       // 周周盈默认次数
@property(nonatomic,copy)NSString<Optional>* orderDate;             // 投资日期
@property(nonatomic,copy)NSString<Optional>* interestDate;          // 计息日期
@property(nonatomic,copy)NSString<Optional>* refundDate;            // 到账日期

#pragma - mark 首页推荐产品中增加的字段

@property (nonatomic, copy) NSString<Optional> *activityDesc;        // 活动描述
@property (nonatomic, copy) NSString<Optional> *rewardDesc;          // 奖励描述

@end
