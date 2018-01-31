//
//  XsdDetailResponseModel.m
//  Ixyb
//
//  Created by dengjian on 16/7/27.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import "XsdDetailResponseModel.h"

@implementation XsdProductModel

+(JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"description" : @"descripe",@"id":@"productId"}];
}

@end


@implementation XsdDetailResponseModel

@end
