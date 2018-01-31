//
//  BorrowUser.h
//  Ixyb
//
//  Created by wang on 15/6/11.
//  Copyright (c) 2015年 xyb. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface BorrowUser : JSONModel

@property (nonatomic, copy) NSString<Optional> *age;
@property (nonatomic, copy) NSString<Optional> *educationBackgroundString;
@property (nonatomic, copy) NSString<Optional> *kidString;
@property (nonatomic, copy) NSString<Optional> *marriageString;
@property (nonatomic, copy) NSString<Optional> *nativeCityString;
@property (nonatomic, copy) NSString<Optional> *sexString;

@end

/*
 "borrowUser": {//借款人信息
 "sexString": "男",//性别
 "age": 26,//年龄
 "nativeCityString": "北京",//出生地
 "kidString": "无",//子女
 "educationBackgroundString": "初中以下",//教育情况
 "marriageString": "未婚"//婚姻状况
 "profession": "金融业"//工作行业
 "workingYears": "4-6年"//工作年限
 "companyName": "深圳信用宝金融"//所在公司名
 "annualSalary": 200000//年薪(元)
 "position": "高层管理"//职位
 } */