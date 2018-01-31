//
//  DMCreditScore.h
//  Ixyb
//
//  Created by dengjian on 11/25/15.
//  Copyright © 2015 xyb. All rights reserved.
//

#import "JSONModel.h"

@interface DMCreditScore : JSONModel

@property (nonatomic, assign) NSInteger personInfo;
@property (nonatomic, assign) NSInteger creditInfo;
@property (nonatomic, copy) NSString *creditLevel;
@property (nonatomic, assign) NSInteger enterpriseInfo;
@property (nonatomic, assign) NSInteger securedInfo;
@property (nonatomic, assign) NSInteger totalCreditInfo;
@property (nonatomic, assign) NSInteger totalEnterpriseInfo;
@property (nonatomic, assign) NSInteger totalPersonInfo;
@property (nonatomic, assign) NSInteger totalSecuredInfo;
@property (nonatomic, assign) NSInteger xybScore;

@end

/*
 creditScore =     {
 creditInfo = 106;
 creditLevel = 10;
 enterpriseInfo = 106;
 personInfo = 154;
 securedInfo = 214;
 totalCreditInfo = 115;
 totalEnterpriseInfo = 172;
 totalPersonInfo = 288;
 totalSecuredInfo = 225;
 xybScore = 580;
 };

 */
