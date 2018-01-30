//
//  NPinvestResModel.h
//  Ixyb
//
//  Created by DzgMac on 2018/1/1.
//  Copyright © 2018年 xyb. All rights reserved.
//

#import "ResponseModel.h"

@interface NPinvestResModel : ResponseModel

@property (nonatomic,copy) NSString<Optional> *orderDate;
@property (nonatomic,copy) NSString<Optional> *productType;
@property (nonatomic,copy) NSString<Optional> *orderId;
@property (nonatomic,copy) NSString<Optional> *amount;

@end
