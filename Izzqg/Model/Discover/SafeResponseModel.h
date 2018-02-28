//
//  SafeResponseModel.h
//  Ixyb
//
//  Created by wang on 16/7/15.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import "ResponseModel.h"

@interface SafeResponseModel : ResponseModel
/**
 *  风险缓释金
 */
@property (nonatomic, copy) NSString<Optional> *depositAmount;

/**
 *  图片路径
 */
@property (nonatomic, copy) NSString<Optional> *reportImage;

/**
 *  累计成交额
 */
@property (nonatomic, copy) NSString<Optional> *totalInvestAmount;
@end
