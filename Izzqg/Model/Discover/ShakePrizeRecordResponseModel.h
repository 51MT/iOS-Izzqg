//
//  ShakeWinRecordResponseModel.h
//  Ixyb
//
//  Created by dengjian on 16/7/27.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import "ResponseModel.h"

@protocol DeliverInfoModel;
@interface DeliverInfoModel : JSONModel

@property (nonatomic, assign) NSInteger state;
@property (nonatomic, copy) NSString<Optional> *receiverName;
@property (nonatomic, copy) NSString<Optional> *receiverAddress;
@property (nonatomic, copy) NSString<Optional> *receiverPhone;
@property (nonatomic, copy) NSString<Optional> *expressCompany;
@property (nonatomic, copy) NSString<Optional> *expressNo;
@property (nonatomic, copy) NSString<Optional> *applyDate;
@property (nonatomic, copy) NSString<Optional> *deliverDate;

@end

@protocol SingleRewardModel;
@interface SingleRewardModel : JSONModel

@property (nonatomic, copy) NSString<Optional> *prizeLogId;
@property (nonatomic, copy) NSString<Optional> *prizeName;
@property (nonatomic, copy) NSString<Optional> *prizeCode;
@property (nonatomic, copy) NSString<Optional> *prizePrice;
@property (nonatomic, assign) NSInteger state;      //状态 0:未领用，1：已领用,2:过期
@property (nonatomic, assign) NSInteger isPhysical; //0:虚拟商品 1:实物商品
@property (nonatomic, copy) NSString<Optional> *applyDate;
@property (nonatomic, copy) NSString<Optional> *endDate;
@property (nonatomic, copy) NSString<Optional> *createdDate;
@property (nonatomic, strong) DeliverInfoModel<Optional> *deliverInfo;

@end

@interface ShakePrizeRecordResponseModel : ResponseModel

@property (nonatomic, strong) NSArray<SingleRewardModel, Optional> *prizeInfos;

@end

/*
 
 "prizeLogId": 131339,
 "prizeName": "MPOS刷卡器",
 "prizeCode": "MPOS",
 "prizePrice": 140,
 "state": 1,//状态 0:未领用，1：已领用,2:过期
 "isPhysical": 1,//实物商品
 "applyDate": "2016-01-02",//申领时间
 "endDate": "2016-01-02",//过期时间
 "createdDate": "2016-01-02"//发放时间
 
 */