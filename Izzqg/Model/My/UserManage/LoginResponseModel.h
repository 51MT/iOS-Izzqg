//
//  LoginResponseModel.h
//  IXsd
//
//  Created by wangjianimac on 16/6/14.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import "ResponseModel.h"

#import "LoginUser.h"

@interface LoginResponseModel : ResponseModel

@property (strong, nonatomic) LoginUser  *user;

@property (strong, nonatomic) NSString<Optional> *sendScore; //赠送积分
@property (strong, nonatomic) NSString *loginToken;          //登录token
@property (nonatomic, assign) BOOL isEvaluation;             //是否测评
@property (nonatomic, assign) BOOL forceEvaluation;          //是否强制测评

@end
