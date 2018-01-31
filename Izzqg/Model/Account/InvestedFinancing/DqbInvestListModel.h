//
//  DqbInvestListModel.h
//  Ixyb
//
//  Created by wang on 2017/9/19.
//  Copyright © 2017年 xyb. All rights reserved.
//

#import "ResponseModel.h"

@protocol  DqbOrderListModel

@end
@interface DqbOrderListModel : JSONModel

@property(nonatomic,copy) NSString <Optional> * orderId;//订单Id
@property(nonatomic,copy) NSString <Optional> * projectId;//项目ID
@property(nonatomic,copy) NSString <Optional> * ccType;//定期宝产品类型
@property(nonatomic,copy) NSString <Optional> * productName;//产品名称
@property(nonatomic,copy) NSString <Optional> * amount;//投资金额
@property(nonatomic,copy) NSString <Optional> * rate;//利率
@property(nonatomic,copy) NSString <Optional> * addRate;//加息
@property(nonatomic,copy) NSString <Optional> * interest;//待收利息
@property(nonatomic,copy) NSString <Optional> * addInterest;//待收加息
@property(nonatomic,copy) NSString <Optional> * rebackApplyDate; //申请赎回时间
@property(nonatomic,copy) NSString <Optional> * projectState;//项目状态 2 招标中 8 还款中
@property(nonatomic,copy) NSString <Optional> * orderDate;//投资时间
@property(nonatomic,copy) NSString <Optional> * interestDate;//计息时间
@property(nonatomic,copy) NSString <Optional> * refundDate;//到账时间
@property(nonatomic,copy) NSString <Optional> * currentDate;//当前日期
@property(nonatomic,copy) NSString <Optional> * orderState;//订单状态 项目为定期宝时,1:成功(策诚月盈、双季满盈、周周盈 不可赎回),2:还款结束,3:赎回中

@property(nonatomic,copy) NSString <Optional> * restDay;//剩余天数
@property(nonatomic,copy) NSString <Optional> * rebackFee;//赎回手续费
@property(nonatomic,copy) NSString <Optional> * assignState;//转让状态 0待审核 1转让中 2审核拒绝 3已满标 4还款结束 5已过期
@end

@interface DqbInvestListModel : ResponseModel

@property(nonatomic,strong)NSArray <DqbOrderListModel,Optional> * orderList;
@property(nonatomic,copy) NSString <Optional> * totalLoanedAmount;//出借本金

@end
