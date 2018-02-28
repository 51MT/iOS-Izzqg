//
//  RedemptionInfo.h
//  Ixyb
//
//  Created by wangjianimac on 16/4/11.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RedemptionInfo : NSObject

@property (nonatomic, assign) double amount; //赎回本金
@property (nonatomic, assign) double fee; //提前赎回手续费
@property (nonatomic, assign) double arrivalAmount; //预计到账金额
@property (nonatomic, assign) double interests; //应计利息
@property (nonatomic, copy) NSString *arrivalDate; //预计到账时间

@end
