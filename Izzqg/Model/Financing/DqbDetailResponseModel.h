//
//  DqbDetailResponseModel.h
//  Ixyb
//
//  Created by dengjian on 16/8/18.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import "ResponseModel.h"
#import "CcProductModel.h"

@interface DqbDetailResponseModel : ResponseModel

@property (nonatomic, strong) CcProductModel *product;

@end
