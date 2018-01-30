//
//  BbgInvestRecordResponseModel.h
//  Ixyb
//
//  Created by dengjian on 16/7/26.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import "ResponseModel.h"

@protocol BbgTradeRecords;
@interface  BbgTradeRecords: JSONModel

@property(nonatomic, assign)double amount;
@property(nonatomic, copy)NSString *username;
@property(nonatomic, copy)NSString *tradeTime;

@end

@interface BbgInvestRecordResponseModel : ResponseModel

@property(nonatomic, strong)NSArray <BbgTradeRecords,Optional>*tradeRecords;

@end




/*
 {
 "resultCode": 1,
 "tradeRecords": [
 {
 "amount": 400,
 "username": "u********6",
 "tradeTime": "2016-07-21 23:48:24"
 }
 ]
 }
 
 */
