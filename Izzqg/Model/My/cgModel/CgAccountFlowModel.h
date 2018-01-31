//
//  CgAccountFlowModel.h
//  Ixyb
//
//  Created by wang on 2017/12/26.
//  Copyright © 2017年 xyb. All rights reserved.
//

#import "ResponseModel.h"

@protocol FlowListModel

@end

@interface FlowListModel : JSONModel

@property (nonatomic, copy) NSString<Optional> *transAmt;    // 交易金额
@property (nonatomic, copy) NSString<Optional> *usableAmt;   // 可用余额
@property (nonatomic, copy) NSString<Optional> *freezedAmt;  // 冻结金额
@property (nonatomic, copy) NSString<Optional> *streamType;  //
@property (nonatomic, copy) NSString<Optional> *flowType;    //

@property (nonatomic, copy) NSString<Optional> *flowTypeDesc; // 交易类型
@property (nonatomic, copy) NSString<Optional> *createdDate;  // 时间


@end

@interface CgAccountFlowModel : ResponseModel

@property(nonatomic,strong)NSArray <FlowListModel,Optional> * flowList;

@end
