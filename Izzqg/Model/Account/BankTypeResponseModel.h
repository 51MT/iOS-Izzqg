//
//  BankTypeResponseModel.h
//  Ixyb
//
//  Created by dengjian on 16/9/9.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import "ResponseModel.h"

@interface BankTypeResponseModel : ResponseModel

@property (nonatomic, copy) NSString<Optional> *bankType; //当输入的银行卡号无法识别时，返回数据只有resultCode，没有bankType，所以此处不能用int接收，要用optional的str接收
@property (nonatomic, copy) NSString<Optional> *bankName;
@property (nonatomic, copy) NSString<Optional> *dayLimit;
@property (nonatomic, copy) NSString<Optional> *monthLimit;
@property (nonatomic, copy) NSString<Optional> *singleLimit;

@end

/*
 "bankType": 1,
 "resultCode": 1,
 "bankName": "中国工商银行"
 "dayLimit": "1万",//当日限额
 "monthLimit": "1万",//当月限额
 "singleLimit": "1万"//单笔限额
*/