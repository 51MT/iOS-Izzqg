//
//  User.h
//  Ixyb
//
//  Created by wang on 15/5/4.
//  Copyright (c) 2015年 xyb. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <JSONModel/JSONModel.h>

@interface User : JSONModel

@property (nonatomic, copy) NSString<Optional> *userId;
@property (nonatomic, copy) NSString<Optional> *from;
@property (nonatomic, copy) NSString<Optional> *id;
@property (nonatomic, copy) NSString<Optional> *userName;
@property (nonatomic, copy) NSString<Optional> *realName; //真实
@property (nonatomic, copy) NSString<Optional> *email;
@property (nonatomic, copy) NSString<Optional> *tel;
@property (nonatomic, copy) NSString<Optional> *sex; //性别
@property (nonatomic, copy) NSString<Optional> *sexStr;
@property (nonatomic, copy) NSString<Optional> *url;       //头像
@property (nonatomic, copy) NSString<Optional> *roleName;  //角色名
@property (nonatomic, copy) NSString<Optional> *birthDate; //生日
@property (nonatomic, copy) NSString<Optional> *nickName;  //昵称
@property (nonatomic, assign) bool isHaveAddr;             //是否有收货地址
@property (nonatomic, copy) NSString<Optional> *loginToken;

@property (nonatomic, copy) NSString<Optional> *idNumber;        //带有*的身份证号
@property (nonatomic, copy) NSString<Optional> *idNumbers;       //不带有*的身份证号
@property (nonatomic, copy) NSString<Optional> *isPhoneAuth;     //是否手机认证
@property (nonatomic, copy) NSString<Optional> *isTradePassword; //是否设置交易密码
@property (nonatomic, copy) NSString<Optional> *isIdentityAuth;  //是否实名认证
@property (nonatomic, copy) NSString<Optional> *isBankSaved;     //是否绑卡
@property (nonatomic, copy) NSString<Optional> *isWithdrawMoney; //是否成功提现
@property (nonatomic, copy) NSString<Optional> *cgTotalAsset;    //存管总资产
@property (nonatomic, copy) NSString<Optional> *cashOrderPrinAmountTotal; //一键出借本金

@property (nonatomic, copy) NSString<Optional> *isOpenTouID;
@property (nonatomic, copy) NSString<Optional> *depAcctId;       //理财存管账户ID
@property (nonatomic, copy) NSString<Optional> *depBorrowAcctId; //借款存管账户ID
@property (nonatomic, copy) NSString<Optional> *openDep;         //是否开通存管账户

@property (nonatomic, copy) NSString<Optional> *isEvaluation;    //是否评测
@property (nonatomic, copy) NSString<Optional> *evaluatingResult;//风险测评结果

@property (nonatomic, copy) NSString<Optional> *accountNumber;   //银行账号
@property (nonatomic, copy) NSString<Optional> *bankType;        //银行类型
@property (nonatomic, copy) NSString<Optional> *bankName;        //开户支行
@property (nonatomic, copy) NSString<Optional> *bankTypeName;    //银行简称
@property (nonatomic, copy) NSString<Optional> *bankmobilePhone; //预留手机
@property (nonatomic, copy) NSString<Optional> *bankId;          //银行卡ID

@property (nonatomic, copy) NSString<Optional> *recommendCode; //推荐码
@property (nonatomic, copy) NSString<Optional> *referrerCode;  //推荐人的推荐码
@property (nonatomic, copy) NSString<Optional> *depTotalAmount; ///存管账户总资产

