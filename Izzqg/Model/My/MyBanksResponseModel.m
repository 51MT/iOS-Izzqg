//
//  MyBanksResponseModel.m
//  Ixyb
//
//  Created by wang on 16/7/18.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import "MyBanksResponseModel.h"
@implementation UserBankModel

@end

@implementation BankModel

+(JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id":@"bankId"}];
}

@end

@implementation MyBanksResponseModel

@end
