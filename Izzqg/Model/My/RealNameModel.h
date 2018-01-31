//
//  RealNameModel.h
//  Ixyb
//
//  Created by wang on 16/9/9.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import "ResponseModel.h"

@interface RealNameModel : ResponseModel
@property(nonatomic,copy)NSString <Optional> * isIdentityAuth;
@property(nonatomic,copy)NSString <Optional> * realName;
@property(nonatomic,copy)NSString <Optional> * idNumber;
@end
