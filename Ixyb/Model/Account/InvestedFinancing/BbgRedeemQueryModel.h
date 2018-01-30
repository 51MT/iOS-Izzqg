//
//  BbgRedeemQueryModel.h
//  Ixyb
//
//  Created by wang on 16/8/23.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import "ResponseModel.h"

@interface BbgRedeemQueryModel : ResponseModel

@property(nonatomic,copy)NSString <Optional> * rebackAmount;
@property(nonatomic,copy)NSString <Optional> * refundDate;

@end
