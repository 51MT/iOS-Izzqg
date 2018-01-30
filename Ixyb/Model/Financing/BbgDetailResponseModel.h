//
//  BbgDetailResponseModel.h
//  Ixyb
//
//  Created by dengjian on 16/8/18.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import "ResponseModel.h"
#import "BbgProductModel.h"

@interface BbgDetailResponseModel : ResponseModel

@property (nonatomic, strong) BbgProductModel <Optional>*product;

@end
