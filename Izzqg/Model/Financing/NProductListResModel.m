//
//  NProductListResModel.m
//  Ixyb
//
//  Created by DzgMac on 2017/12/28.
//  Copyright © 2017年 xyb. All rights reserved.
//

#import "NProductListResModel.h"

@implementation NProductModel

+(JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id":@"nproductId"}];
}

@end

@implementation NProductListResModel

@end
