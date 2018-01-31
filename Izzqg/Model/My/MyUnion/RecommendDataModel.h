//
//  RecommendDataModel.h
//  Ixyb
//
//  Created by wang on 16/8/26.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import "ResponseModel.h"
#import "MyUnionResponseModel.h"

@interface RecommendDataModel : ResponseModel

@property (nonatomic, strong) NSArray <ReportModel,Optional> * recommendData;

@end
