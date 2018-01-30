//
//  XtbHaveCastDetailModel.h
//  Ixyb
//
//  Created by wang on 2017/9/16.
//  Copyright © 2017年 xyb. All rights reserved.
//

#import "ResponseModel.h"

@protocol  OrderInfoXtbModel



@end
@interface OrderInfoXtbModel : JSONModel

@property(nonatomic,copy)NSString <Optional> *   projectId;//项目ID
@property(nonatomic,copy)NSString <Optional> *   orderId;//订单id
@property(nonatomic,copy)NSString <Optional> *   amount;//投资金额
@property(nonatomic,copy)NSString <Optional> *   title;//信投保标题
@property(nonatomic,copy)NSString <Optional> *   rate;//利率
@property(nonatomic,copy)NSString <Optional> *   isCa;////是否是转让标
@property(nonatomic,copy)NSString <Optional> *   addRate;//加息利率
@property(nonatomic,copy)NSString <Optional> *   productType;//项目类型
@property(nonatomic,copy)NSString <Optional> *   interest;//待收利息
@property(nonatomic,copy)NSString <Optional> *   addInterest;//待收加息
@property(nonatomic,copy)NSString <Optional> *   orderDate;//投资时间
@property(nonatomic,copy)NSString <Optional> *   interestDate;//计息时间
@property(nonatomic,copy)NSString <Optional> *   refundDate;//到账时间
@property(nonatomic,copy)NSString <Optional> *   orderState;//订单状态
@property(nonatomic,copy)NSString <Optional> *   refundTypeStr;//回款方式
@property(nonatomic,copy)NSString <Optional> *   periods;//回款总期数
@property(nonatomic,copy)NSString <Optional> *   refundPeriods;//已回款期数
@property(nonatomic,copy)NSString <Optional> *   projectStateStr;//项目状态
@property(nonatomic,copy)NSString <Optional> *   assignDate;//转让时间
@property(nonatomic,copy)NSString <Optional> *   assignAmount;//转让金额
@property(nonatomic,copy)NSString <Optional> *   acceptAmount;//已承接金额
@property(nonatomic,copy)NSString <Optional> *   assignState;//转让状态
@property(nonatomic,copy)NSString <Optional> *   assignStateStr;//转让状态
@property(nonatomic,copy)NSString <Optional> *   restDay;//剩余天数
@property(nonatomic,copy)NSString <Optional> *   isAssigner;//是否转让方
@property(nonatomic,copy)NSString <Optional> *   isCanAssign;//是否可转让
@property(nonatomic,copy)NSString <Optional> *   assignFee;//转让服务费
@property(nonatomic,copy)NSString <Optional> *   currentDate;//当前时间
@property(nonatomic,copy)NSString <Optional> *   disScoreFee;//积分折让费
@property(nonatomic,copy)NSString <Optional> *   assignInterest;//应计利息
@property(nonatomic,copy)NSString <Optional> *   assignAddInterest;//应计加息
@property(nonatomic,copy) NSString <Optional> *  projectState;//项目状态 2 招标中 8 还款中

@end

@interface XtbHaveCastDetailModel : ResponseModel

@property(nonatomic,strong)OrderInfoXtbModel <Optional> * orderInfo;


@end
