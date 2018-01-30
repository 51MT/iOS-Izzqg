//
//  XsdPageResponseModel.h
//  Ixyb
//
//  Created by dengjian on 16/12/20.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import "ResponseModel.h"

@interface XsdDataModel : JSONModel

@property (nonatomic, assign) NSInteger overdueCount;                //逾期笔数
@property (nonatomic, copy) NSString<Optional> *overdueRepaylistUrl; //逾期还款页面列表url
@property (nonatomic, copy) NSString<Optional> *highCanBorrowAmount; //最高可借额度
@property (nonatomic, copy) NSString<Optional> *totalAmount;         //总额度
@property (nonatomic, copy) NSString<Optional> *dayFees;             //日费用
@property (nonatomic, copy) NSString<Optional> *grantUrl;            //提额按钮url
@property (nonatomic, copy) NSString<Optional> *canGrant;            //是否可提额(0不可提额,1可提额)
@property (nonatomic, copy) NSString<Optional> *borrowApplyUrl;      //发起借款业务按钮
@property (nonatomic, copy) NSString<Optional> *lowAmount;           //最低起借金额
@property (nonatomic, copy) NSString<Optional> *repayApplyUrl;       //我要还款
@property (nonatomic, copy) NSString<Optional> *applyListUrl;        //借款记录
@property (nonatomic, copy) NSString<Optional> *repayListUrl;        //还款记录
@property (nonatomic, copy) NSString<Optional> *message;
@property (nonatomic, copy) NSString<Optional> *showBtn;

@end
/**
 *  @author Dzg
 *
 *  @brief 信闪贷页面Model
 */
@interface XsdPageResponseModel : JSONModel

@property (nonatomic, assign) int result;
@property (nonatomic, strong) XsdDataModel<Optional> *data;

@end
