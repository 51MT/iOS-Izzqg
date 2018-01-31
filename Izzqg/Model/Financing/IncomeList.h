//
//  IncomeList.h
//  Ixyb
//
//  Created by 董镇华 on 16/7/21.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface IncomeList : JSONModel

@property(nonatomic, assign)double rate;
@property(nonatomic, assign)double income;
@property(nonatomic, assign)NSInteger month;

@end
