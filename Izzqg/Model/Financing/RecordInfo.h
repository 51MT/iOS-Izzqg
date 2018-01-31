//
//  RecordInfo.h
//  Ixyb
//
//  Created by wang on 15/6/11.
//  Copyright (c) 2015年 xyb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RecordInfo : NSObject

@property (strong, nonatomic) NSString *autoBid;
@property (strong, nonatomic) NSString *autoBidAmount;
@property (strong, nonatomic) NSString *availableAmount;
@property (strong, nonatomic) NSString *bidCount;
@property (strong, nonatomic) NSString *bidDate;
@property (strong, nonatomic) NSString *bidState;
@property (strong, nonatomic) NSString *username;

@end

/*
 "username" : "用户名",
 "availableAmount" : 总投标金额,
 "bidState" : 投标状态,
 "autoBid" : 是否自动投标,
 "bidCount" : 投标次数,
 "autoBidAmount" : 自动投标金额,
 "bidDate":"投标时间"
 */