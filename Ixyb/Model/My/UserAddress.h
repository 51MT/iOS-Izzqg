//
//  UserAddress.h
//  Ixyb
//
//  Created by wangjianimac on 15/12/15.
//  Copyright © 2015年 xyb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JSONModel/JSONModel.h>

@interface UserAddress :JSONModel

@property (nonatomic, strong) NSString <Optional>*userId;
@property (nonatomic, strong) NSString <Optional>*recipients;
@property (nonatomic, strong) NSString <Optional>*mobilePhone;
@property (nonatomic, strong) NSString <Optional>*detail;
@property (nonatomic, strong) NSString <Optional>*provinceName;
@property (nonatomic, strong) NSString <Optional>*provinceCode;
@property (nonatomic, strong) NSString <Optional>*cityName;
@property (nonatomic, strong) NSString <Optional>*cityCode;
@property (nonatomic, strong) NSString <Optional>*countyName;
@property (nonatomic, strong) NSString <Optional>*countyCode;

@end


//                userAddress.userId = [userAddressDic objectForKey:@"userId"];
//                userAddress.recipients = [userAddressDic objectForKey:@"recipients"];
//                userAddress.mobilePhone = [userAddressDic objectForKey:@"mobilePhone"];
//                userAddress.detail = [userAddressDic objectForKey:@"detail"];
//                userAddress.provinceName = [userAddressDic objectForKey:@"provinceName"];
//                userAddress.provinceCode = [userAddressDic objectForKey:@"provinceCode"];
//                userAddress.cityName = [userAddressDic objectForKey:@"cityName"];
//                userAddress.cityCode = [userAddressDic objectForKey:@"cityCode"];
//                userAddress.countyName = [userAddressDic objectForKey:@"countyName"];
//                userAddress.countyCode = [userAddressDic objectForKey:@"countyCode"];