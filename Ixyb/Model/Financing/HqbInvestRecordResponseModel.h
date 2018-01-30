//
//  HqbInvestRecordResponseModel.h
//  Ixyb
//
//  Created by dengjian on 16/7/26.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import "ResponseModel.h"

@protocol HqbTradeRecords;
@interface HqbTradeRecords : JSONModel

@property(nonatomic, assign)double amount;
@property(nonatomic, copy)NSString *username;
@property(nonatomic, copy)NSString *tradeTime;
@property(nonatomic, copy)NSString *tradeType;

@end

@interface HqbInvestRecordResponseModel : ResponseModel

@property(nonatomic, strong)NSArray <HqbTradeRecords>*tradeRecords;

@end
