//
//  XtbPossessionModel.h
//  Ixyb
//
//  Created by wang on 16/8/23.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import "ResponseModel.h"

@interface XtbPossessionModel : ResponseModel

@property(nonatomic,copy)NSString <Optional> * assertValue;//债权价值
@property(nonatomic,copy)NSString <Optional> * assignFee;//转让服务费
@property(nonatomic,copy)NSString <Optional> * assignFeeRate;//让服务费率
@property(nonatomic,copy)NSString <Optional> * assignMinAmount;//最小债权本金
@property(nonatomic,copy)NSString <Optional> * canAssignMonths;//转让时间在计息的*月份数
@property(nonatomic,copy)NSString <Optional> * disScoreAmount;//积分折让费
@property(nonatomic,copy)NSString <Optional> * interest;//应计利息（元）
@property(nonatomic,copy)NSString <Optional> * maxAssignDay;//申请日距离到期日最小天数
@property(nonatomic,copy)NSString <Optional> * minBidAmount;//最低申购金额
@property(nonatomic,copy)NSString <Optional> * addInterest;//加息
@property(nonatomic,copy)NSString <Optional> * actualAmount;//预计到账金额

@end
