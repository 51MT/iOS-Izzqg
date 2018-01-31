//
//  SleepRewardAccountModel.h
//  Ixyb
//
//  Created by wang on 15/8/8.
//  Copyright (c) 2015年 xyb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JSONModel.h>
#import "ResponseModel.h"

@protocol SleepRewardAccountDetailListModel


@end

@interface SleepRewardAccountDetailListModel : JSONModel
/*
 "createTime":"2015-08-06 14:51:34",//领取时间
 "reward":"10,000.00",/金额
 "issueTypeStr":"活动赠送",//途径
 "streamTypeStr":0//交易类型，备注：0：已获取；1：已解冻；2：已过期
 */
@property(strong ,nonatomic)NSString <Optional>*createTime;
@property(strong ,nonatomic)NSString <Optional> *reward;
@property(strong ,nonatomic)NSString <Optional> *issueTypeStr;
@property(strong ,nonatomic)NSString <Optional>*streamTypeStr;

@end

@interface SleepRewardAccountModel : ResponseModel


@property(nonatomic,retain)NSArray <SleepRewardAccountDetailListModel,Optional> * sleepRewardAccountDetailList;

@end
