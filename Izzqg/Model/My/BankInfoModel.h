//
//  BankInfoModel.h
//  Ixyb
//
//  Created by wang on 16/6/28.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ResponseModel.h"

@protocol payLimitsModel
@end
@interface payLimitsModel : JSONModel
/**
 *  银行
 */
@property(nonatomic,copy)NSString <Optional>* bankName;

/**
 *  类型
 */
@property(nonatomic,copy)NSString <Optional>* bankType;

/**
 *  日限额
 */
@property(nonatomic,copy)NSString <Optional>* dayLimit;

/**
 *  首笔限额
 */
@property(nonatomic,copy)NSString <Optional>* firstLimit;

/**
 *  月限额
 */
@property(nonatomic,copy)NSString <Optional> * monthLimit;

/**
 *  单笔限额
 */
@property(nonatomic,copy)NSString <Optional> * singleLimit;
@end


@interface BankInfoModel : ResponseModel
@property(nonatomic,retain)NSArray <payLimitsModel,Optional> * payLimits;
@end
