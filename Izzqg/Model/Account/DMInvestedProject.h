//
//  DMInvestedProject.h
//  Ixyb
//
//  Created by dengjian on 12/11/15.
//  Copyright © 2015 xyb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JSONModel.h>

#import "ResponseModel.h"

/**
 *  已投列表Model
 */
@protocol ProductsProject

@end

@interface ProductsProject : JSONModel

@property (nonatomic, copy) NSString<Optional> *orderId;   //订单ID
@property (nonatomic, copy) NSString<Optional> *projectId; //项目ID
@property (nonatomic, copy) NSString<Optional> *amount;    //出借金额
@property (nonatomic, copy) NSString<Optional> *income;    //出借收益

@property (nonatomic, copy) NSString<Optional> *projectType; //项目类型 1.定期宝 2.信投宝 3.债权转让 4.步步高[CCNNY]
@property (nonatomic, copy) NSString<Optional> *productType; //产品类型 ZZY CCYY CCNY CCNNY

@property (nonatomic, copy) NSString<Optional> *title; //标题产品类型：策诚久久盈
@property (nonatomic, copy) NSString<Optional> *desc;  //描述 扩大经营

@property (nonatomic, copy) NSString<Optional> *investDate;  //出借时间
@property (nonatomic, copy) NSString<Optional> *intrestDate; //计息时间 2015-10-19 14:40:50

@property (nonatomic, copy) NSString<Optional> *actualRate;     //实际利率
@property (nonatomic, copy) NSString<Optional> *monthes2Return; //期限

@property (nonatomic, copy) NSString<Optional> *baseRate; // 基准年化
@property (nonatomic, copy) NSString<Optional> *paddRate; // 每期增加年化
@property (nonatomic, copy) NSString<Optional> *maxRate;  //最大年化

@property (nonatomic, copy) NSString<Optional> *refundTypeStr; //还款方式 到期还本息
@property (nonatomic, copy) NSString<Optional> *orderState;    //订单状态为,项目为定期宝时,1:成功,2:还款结束,3:赎回中

@property (nonatomic, copy) NSString<Optional> *projectState;    //项目状态
@property (nonatomic, copy) NSString<Optional> *projectStateStr; //项目状态描述 发售中

@property (nonatomic, copy) NSString<Optional> *refundDate; //最后回款时间 2017-04-19

@property (nonatomic, copy) NSString<Optional> *interestDay;    //计息日 T（出借日）+2个工作日
@property (nonatomic, copy) NSString<Optional> *assignState;    //转让状态
@property (nonatomic, copy) NSString<Optional> *assignStateStr; //转让状态描述 已投满
@property (nonatomic, copy) NSString<Optional> *assignDate;     //转让日期 2015-10-16 10:58:40

@property (nonatomic, copy) NSString<Optional> *isAssigner;   //是否转让方
@property (nonatomic, copy) NSString<Optional> *acceptAmount; //已转让债权 1000.00
@property (nonatomic, copy) NSString<Optional> *assignAmount; //总的债权额 3744.75



@property (nonatomic, copy) NSString<Optional> *assignProgress; //已投百分比
@property (nonatomic, copy) NSString<Optional> *currentDate;    //当前日期 2015-10-20"
@property (nonatomic, copy) NSString<Optional> *isCanTransfer;  //是否可转让
@property (nonatomic, copy) NSString<Optional> *prepayInterest; //预付利息,
@property (nonatomic, copy) NSString<Optional> *isCanRedeem;    //是否可赎回

@property (nonatomic, copy) NSString<Optional> *restAmount; //剩余债权 2744.75
@property (nonatomic, copy) NSString<Optional> *restDay;    //剩余时间 持有天数

@property (nonatomic, copy) NSString<Optional> *currRebackAmount; //当前赎回金额

@property (nonatomic, copy) NSString<Optional> *addRate; //加息收益率
@property (nonatomic, copy) NSString<Optional> *refundPeriods; //已回款期数
@property (nonatomic, copy) NSString<Optional> *interest; //待收利息
@property (nonatomic, copy) NSString<Optional> *interestBal;//待收补息
@property (nonatomic, copy) NSString<Optional> * rebackDate;//赎回日期
@property (nonatomic, copy) NSString<Optional> * interestDate;//计息周期

@end

@interface DMInvestedProject : ResponseModel

@property (nonatomic, copy) NSString<Optional> *monthCallBackIncome;
@property (nonatomic, copy) NSString<Optional> *totalLoanedAmount;
@property (nonatomic, retain) NSArray<ProductsProject, Optional> *products;

@end

//    "periodsList" [{
//        "periods;1,//期数
//        "periodsStr;"1期",//期数字符串
//        "deadline;"2015-10-16",/
//    }]

//"productInfo; {
//    "orderId; 4970, //订单ID
//    "projectId; 137, //项目ID
//    "amount; 1000.00, //出借金额
//    "income; 100,//出借收益
//    "projectType; 1, //项目类型, 1:定期宝，2:信投宝
//    "productType; "ZZY",//产品类型
//    "title; "策诚久久盈",//标题
//    "description; "扩大经营",//描述
//    "investDate; "2015-10-15 14:40:50",//出借时间
//    "intrestDate; "2015-10-19 14:40:50",//计息时间
//    "actualRate; 0.1950,//实际利率
//    "monthes2Return; "18个月",//期限
//    "refundTypeStr; "到期还本息",//还款方式
//    "orderState;"",//订单状态为,项目为定期宝时,1:成功,2:还款结束,3:赎回中
//    "projectStateStr; "发售中",//项目状态描述
//    "refundDate; "2017-04-19",//最后回款时间
//    "interestDay; "T（出借日）+2个工作日"//计息日
//    "assignState; 3,//转让状态
//    "assignStateStr; "已投满",//转让状态描述
//    "assignDate; "2015-10-16 10:58:40",转让日期
//    "assignAmount; 3744.75,//总的债权额
//    "acceptAmount; 1000.00,//已转让债权
//    "assignProgress; 0.2670,//已投百分比
//    "restAmount; 2744.75//剩余债权
//    "currentDate; "2015-10-20",//当前日期
//    "isAssigner; true,//是否转让方
//    "isCanTransfer; false,//是否可转让
//    "prepayInterest;0.70,//预付利息,
//    "isCanRedeem;true,//是否可赎回
//    "periodsList; [{
//        "periods;1,//期数
//        "periodsStr;"1期",//期数字符串
//        "deadline;"2015-10-16",/
//    }]
