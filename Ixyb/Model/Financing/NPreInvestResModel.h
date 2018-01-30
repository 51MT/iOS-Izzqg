//
//  NPreInvestResModel.h
//  Ixyb
//
//  Created by DzgMac on 2018/1/1.
//  Copyright © 2018年 xyb. All rights reserved.
//

#import "ResponseModel.h"
#import "NProductListResModel.h"

@interface NPreInvestResModel : ResponseModel

@property (nonatomic,strong) NProductModel<Optional> *productInfo;
@property (nonatomic,copy) NSString<Optional> *isEvaluation;
@property (nonatomic,copy) NSString<Optional> *usableAmt;
@property (nonatomic,copy) NSString<Optional> *depAcctId;

@end
