//
//  CcProductResponseModel.h
//  Ixyb
//
//  Created by 董镇华 on 16/7/20.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import "ResponseModel.h"
#import "CcProductModel.h"

@protocol CcProductModel;
@interface CcProductResponseModel : ResponseModel

@property(nonatomic,strong)NSArray <CcProductModel>*products;
@property(nonatomic,copy)NSString <Optional>*isNewUser;

@end
