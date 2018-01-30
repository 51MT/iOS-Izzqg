//
//  DMUpdateInfo.m
//  Ixyb
//
//  Created by dengjian on 12/9/15.
//  Copyright © 2015 xyb. All rights reserved.
//

#import "DMUpdateInfo.h"

@implementation VersionModel
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{ @"id" : @"infoId",
                                                        @"need" : @"isForceUpdate",
                                                        @"remark" : @"updateTips" }];
}
@end

@implementation DMUpdateInfo

@end
