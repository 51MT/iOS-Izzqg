//
//  CgAssignDetailModel.h
//  Ixyb
//
//  Created by wang on 2018/1/3.
//  Copyright © 2018年 xyb. All rights reserved.
//

#import "ResponseModel.h"

@protocol CGAssignDetailListModel

@end

@interface CGAssignDetailListModel : JSONModel

@property(nonatomic,copy)NSString<Optional> *lastModifiedDate;  //转让时间
@property(nonatomic,copy)NSString<Optional> *assignAmt;         //转让金额
@property(nonatomic,copy)NSString<Optional> *assignFee;         //服务费
@property(nonatomic,copy)NSString<Optional> *sumPreInte;        //垫付利息
@property(nonatomic,copy)NSString<Optional> *acceptAmt;

@end

@interface CgAssignDetailModel : ResponseModel

@property(nonatomic,strong)CGAssignDetailListModel * assignDetail;

@end
