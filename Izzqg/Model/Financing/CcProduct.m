//
//  CcProduct.m
//  Ixyb
//
//  Created by wangjianimac on 15/8/26.
//  Copyright (c) 2015年 xyb. All rights reserved.
//

#import "CcProduct.h"

@implementation CcProduct

+ (NSDictionary *)replacedKeyFromPropertyName {
    
    return @{
             @"id" : @"id",
             @"type" : @"type",
             @"typeStr" : @"typeStr",
             @"amount" : @"amount",
             @"soldAmount" : @"soldAmount",
             @"periods" : @"periods",
             @"periodsStr" : @"periodsStr",
             @"state" : @"state",
             @"rate" : @"rate",
             @"addRate" : @"addRate",
             @"minBidAmount" : @"minBidAmount",
             @"refundTypeString" : @"refundTypeString",
             @"createdDate": @"createdDate",
             @"sncode":@"sncode",
             @"isNew" : @"isNew",
             @"sort" : @"sort",
             @"restAmount":@"restAmount",
             @"interestDay":@"interestDay",
             @"restInvestCount":@"restInvestCount"
             };
}


- (id) init {
    if((self = [super init])) {
    }
    return self;
}

@end
