//
//  MposModel.h
//  Ixyb
//
//  Created by wang on 15/11/9.
//  Copyright © 2015年 xyb. All rights reserved.
//

#import "ResponseModel.h"
#import <Foundation/Foundation.h>
@interface MposModel : ResponseModel
/*{
 "amount": 1000,
 "payFee": 3.80,
 "totalAmount": 1003.80,
 "resultCode": 1
 }*/

@property (nonatomic, assign) double amount;      // 充值金额
@property (nonatomic, assign) double payFee;      // 手续费
@property (nonatomic, assign) double totalAmount; // 总金额
@end
