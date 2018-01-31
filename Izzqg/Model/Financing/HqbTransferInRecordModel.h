//
//  HqbTransferInRecordModel.h
//  Ixyb
//
//  Created by dengjian on 16/7/19.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import "ResponseModel.h"
#import "TransferInRecordsModel.h"
@protocol TransferInRecordsModel;

@interface HqbTransferInRecordModel : ResponseModel

@property(nonatomic,strong) NSArray <TransferInRecordsModel,Optional> *records;

@end
