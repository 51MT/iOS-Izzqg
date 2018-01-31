//
//  EarningsRecordInfo.h
//  Ixyb
//
//  Created by wang on 15/10/16.
//  Copyright (c) 2015年 xyb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EarningsRecordInfo : NSObject
/*    "yesterIncome": 1.91, //收益
 "gainDate": "2015-10-14"//日期
*/

@property(nonatomic,strong)NSString *gainDate;

@property(nonatomic,assign)double yesterIncome;

@end
