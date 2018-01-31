//
//  HqbProductModel.h
//  Ixyb
//
//  Created by 董镇华 on 16/7/18.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import "ResponseModel.h"

@interface HqbProductModel : JSONModel

@property (nonatomic, copy) NSString<Optional> *currentTime; // 当前时间
@property (nonatomic, copy) NSString<Optional> *name;
@property (nonatomic, copy) NSString<Optional> *nextTime; // 下期更新时间
@property (nonatomic, assign) double investProgress;      // 出借百分百
@property (nonatomic, assign) double quota;               //今日活期剩余额度
@property (nonatomic, assign) double rateOfWeek;
@property (nonatomic, assign) double totalQuota;   // 今日活期总额度
@property (nonatomic, assign) double yesterRate;   //昨日年化收益率
@property (nonatomic, assign) double yesterIncome; //  昨日万元收益

@end

/*
    currentTime = "2016-07-19 09:58:04";
    investProgress = 1;
    name = "\U6d3b\U671f\U5b9d";
    nextTime = "2016-07-19 11:00:00";
    quota = 0;
    rateOfWeek = 0;
    totalQuota = 69800;
    yesterIncome = 0;
    yesterRate = 0;
*/
