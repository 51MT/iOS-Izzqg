//
//  MyUnionResponseModel.h
//  Ixyb
//
//  Created by dengjian on 16/8/19.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import "ResponseModel.h"

@protocol ReportModel;
@interface ReportModel : JSONModel
@property (nonatomic, assign) double totalAmount;
@property (nonatomic, copy) NSString<Optional> *incomeAmount;
//@property (nonatomic, assign) NSInteger hits;
@property (nonatomic, assign) NSInteger registerNum;
@property (nonatomic, copy) NSString<Optional> *relationlevel;
@end

@interface AllStatModel : JSONModel
@property (nonatomic, assign) double totalAmount;
@property (nonatomic, assign) NSInteger registerNum;
@property (nonatomic, assign) NSInteger hits;
@end

@protocol TodayStatModel;
@interface TodayStatModel : JSONModel
@property (nonatomic, assign) double totalAmount;
@property (nonatomic, assign) NSInteger registerNum;
@property (nonatomic, assign) NSInteger hits;
@end

@interface MyUnionResponseModel : ResponseModel

@property (nonatomic, strong) NSArray<ReportModel, Optional> *yesterdayDetail;
@property (nonatomic, assign) double recommendIncome;
@property (nonatomic, assign) NSInteger userType;
@property (nonatomic, strong) AllStatModel<Optional> *allStat;
@property (nonatomic, strong) TodayStatModel<Optional> *todayStat;
@property (nonatomic, strong) NSArray<ReportModel, Optional> *allDetail;

@end
