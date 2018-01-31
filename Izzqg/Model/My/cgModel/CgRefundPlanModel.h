//
//  CgRefundPlanModel.h
//  Ixyb
//
//  Created by wang on 2018/1/3.
//  Copyright © 2018年 xyb. All rights reserved.
//

#import "ResponseModel.h"

@protocol CGRefundListModel

@end

@interface CGRefundListModel : JSONModel

@property(nonatomic,copy)NSString<Optional> *gatherName;  //名称
@property(nonatomic,copy)NSString<Optional> *orderId;     //订单id
@property(nonatomic,copy)NSString<Optional> *periodIndex; //期数
@property(nonatomic,copy)NSString<Optional> *restAmount;  //剩余应还金额
@property(nonatomic,copy)NSString<Optional> *progress;    //回款进度
@property(nonatomic,copy)NSString<Optional> *expectedTime;//回款时间
@property(nonatomic,copy)NSString<Optional> *expectedAmt; //回款总额

@end

@interface CgRefundPlanModel : ResponseModel

@property(nonatomic,strong)NSArray <CGRefundListModel,Optional> * refundList;


@end
