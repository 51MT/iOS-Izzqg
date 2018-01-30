//
//  UserMessageModel.h
//  Ixyb
//
//  Created by wang on 16/7/18.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface UserMessageModel : JSONModel

@property (nonatomic, copy) NSString<Optional> *username;        //手机号码或邮箱
@property (nonatomic, copy) NSString<Optional> *mobilePhone;     //手机
@property (nonatomic, copy) NSString<Optional> *isPhoneAuth;     //是否手机认证
@property (nonatomic, copy) NSString<Optional> *isTradePassword; //是否设置交易密码
@property (nonatomic, copy) NSString<Optional> *isIdentityAuth;  //是否实名认证
@property (nonatomic, copy) NSString<Optional> *isBankSaved;     //是否绑定银行卡
@property (nonatomic, copy) NSString<Optional> *url;             //头像路径
@property (nonatomic, copy) NSString<Optional> *score;           //账户积分
@property (nonatomic, copy) NSString<Optional> *vipLevel;        //用户等级,
@property (nonatomic, copy) NSString<Optional> *bonusState;      //信用宝联盟状态 // 0: 未加入,1: 审核中,2: 已加入
@property (nonatomic, copy) NSString<Optional> *roleName;        //出借顾问"//角色名
@property (nonatomic, copy) NSString<Optional> *birthDate;       //生日
@property (nonatomic, copy) NSString<Optional> *sexStr;          //性别
@property (nonatomic, copy) NSString<Optional> *nickName;        //昵称
@property (nonatomic, copy) NSString<Optional> *isEmailAuth;     //是否邮箱认证
@property (nonatomic, copy) NSString<Optional> *email;           //邮箱
@property (nonatomic, copy) NSString<Optional> *id;
@property (nonatomic, copy) NSString<Optional> *isHaveAddr;
@property (nonatomic, copy) NSString<Optional> *isNewUser;
@property (nonatomic, copy) NSString<Optional> *recommendCode;
@property (nonatomic, copy) NSString<Optional> *sex;
@end
//"username": 手机号码或邮箱,
//"mobilePhone": "手机",
//"isPhoneAuth": “是否手机认证”,
//"isTradePassword": “是否设置交易密码”,
//"isIdentityAuth": “是否实名认证” ,
//"isBankSaved": “是否绑定银行卡”,
//"url" : "头像路径"
//"score": 0 //账户积分,
//"vipLevel": 0 //用户等级,
//"bonusState":信用宝联盟状态 // 0: 未加入,1: 审核中,2: 已加入
//"roleName": "出借顾问"//角色名
//"birthDate": "1900-01-01",//生日
//"sexStr": "女",//性别
//"nickName": "xxx"//昵称
//"isEmailAuth": false,//是否邮箱认证
//"email": xx@qq.com//邮箱
