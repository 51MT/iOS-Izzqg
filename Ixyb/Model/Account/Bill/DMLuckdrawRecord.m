//
//  DMLuckdrawRecord.m
//  Ixyb
//
//  Created by dengjian on 10/24/15.
//  Copyright © 2015 xyb. All rights reserved.
//

#import "DMLuckdrawRecord.h"

@implementation DMLuckdrawRecord
- (id)init {
    if ((self = [super init])) {
    }
    return self;
}

+ (NSDictionary *)replacedKeyFromPropertyName {

    return @{
        @"createdDate" : @"createdDate",
        @"desc" : @"description",
        @"isSend" : @"isSend",
        @"sendStr" : @"sendStr",
    };
}

@end
