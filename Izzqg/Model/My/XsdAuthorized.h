//
//  XsdAuthorized.h
//  Ixyb
//
//  Created by wang on 16/2/25.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import "JSONModel.h"
#import "EmptyModel.h"

@protocol  NSDictionary;
@interface XsdAuthorized : JSONModel
@property (nonatomic, copy) NSString <Optional>*type;//授信状态
@property (nonatomic, copy) NSString <Optional>*bankInfo;//收款还款账户
@property (nonatomic, copy) NSString <Optional>*borrowId;//申请ID 待签约客户有值否则为NULL
@property (nonatomic, copy) NSString <Optional>*approvedAmount;//审批金额
@property (nonatomic, copy) NSString <Optional>*repayAmount;//还款总额
@property (nonatomic, copy) NSString <Optional>*applyAmount;//借款金额
@property (nonatomic, copy) NSString <Optional>*dayRate;//日利息
@property (nonatomic, copy) NSString <Optional>*loanLimit;//借款期限
@property (nonatomic, copy) NSString <Optional>*repayEndDay;//最后还款日
@property (nonatomic, copy) NSString <Optional>*bankName;//开户行名称
@property (nonatomic, copy) NSString <Optional>*cardNo;//卡号后四位
@property (nonatomic, copy) NSString <Optional>*customerName;//借款人姓名
@property (nonatomic, copy) NSString <Optional>*idNumber;//借款人身份证
@property (nonatomic, copy) NSString <Optional>*loanProvider;//贷款发放人
@property (nonatomic, copy) NSString <Optional>*loanTerm;//金额分期
@property (nonatomic, copy) NSString <Optional>*url;//借款地址
@property (nonatomic, strong) NSArray <Optional>*repayInfoList;//还款数组
@property (nonatomic, copy) NSString <Optional>*historyUrl;//历史记录地址
@property (nonatomic, copy) NSString <Optional>*approvedState;//借款状态

@end
