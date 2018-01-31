//
//  NPLoanListResModel.h
//  Ixyb
//
//  Created by DzgMac on 2017/12/29.
//  Copyright © 2017年 xyb. All rights reserved.
//

#import "ResponseModel.h"

@protocol NPLoanListModel <NSObject>
@end
@interface NPLoanListModel : JSONModel

@property (nonatomic,copy) NSString<Optional> *username;
@property (nonatomic,copy) NSString<Optional> *totalDeposit;
@property (nonatomic,copy) NSString<Optional> *createdDate;
@property (nonatomic,copy) NSString<Optional> *lastMatchTime;

@end

@interface NPLoanListResModel : ResponseModel

@property (nonatomic,strong) NSArray<NPLoanListModel,Optional> *orderList;

@end

