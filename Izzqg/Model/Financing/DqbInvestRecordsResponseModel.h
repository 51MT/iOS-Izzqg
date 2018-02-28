//
//  DqbInvestRecordsResponseModel.h
//  Ixyb
//
//  Created by dengjian on 16/8/18.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import "ResponseModel.h"

@interface TrendRecordInfo : JSONModel

@property (strong, nonatomic) NSString *username;
@property (strong, nonatomic) NSString *amount;
@property (strong, nonatomic) NSString *createdDate;

@end

@protocol TrendRecordInfo ;
@interface DqbInvestRecordsResponseModel : ResponseModel

@property (nonatomic, strong) NSArray <TrendRecordInfo>*projects;

@end
