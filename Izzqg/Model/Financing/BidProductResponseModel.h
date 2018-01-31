//
//  BidProductResponseModel.h
//  Ixyb
//
//  Created by 董镇华 on 16/7/20.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import "ResponseModel.h"
#import "BidProduct.h"

@protocol  BidProduct;
@interface BidProductResponseModel : ResponseModel

@property(nonatomic,strong)NSArray <BidProduct>*products;
@property(nonatomic,assign)NSString <Optional>*isNewUser;

@end
