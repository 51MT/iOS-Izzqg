//
//  RealNamesResponseModel.h
//  Ixyb
//
//  Created by wang on 16/7/18.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import "ResponseModel.h"

@interface RealNamesResponseModel : ResponseModel

@property (nonatomic,copy) NSString<Optional> *idNumber;
@property (nonatomic,copy) NSString<Optional> *realName;

@end
