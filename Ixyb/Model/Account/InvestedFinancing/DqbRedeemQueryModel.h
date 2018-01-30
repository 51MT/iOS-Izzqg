//
//  DqbRedeemQueryModel.h
//  Ixyb
//
//  Created by wang on 16/8/23.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import "ResponseModel.h"

@interface DqbRedeemQueryModel : ResponseModel

@property(nonatomic,copy)NSString <Optional> * addInterest;//addInterest
@property(nonatomic,copy)NSString  <Optional> * amount;//赎回本金
@property(nonatomic,copy)NSString  <Optional> * fee;//提前赎回手续费
@property(nonatomic,copy)NSString  <Optional> * arrivalAmount;//预计到账金额
@property(nonatomic,copy)NSString  <Optional> * interests;//应计利息
@property(nonatomic,copy)NSString  <Optional> * arrivalDate;///预计到账时间
@property(nonatomic,copy)NSString  <Optional> * restDay; //剩余天数

@end
