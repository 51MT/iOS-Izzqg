//
//  CgOrderFinishModel.h
//  Ixyb
//
//  Created by wang on 2018/1/3.
//  Copyright © 2018年 xyb. All rights reserved.
//

#import "ResponseModel.h"

@protocol CGOrderListModel

@end

@interface CGOrderListModel : JSONModel

@property(nonatomic,copy)NSString<Optional> *name;  //名称
@property(nonatomic,copy)NSString<Optional> *orderPrin;  //本金
@property(nonatomic,copy)NSString<Optional> *creditInte;  //实际应得利息
@property(nonatomic,copy)NSString<Optional> *createdDate; //时间

@end

@interface CgOrderFinishModel : ResponseModel

@property(nonatomic,strong)NSArray <CGOrderListModel,Optional> * orderList;

@end