@property (nonatomic, copy) NSString<Optional> *usableAmount;           //可用余额
@property (nonatomic, copy) NSString<Optional> *cgUsableAmount;         //存管可用余额
@property (nonatomic, copy) NSString<Optional> *totalAmount;            //资金总额
@property (nonatomic, copy) NSString<Optional> *freezedAmount;          //冻结金额
@property (nonatomic, copy) NSString<Optional> *totalEarnedAmount;      //出借收益
@property (nonatomic, copy) NSString<Optional> *yesterdayEarnedAmount;  //昨日收益
@property (nonatomic, copy) NSString<Optional> *creditScore;            //基础信用分
@property (nonatomic, copy) NSString<Optional> *evaluateDate;           //信用分评测时间
@property (nonatomic, copy) NSString<Optional> *recommendIncome;        //推荐收益
@property (nonatomic, copy) NSString<Optional> *totalInterest2callback; //代收收益
@property (nonatomic, copy) NSString<Optional> *totalLoanedAmount;      //累计出借金额
@property (nonatomic, copy) NSString<Optional> *investedPrincipal;      //资产本金
@property (nonatomic, copy) NSString<Optional> *bbgPrincipal;      // 步步高本金
@property (nonatomic, copy) NSString<Optional> *dqbPrincipal;      // 定期宝本金
@property (nonatomic, copy) NSString<Optional> *xtbPrincipal;      // 信投保本金

@property (nonatomic, copy) NSString<Optional> *hqbRateOfWeek;          //活期宝7日年化收益率
@property (nonatomic, copy) NSString<Optional> *hqbYesterInterest;      //活期宝昨日收益
@property (nonatomic, copy) NSString<Optional> *depositAmount;          //活期宝金额

@property (nonatomic, copy) NSString<Optional> *uncollectedAmount; //借款金额

@property (nonatomic, copy) NSString<Optional> *score;              //账户积分,
@property (nonatomic, copy) NSString<Optional> *vipLevel;           //用户等级
@property (nonatomic, copy) NSString<Optional> *rewardAmount;       //礼金账户
@property (nonatomic, copy) NSString<Optional> *sleepRewordAmount;  //红包账户
@property (nonatomic, copy) NSString<Optional> *increaseCardCount;  //收益卡
@property (nonatomic, copy) NSString<Optional> *toReceivePrincipal; //待收本金

@property (nonatomic, copy) NSString<Optional> *province;
@property (nonatomic, copy) NSString<Optional> *city;
@property (nonatomic, copy) NSString<Optional> *district;

@property (nonatomic, copy) NSString<Optional> *gestureUnlock;       //手势密码
@property (nonatomic, copy) NSString<Optional> *gestureUnlockNumber; //手势密码次数

@property (nonatomic, copy) NSString<Optional> *isNewUser; //是否是新手

@property (nonatomic, copy) NSString<Optional> *vipExpired; //vip是否过期0未过期，1已过期

@property (nonatomic, copy) NSString<Optional> *bonusState; //信用宝联盟状态 // 0: 未加入,1: 审核中,2: 已加入

/**
 *  提现在途10+招标中1",//冻结金额说明
 */
@property (nonatomic, copy) NSString<Optional> *freezedAmountDesc;

//@property (nonatomic, copy) NSString *userId; // 用户ID
//@property (nonatomic, copy) NSString *username; // 用户名：手机号码或邮箱
//@property (nonatomic, assign) bool isPhoneAuth; // 是否手机认证
//@property (nonatomic, assign) bool isTradePassword; // 是否设置交易密码
//@property (nonatomic, assign) bool isIdentityAuth; // 是否实名认证
//@property (nonatomic, assign) bool isBankSaved; // 是否绑定银行卡
//@property (nonatomic, copy) NSString *url; // 头像路径
//@property (nonatomic, copy) NSString *recommendCode; // 推荐码
//@property (nonatomic, assign) bool isUnion;// "信用宝联盟":立即申请、审核中、申请通过
//
//@property (nonatomic, copy) NSString *mobilePhone;// 手机号码
//@property (nonatomic, copy) NSString *realName;// 真实姓名---实名认证、借款时填写的姓名
//@property (nonatomic, copy) NSString *idNumber;// 身份证号
//
////和账户AccountInfo相关（下个版本优化）
//@property (nonatomic, assign) NSInteger score; // 账户积分
//@property (nonatomic, assign) int vipLevel;// 用户等级

@property (nonatomic, assign) bool isEmailAuth;

@end
