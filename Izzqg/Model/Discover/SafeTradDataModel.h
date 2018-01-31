//
//  SafeTradDataModel.h
//  Ixyb
//
//  Created by wang on 16/12/16.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import "ResponseModel.h"
@protocol TradeDataModel

@end

@interface TradeDataModel : JSONModel
/*!
 *  @author JiangJJ, 16-12-16 17:12:11
 *
 *  总成交借款笔数
 */
@property (nonatomic, copy) NSString<Optional> *loadSuccessCount;

/*!
 *  @author JiangJJ, 16-12-16 17:12:19
 *
 *  累计成交金额
 */
@property (nonatomic, copy) NSString<Optional> *allSuccessfulAmount;

/*!
 *  @author JiangJJ, 16-12-16 17:12:45
 *
 *  待还金额
 */
@property (nonatomic, copy) NSString<Optional> *paymentTotal;

/*!
 *  @author JiangJJ, 16-12-16 17:12:54
 *
 *  已还金额
 */
@property (nonatomic, copy) NSString<Optional> *repaymentTotal;

/*!
 *  @author JiangJJ, 16-12-16 17:12:03
 *
 *  最近30天待还金额
 */
@property (nonatomic, copy) NSString<Optional> *lastMonthPaymentTotal;

/*!
 *  @author JiangJJ, 16-12-16 17:12:10
 *
 *  风险缓释金
 */
@property (nonatomic, copy) NSString<Optional> *bankMargin;

@end
@interface SafeTradDataModel : ResponseModel
@property(nonatomic,strong)TradeDataModel * tradeData;
@end
