//
//  LoginUser.h
//  Ixyb
//
//  Created by wangjianimac on 16/7/13.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <JSONModel/JSONModel.h>

@interface LoginUser : JSONModel

@property (strong, nonatomic) NSString<Optional> *id; //用户id

@property (strong, nonatomic) NSString<Optional> *recommendCode; //推荐码
@property (strong, nonatomic) NSString<Optional> *mobilePhone;   //手机
@property (strong, nonatomic) NSString<Optional> *username;      //用户名

@property (strong, nonatomic) NSString<Optional> *isPhoneAuth;     //是否手机认证
@property (strong, nonatomic) NSString<Optional> *isTradePassword; //是否设置交易密码
@property (strong, nonatomic) NSString<Optional> *isIdentityAuth;  //是否实名认证
@property (strong, nonatomic) NSString<Optional> *isBankSaved;     //是否绑定银行卡

@property (strong, nonatomic) NSString<Optional> *url;       //头像路径
@property (strong, nonatomic) NSString<Optional> *isNewUser; //是否新手
@property (strong, nonatomic) NSString<Optional> *realName;  //真实姓名

@property(strong,nonatomic)NSString <Optional> * idNumber; //身份证

@property (strong, nonatomic) NSString<Optional> *bonusState;
@property (strong, nonatomic) NSString<Optional> *email;

@property (strong, nonatomic) NSString<Optional> *isEmailAuth;
@property (strong, nonatomic) NSString<Optional> *isHaveAddr;

@property (strong, nonatomic) NSString<Optional> *nickName;
@property (strong, nonatomic) NSString<Optional> *score;
@property (strong, nonatomic) NSString<Optional> *vipLevel;

@end

//"id" : 36055, "recommendCode" : 推荐码, "mobilePhone" : "手机", "username" : "15602967391", "isPhoneAuth" : “是否手机认证”, "isTradePassword" : “是否设置交易密码”, "isIdentityAuth" : “是否实名认证, "isBankSaved" : “是否绑定银行卡”"url" : "头像路径", "isNewUser" : true //是否新手 "realName" : "真实姓名"

//{
//    loginToken = 7b933cafb77302bfa1ebc631313b87bdd3d7527c;
//    resultCode = 1;
//    sendScore = 0;
//    user =     {
//        bonusState = 2;
//        email = "wan***@xyb100.com";
//        id = 33481;
//        isBankSaved = 1;
//        isEmailAuth = 0;
//        isHaveAddr = 0;
//        isIdentityAuth = 1;
//        isNewUser = 0;
//        isPhoneAuth = 1;
//        isTradePassword = 1;
//        mobilePhone = 15889406352;
//        nickName = "\U751f\U4ea7\U73af\U5883";
//        recommendCode = 406352;
//        score = 11636;
//        url = "";
//        username = "158****6352";
//        vipLevel = 1;
//    };
//}
