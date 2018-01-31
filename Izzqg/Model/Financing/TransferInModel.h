//
//  TransferInModel.h
//  Ixyb
//
//  Created by dengjian on 16/7/19.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import "ResponseModel.h"

@interface TransferInModel : ResponseModel

@property(nonatomic,assign) double depositAmount;
@property(nonatomic,assign) double quota;
@property(nonatomic,assign) double usableAmount;
@property(nonatomic,assign) double yesterRate;

@end


/*
 depositAmount = 32170;
 quota = 2000;
 resultCode = 1;
 usableAmount = "67556.92999999999";
 yesterRate = "0.08699999999999999";
 
 */