//
//  CalculatorResponseModel.h
//  Ixyb
//
//  Created by 董镇华 on 16/7/21.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import "ResponseModel.h"

@protocol IncomeList;
@interface CalculatorResponseModel : ResponseModel

@property(nonatomic, assign)double baseRate;
@property(nonatomic, assign)double maxRate;
@property(nonatomic, assign)double padRate;
@property(nonatomic, strong)NSArray<IncomeList> *incomeList;

@end
