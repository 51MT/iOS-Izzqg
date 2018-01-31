//
//  CGAccountStatModel.h
//  Ixyb
//
//  Created by wang on 2017/12/23.
//  Copyright © 2017年 xyb. All rights reserved.
//

#import "ResponseModel.h"

@protocol AccountStatInfoModel

@end

@interface AccountStatInfoModel : JSONModel
@property (nonatomic, copy) NSString<Optional> *rechargeAmountTotal;           // 累计充值
@property (nonatomic, copy) NSString<Optional> *rechargeIngAmountTotal;        // 充值中金额
@property (nonatomic, copy) NSString<Optional> *withdrawAmountTotal;           // 累计提现
@property (nonatomic, copy) NSString<Optional> *actualInteAmountTotal;         // 累计出借收益
@property (nonatomic, copy) NSString<Optional> *depositAmountTotal;            // 累计出借
@property (nonatomic, copy) NSString<Optional> *expectedInteAmountTotal;       // 待收利息
@property (nonatomic, copy) NSString<Optional> *cashOrderPrinAmountTotal;      // 一键出借本金
@property (nonatomic, copy) NSString<Optional> *expectedPrinAmountTotal;       // 待收本金
@property (nonatomic, copy) NSString<Optional> *totalAsset;                    // 总资产
@property (nonatomic, copy) NSString<Optional> *expectedPrinAndInte;           // 待收本息
@property (nonatomic, copy) NSString<Optional> *usableAmt;   //可用金额
@property (nonatomic, copy) NSString<Optional> *freezedAmt; // 冻结金额
@end

@interface CGAccountStatModel : ResponseModel

@property(nonatomic,strong)AccountStatInfoModel * accountStatInfo;

@end
