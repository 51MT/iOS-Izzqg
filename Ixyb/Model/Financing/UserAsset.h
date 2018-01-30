//
//  UserAsset.h
//  Ixyb
//
//  Created by wang on 15/6/11.
//  Copyright (c) 2015年 xyb. All rights reserved.
//

#import "JSONModel.h"

@interface UserAsset : JSONModel

@property (nonatomic, copy) NSString<Optional> *carInfoString;
@property (nonatomic, copy) NSString<Optional> *creditCardString;
@property (nonatomic, copy) NSString<Optional> *creditCardUse;
@property (nonatomic, copy) NSString<Optional> *creditGrade;
@property (nonatomic, copy) NSString<Optional> *houseInfoString;
@property (nonatomic, copy) NSString<Optional> *incomeGradeString;
@property (nonatomic, copy) NSString<Optional> *otherLoan;
@property (nonatomic, assign) long xybScore;

@end

/*
 userAsset =     {
 carInfoString = "\U65e0";
 creditCardString = "\U65e0";
 creditCardUse = "-";
 creditGrade = C;
 houseInfoString = "\U6709\U623f\U4ea7";
 incomeGradeString = "1000\U5143\U4ee5\U4e0b";
 otherLoan = "\U65e0";
 xybScore = 0;
 };

 */

/*
 "userAsset" : {//用户资产信息
 "incomeGradeString" : "1000元以下",//收入
 "carInfoString" : "无",//车产
 "houseInfoString" : "自有房",//房产
 "creditCardString" : "无"//未销户信用卡,
 "otherLoan" : "无",//其他贷款
 "creditCardUse" : "-"//信用卡额度使用
 },
 */
