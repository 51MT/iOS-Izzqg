//
//  ZqzrInvestResponseModel.h
//  Ixyb
//
//  Created by 董镇华 on 16/9/27.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import "ResponseModel.h"

@interface ZqzrInvestResponseModel : ResponseModel

@property (nonatomic, copy) NSString<Optional> *orderId;
@property (nonatomic, copy) NSString<Optional> *productType;
@property (nonatomic, copy) NSString<Optional> *orderDate; //出借成功日期
@property (nonatomic, copy) NSString<Optional> *startDate; //计息时间

@end

/*
 "resultCode": 1
 "firstReward":"首投赠送礼金",
 "activeReward":"活动赠送礼金"
 "orderId":123654,//订单ID
 "productType":CC,//产品类型
 */
