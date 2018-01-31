//
//  DMVip.h
//  Ixyb
//
//  Created by dengjian on 11/6/15.
//  Copyright © 2015 xyb. All rights reserved.
//

#import "ResponseModel.h"
#import <Foundation/Foundation.h>

@protocol VipGrowsModel;
@interface VipGrowsModel : JSONModel

@property (nonatomic, assign) NSInteger vip2;
@property (nonatomic, assign) NSInteger vip3;
@property (nonatomic, assign) NSInteger vip4;
@property (nonatomic, assign) NSInteger vip5;
@property (nonatomic, assign) NSInteger vip6;
@property (nonatomic, assign) NSInteger vip7;
@property (nonatomic, assign) NSInteger vip8;
@end

@protocol VIpModel
@end
@interface VIpModel : JSONModel

@property (nonatomic, copy) NSString<Optional> *vipDuetime;
@property (nonatomic, assign) NSInteger currGrow;
@property (nonatomic, assign) NSInteger nextGrow;
@property (nonatomic, copy) NSString<Optional> *scoreRate;
@property (nonatomic, assign) NSInteger increaseCardCount;
@property (nonatomic, assign) NSInteger totalLoginScore;
@property (nonatomic, assign) NSInteger totalBirthdayScore;
@property (nonatomic, assign) NSInteger vipLevel;
@property (nonatomic, assign) NSInteger loginScore;
@property (nonatomic, copy) NSString<Optional> *isExpired; //VIP是否过期
@property (nonatomic, assign) NSInteger totalSignScore;    //签到总积分
@property (nonatomic, assign) double birthReward;          //生日送礼金
@property (nonatomic, assign) int maxLuckyDraw;            //抽奖上限
@property (nonatomic, assign) int firstDaySleepReward;     //每月1号送红包
@property (nonatomic, assign) int zzy;                     //周周盈次数
@property (nonatomic, assign) double serviceFeeDiscount;   //服务费折扣
@property (nonatomic, assign) double increaseCard;         //升级送加息券
@property (nonatomic, strong) VipGrowsModel<Optional> *vipGrows;

@end

@interface DMVip : ResponseModel

@property (nonatomic, strong) VIpModel *vip;

@end
