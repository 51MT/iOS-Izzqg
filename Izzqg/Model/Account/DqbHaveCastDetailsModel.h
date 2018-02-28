//
//  DqbHaveCastDetailsModel.h
//  Ixyb
//
//  Created by wang on 2017/9/16.
//  Copyright © 2017年 xyb. All rights reserved.
//

#import "ResponseModel.h"


@protocol  OrderDqbInfoModel



@end
@interface OrderDqbInfoModel : JSONModel
@property(nonatomic,copy)NSString <Optional> *   projectId;//项目ID
@property(nonatomic,copy)NSString <Optional> *   orderId;//订单id
@property(nonatomic,copy)NSString <Optional> *   ccType;//产品类型
@property(nonatomic,copy)NSString <Optional> *   productName;//产品名称
@property(nonatomic,copy)NSString <Optional> *   amount;//投资金额
@property(nonatomic,copy)NSString <Optional> *   rate;//利率
@property(nonatomic,copy)NSString <Optional> *   addRate;//加息利率
@property(nonatomic,copy)NSString <Optional> *   refundTypeStr;//回款方式
@property(nonatomic,copy)NSString <Optional> *   interest;//待收利息
@property(nonatomic,copy)NSString <Optional> *   addInterest;//待收加息
@property(nonatomic,copy)NSString <Optional> *   orderDate;//投资时间
@property(nonatomic,copy)NSString <Optional> *   interestDate;//计息时间
@property(nonatomic,copy)NSString <Optional> *   refundDate;//到账时间
@property(nonatomic,copy)NSString <Optional> *   orderState;//订单状态
@property(nonatomic,copy)NSString <Optional> *   orderStateStr;//状态描述
@property(nonatomic,copy)NSString <Optional> *   canRebackDate;//可赎回时间
@property(nonatomic,copy)NSString <Optional> *   rebackFee;//赎回手续费
@property(nonatomic,copy)NSString <Optional> *   rebackApplyDate;//赎回申请时间
@property(nonatomic,copy)NSString <Optional> *   productType;//项目类型
@property(nonatomic,copy)NSString <Optional> *   actualAmount;//计到账金额
@property(nonatomic,copy)NSString <Optional> *   periods;//回款总期数
@property(nonatomic,copy)NSString <Optional> *   refundPeriods;//已回款期数
@property(nonatomic,copy)NSString <Optional> *   restDay;//剩余天数
@property(nonatomic,copy)NSString <Optional> *   canRedeem;//是否可赎回
@property(nonatomic,copy) NSString <Optional> *  currentDate;//当前日期
@property(nonatomic,copy) NSString <Optional> * projectState;//项目状态 2 招标中 8 还款中
@end

@interface DqbHaveCastDetailsModel : ResponseModel

@property(nonatomic,strong)OrderDqbInfoModel <Optional> * orderInfo;

@end
