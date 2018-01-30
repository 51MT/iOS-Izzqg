//
//  BbgRedeemModel.h
//  Ixyb
//
//  Created by wang on 16/8/22.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import "ResponseModel.h"

@interface BbgRedeemModel : ResponseModel

@property(nonatomic,copy)NSString <Optional> * currentTime;
@property(nonatomic,copy)NSString <Optional> * rebackAmount;
@property(nonatomic,copy)NSString <Optional> * refundDate;

@end
