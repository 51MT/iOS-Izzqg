//
//  RecommendCommmissionModel.h
//  Ixyb
//
//  Created by wang on 2017/3/8.
//  Copyright © 2017年 xyb. All rights reserved.
//

#import "ResponseModel.h"
@protocol CommissionList ;
@interface CommissionList : JSONModel
@property (nonatomic, copy) NSString <Optional>*closedCycle;//发放周期
@property(nonatomic,copy)   NSString <Optional> * actionDate;//发放时间
@property (nonatomic, copy) NSString <Optional>*interest;//发放金额
@end

@interface RecommendCommmissionModel : ResponseModel
@property (nonatomic, strong) NSArray <CommissionList>*commissionList;
@end
