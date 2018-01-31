//
//  DetailedModel.h
//  Ixyb
//
//  Created by wang on 16/8/22.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import "ResponseModel.h"
#import <JSONModel.h>

@protocol UnRefundListModel

@end

@interface UnRefundListModel : JSONModel

@property(nonatomic,copy)NSString <Optional> * monthIndex;//期数
@property(nonatomic,copy)NSString <Optional> * deadline;//回款时间
@property(nonatomic,copy)NSString <Optional> * principal;//本金
@property(nonatomic,copy)NSString <Optional> * interest;//利息
@property(nonatomic,copy)NSString <Optional> * addInterest;//补息
@property(nonatomic,copy)NSString <Optional> * state;//状态
@property(nonatomic,copy)NSString <Optional> * title;//标题

@end

@interface DetailedModel : ResponseModel

@property(nonatomic,retain)NSArray <UnRefundListModel,Optional> * unRefundList;//待回款列表
@property(nonatomic,retain)NSArray <UnRefundListModel,Optional> * refundList;//已回款列表

@end
