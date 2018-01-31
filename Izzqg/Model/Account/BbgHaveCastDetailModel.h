//
//  BbgHaveCastDetailModel.h
//  Ixyb
//
//  Created by wang on 2017/9/19.
//  Copyright © 2017年 xyb. All rights reserved.
//

#import "ResponseModel.h"

@protocol  OrderInfoBbgModel

@end

@interface OrderInfoBbgModel : JSONModel

@property(nonatomic,copy)NSString <Optional> *   title;//标题
@property(nonatomic,copy)NSString <Optional> *   amount;//投资金额
@property(nonatomic,copy)NSString <Optional> *   baseRate;//基准年化
@property(nonatomic,copy)NSString <Optional> *   paddRate;//每期增加年化
@property(nonatomic,copy)NSString <Optional> *   maxRate;//最大年化
@property(nonatomic,copy)NSString <Optional> *   actualRate;//当前年化
@property(nonatomic,copy)NSString <Optional> *   refundTypeStr;//还款方式
@property(nonatomic,copy)NSString <Optional> *   isReback;//是否可赎回
@property(nonatomic,copy)NSString <Optional> *   rebackId;//赎回ID
@property(nonatomic,copy)NSString <Optional> *   investDate;//投资时间
@property(nonatomic,copy)NSString <Optional> *   projectId;//项目ID
@property(nonatomic,copy)NSString <Optional> *   refundDate;//到账时间
@property(nonatomic,copy)NSString <Optional> *   productType;//项目类型
@property(nonatomic,copy)NSString <Optional> *   orderId;//订单ID
@property(nonatomic,copy)NSString <Optional> *   state;//订单状态，1：还款中, 9: 还款结束
@property(nonatomic,copy)NSString <Optional> *   rebackAmount;//已赎回金额
@property(nonatomic,copy)NSString <Optional> *   currRebackAmount;//当前赎回金额
@property(nonatomic,copy)NSString <Optional> *   rebackDate;//赎回日期
@property(nonatomic,copy)NSString <Optional> *   restAmount;//赎回金额
@property(nonatomic,copy)NSString <Optional> *   interestDate;//计息日期
@property(nonatomic,copy)NSString <Optional> *   refundPeriods;//已回款期数
@property(nonatomic,copy)NSString <Optional> *   interest;//待收利息
@property(nonatomic,copy)NSString <Optional> *   interestBal;//待收补息
@property(nonatomic,copy)NSString <Optional> *   restDay;//持有天数
@property(nonatomic,copy) NSString <Optional> * currentDate;//当前日期

@end




@interface BbgHaveCastDetailModel : ResponseModel

@property(nonatomic,strong)OrderInfoBbgModel <Optional> * order;

@end
