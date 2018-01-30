//
//  NProductListResModel.h
//  Ixyb
//
//  Created by DzgMac on 2017/12/28.
//  Copyright © 2017年 xyb. All rights reserved.
//

#import "ResponseModel.h"

@protocol NProductModel
@end
@interface NProductModel : JSONModel

@property (nonatomic,copy) NSString<Optional> *nproductId;
@property (nonatomic,copy) NSString<Optional> *name;
@property (nonatomic,copy) NSString<Optional> *rate;
@property (nonatomic,copy) NSString<Optional> *loanMonths;
@property (nonatomic,copy) NSString<Optional> *loanDays;
@property (nonatomic,copy) NSString<Optional> *repayType;
@property (nonatomic,copy) NSString<Optional> *repayTypeStr;
@property (nonatomic,copy) NSString<Optional> *lockMonths;
@property (nonatomic,copy) NSString<Optional> *lockDays;
@property (nonatomic,copy) NSString<Optional> *restAmount;
@property (nonatomic,copy) NSString<Optional> *minInvestAmount;//起投金额
@property (nonatomic,copy) NSString<Optional> *maxInvestAmount;//最大投资金额
@property (nonatomic,copy) NSString<Optional> *currDate;

@end


@interface NProductListResModel : ResponseModel

@property (nonatomic,strong) NSArray<NProductModel,Optional> *productList;

@end
