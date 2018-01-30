//
//  CheckTheInvestMoney.h
//  Ixyb
//
//  Created by wang on 15/11/18.
//  Copyright © 2015年 xyb. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BbgProductModel.h"
#import "BidProduct.h"
#import "CcProductModel.h"
#import "HUD.h"
#import "NProductListResModel.h"

@interface CheckTheInvestMoney : NSObject

+ (BOOL)checkTheInvestMoney:(NSString *)moneyStr preInvest:(NSDictionary *)preInvestDic fromTag:(NSString *)fromTag prouduct:(BidProduct *)info ccProuduct:(CcProductModel *)ccinfo;

//出借全投金额判断
+ (NSString *)allInvestMoneyPreInvest:(NSDictionary *)preInvestDic fromTag:(NSString *)fromTag prouduct:(BidProduct *)info ccProuduct:(CcProductModel *)ccInfo;

//步步高检测
+ (BOOL)checkTheBbgInvestMoney:(NSString *)moneyStr preInvest:(NSDictionary *)preInvestDic prouduct:(BbgProductModel *)info;


/**
 一键出借产品 全投金额校验

 @param preInvestDic    preInvestDic description
 @param Info            一键出借产品模型
 @return                正确的全投金额
 */
+ (NSString *)np_allInvestMoneyPreInvest:(NSDictionary *)preInvestDic nProuduct:(NProductModel *)info;


/**
 一键出借产品 投资金额校验

 @param moneyStr        投资金额字符串
 @param preInvestDic    preInvestDic description
 @param info            一键出借产品模型
 @return                yes/no
 */
+ (BOOL)checkTheNProductInvestMoney:(NSString *)moneyStr preInvest:(NSDictionary *)preInvestDic prouduct:(NProductModel *)info;


/**
 *    @brief    截取指定小数位的值
 *
 *    @param     price     需要转化的数据
 *    @param     position     有效小数位
 *
 *    @return    截取后数据
 */
+ (NSString *)notRounding:(NSDecimalNumber *)price afterPoint:(NSInteger)position;

@end
