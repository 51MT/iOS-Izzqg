//
//  Report.h
//  Ixyb
//
//  Created by wang on 15/10/21.
//  Copyright (c) 2015年 xyb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Report : NSObject
/* "totalAmount": 2000.00,//推荐出借额
 "incomeAmount": 9.64,//历史收益
 "registerNum": 1,//注册人数
 "relationlevel": "0"//关系级别，0: 1级，1:2级
*/
@property (nonatomic, assign) double totalAmount;// 
@property (nonatomic, assign) double incomeAmount;//
@property (nonatomic, assign) NSInteger registerNum;//
@property (nonatomic, assign) NSInteger  relationlevel;

@end
