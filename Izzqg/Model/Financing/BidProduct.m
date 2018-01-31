//
//  BidProduct.m
//  Ixyb
//
//  Created by wangjianimac on 15/8/26.
//  Copyright (c) 2015年 xyb. All rights reserved.
//

#import "BidProduct.h"

@implementation BidProduct

+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id":@"productId",@"description":@"productDescription"}];
}

@end
