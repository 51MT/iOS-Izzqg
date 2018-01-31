//
//  XsdDetailResponseModel.h
//  Ixyb
//
//  Created by dengjian on 16/7/27.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import "ResponseModel.h"
#import "XtbDetailResponseModel.h"
#import "XtbZqzrInvestRecordResponseModel.h"

@protocol XsdProductModel;

@interface XsdProductModel : JSONModel

@property (nonatomic, copy) NSString<Optional>* title;    //标题
@property (nonatomic, copy) NSString<Optional>* descripe; //描述
@property (nonatomic, copy) NSString<Optional>* baseRate;            //年化利率
@property (nonatomic, copy) NSString<Optional>* addRate;             //加送利率

@property (nonatomic, copy) NSString<Optional>* monthes2Return;            //出借期限数值
@property (nonatomic, copy) NSString<Optional>* monthes2ReturnStr; //出借期限字符串
@property (nonatomic, copy) NSString<Optional>* bidRequestType;            //借款类型
@property (nonatomic, copy) NSString<Optional>* returnType;                //还款方式类型

@property (nonatomic, copy) NSString<Optional>* returnTypeString; //还款方式
@property (nonatomic, copy) NSString<Optional>* bidRequestState;          //标的状态
@property (nonatomic, copy) NSString<Optional>* bidRequestSort;   //标的类型
@property (nonatomic, copy) NSString<Optional>* bidRequestBal;               //剩余可投金额

@property (nonatomic, copy) NSString<Optional>* bidProgressRate;                 //已投百分百
@property (nonatomic, copy) NSString<Optional>* bidRequestTypeString; //抵押借款
@property (nonatomic, copy) NSString<Optional>* currentSum;                      //已投金额
@property (nonatomic, copy) NSString<Optional>* bidRequestAmount;                //可投总金额

@property (nonatomic, copy) NSString<Optional>* guaranteeMode; //保障方式
@property (nonatomic, copy) NSString<Optional>* productId;             //productId
@property (nonatomic, copy) NSString<Optional>* creditLevel;           //信用等级
@property (nonatomic, copy) NSString<Optional>* minBidAmount;             //最小限额
@property (nonatomic, copy) NSString<Optional>* maxBidAmount;             //最大限额

@property (nonatomic, copy) NSString<Optional>* orderDate;              // 起借日期
@property (nonatomic, copy) NSString<Optional>* interestDate;           // 满标日期
@property (nonatomic, copy) NSString<Optional>* refundDate;             // 到账日期

@end


@interface XsdDetailResponseModel : ResponseModel

@property (nonatomic, strong) XsdProductModel<Optional> *product;
@property (nonatomic, strong) NSArray <BidsModel,Optional>* bidList;
@property (nonatomic, strong) NSArray<DetailListModel,Optional>* detailList;

@end
