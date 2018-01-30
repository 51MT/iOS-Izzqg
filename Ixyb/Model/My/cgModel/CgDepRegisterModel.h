//
//  CgDepRegisterModel.h
//  Ixyb
//
//  Created by wang on 2017/12/21.
//  Copyright © 2017年 xyb. All rights reserved.
//

#import "ResponseModel.h"

@interface CgDepRegisterModel : ResponseModel

@property (nonatomic,copy) NSString<Optional> *sign;
@property (nonatomic,copy) NSString<Optional> *userDevice;
@property (nonatomic,copy) NSString<Optional> *platformNo;
@property (nonatomic,copy) NSString<Optional> *keySerial;
@property (nonatomic,copy) NSString<Optional> *gatewayUrl;
@property (nonatomic,copy) NSString<Optional> *reqData;
@property (nonatomic,copy) NSString<Optional> *serviceName;

@end
