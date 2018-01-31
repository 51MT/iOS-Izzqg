//
//  PosPreApplyModel.h
//  Ixyb
//
//  Created by wang on 16/9/9.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import "ResponseModel.h"

@protocol UserAddressModel
@end
@interface UserAddressModel : JSONModel
@property(nonatomic,copy)NSString <Optional> * userId;
@property(nonatomic,copy)NSString <Optional> * recipients;
@property(nonatomic,copy)NSString <Optional> * provinceCode;
@property(nonatomic,copy)NSString <Optional> * cityCode;
@property(nonatomic,copy)NSString <Optional> * countyCode;
@property(nonatomic,copy)NSString <Optional> * detail;
@property(nonatomic,copy)NSString <Optional> * mobilePhone;
@property(nonatomic,copy)NSString <Optional> * provinceName;
@property(nonatomic,copy)NSString <Optional> * cityName;
@property(nonatomic,copy)NSString <Optional> * countyName;
@end

@interface PosPreApplyModel : ResponseModel
@property(nonatomic,strong)UserAddressModel * userAddress;
@property(nonatomic,copy)NSString <Optional> * price;
@end
