//
//  HqbProduct.h
//  Ixyb
//
//  Created by wang on 15/10/14.
//  Copyright (c) 2015年 xyb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HqbProduct : NSObject
/*    
 "quota": 449900.00,// 今日活期剩余额度
 "totalQuota": 500000,// 今日活期总额度
 "yesterRate": 0.070000,// 昨日年化收益率
 "yesterIncome": 1.944445,// 昨日万元收益
 "investProgress": 0.1,//出借百分百
 "nextTime": "2015-10-15 11:30:00",//下期更新时间
 "currentTime": "2015-10-14 18:09:39"//当前时间

*/

@property (nonatomic, copy) NSString *nextTime; // 下期更新时间
@property (nonatomic, copy) NSString *currentTime; // 当前时间
@property (nonatomic, assign) double quota; //今日活期剩余额度
@property (nonatomic, assign) double totalQuota; // 今日活期总额度
@property (nonatomic, assign) double yesterRate; //昨日年化收益率
@property (nonatomic, assign) double yesterIncome; //  昨日万元收益
@property (nonatomic, assign) double investProgress; // 出借百分百

@end
