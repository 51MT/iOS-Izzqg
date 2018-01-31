//
//  HqbDeposit.h
//  Ixyb
//
//  Created by wang on 15/10/17.
//  Copyright (c) 2015年 xyb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HqbDeposit : NSObject

/* "amount": 100.00,//转入金额
 "title":"转出",//操作类型
 "createTime": "2015-10-14 17:52:30"//转入时间
 "dataType": // 1:收益，2：转入，3：转出
 

 */
@property (nonatomic, strong) NSString *title; //标题
@property (nonatomic, strong) NSString *createTime;
@property (nonatomic, assign) double amount;
@property (nonatomic, assign) int dataType;
@end
