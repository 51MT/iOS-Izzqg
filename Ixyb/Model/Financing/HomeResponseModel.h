//
//  HomeResponseModel.h
//  Ixyb
//
//  Created by dengjian on 16/7/18.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import "LoginUser.h"
#import "RecommendProductModel.h"
#import "ResponseModel.h"

@interface HomeResponseModel : ResponseModel

@property (nonatomic, strong) NSArray<Optional> *indexIcons; //五个入口处的图片路径

@property (nonatomic, strong) RecommendProductModel *recommendProduct; //推荐产品的模型
@property (nonatomic, assign) NSInteger recommendType;                 //推荐类型
@property (nonatomic, assign) NSNumber<Optional> *totalInvestAmount;   //总计出借金额
@property (nonatomic, assign) NSInteger unreadMsg;

@property (nonatomic, strong) LoginUser<Optional> *user; //用户模型
@property (nonatomic, assign) BOOL forceEvaluation;      //是否强制测评

@end

/*
 indexIcons =     (
 );
 
 recommendProduct =     {
 investProgress = 0;
 name = "\U6d3b\U671f\U5b9d";
 quota = 14504;
 rateOfWeek = 0;
 totalQuota = 0;
 yesterIncome = "2.3835";
 yesterRate = "0.08699999999999999";
 };
 
 
 recommendType = 1;
 resultCode = 1;
 totalInvestAmount = 715561471;
 unreadMsg = 0;
 
 user =     {
 isBankSaved = 1;
 isEmailAuth = 0;
 isHaveAddr = 0;
 isIdentityAuth = 1;
 isNewUser = 0;
 isPhoneAuth = 1;
 isTradePassword = 1;
 };
 
*/
