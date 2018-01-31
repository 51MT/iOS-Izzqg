//
//  XtbInvestListModel.h
//  Ixyb
//
//  Created by wang on 2017/9/19.
//  Copyright © 2017年 xyb. All rights reserved.
//

#import "ResponseModel.h"

@protocol  XtbOrderListModel

@end
@interface XtbOrderListModel : JSONModel

@property(nonatomic,copy) NSString <Optional> * orderId;//订单Id
@property(nonatomic,copy) NSString <Optional> * projectId;//项目ID
@property(nonatomic,copy) NSString <Optional> * amount;//投资金额
@property(nonatomic,copy) NSString <Optional> * title;//产品名称
@property(nonatomic,copy) NSString <Optional> * rate;//利率
@property(nonatomic,copy) NSString <Optional> * addRate;//加息
@property(nonatomic,copy) NSString <Optional> * interest;//待收利息
@property(nonatomic,copy) NSString <Optional> * addInterest;//待收加息
@property(nonatomic,copy) NSString <Optional> * orderDate;//投资时间
@property(nonatomic,copy) NSString <Optional> * orderState;//订单状态
@property(nonatomic,copy) NSString <Optional> * projectState;//项目状态 2 招标中 8 还款中

@property(nonatomic,copy) NSString <Optional> * projectStateStr;//项目状态描述
@property(nonatomic,copy) NSString <Optional> * interestDate;//计息时间
@property(nonatomic,copy) NSString <Optional> * refundDate;//到账时间
@property(nonatomic,copy) NSString <Optional> * restDay;//剩余天数
@property(nonatomic,copy) NSString <Optional> * isCa;//是否是转让标
@property(nonatomic,copy) NSString <Optional> * isAssigner;//是否是转让方
@property(nonatomic,copy) NSString <Optional> * assignDate;//转让时间
@property(nonatomic,copy) NSString <Optional> * assignState;//转让状态 0待审核 1转让中 2审核拒绝 3已满标 4还款结束 5已过期
@property(nonatomic,copy) NSString <Optional> * assignStateStr;//转让状态描述
@property(nonatomic,copy) NSString <Optional> * productType; //项目类型 1.定期宝 2.信投宝 3.债权转让 4.步步高[CCNNY]

@end

@interface XtbInvestListModel : ResponseModel

@property(nonatomic,strong)NSArray <XtbOrderListModel,Optional> * orderList;
@property(nonatomic,copy) NSString <Optional> * totalLoanedAmount;//出借本金

@end
