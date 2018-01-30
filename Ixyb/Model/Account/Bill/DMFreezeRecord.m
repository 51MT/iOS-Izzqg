//
//  DMFreezeRecord.m
//  Ixyb
//
//  Created by dengjian on 10/24/15.
//  Copyright © 2015 xyb. All rights reserved.
//

#import "DMFreezeRecord.h"

@implementation FreezeListRecord

+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{ @"description" : @"desc" }];
}

@end
@implementation DMFreezeRecord
- (id)init {
    if ((self = [super init])) {
    }
    return self;
}
@end
