//
//  WithdrawalsCounterFeeModel.h
//  Ixyb
//
//  Created by wang on 16/8/23.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import "ResponseModel.h"

@interface WithdrawalsCounterFeeModel : ResponseModel

@property (nonatomic, copy) NSString<Optional> *drawMoneyFee;
@property (nonatomic, copy) NSString<Optional> *freeAmount;
@property (nonatomic,copy) NSString <Optional> *actualAmount;
//@property(nonatomic,copy)NSString <Optional> * uncollectedAmount;

@end
