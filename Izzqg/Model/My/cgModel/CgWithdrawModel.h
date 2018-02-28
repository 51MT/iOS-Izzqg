//
//  CgWithdrawModel.h
//  Ixyb
//
//  Created by wang on 2017/12/26.
//  Copyright © 2017年 xyb. All rights reserved.
//

#import "ResponseModel.h"

@protocol WithdrawListModel

@end

@interface WithdrawListModel : JSONModel

@property (nonatomic, copy) NSString<Optional> *amount;
@property (nonatomic, copy) NSString<Optional> *state;
@property (nonatomic, copy) NSString<Optional> *stateDesc;
@property (nonatomic, copy) NSString<Optional> *createdDate;

@end

@interface CgWithdrawModel : ResponseModel

@property(nonatomic,strong)NSArray <WithdrawListModel,Optional> * withdrawList;

@end
