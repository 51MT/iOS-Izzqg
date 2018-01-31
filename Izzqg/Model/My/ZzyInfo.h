//
//  ZzyInfo.h
//  Ixyb
//
//  Created by wang on 16/4/8.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import <Foundation/Foundation.h>

/*    "prizeLogId": 21743,
 "prizeName": "周周盈出借次数",//奖品名称
 "prizeCode": "ZZY",//奖品代码
 "createdDate": "2016-01-02"//发放时间
 */

@interface ZzyInfo : NSObject

@property (nonatomic, copy) NSString *prizeLogId;
@property (nonatomic, copy) NSString *prizeName;
@property (nonatomic, copy) NSString *prizeCode;
@property (nonatomic, copy) NSString *createdDate;

@end
