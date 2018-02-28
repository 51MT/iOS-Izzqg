//
//  BorrowRecordModel.h
//  Ixyb
//
//  Created by wang on 16/3/9.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BorrowRecordModel : NSObject

@property (nonatomic, strong) NSString *currentDate;//还款日
@property (nonatomic, strong) NSString *actualRepayAmount;//还款金额
@property (nonatomic, strong) NSString *repayUrl;//还款路径
@property (nonatomic, strong) NSString *isOverdue;//是否逾期
@property (nonatomic, strong) NSString *bankInfo;//银行信息
@end
