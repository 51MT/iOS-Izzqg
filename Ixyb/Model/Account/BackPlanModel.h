//
//  BackPlanModel.h
//  Ixyb
//
//  Created by wang on 15/7/1.
//  Copyright (c) 2015年 xyb. All rights reserved.
//

#import "ResponseModel.h"
#import <Foundation/Foundation.h>
#import <JSONModel.h>

@protocol DetailsModel

@end

@interface DetailsModel : JSONModel
/*           "deadline": "2016-05-23", //日期
 "totalAmount": 4.46,//金额
 "br_title": "审核中借款测试", //标题
 "periodsStr": "12/12期" //期数
 */

@property (strong, nonatomic) NSString<Optional> *deadline;
@property (strong, nonatomic) NSString<Optional> *totalAmount;
@property (strong, nonatomic) NSString<Optional> *br_title;
@property (strong, nonatomic) NSString<Optional> *periodsStr;

@end

@interface BackPlanModel : ResponseModel

@property (nonatomic, retain) NSArray<DetailsModel, Optional> *details;

@end
