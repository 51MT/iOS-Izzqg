//
//  ProvinceModel.h
//  Ixyb
//
//  Created by wang on 15/7/8.
//  Copyright (c) 2015年 xyb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import  <JSONModel.h>
#import "ResponseModel.h"

@protocol  AreasModel
@end

@interface AreasModel :JSONModel

@property (nonatomic, copy) NSString <Optional> *name;
@property (nonatomic, copy) NSString <Optional> *code;

@end

@interface ProvinceModel : ResponseModel

@property(nonatomic,retain)NSArray <AreasModel,Optional> * areas;

@end
