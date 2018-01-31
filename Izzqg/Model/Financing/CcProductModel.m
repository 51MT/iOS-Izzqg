//
//  CcProductModel.m
//  Ixyb
//
//  Created by 董镇华 on 16/7/18.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import "CcProductModel.h"

@implementation CcProductModel

+(JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id":@"ccId"}];
}

@end
