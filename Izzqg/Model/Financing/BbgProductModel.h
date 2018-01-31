//
//  BbgProductModel.h
//  Ixyb
//
//  Created by 董镇华 on 16/7/18.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import "JSONModel.h"

@interface BbgProductModel : JSONModel

@property (nonatomic, copy) NSString<Optional> *projectId;
@property (nonatomic, copy) NSString<Optional> *title;              // 标题
@property (nonatomic, copy) NSString<Optional> *sn;                 // 产品编号
@property (nonatomic, copy) NSString<Optional> *amount;             // 总金额
@property (nonatomic, copy) NSString<Optional> *soldAmount;         // 已售金额
@property (nonatomic, copy) NSString<Optional> *minBidAmount;       // 最低出借金额
@property (nonatomic, copy) NSString<Optional> *state;              // 状态
@property (nonatomic, copy) NSString<Optional> *baseRate;           // 年化利率
@property (nonatomic, copy) NSString<Optional> *paddRate;           // 每期增加年化
@property (nonatomic, copy) NSString<Optional> *maxRate;            // 最大年化
@property (nonatomic, copy) NSString<Optional> *restAmount;         // 剩余可投
@property (nonatomic, copy) NSString<Optional> *investProgress;     // 已投百分比
@property (nonatomic, copy) NSString<Optional> *productUrl;         // 步步高视图中图片的路径
@property (nonatomic, copy) NSString<Optional> *minPeriods;         // 最低出借期限
@property (nonatomic, copy) NSString<Optional> *refundTypeStr;      // 还款方式

@property (nonatomic, copy) NSString<Optional> *orderDate;          // 投资日期
@property (nonatomic, copy) NSString<Optional> *interestDate;       // 计息日期
@property (nonatomic, copy) NSString<Optional> *refundDate;         // 到账日期

@end
