//
//  BbgInvestListModel.h
//  Ixyb
//
//  Created by wang on 2017/9/19.
//  Copyright © 2017年 xyb. All rights reserved.
//

#import "ResponseModel.h"

@protocol  BbgOrderListModel

@end
@interface BbgOrderListModel : JSONModel

@property(nonatomic,copy) NSString <Optional> * orderId;//订单Id
@property(nonatomic,copy) NSString <Optional> * projectId;//项目ID
@property(nonatomic,copy) NSString <Optional> * amount;//投资金额
@property(nonatomic,copy) NSString <Optional> * state;//状态
@property(nonatomic,copy) NSString <Optional> * actualRate;//利率
@property(nonatomic,copy) NSString <Optional> * investDate;//投资时间
@property(nonatomic,copy) NSString <Optional> * interestDate;//计息时间
@property(nonatomic,copy) NSString <Optional> * refundDate;//到账时间
@property(nonatomic,copy) NSString <Optional> * restDay;//持有天数
@property(nonatomic,copy) NSString <Optional> * title;//项目名称

@end



@interface BbgInvestListModel : ResponseModel

@property(nonatomic,strong)NSArray <BbgOrderListModel,Optional> * orderList;
@property(nonatomic,copy) NSString <Optional> * totalLoanedAmount;//出借本金

@end
