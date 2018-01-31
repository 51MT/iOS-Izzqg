//
//  BidProduct.h
//  Ixyb
//
//  Created by wangjianimac on 15/8/26.
//  Copyright (c) 2015年 xyb. All rights reserved.
//

#import "JSONModel.h"

@interface BidProduct : JSONModel

@property (nonatomic, copy) NSString<Optional>* productId;              // 产品Id
@property (nonatomic, copy) NSString<Optional>* title;                  // 标题
@property (nonatomic, copy) NSString<Optional>* productDescription;     // 描述
@property (nonatomic, copy) NSString<Optional>* baseRate;               // 年化利率
//@property (nonatomic, copy) NSString<Optional>* description;            // 简介
@property (nonatomic, copy) NSString<Optional>* purpose;                // 借款用途
@property (nonatomic, copy) NSString<Optional>* loanId;                 // 项目编号
@property (nonatomic, copy) NSString<Optional>* addRate;                // 额外加送利率

@property (nonatomic, copy) NSString<Optional>* monthes2Return;         // 出借期限数值
@property (nonatomic, copy) NSString<Optional>* monthes2ReturnStr;      // 出借期限字符串
@property (nonatomic, copy) NSString<Optional>* bidRequestType;         // 借款类型
@property (nonatomic, copy) NSString<Optional>* returnType;             // 还款方式
@property (nonatomic, copy) NSString<Optional>* returnTypeString;       // 还款方式字符串

@property (nonatomic, copy) NSString<Optional>* bidRequestState;        // 2 招标中，4 已流标，8 还款中(满标)，9 已还清
@property (nonatomic, copy) NSString<Optional>* bidRequestBal;          // 当前剩余可投金额(元)
@property (nonatomic, copy) NSString<Optional>* bidProgressRate;        // 已投百分比
@property (nonatomic, copy) NSString<Optional> *bidRequestTypeString;   // 借款类型字符串


@property (nonatomic, copy) NSString<Optional>* currentSum;             // 当前已投金额
@property (nonatomic, copy) NSString<Optional>* bidRequestAmount;       // 可投总金额
@property (nonatomic, copy) NSString<Optional>* guaranteeMode;          // 保障方式
@property (nonatomic, copy) NSString<Optional> *creditLevel;            // 信用等级
@property (nonatomic, copy) NSString<Optional>* ptype;                  // 产品类型//1：信投宝，2：债权
@property (nonatomic, copy) NSString<Optional>* bidRequestSort;         // 标的类型

@property (nonatomic, copy) NSString<Optional>* minBidAmount;           // 最小限额
@property (nonatomic, copy) NSString<Optional>* maxBidAmount;           // 最大限额

@property (nonatomic, copy) NSString<Optional>* orderDate;              // 投资日期
@property (nonatomic, copy) NSString<Optional>* interestDate;           // 满标日期
@property (nonatomic, copy) NSString<Optional>* refundDate;             // 到账日期

@property (nonatomic, copy) NSString<Optional>* loanStateStr;           // 借款状态


@end

/*
 product =     {
 addRate = 0;
 baseRate = "0.08";
 bidProgressRate = "0.98";
 bidRequestAmount = 55000;
 bidRequestBal = 796;
 bidRequestSort = FLOW;
 bidRequestState = 2;
 bidRequestType = 0;
 bidRequestTypeString = "\U4fe1\U7528\U501f\U6b3e";
 creditLevel = 10;
 currentSum = 54204;
 description = "\U8d2d\U4e70\U519c\U673a";
 guaranteeMode = "\U98ce\U9669\U51c6\U5907\U91d1\U57ab\U4ed8";
 id = 24397;
 maxBidAmount = 55000;
 minBidAmount = 100;
 monthes2Return = 5;
 monthes2ReturnStr = "5\U4e2a\U6708";
 ptype = 1;
 returnType = 5;
 returnTypeString = "\U5230\U671f\U8fd8\U672c\U606f";
 title = "\U8d2d\U4e70\U519c\U673a";
 };

 */
