//
//  AuthRealNameResponseModel.h
//  Ixyb
//
//  Created by dengjian on 16/8/18.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import "ResponseModel.h"

@interface AuthRealNameResponseModel : ResponseModel

@property (nonatomic ,assign) BOOL isIdentityAuth;//是否认证通过
@property (nonatomic, copy) NSString <Optional>*realName;
@property (nonatomic, copy) NSString <Optional>*idNumber;

@end
