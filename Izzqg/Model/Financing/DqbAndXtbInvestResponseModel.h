//
//  DqbInvestModel.h
//  Ixyb
//
//  Created by dengjian on 16/9/8.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import "ResponseModel.h"

@interface DqbAndXtbInvestResponseModel : ResponseModel

@property (nonatomic, copy) NSString<Optional> *startDate;
@property (nonatomic, copy) NSString<Optional> *toAccountDate;
@property (nonatomic, copy) NSString *orderDate;
@property (nonatomic, copy) NSString *orderId;
@property (nonatomic, copy) NSString *productType;

@end

/* 定期宝
 resultCode: 1
 startDate:计息时间
 toAccountDate：到帐时间
 orderDate:出借时间
 "firstReward":"首投赠送礼金",
 "activeReward":"活动赠送礼金"
 "orderId":123654,//订单ID
 "productType":CC,//产品类型
 }
 */

/* 信投宝
 resultCode: 1,
 orderDate:出借时间
 "firstReward":"首投赠送礼金",
 "activeReward":"活动赠送礼金"
 "orderId":123654,//订单ID
 "productType":CC,//产品类型
 */
