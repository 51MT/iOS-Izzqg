//
//  UserAddress.m
//  Ixyb
//
//  Created by wangjianimac on 15/12/15.
//  Copyright © 2015年 xyb. All rights reserved.
//

#import "UserAddress.h"

@implementation UserAddress


- (id) initWithCoder: (NSCoder *)coder {
    if (self = [super init]) {
        self.userId = [coder decodeObjectForKey:@"userId"];
        self.recipients = [coder decodeObjectForKey:@"recipients"];
        self.mobilePhone = [coder decodeObjectForKey:@"mobilePhone"];
        self.detail = [coder decodeObjectForKey:@"detail"];
        self.provinceCode = [coder decodeObjectForKey:@"provinceCode"];
        self.provinceName = [coder decodeObjectForKey:@"provinceName"];
        self.cityCode = [coder decodeObjectForKey:@"cityCode"];
        self.cityName = [coder decodeObjectForKey:@"cityName"];
        self.countyCode = [coder decodeObjectForKey:@"countyCode"];
        self.countyName = [coder decodeObjectForKey:@"countyName"];
    }
    return self;
}

- (void) encodeWithCoder: (NSCoder *)coder {
    [coder encodeObject:_userId forKey:@"userId"];
    [coder encodeObject:_recipients forKey:@"recipients"];
    [coder encodeObject:_mobilePhone forKey:@"mobilePhone"];
    [coder encodeObject:_detail forKey:@"detail"];
    [coder encodeObject:_provinceCode forKey:@"provinceCode"];
    [coder encodeObject:_provinceName forKey:@"provinceName"];
    [coder encodeObject:_cityCode forKey:@"cityCode"];
    [coder encodeObject:_cityName forKey:@"cityName"];
    [coder encodeObject:_countyCode forKey:@"countyCode"];
    [coder encodeObject:_countyName forKey:@"countyName"];
}


@end
