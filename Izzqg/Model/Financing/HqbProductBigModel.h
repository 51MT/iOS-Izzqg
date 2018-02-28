//
//  HqbProductBigModel.h
//  Ixyb
//
//  Created by dengjian on 16/7/19.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import "HqbProductModel.h"
#import "ResponseModel.h"

@interface HqbProductBigModel : ResponseModel

@property (nonatomic, strong) HqbProductModel<Optional> *product;

@end
