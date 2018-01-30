//
//  MyPosModel.h
//  Ixyb
//
//  Created by wang on 16/4/7.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 "prizeLogId": 21743,
 "prizeName": "扩大经营（备货）",//奖品名称
 "prizeCode": "MPOS",//奖品代码
 "state": 0,//状态 0:未领用，1：已领用,2:过期
 "freePostage": false //是否包邮
 "applyDate": "2016-01-02",//申领时间
 "endDate": "2016-01-02",//过期时间
 "createdDate": "2016-01-02"//发放时间
 "deliverInfo": {//配送信息
 "state": 0,//配送状态 0未发货，1已发货
 "receiverName": "曹雪峰",
 "receiverAddress": "广东省深圳市南山区高新南一道",
 "receiverPhone": "15013538314",
 "applyDate": "2016-04-07",//申领时间
 "deliverDate": "2016-04-07"//发货时间
 "expressCompany": "EMS"//快递公司
 "expressNo": "2012325648899"//快递单号
 
 }
 */
@interface MyPosModel : NSObject

@property (nonatomic, copy) NSString *prizeLogId;
@property (nonatomic, copy) NSString *prizeName;
@property (nonatomic, copy) NSString *prizeCode;
@property (nonatomic, copy) NSString *applyDate;
@property (nonatomic, copy) NSString *endDate;
@property (nonatomic, copy) NSString *createdDate;
@property (nonatomic, assign) int  state;
@property (nonatomic, assign) BOOL  freePostage;
@property (nonatomic, copy) NSDictionary *deliverInfo;

@end
