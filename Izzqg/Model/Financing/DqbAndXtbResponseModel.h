//
//  DqbAndXtbResponseModel.h
//  Ixyb
//
//  Created by dengjian on 16/9/8.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import "ResponseModel.h"

@interface CardModel : JSONModel

@property (nonatomic, copy) NSString<Optional>* productId;
@property (nonatomic, copy) NSString<Optional>* stime;
@property (nonatomic, copy) NSString<Optional>* etime;
@property (nonatomic, copy) NSString<Optional>* rate;
@property (nonatomic, copy) NSString<Optional>* state;

@end

@interface DqbAndXtbResponseModel : ResponseModel

@property (nonatomic, copy) NSString<Optional>* usableAmount;
@property (nonatomic, copy) NSString<Optional>* usableCard;
@property (nonatomic, copy) NSString<Optional>* income;
@property (nonatomic, copy) NSString<Optional>* canInvestAmount;
@property (nonatomic, copy) NSString<Optional>* rewardAmount;
@property (nonatomic, copy) NSString<Optional>* addIncome;
@property (nonatomic, copy) NSString<Optional>* rate;
@property (nonatomic, copy) NSString<Optional>* periodStr;
@property (nonatomic, strong) CardModel<Optional>* card;

@end

/*
 “usableAmount”: 1997.58,//可用金额
 “usableCard”: yes, //是否有可用的优惠券
 “income”: 3600, //历史收益
 “canInvestAmount”: 27999900, //可投金额
 “resultCode”: 1,
 “card”: {//收益卡
 “id”: 251,
 “stime”: “2015-08-06”,
 “etime”: “2015-08-13”,
 “rate”: 1.2,
 “state”: 0
 },
 “rewardAmount”: 0, //礼金
 “addIncome”: 720 //使用收益卡后的增加收益
 “rate“: 0.08,//利率
 “periodStr“: 12个月,//期限
 */
