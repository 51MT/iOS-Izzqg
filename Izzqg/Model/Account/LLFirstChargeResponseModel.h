//
//  LLFirstChargeResponseModel.h
//  Ixyb
//
//  Created by dengjian on 16/9/9.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import "ChargePayRouteResponseModel.h"
#import "ResponseModel.h"

@interface LLFirstChargeResponseModel : ResponseModel

@property (nonatomic, assign) BOOL supportCard;
@property (nonatomic, strong) LLResultDataModel<Optional> *resultData;

@end